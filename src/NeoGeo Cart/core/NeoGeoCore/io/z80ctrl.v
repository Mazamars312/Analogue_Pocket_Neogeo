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

module z80ctrl(
	input [4:2] SDA_L,
	input [15:11] SDA_U,
	input nSDRD, nSDWR,
	input nMREQ, nIORQ,
	input nSDW,						// From NEO-C1
	input nRESET,
	output reg nZ80NMI,
	output nSDZ80R, nSDZ80W,	// To NEO-C1
	output nSDZ80CLR,				// To NEO-C1
	output nSDROM,
	output nSDMRD, nSDMWR,
	output nSDRD0, nSDRD1,
	output n2610CS,
	output n2610RD, n2610WR,
	output nZRAMCS
);

	reg nNMI_EN;
	wire nIORD, nIOWR;
	wire nNMI_SET, nNMI_RESET;
	
	// $0000~$F7FF: ROM
	// $F800~$FFFF: RAM
	assign nSDROM = &{SDA_U};
	assign nZRAMCS = ~nSDROM;

	assign nSDMRD = nMREQ | nSDRD;	// RAM read
	assign nSDMWR = nMREQ | nSDWR;	// RAM write
	
	assign nIORD = nIORQ | nSDRD;		// Port read
	assign nIOWR = nIORQ | nSDWR;		// Port write

	// Port $x0, $x1, $x2, $x3 read
	assign nSDZ80R = (nIORD | SDA_L[3] | SDA_L[2]);
	// Port $x0, $x1, $x2, $x3 write
	assign nSDZ80CLR = (nIOWR | SDA_L[3] | SDA_L[2]);
	
	// Port $x4, $x5, $x6, $x7 read
	assign n2610RD = (nIORD | SDA_L[3] | ~SDA_L[2]);
	// Port $x4, $x5, $x6, $x7 write
	assign n2610WR = (nIOWR | SDA_L[3] | ~SDA_L[2]);
	assign n2610CS = n2610RD & n2610WR;
	
	// Port $x8, $x9, $xA, $xB read
	assign nSDRD0 = (nIORD | ~SDA_L[3] | SDA_L[2]);
	// Port $x8, $x9, $xA, $xB write
	assign nNMI_SET = (nIOWR | ~SDA_L[3] | SDA_L[2]);
	
	// Port $xC, $xD, $xE, $xF read
	assign nSDRD1 = (nIORD | ~SDA_L[3] | ~SDA_L[2]);
	// Port $xC, $xD, $xE, $xF write
	assign nSDZ80W = (nIOWR | ~SDA_L[3] | ~SDA_L[2]);

	assign nNMI_RESET = nSDZ80R & nRESET;
	
	// NMI enable DFF
	always @(posedge nNMI_SET or negedge nRESET)
	begin
		if (!nRESET)
			nNMI_EN <= 1'b1;
		else
			nNMI_EN <= SDA_L[4];
	end
	
	// NMI trig DFF
	always @(posedge nSDW or negedge nNMI_RESET)
	begin
		if (!nNMI_RESET)
			nZ80NMI <= 1'b1;
		else
			nZ80NMI <= nNMI_EN;
	end

endmodule
