--------======== operator.vhd ========--------
-- YM2203 / YM2612 (OPN / OPN2) Operator Unit
-- Reverse engineered from YM2203 (and YM2612) die shots
-- Copyright (C) 2015 Sauraen
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- NOTICE:
-- This is an UNTESTED implementation!
-- 
-- I attempted to get the overall architecture of this unit correct,
-- especially the position and number of registers in the pipeline. I 
-- am confident that this is correct at a large-scale level. I am not,
-- however, confident that this description is free from errors. In
-- particular, it is very likely that one or more bits are wrong in the
-- sine or exponential tables. Also, since the chip uses both positive
-- and negative logic throughout, it is easy to miss an inverter, and
-- so there may be an error where a particular signal or variable should
-- be inverted from how it is written here. I tried my best to trace
-- adders, etc. completely, but this is not error-proof.
-- 
-- The benefit of this situation is that if anyone does test an
-- implementation based on this code, the errors that may exist here are
-- likely to produce obviously wrong results. In previous implementations,
-- authors tried to get the right sound 99% of the time, but had no idea
-- of the pipelined architecture or certain other details here which became
-- important in the other cases. Thus it is much harder to make a perfect
-- implementation.


--------======== EXTERNALLY DEFINED ENTITIES ========--------

-- circular_buffer
-- A simple circular buffer, used for most of the YM2612's registers.

library ieee;
use ieee.std_logic_1164.all;

entity circular_buffer is
	generic (
		DATA_WIDTH: positive := 8; --arbitrary default value
		BUFFER_DEPTH: positive := 3; --arbitrary default value
		CLEAR_ON_RESET: boolean := false
	);
	port (
		clk, rst_bar: in std_logic;
		din: in std_logic_vector(DATA_WIDTH-1 downto 0);
		dout: out std_logic_vector(DATA_WIDTH-1 downto 0);
		load: in std_logic
	);
end entity;


--------======== FILE BODY ========--------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity opn_operator is
	generic (
		NUM_VOICES : positive := 6
	);
	port (
		-- Global control
		clk, rst_bar: in std_logic;
		-- Operator inputs, not all applying to the same operator at the same time
		pg_phase: in unsigned(9 downto 0);
		eg_atten: in unsigned(9 downto 0);
		voice_fb: in unsigned(2 downto 0);
		op_fb_enable: in std_logic;
		op_algorithm_ctl: in std_logic_vector(5 downto 0);
		test_214: in std_logic;
		-- Operator output
		op_result: out unsigned(13 downto 0)
	);
end entity;

architecture arch of opn_operator is
	type pipeline_delayer_t is array(natural range <>) of unsigned(9 downto 0);
	signal prev1, prevprev1, prev2: unsigned(13 downto 0);
	signal fm_preshift: unsigned(14 downto 0);
	signal pipeline_delayer : pipeline_delayer_t(2*NUM_VOICES - 7 downto 0);
	signal phaselo: unsigned(7 downto 0);
	signal signbit, signbit_1, signbit_2: std_logic;
	signal totalatten: unsigned(11 downto 0);
	signal mantissa: unsigned(9 downto 0);
	signal exponent: unsigned(3 downto 0);
	signal op_result_pre: unsigned(13 downto 0);
	signal op_result_internal: unsigned(13 downto 0);
