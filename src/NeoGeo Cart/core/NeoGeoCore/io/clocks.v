// NeoGeo logic definition
// Copyright (C) 2018 Sean Gonsalves
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Everything here was verified on a MV4 board
// Todo: Check phase relations between 12M, 68KCLK and 68KCLKB
// Todo: Check cycle right after nRESETP goes high, real hw might have an important delay added

module clocks(
	input CLK_24M,
	input nRESETP,
	output CLK_12M,
	output reg CLK_68KCLK,
	output CLK_68KCLKB,
	output CLK_6MB,
	output reg CLK_1HB
);

	reg [2:0] CLK_DIV;
	wire CLK_3M;
	
	assign CLK_68KCLKB = ~CLK_68KCLK;
	
	always @(posedge CLK_24M or negedge nRESETP)
	begin
		if (!nRESETP)
			CLK_68KCLK <= 1'b0;	// Thanks ElectronAsh ! Real hw doesn't clearly init DFF
		else
			CLK_68KCLK <= ~CLK_68KCLK;	// MV4 C4:A
	end
	//always @(posedge CLK_24M)
	//	CLK_68KCLK <= ~CLK_68KCLK;	// MV4 C4:A
	
	always @(negedge CLK_24M or negedge nRESETP)
	begin
		if (!nRESETP)
			CLK_DIV <= 3'b100;
		else
			CLK_DIV <= CLK_DIV + 1'b1;
	end
	
	assign CLK_12M = CLK_DIV[0];
	assign CLK_6MB = ~CLK_DIV[1];
	assign CLK_3M = CLK_DIV[2];
	
	// MV4 C4:B
	always @(posedge CLK_12M)
		CLK_1HB <= ~CLK_3M;
	
endmodule
