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
	Date: 14-2-2017

	YM3438_APL.pdf
	Timer A = 144*(1024-NA)/Phi M
	Timer B = 2304*(256-NB)/Phi M
	*/

`timescale 1ns / 1ps

module jt12_timers(
  input			clk,
  input			rst,
  input			clk_en /* synthesis direct_enable */,
  input [9:0]	value_A,
  input [7:0]	value_B,
  input 		load_A,
  input 		load_B,
  input 		clr_flag_A,
  input 		clr_flag_B,
  input 		enable_irq_A,
  input 		enable_irq_B,
  output 	 	flag_A,
  output 	 	flag_B,
  output		overflow_A,
  output 	 	irq_n
);

assign irq_n = ~( (flag_A&enable_irq_A) | (flag_B&enable_irq_B) );

jt12_timer #(.mult_width(5), .mult_max(24), .counter_width(10)) 
timer_A(
	.clk		( clk		), 
	.rst		( rst		),
	.clk_en		( clk_en 	),
	.start_value( value_A	),
	.load		( load_A   	),
	.clr_flag   ( clr_flag_A),
	.flag		( flag_A	),
	.overflow	( overflow_A)
);

jt12_timer #(.mult_width(9), .mult_max(384), .counter_width(8)) 
timer_B(
	.clk		( clk		), 
	.rst		( rst		),
	.clk_en		( clk_en 	),
	.start_value( value_B	),
	.load		( load_B   	),
	.clr_flag   ( clr_flag_B),
	.flag		( flag_B	),
	.overflow	(			)
);

endmodule

module jt12_timer #(parameter counter_width = 10, mult_width=5, mult_max=4 )
(
	input	clk, 
	input	rst,
(* direct_enable *) input	clk_en,
	input	[counter_width-1:0] start_value,
	input	load,
	input	clr_flag,
	output reg flag,
	output reg overflow
);

reg [   mult_width-1:0] mult;
reg [counter_width-1:0] cnt;

always@(posedge clk)
	if( clr_flag || rst)
		flag <= 1'b0;
	else if(overflow) flag<=1'b1;

reg [mult_width+counter_width-1:0] next, init;

always @(*) begin
	if( mult+1'b1<mult_max ) begin
		// mult not meant to overflow in this line
		{overflow, next } = { {1'b0, cnt}, mult+1'b1 } ; 
	end else begin
		{overflow, next } = { {1'b0, cnt}+1'b1, {mult_width{1'b0}} };
	end
	init = { start_value, {mult_width{1'b0}} };
end

always @(posedge clk)
	if( ~load || rst) begin
	  mult <= { (mult_width){1'b0} };
	  cnt  <= start_value;
	end
	else if( clk_en )
	  { cnt, mult } <= overflow ? init : next;

endmodule
