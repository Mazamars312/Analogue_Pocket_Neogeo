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
    Date: 15-11-2018

*/

`timescale 1ns / 1ps

/* Use for YM2203
    no left/right channels
    full operator resolution
    clamped to maximum output of signed 16 bits */

module jt03_acc
(
    input               rst,
    input               clk,
    input               clk_en /* synthesis direct_enable */,
    input signed [13:0] op_result,
    input               s1_enters,
    input               s2_enters,
    input               s3_enters,
    input               s4_enters,
    input               zero,
    input   [2:0]       alg,
    // combined output
    output signed [15:0] snd
);

reg sum_en;

always @(*) begin
    case ( alg )
        default: sum_en = s4_enters;
        3'd4: sum_en = s2_enters | s4_enters;
        3'd5,3'd6: sum_en = ~s1_enters;        
        3'd7: sum_en = 1'b1;
    endcase
end

localparam res=18;
wire [res-1:0] hires;
assign snd = hires[res-1:res-16];

jt12_single_acc #(.win(14),.wout(res)) u_mono(
    .clk        ( clk            ),
    .clk_en     ( clk_en         ),
    .op_result  ( op_result      ),
    .sum_en     ( sum_en         ),
    .zero       ( zero           ),
    .snd        ( hires          )
);

endmodule
