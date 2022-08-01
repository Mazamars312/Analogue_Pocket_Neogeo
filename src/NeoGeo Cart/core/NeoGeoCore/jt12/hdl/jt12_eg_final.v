/*  This file is part of JT12.

	JT12 is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	JT12 is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with JT12.  If not, see <http://www.gnu.org/licenses/>.

	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 29-10-2018

	*/

module jt12_eg_final(
	input [ 6:0] lfo_mod,
	input        amsen,
	input [ 1:0] ams,
	input [ 6:0] tl,
	input [ 9:0] eg_pure_in,
	input 		 ssg_inv,
	output reg	[9:0] eg_limited
);

reg	[ 8:0]	am_final;
reg	[11:0]	sum_eg_tl;
reg	[11:0]	sum_eg_tl_am;
reg	[ 5:0]	am_inverted;
reg [ 9:0]	eg_pream;

always @(*) begin
	am_inverted = lfo_mod[6] ? ~lfo_mod[5:0] : lfo_mod[5:0];
end

always @(*) begin
	casez( {amsen, ams } )
		default: am_final = 9'd0;
		3'b1_01: am_final = { 5'd0, am_inverted[5:2]	};
		3'b1_10: am_final = { 3'd0, am_inverted 		};
		3'b1_11: am_final = { 2'd0, am_inverted, 1'b0	};
	endcase
	eg_pream = ssg_inv ? (10'h200-eg_pure_in) : eg_pure_in;
	sum_eg_tl = {  1'b0, tl,   3'd0 } + {1'b0, eg_pream}; // leading zeros needed to compute correctly
	sum_eg_tl_am = sum_eg_tl + { 3'd0, am_final };
end

always @(*)  
	eg_limited = sum_eg_tl_am[11:10]==2'd0 ? sum_eg_tl_am[9:0] : 10'h3ff;

endmodule // jt12_eg_final