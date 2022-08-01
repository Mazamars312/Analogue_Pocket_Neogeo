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
	Date: 23-2-2017	
	
*/



`timescale 1ns / 1ps

module jt12_amp(
	input			clk,
	input			rst,
	input			sample,
	input	[2:0]	volume,

	input		signed	[13:0]	pre,	
	output	reg signed	[15:0]	post
);

wire signed [14:0] x2 = pre<<<1;
wire signed [15:0] x3 = x2+pre;
wire signed [15:0] x4 = pre<<<2;
//wire signed [16:0] x5 = x4+pre;
wire signed [16:0] x6 = x4+x2;
//wire signed [16:0] x7 = x4+x3;
wire signed [16:0] x8 = pre<<<3;
wire signed [17:0] x12 = x8+x4;
wire signed [17:0] x16 = pre<<<4;

always @(posedge clk)
if( rst )
	post <= 16'd0;
else
if( sample )
	case( volume ) 
		3'd0: // /2
			post <= { {2{pre[13]}}, pre	};
		3'd1: // x1
			post <= { x2[14], x2	};
		3'd2: // x2
			post <= { x2, 1'd0   	};
			/*
		3'd3: // x3
			case( x3[15:14] )
				2'b00, 2'b11: post <= { x3[14:0], 1'd0 };
				2'b01: post <= 16'h7FFF;
				2'b10: post <= 16'h8000;
			endcase
			*/
		3'd3: // x4
			post <= x4;
			/*
		3'd5: // x5
			case( x5[16:15] )
				2'b00, 2'b11: post <= x5[15:0];
				2'b01: post <= 16'h7FFF;
				2'b10: post <= 16'h8000;
			endcase				
			*/
		3'd4: // x6
			casex( x6[16:15] )
				2'b00, 2'b11: post <= x6[15:0];
				2'b0x: post <= 16'h7FFF;
				2'b1x: post <= 16'h8000;
			endcase				
/*			
		3'd7: // x7
			case( x7[16:15] )
				2'b00, 2'b11: post <= x7[15:0];
				2'b01: post <= 16'h7FFF;
				2'b10: post <= 16'h8000;
			endcase	
*/			
		3'd5: // x8
			casex( x8[16:15] )
				2'b00, 2'b11: post <= x8[15:0];
				2'b0x: post <= 16'h7FFF;
				2'b1x: post <= 16'h8000;
			endcase
		3'd6: // x12
			casex( x12[17:15] )
				3'b000, 3'b111: post <= x12[15:0];
				3'b0xx: post <= 16'h7FFF;
				3'b1xx: post <= 16'h8000;				
			endcase	
		3'd7: // x16
			casex( x16[17:15] )
				3'b000, 3'b111: post <= x16[15:0];
				3'b0xx: post <= 16'h7FFF;
				3'b1xx: post <= 16'h8000;				
			endcase						
	endcase

endmodule

module jt12_amp_stereo(
	input			clk,
	input			rst,
	input			sample,

	input			[ 5:0]	psg,
	input			enable_psg,

	input	signed	[11:0]	fmleft,
	input	signed	[11:0]	fmright,
	input	[2:0]	volume,
	
	output	signed	[15:0]	postleft,
	output	signed	[15:0]	postright
);

wire signed	[13:0]	preleft;
wire signed	[13:0]	preright;

// psg, 6'd0 suena muy fuerte
// According to Nemesis:
// All 4 PSG channels at max combined is equivalent to the maximum output of a single YM2612 channel at max. 
// A single channel at max is 11'd255

//wire signed [5:0] psgm = psg-6'h20;
//wire signed [8:0] psg_dac = psgm<<<3;
//wire signed [12:0] psg_sum = {13{enable_psg}} & { {3{psg_dac[8]}}, psg_dac };

//wire signed [5:0] psgm = psg-6'h20;
wire signed [8:0] psg_dac = psg<<<3;

//wire signed [12:0] psg_sum = {13{enable_psg}} & { 3'b0, psg_dac };
wire signed [12:0] psg_sum = {13{enable_psg}} & { 2'b0, psg_dac, 1'b0 };


assign preleft = {  fmleft [11], fmleft, 1'd0 } + psg_sum;
assign preright= {  fmright[11],fmright, 1'd0 } + psg_sum;

jt12_amp amp_left(
	.clk	( clk		),
	.rst	( rst		),
	.sample	( sample	),
	.pre	( preleft	),
	.post	( postleft	),
	.volume	( volume	)
);

jt12_amp amp_right(
	.clk	( clk		),
	.rst	( rst		),
	.sample	( sample	),
	.pre	( preright	),
	.post	( postright	),
	.volume	( volume	)
);

endmodule
