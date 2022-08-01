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
	Date: 14-2-2017	

*/

module jt12_clk(
	input		rst,
	input		clk,
	
	input		set_n6,
	input		set_n3, // not implemented because it relies on 50% duty cycle of clk
	input		set_n2,
	
	output	reg clk_int,
	output	reg rst_int
);

reg	clk_n2, clk_n6;
wire clk_n3;

reg [1:0] clksel;

parameter USE6=2'd0, USE3=2'b10, USE2=2'b01;

always @(negedge clk_n6 or posedge rst_int) 
	if( rst_int ) begin
		clksel <= USE6;
	end
	else
		clksel <= { set_n3, set_n2 };	

always @(*)
	case( clksel )
		USE3: clk_int <= clk_n3;
		USE2: clk_int <= clk_n2;
		default: clk_int <= clk_n6;
	endcase

// n=2
// Generate internal clock and synchronous reset for it.
reg	[1:0] rst_int_aux;

always @(posedge clk or posedge rst) 
	clk_n2 	<= rst ? 1'b0 : ~clk_n2;
	
reg [1:0] cnt3;
reg [2:0] cnt6;
assign clk_n3 = cnt3[0];

always @(posedge clk or posedge rst) 
	if( rst ) begin
		cnt3 <= 2'd0;
		cnt6 <= 3'd0;
		clk_n6 <= 1'b0;
	end else begin
		cnt3 <= cnt3==2'd2 ? 2'd0 : cnt3+2'd1;
		cnt6 <= cnt6==3'd5 ? 3'd0 : cnt6+3'd1;
		clk_n6 <= cnt6<=3'd2;
	end

wire [3:0] delay;

always @(posedge clk_n6 or posedge rst) 
	if( rst ) begin
		rst_int_aux	<= 2'b11;
		rst_int		<= 1'b1;
	end
	else begin		
		{ rst_int, rst_int_aux } <= { rst_int_aux, 1'b0 };
	end

	
endmodule
