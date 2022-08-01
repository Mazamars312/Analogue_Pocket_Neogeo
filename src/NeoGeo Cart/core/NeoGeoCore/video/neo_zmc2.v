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

// Graphics mux part (CT0) was written by Kyuusaku

module neo_zmc2(
	input CLK_12M,
	input EVEN,
	input LOAD,
	input H,
	input [31:0] CR,
	output [3:0] GAD, GBD,
	output DOTA, DOTB
	
	// Not used here
	/*input SDRD0,
	input [1:0] SDA_L,
	input [15:8] SDA_U,
	output [21:11] MA*/
);

	// Not used here
	//zmc2_zmc ZMC2ZMC(SDRD0, SDA_L, SDA_U, MA);
	zmc2_dot ZMC2DOT(CLK_12M, EVEN, LOAD, H, CR, GAD, GBD, DOTA, DOTB);

endmodule

