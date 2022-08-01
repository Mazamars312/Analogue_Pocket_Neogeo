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

module zmc(
	input nRESET,
	input nSDRD0,
	input [1:0] SDA_L,
	input [15:8] SDA_U,
	output [18:11] MA
);

	//      Z80         ROM          Region	Reg
	// 1E = F000~F7FF = F000~F7FF		1111		(0)
	// 0E = E000~EFFF = E000~EFFF		1110		(1)
	// 06 = C000~DFFF = C000~DFFF		110x		(2)
	// 02 = 8000~BFFF = 8000~BFFF		10xx		(3)

	reg [7:0] WINDOW_0;
	reg [6:0] WINDOW_1;
	reg [5:0] WINDOW_2;
	reg [4:0] WINDOW_3;
	
	assign MA = (~SDA_U[15]) ? {3'b000, SDA_U[15:11]} :     		// Pass-through
			(SDA_U[15:12] == 4'b1111) ? WINDOW_0 :						// F000~F7FF
			(SDA_U[15:12] == 4'b1110) ? {WINDOW_1, SDA_U[11]} :	// E000~EFFF
			(SDA_U[15:13] == 3'b110) ? {WINDOW_2, SDA_U[12:11]} :	// C000~DFFF
			{WINDOW_3, SDA_U[13:11]};										// 8000~BFFF
	
	always @(posedge nSDRD0, negedge nRESET)
	begin
		if(!nRESET) begin
			WINDOW_0 <= 'h1E;
			WINDOW_1 <= 'h0E;
			WINDOW_2 <= 'h06;
			WINDOW_3 <= 'h02;
		end
		else begin
			case (SDA_L)
				0: WINDOW_0 <= SDA_U[15:8];
				1: WINDOW_1 <= SDA_U[14:8];
				2: WINDOW_2 <= SDA_U[13:8];
				3: WINDOW_3 <= SDA_U[12:8];
			endcase
		end
	end

endmodule