begin

	
	-- REGISTER/CYCLE 1
	-- Creation of phase modulation (FM) feedback signal, before shifting
	make_fm_preshift: process(clk) is
		variable x, y: unsigned(13 downto 0);
		variable xs, ys: unsigned(14 downto 0);
	begin
		if rising_edge(clk) then
			x := (prevprev1 and op_algorithm_ctl(0)) 
				or (prev2 and op_algorithm_ctl(1)) 
				or (op_result_internal and op_algorithm_ctl(2));
			y := (op_result_internal and op_algorithm_ctl(3))
				or (prev1 and op_algorithm_ctl(4));
			xs := x(13) & x(13 downto 0); -- sign-extend
			ys := y(13) & y(13 downto 0); -- sign-extend
			fm_preshift <= xs + ys; -- carry is discarded
		end if;
	end process;
	
	
	-- REGISTER/CYCLE 2 (also YM2612 extra cycles 1-6)
	-- Shifting of FM feedback signal, adding phase from PG to FM phase
	-- In YM2203, fm_feedback is not registered at all, it is latched on the first edge 
	-- in add_pg_phase and the second edge is the output of add_pg_phase. In the YM2612, there
	-- are 6 cycles worth of registers between the generated (non-registered) fm_feedback signal
	-- and the input to add_pg_phase.
	shift_fb_and_add_pg_phase: process(clk) is 
		variable fm_feedback: unsigned(9 downto 0);
		variable fm_feedback_delayed: unsigned(9 downto 0);
		variable phase: unsigned(9 downto 0);
	begin
		if rising_edge(clk) then
			-- Shift FM feedback signal
			if op_fb_enable = '1' then
				fm_feedback := fm_preshift(10 downto 1); -- Bit 0 of fm_preshift is never used
			else
				case to_integer(voice_fb) is
					when 1 => fm_feedback := 
							(9 downto 6 => fm_preshift(14), 5 downto 0 => fm_preshift(14 downto 9));
					when 2 => fm_feedback := 
							(9 downto 7 => fm_preshift(14), 6 downto 0 => fm_preshift(14 downto 8));
					when 3 => fm_feedback := 
							(9 downto 8 => fm_preshift(14), 7 downto 0 => fm_preshift(14 downto 7));
					when 4 => fm_feedback := 
							(9 => fm_preshift(14), 8 downto 0 => fm_preshift(14 downto 6));
					when 5 => fm_feedback := fm_preshift(14 downto 5);
					when 6 => fm_feedback := fm_preshift(13 downto 4);
					when 7 => fm_feedback := fm_preshift(12 downto 3);
					when others => fm_feedback := (others => '0');
				end case;
			end if;
			-- Delay pipeline by 6 cycles if this is a YM2612
			if NUM_VOICES <= 3 then
				fm_feedback_delayed := fm_feedback; -- Don't delay, don't register at all
			else
				pipeline_delayer((2*NUM_VOICES)-7) <= fm_feedback;
				for i in (2*NUM_VOICES-8) downto 0 loop
					pipeline_delayer(i) <= pipeline_delayer(i+1);
				end loop;
				fm_feedback_delayed := pipeline_delayer(0);
			end if;
			-- Add in PG phase
			add_pg_phase:
			phase := fm_feedback_delayed + pg_phase;
			phaselo <= phase(7 downto 0) xor phase(8);
			signbit <= phase(9);
		end if;
	end process;
	
	
	-- REGISTER/CYCLE 3
	-- Sine table
	sine_table: process(clk) is 
		type sinetable_t is array(31 downto 0) of std_logic_vector(45 downto 0);
		constant sinetable: sinetable_t := (
			"0001100000100100010001000010101010101001010010",
			"0001100000110100000100000010010001001101000001",
			"0001100000110100000100110010001011001101100000",
			"0001110000010000000000110010110001001101110010",
			"0001110000010000001100000010111010001101101001",
			"0001110000010100001001100010000000101101111010",
			"0001110000010100001101100010010011001101011010",
			"0001110000011100000101010010111000101111111100",
			"0001110000111000000001110010101110001101110111",
			"0001110000111000010100111000011101011010100110",
			"0001110000111100011000011000111100001001111010",
			"0001110000111100011100111001101011001001110111",
			"0100100001010000010001011001001000111010110111",
			"0100100001010100010001001001110001111100101010",
			"0100100001010100010101101101111110100101000110",
			"0100100011100000001000011001010110101101111001",
			"0100100011100100001000101011100101001011101111",
			"0100100011101100000111011010000001011010110001",
			"0100110011001000000111101010000010111010111111",
			"0100110011001100001011011110101110110110000001",
			"0100110011101000011010111011001010001101110001",
			"0100110011101101011010110101111001010100001111",
			"0111000010000001010111000101010101010110010111",
			"0111000010000101010111110111110101010010111011",
			"0111000010110101101000101100001000010000011001",
			"0111010010011001100100011110100100010010010010",
			"0111010010111010100101100101000000110100100011",
			"1010000010011010101101011101100001110010011010",
			"1010000010111111111100100111010100010000111001",
			"1010010111110100110010001100111001010110100000",
			"1011010111010011111011011110000100110010100001",
			"1110011011110001111011100111100001110110100111"
		);
		variable sta : std_logic_vector(45 downto 0);
		variable stb : std_logic_vector(18 downto 0);
		variable stf, stg : std_logic_vector(10 downto 0);
		variable logsin : unsigned(11 downto 0);
		variable subtresult : unsigned(10 downto 0);
		variable atten_internal : unsigned(11 downto 0);
		
	begin
		if rising_edge(clk) then
			-- Main sine table body
			sta := sinetable(to_integer(phaselo(5 downto 1)));
			-- 2-bit row chooser
			case std_logic_vector(phaselo(7 downto 6)) is
				when "00" => stb :=
					  "0000000000" & sta(29) & sta(25) 
					& "00" & sta(18) & sta(14) 
					& "0" & sta(7) & sta(3);
				when "01" => stb :=
					  "000000" & sta(37) & sta(34)
					& "00" & sta(28) & sta(24)
					& "00" & sta(17) & sta(13)
					& sta(10) & sta(6) & sta(2);
				when "10" => stb :=
					  "00" & sta(43) & sta(41)
					& "00" & sta(36) & sta(33)
					& "00" & sta(27) & sta(23)
					& "0" & sta(20) & sta(16)
					& sta(12) & sta(9) & sta(5) & sta(1);
				when others => stb :=
					  sta(45) & sta(44) & sta(42) & sta(40)
					& sta(39) & sta(38) & sta(35) & sta(32)
					& sta(31) & sta(30) & sta(26) & sta(22)
					& sta(21) & sta(19) & sta(15) & sta(11)
					& sta(8) & sta(4) & sta(0);
			end case;
			-- Fixed value to sum
			stf := stb(18 downto 15) & stb(12 downto 11) & stb(8 downto 7) & stb(4 downto 3) & stb(0);
			-- Gated value to sum; bit 14 is indeed used twice
			stg := "00" & stb(14) & stb(14 downto 13) & stb(10 downto 9) & stb(6 downto 5) & stb(2 downto 1);
			stg := stg and phaselo(0);
			-- Sum to produce final logsin value
			logsin := unsigned('0' & stf) + unsigned('0' & stg); -- Carry-out of 11-bit addition becomes 12th bit
			-- Invert-subtract logsin value from EG attenuation value, with inverted carry
			-- In the actual chip, the output of the above logsin sum is already inverted.
			-- The two LSBs go through inverters (so they're non-inverted); the eg_atten signal goes through inverters.
			-- The adder is normal except the carry-in is 1. It's a 10-bit adder.
			-- The outputs are inverted outputs, including the carry bit.
			--subtresult := not (('0' & not eg_atten) - ('1' & logsin(11 downto 2)));
			-- After a little pencil-and-paper, turns out this is equivalent to a regular adder!
			subtresult := ('0' & eg_atten) + ('0' & logsin(11 downto 2));
			-- Place all but carry bit into result; also two LSBs of logsin
			atten_internal := subtresult(9 downto 0) & logsin(1 downto 0);
			-- If addition overflowed, make it the largest value (saturate)
			atten_internal := atten_internal or subtresult(10);
			totalatten <= atten_internal;
			signbit_1 <= signbit;
		end if;
	end process;
	
	
	-- REGISTER/CYCLE 4
	-- Exponential table
	exp_table: process(clk) is 
		type exptable_t is array(31 downto 0) of std_logic_vector(44 downto 0);
		constant exptable: exptable_t := (
			"101110011001000000110100010111111000111111011",
			"110011011100001100000011111001011000111111011",
			"010110111001011101110101101111000000111111011",
			"011010101010000001110110000111000000111111011",
			"110110101010000001010001100001000000111111011",
			"101110111001111000110110111010101010010111011",
			"000000110000110100111001011110111011010011011",
			"011110111001100100010110100100111011010011011",
			"010110111000101000110101100010110011010011011",
			"001010111001010011110011001110000011010011011",
			"101010011001011011010100111101000111000011011",
			"110110011000011111110011110011001111100001011",
			"101111011101100111100100000011001111100001011",
			"100010101010101011010111101101111100100001011",
			"110010011001100011010000001101111100100001011",
			"101010111000011100110101011010110100100001011",
			"111011011101010100100010110000110100100001011",
			"100011011100111000000001010100100100100001011",
			"110011011101110000000110101110001100000001011",
			"101011111100001110100001101000001100000001011",
			"101010011001000110110110010001001000000001011",
			"101011011100101010000101110111010001000101110",
			"110011111101100010000010011111110011001100110",
			"100011011100001100100111001001110011001100110",
			"010101011100000000100100101011111011101110100",
			"000111011101101000000011000111101011101110100",
			"010110011000100100010100110100101011101110100",
			"000010011001000110010011011000001011101110100",
			"100011011100101010100000011010000011101110100",
			"110111011101100010100111100100010010101110100",
			"000000001001000100110000000100010010101110100",
			"000011011100101000000001100010011010001110100"
		);
		variable eta : std_logic_vector(44 downto 0);
		variable etb : std_logic_vector(12 downto 0);
		variable etf, etg : std_logic_vector(9 downto 0);
		
	begin
		if rising_edge(clk) then
			-- Main sine table body
			eta := exptable(to_integer(totalatten(5 downto 1)));
			-- 2-bit row chooser
			case std_logic_vector(totalatten(7 downto 6)) is
				when "00" => etb := "1" & eta(43) & eta(40) & eta(36) & eta(32) & eta(28) 
						& eta(24) & "1" & eta(18) & eta(14) & eta(10) & eta(7) & eta(3);
				when "01" => etb := eta(44) & eta(42) & eta(39) & eta(35) & eta(31) & eta(27) 
						& eta(23) & "1" & eta(17) & eta(13) & "0" & eta(6) & eta(2);
				when "10" => etb := "0" & eta(41) & eta(38) & eta(34) & eta(30) & eta(26) 
						& eta(22) & eta(19) & eta(16) & eta(12) & eta(9) & eta(5) & eta(1);
				when others => etb := "00" & eta(37) & eta(33) & eta(29) & eta(25) 
						& eta(21) & eta(20) & eta(15) & eta(11) & eta(8) & eta(4) & eta(0);
			end case;
			-- Fixed value to sum
			etf := etb(12 downto 6) & etb(4) & etb(3) & etb(0);
			-- Gated value to sum
			etg := "0000000" & etb(5) & etb(2) & etb(1);
			etg := etg and not totalatten(0);
			--RESULT
			mantissa <= unsigned(etf) + unsigned(etg); --carry-out discarded
			exponent <= totalatten(11 downto 8);
			signbit_2 <= signbit_1;
		end if;
	end process;
	
	-- REGISTER/CYCLE 5
	-- Floating-point to integer, and incorporating sign bit
	shift_and_flip: process(clk) is
		variable shifter : unsigned(12 downto 0);
		variable result : unsigned(13 downto 0);
	begin
		if rising_edge(clk) then
			-- Two-stage shifting of mantissa by exponent
			shifter := "001" & mantissa;
			case std_logic_vector(exponent(1 downto 0)) is
				when "00" => shifter := '0' & shifter(12 downto 1); -- LSB discarded
				-- when "01" => shifter := shifter; -- no change
				when "10" => shifter := shifter(11 downto 0) & '0';
				when "11" => shifter := shifter(10 downto 0) & "00";
				when others => null;
			end case;
			case std_logic_vector(exponent(3 downto 2)) is
				when "00" => shifter := "000000000000" & shifter(12);
				when "01" => shifter := "00000000" & shifter(12 downto 8);
				when "10" => shifter := "0000" & shifter(12 downto 4);
				-- when "11" => shifter := shifter; -- no change
				when others => null;
			end case;
			result := test_214 & shifter; -- Introduce test bit as MSB
			-- 2's complement
			result := result xor signbit_2;
			result := result + signbit_2; -- Carry-out discarded
			op_result_pre <= result;
		end if;
	end process;
	
	
	-- REGISTER/CYCLE 6
	-- Extra register, take output after here
	register_output: process(clk) is begin
		if rising_edge(clk) then
			op_result_internal <= op_result_pre;
		end if;
	end process;
	
	op_result <= op_result_internal;
	
	
	-- Circular buffers for old operator output values
	-- These latch op_result_internal on the clock after
	-- it is generated in register_output, and they provide
	-- their output (prev1, etc.) on the same cycle as
	-- op_result_internal is available.
	prev1_buffer: entity circular_buffer
		generic map(
			DATA_WIDTH => 14,
			BUFFER_DEPTH => NUM_VOICES,
			CLEAR_ON_RESET => false)
		port map(
			clk => clk,
			rst_bar => rst_bar,
			din => std_logic_vector(op_result_internal),
			std_logic_vector(dout) => prev1,
			load => op_algorithm_ctl(5)
		);
	
	prevprev1_buffer: entity circular_buffer
		generic map(
			DATA_WIDTH => 14,
			BUFFER_DEPTH => NUM_VOICES,
			CLEAR_ON_RESET => false)
		port map(
			clk => clk,
			rst_bar => rst_bar,
			din => std_logic_vector(prev1),
			std_logic_vector(dout) => prevprev1,
			load => op_algorithm_ctl(5)
		);
	
	prev2_buffer: entity circular_buffer
		generic map(
			DATA_WIDTH => 14,
			BUFFER_DEPTH => NUM_VOICES,
			CLEAR_ON_RESET => false)
		port map(
			clk => clk,
			rst_bar => rst_bar,
			din => std_logic_vector(op_result_internal),
			std_logic_vector(dout) => prev2,
			load => op_algorithm_ctl(0)
		);
	
	
end architecture;
