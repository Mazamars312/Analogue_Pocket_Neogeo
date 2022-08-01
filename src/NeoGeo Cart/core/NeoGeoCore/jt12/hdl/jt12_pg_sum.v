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
	Date: 2-11-2018
	
	Based on information posted by Nemesis on:
http://gendev.spritesmind.net/forum/viewtopic.php?t=386&postdays=0&postorder=asc&start=167

	Based on jt51_phasegen.v, from JT51	
	
	*/

module jt12_pg_sum (
	input		[ 3:0]	mul,		
	input		[19:0]	phase_in,
	input				pg_rst,
	input signed [5:0]  detune_signed,
	input		[16:0]  phinc_pure,

	output reg	[19:0]	phase_out,
	output reg	[ 9:0]	phase_op
);

reg [16:0] phinc_premul; 
reg [19:0] phinc_mul;

always @(*) begin
	phinc_premul = phinc_pure + {{11{detune_signed[5]}},detune_signed};
	phinc_mul	 = ( mul==4'd0 ) ? {4'b0,phinc_premul[16:1]} : ({3'd0,phinc_premul} * mul);
	
	phase_out   = pg_rst ? 20'd0 : (phase_in + { phinc_mul});
	phase_op	= phase_out[19:10];
end

endmodule // jt12_pg_sum