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

	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 19-3-2017	

*/


module jt12_mod6
(
	input		[2:0]	in, // only 0 to 5 are valid entries
	input		[2:0]	sum,
	output	reg [2:0]	out	// output between 0 to 5
);

reg	[3:0] aux;

always @(*) begin
	aux <= in+sum;
	case( aux )
		4'd6:	out <= 3'd0;
		4'd7:	out <= 3'd1;
		4'd8:	out <= 3'd2;
		4'd9:	out <= 3'd3;
		4'ha:	out <= 3'd4;
		4'hb:	out <= 3'd5;
		4'hc:	out <= 3'd0;
		4'he:	out <= 3'd1;
		4'hf:	out <= 3'd2;
		default:	out <= aux;
	endcase
end

endmodule
