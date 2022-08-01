`timescale 1ns / 1ps


/* This file is part of JT12.

 
	JT12 program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	JT12 program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with JT12.  If not, see <http://www.gnu.org/licenses/>.

	Based on Sauraen VHDL version of OPN/OPN2, which is based on die shots.

	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 27-1-2017	

*/

module jt12_opram
(
	input [4:0] wr_addr,
	input [4:0] rd_addr,
	input clk, 
	input clk_en,
	input [43:0] data,
	output reg [43:0] q
);

	reg [43:0] ram[31:0];

	always @ (posedge clk) if(clk_en) begin
		q <= ram[rd_addr];
		ram[wr_addr] <= data;
	end

endmodule
