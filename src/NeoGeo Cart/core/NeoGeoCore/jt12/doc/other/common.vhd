--------======== common.vhd ========--------
-- Common entities for use with YM2203/YM2612 implementation
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

architecture arch of circular_buffer is
	type memtype is array(BUFFER_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem : memtype;
begin
	process(clk, rst_bar) is begin
		if rst_bar = '0' and CLEAR_ON_RESET then
			for i in BUFFER_DEPTH-1 downto 0 loop
				mem(i) <= (others => '0');
			end loop;
		elsif rising_edge(clk) then
			if load = '1' then
				mem(BUFFER_DEPTH-1) <= din;
			else
				mem(BUFFER_DEPTH-1) <= mem(0);
			end if;
			for i in buffer_depth-2 downto 0 loop
				mem(i) <= mem(i+1);
			end loop;
			dout <= mem(0);
		end if;
	end process;
end architecture;