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
    Date: 27-1-2017 
    
*/

// Accumulates an arbitrary number of inputs with saturation
// restart the sum when input "zero" is high

`timescale 1ns / 1ps

module jt12_single_acc #(parameter 
        win=14, // input data width 
        wout=16 // output data width
)(
    input                 clk,
    input                 clk_en /* synthesis direct_enable */,
    input [win-1:0]       op_result,
    input                 sum_en,
    input                 zero,
    output reg [wout-1:0] snd
);

// for full resolution use win=14, wout=16
// for cut down resolution use win=9, wout=12
// wout-win should be > 0

reg signed [wout-1:0] next, acc, current;
reg overflow;

wire [wout-1:0] plus_inf  = { 1'b0, {(wout-1){1'b1}} }; // maximum positive value
wire [wout-1:0] minus_inf = { 1'b1, {(wout-1){1'b0}} }; // minimum negative value

always @(*) begin
    current = sum_en ? { {(wout-win){op_result[win-1]}}, op_result } : {wout{1'b0}};
    next = zero ? current : current + acc;
    overflow = !zero && 
        (current[wout-1] == acc[wout-1]) && 
        (acc[wout-1]!=next[wout-1]);
end

always @(posedge clk) if( clk_en ) begin
    acc <= overflow ? (acc[wout-1] ? minus_inf : plus_inf) : next;
    if(zero) snd <= acc;
end

endmodule // jt12_single_acc