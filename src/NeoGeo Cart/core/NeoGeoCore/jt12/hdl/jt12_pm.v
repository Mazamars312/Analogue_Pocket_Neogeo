/*  This file is part of jt12.

    jt12 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    jt12 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with jt12.  If not, see <http://www.gnu.org/licenses/>.
	
	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 14-10-2018
	*/
// altera message_off 10030

`timescale 1ns / 1ps

// This implementation follows that of Alexey Khokholov (Nuke.YKT) in C language.

module jt12_pm (
	input [4:0] lfo_mod,
	input [10:0] fnum,
	input [2:0] pms,
	output reg signed [8:0] pm_offset
);


reg [7:0] pm_unsigned;
reg [7:0] pm_base;
reg [9:0] pm_shifted;

wire [2:0] index = lfo_mod[3] ? (~lfo_mod[2:0]) : lfo_mod[2:0];

reg [2:0] lfo_sh1_lut [0:63];
reg [2:0] lfo_sh2_lut [0:63];
reg [2:0] lfo_sh1, lfo_sh2;

initial begin
    lfo_sh1_lut[6'h00] = 3'd7;
    lfo_sh1_lut[6'h01] = 3'd7;
    lfo_sh1_lut[6'h02] = 3'd7;
    lfo_sh1_lut[6'h03] = 3'd7;
    lfo_sh1_lut[6'h04] = 3'd7;
    lfo_sh1_lut[6'h05] = 3'd7;
    lfo_sh1_lut[6'h06] = 3'd7;
    lfo_sh1_lut[6'h07] = 3'd7;
    lfo_sh1_lut[6'h08] = 3'd7;
    lfo_sh1_lut[6'h09] = 3'd7;
    lfo_sh1_lut[6'h0A] = 3'd7;
    lfo_sh1_lut[6'h0B] = 3'd7;
    lfo_sh1_lut[6'h0C] = 3'd7;
    lfo_sh1_lut[6'h0D] = 3'd7;
    lfo_sh1_lut[6'h0E] = 3'd7;
    lfo_sh1_lut[6'h0F] = 3'd7;
    lfo_sh1_lut[6'h10] = 3'd7;
    lfo_sh1_lut[6'h11] = 3'd7;
    lfo_sh1_lut[6'h12] = 3'd7;
    lfo_sh1_lut[6'h13] = 3'd7;
    lfo_sh1_lut[6'h14] = 3'd7;
    lfo_sh1_lut[6'h15] = 3'd7;
    lfo_sh1_lut[6'h16] = 3'd1;
    lfo_sh1_lut[6'h17] = 3'd1;
    lfo_sh1_lut[6'h18] = 3'd7;
    lfo_sh1_lut[6'h19] = 3'd7;
    lfo_sh1_lut[6'h1A] = 3'd7;
    lfo_sh1_lut[6'h1B] = 3'd7;
    lfo_sh1_lut[6'h1C] = 3'd1;
    lfo_sh1_lut[6'h1D] = 3'd1;
    lfo_sh1_lut[6'h1E] = 3'd1;
    lfo_sh1_lut[6'h1F] = 3'd1;
    lfo_sh1_lut[6'h20] = 3'd7;
    lfo_sh1_lut[6'h21] = 3'd7;
    lfo_sh1_lut[6'h22] = 3'd7;
    lfo_sh1_lut[6'h23] = 3'd1;
    lfo_sh1_lut[6'h24] = 3'd1;
    lfo_sh1_lut[6'h25] = 3'd1;
    lfo_sh1_lut[6'h26] = 3'd1;
    lfo_sh1_lut[6'h27] = 3'd0;
    lfo_sh1_lut[6'h28] = 3'd7;
    lfo_sh1_lut[6'h29] = 3'd7;
    lfo_sh1_lut[6'h2A] = 3'd1;
    lfo_sh1_lut[6'h2B] = 3'd1;
    lfo_sh1_lut[6'h2C] = 3'd0;
    lfo_sh1_lut[6'h2D] = 3'd0;
    lfo_sh1_lut[6'h2E] = 3'd0;
    lfo_sh1_lut[6'h2F] = 3'd0;
    lfo_sh1_lut[6'h30] = 3'd7;
    lfo_sh1_lut[6'h31] = 3'd7;
    lfo_sh1_lut[6'h32] = 3'd1;
    lfo_sh1_lut[6'h33] = 3'd1;
    lfo_sh1_lut[6'h34] = 3'd0;
    lfo_sh1_lut[6'h35] = 3'd0;
    lfo_sh1_lut[6'h36] = 3'd0;
    lfo_sh1_lut[6'h37] = 3'd0;
    lfo_sh1_lut[6'h38] = 3'd7;
    lfo_sh1_lut[6'h39] = 3'd7;
    lfo_sh1_lut[6'h3A] = 3'd1;
    lfo_sh1_lut[6'h3B] = 3'd1;
    lfo_sh1_lut[6'h3C] = 3'd0;
    lfo_sh1_lut[6'h3D] = 3'd0;
    lfo_sh1_lut[6'h3E] = 3'd0;
    lfo_sh1_lut[6'h3F] = 3'd0;
    lfo_sh2_lut[6'h00] = 3'd7;
    lfo_sh2_lut[6'h01] = 3'd7;
    lfo_sh2_lut[6'h02] = 3'd7;
    lfo_sh2_lut[6'h03] = 3'd7;
    lfo_sh2_lut[6'h04] = 3'd7;
    lfo_sh2_lut[6'h05] = 3'd7;
    lfo_sh2_lut[6'h06] = 3'd7;
    lfo_sh2_lut[6'h07] = 3'd7;
    lfo_sh2_lut[6'h08] = 3'd7;
    lfo_sh2_lut[6'h09] = 3'd7;
    lfo_sh2_lut[6'h0A] = 3'd7;
    lfo_sh2_lut[6'h0B] = 3'd7;
    lfo_sh2_lut[6'h0C] = 3'd2;
    lfo_sh2_lut[6'h0D] = 3'd2;
    lfo_sh2_lut[6'h0E] = 3'd2;
    lfo_sh2_lut[6'h0F] = 3'd2;
    lfo_sh2_lut[6'h10] = 3'd7;
    lfo_sh2_lut[6'h11] = 3'd7;
    lfo_sh2_lut[6'h12] = 3'd7;
    lfo_sh2_lut[6'h13] = 3'd2;
    lfo_sh2_lut[6'h14] = 3'd2;
    lfo_sh2_lut[6'h15] = 3'd2;
    lfo_sh2_lut[6'h16] = 3'd7;
    lfo_sh2_lut[6'h17] = 3'd7;
    lfo_sh2_lut[6'h18] = 3'd7;
    lfo_sh2_lut[6'h19] = 3'd7;
    lfo_sh2_lut[6'h1A] = 3'd2;
    lfo_sh2_lut[6'h1B] = 3'd2;
    lfo_sh2_lut[6'h1C] = 3'd7;
    lfo_sh2_lut[6'h1D] = 3'd7;
    lfo_sh2_lut[6'h1E] = 3'd2;
    lfo_sh2_lut[6'h1F] = 3'd2;
    lfo_sh2_lut[6'h20] = 3'd7;
    lfo_sh2_lut[6'h21] = 3'd7;
    lfo_sh2_lut[6'h22] = 3'd2;
    lfo_sh2_lut[6'h23] = 3'd7;
    lfo_sh2_lut[6'h24] = 3'd7;
    lfo_sh2_lut[6'h25] = 3'd7;
    lfo_sh2_lut[6'h26] = 3'd2;
    lfo_sh2_lut[6'h27] = 3'd7;
    lfo_sh2_lut[6'h28] = 3'd7;
    lfo_sh2_lut[6'h29] = 3'd7;
    lfo_sh2_lut[6'h2A] = 3'd7;
    lfo_sh2_lut[6'h2B] = 3'd2;
    lfo_sh2_lut[6'h2C] = 3'd7;
    lfo_sh2_lut[6'h2D] = 3'd7;
    lfo_sh2_lut[6'h2E] = 3'd2;
    lfo_sh2_lut[6'h2F] = 3'd1;
    lfo_sh2_lut[6'h30] = 3'd7;
    lfo_sh2_lut[6'h31] = 3'd7;
    lfo_sh2_lut[6'h32] = 3'd7;
    lfo_sh2_lut[6'h33] = 3'd2;
    lfo_sh2_lut[6'h34] = 3'd7;
    lfo_sh2_lut[6'h35] = 3'd7;
    lfo_sh2_lut[6'h36] = 3'd2;
    lfo_sh2_lut[6'h37] = 3'd1;
    lfo_sh2_lut[6'h38] = 3'd7;
    lfo_sh2_lut[6'h39] = 3'd7;
    lfo_sh2_lut[6'h3A] = 3'd7;
    lfo_sh2_lut[6'h3B] = 3'd2;
    lfo_sh2_lut[6'h3C] = 3'd7;
    lfo_sh2_lut[6'h3D] = 3'd7;
    lfo_sh2_lut[6'h3E] = 3'd2;
    lfo_sh2_lut[6'h3F] = 3'd1;
end

always @(*) begin
	lfo_sh1 = lfo_sh1_lut[{pms,index}];
	lfo_sh2 = lfo_sh2_lut[{pms,index}];
	pm_base = ({1'b0,fnum[10:4]}>>lfo_sh1) + ({1'b0,fnum[10:4]}>>lfo_sh2);
	case( pms )
		default: pm_shifted = { 2'b0, pm_base };
		3'd6: pm_shifted = { 1'b0, pm_base, 1'b0 };
		3'd7: pm_shifted = {       pm_base, 2'b0 };
	endcase // pms
	pm_offset = lfo_mod[4] ? (-{1'b0,pm_shifted[9:2]}) : {1'b0,pm_shifted[9:2]};
end // always @(*)

endmodule
