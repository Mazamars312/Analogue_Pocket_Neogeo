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
    
    Each channel can use the full range of the DAC as they do not
    get summed in the real chip.

    Operator data is summed up without adding extra bits. This is
    the case of real YM3438, which was used on Megadrive 2 models.


*/

/* 
 YM2612 had a limiter to prevent overflow
 YM3438 did not
 JT12 always has a limiter enabled
 */

module jt12_acc(
    input               rst,
    input               clk,
    input               clk_en /* synthesis direct_enable */,
    input signed [8:0]  op_result,
    input        [ 1:0] rl,
    input               zero,
    input               s1_enters,
    input               s2_enters,
    input               s3_enters,
    input               s4_enters,
    input               ch6op,
    input   [2:0]       alg,
    input               pcm_en, // only enabled for channel 6
    input   signed [8:0] pcm,
    // combined output
    output reg signed   [11:0]  left,
    output reg signed   [11:0]  right
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

reg pcm_sum;

always @(posedge clk) if(clk_en)
    if( zero ) pcm_sum <= 1'b1;
    else if( ch6op ) pcm_sum <= 1'b0;

wire use_pcm = ch6op && pcm_en;
wire sum_or_pcm = sum_en | use_pcm;
wire left_en = rl[1];
wire right_en= rl[0];
wire signed [8:0] pcm_data = pcm_sum ? pcm : 9'd0;
wire [8:0] acc_input =  use_pcm ? pcm_data : op_result;

// Continuous output
wire signed   [11:0]  pre_left, pre_right;
jt12_single_acc #(.win(9),.wout(12)) u_left(
    .clk        ( clk            ),
    .clk_en     ( clk_en         ),
    .op_result  ( acc_input      ),
    .sum_en     ( sum_or_pcm & left_en ),
    .zero       ( zero           ),
    .snd        ( pre_left       )
);

jt12_single_acc #(.win(9),.wout(12)) u_right(
    .clk        ( clk            ),
    .clk_en     ( clk_en         ),
    .op_result  ( acc_input      ),
    .sum_en     ( sum_or_pcm & right_en ),
    .zero       ( zero           ),
    .snd        ( pre_right      )
);

// Output can be amplied by 8/6=1.33 to use full range
// an easy alternative is to add 1/4th and get 1.25 amplification
always @(posedge clk) if(clk_en) begin
    left  <= pre_left  + { {2{left [11]}}, left [11:2] };
    right <= pre_right + { {2{right[11]}}, right[11:2] };
end

endmodule
