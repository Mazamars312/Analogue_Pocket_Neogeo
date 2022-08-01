//============================================================================
//  SNK NeoGeo for MiSTer
//
//  Copyright (C) 2018 Sean 'Furrtek' Gonsalves
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module neo_f0(
	input nRESET,
	input nDIPRD0,
	input nDIPRD1,					// Also called "IN3"
	input nBITW0,
	output nBITWD0,				// "nBITW0 for NEO-D0"
	input [7:0] DIPSW,
	input COIN1, COIN2,
	input [7:4] M68K_ADDR,
	inout [7:0] M68K_DATA,
	input SYSTEMB,
	output [5:0] nSLOT,
	output SLOTA, SLOTB, SLOTC,
	output reg [2:0] LED_LATCH,
	output reg [7:0] LED_DATA,
	
	input RTC_DOUT, RTC_TP,
	output RTC_DIN, RTC_CLK, RTC_STROBE,
	
	output nCOUNTOUT,
	
	input SYSTEM_TYPE
	
	//output [3:0] EL_OUT,
	//output [8:0] LED_OUT1,
	//output [8:0] LED_OUT2
);

	reg [2:0] REG_RTCCTRL;
	reg [2:0] SLOTS;
	
	// Todo: verify
	// This is used (among other things) for the RTC
	assign nBITWD0 = |{nBITW0, M68K_ADDR[6:5]};
	
	// Todo: verify
	// This is used to select NEO-I0
	assign nCOUNTOUT = |{nBITW0, ~M68K_ADDR[6:5]};
	
	assign RTC_DIN = REG_RTCCTRL[0];
	assign RTC_CLK = REG_RTCCTRL[1];
	assign RTC_STROBE = REG_RTCCTRL[2];
	
	// REG_DIPSW $300001~?, odd bytes
	// REG_SYSTYPE $300081~?, odd bytes (TODO: Test switch and stuff... Neutral for now)
	assign M68K_DATA = nDIPRD0 ? 8'bzzzzzzzz :
								(M68K_ADDR[7]) ? 8'b10000000 :
								DIPSW;
	
	// REG_STATUS_A $320001~?, odd bytes
	// In console mode, reading REG_STATUS_A returns 00. This is used by the Unibios to detect the system type.
	assign M68K_DATA = nDIPRD1 ? 8'bzzzzzzzz :
								SYSTEM_TYPE ? {RTC_DOUT, RTC_TP, 4'b1111, COIN2, COIN1} : 8'h00;
	
	always @(negedge nRESET or negedge nBITW0)
	begin
		if (!nRESET)
		begin
			SLOTS <= 3'b000;
			REG_RTCCTRL <= 3'b000;
		end
		else if (!nBITW0)
		begin
			case (M68K_ADDR[6:4])
				3'b010:
					SLOTS <= M68K_DATA[2:0];			// REG_SLOT $380021
				3'b011:
					LED_LATCH <= M68K_DATA[5:3];		// REG_LEDLATCHES $380031
				3'b100:
					LED_DATA <= M68K_DATA[7:0];		// REG_LEDDATA $380041
				3'b101:
					REG_RTCCTRL <= M68K_DATA[2:0];	// REG_RTCCTRL $380051
			endcase
		end
	end
	
	assign {SLOTC, SLOTB, SLOTA} = SYSTEMB ? SLOTS : 3'b000;	// Maybe not
	
	// TODO: check this
	assign nSLOT = SYSTEMB ? 
						(SLOTS == 3'b000) ? 6'b111110 :
						(SLOTS == 3'b001) ? 6'b111101 :
						(SLOTS == 3'b010) ? 6'b111011 :
						(SLOTS == 3'b011) ? 6'b110111 :
						(SLOTS == 3'b100) ? 6'b101111 :
						(SLOTS == 3'b101) ? 6'b011111 :
						6'b111111 :		// Invalid
						6'b111111 ;		// All slots disabled
	
endmodule
