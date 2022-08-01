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
    Date: 21-03-2019
*/

module jt10_adpcm_gain(
    input           rst_n,
    input           clk,        // CPU clock
    input           cen,        // 666 kHz
    // pipeline channel
    input   [5:0]   cur_ch,
    input   [5:0]   en_ch,
    input           match,

    input   [5:0]   atl,        // ADPCM Total Level
    // Gain update
    input   [7:0]   lracl,
    input   [2:0]   up_ch,
    // Data
    output  [1:0]   lr,
    input      signed [15:0] pcm_in,
    output     signed [15:0] pcm_att
);

reg [5:0] up_ch_dec;
always @(*)
    case(up_ch)
        3'd0: up_ch_dec = 6'b000_001;
        3'd1: up_ch_dec = 6'b000_010;
        3'd2: up_ch_dec = 6'b000_100;
        3'd3: up_ch_dec = 6'b001_000;
        3'd4: up_ch_dec = 6'b010_000;
        3'd5: up_ch_dec = 6'b100_000;
        default: up_ch_dec = 6'd0;
    endcase

//wire [5:0] en_ch2 = { en_ch[4:0], en_ch[5] }; // shift the bits to fit in the pipeline slot correctly

reg  [6:0] db5;
always @(*)
    case( db5[2:0] )
        3'd0: lin_5b = 10'd512;
        3'd1: lin_5b = 10'd470;
        3'd2: lin_5b = 10'd431;
        3'd3: lin_5b = 10'd395;
        3'd4: lin_5b = 10'd362;
        3'd5: lin_5b = 10'd332;
        3'd6: lin_5b = 10'd305;
        3'd7: lin_5b = 10'd280;
    endcase

reg [7:0] lracl1, lracl2, lracl3, lracl4, lracl5, lracl6;
reg  [9:0] lin_5b, lin1, lin2, lin6;
reg [3:0] sh1, sh6;

// dB to linear conversion
assign lr = lracl1[7:6];

always @(posedge clk or negedge rst_n)
    if( !rst_n ) begin
        lracl1  <= 8'd0; lracl2 <= 8'd0;
        lracl3  <= 8'd0; lracl4 <= 8'd0;
        lracl5  <= 8'd0; lracl6 <= 8'd0;
        db5     <= 'd0;
        sh1     <= 4'd0; sh6    <= 4'd0;
        lin1    <= 10'd0;
        lin6    <= 10'd0;
    end else if(cen) begin

        // I
        lracl2  <= up_ch_dec == cur_ch ? lracl : lracl1;
        // II
        lracl3  <= lracl2;
        // III
        lracl4  <= lracl3;
        // IV: new data is accepted here
        lracl5  <= lracl4;
        db5     <= { 2'b0, ~lracl4[4:0] } + {1'b0, ~atl};
        // V
        lracl6  <= lracl5;
        lin6    <= lin_5b;
        sh6     <= db5[6:3];
        // VI close the loop
        lracl1  <= lracl6;
        lin1    <= sh6[3] ? 10'h0 : lin6;
        sh1     <= sh6;
    end

// Apply gain
// The pipeline has 6 stages, there is new input data once every 6*6=36 clock cycles
// New data is read once and it takes 4*6 cycles to get through because the shift
// operation is distributed among several iterations. This prevents the need of
// a 10x16-input mux which is very large. Instead of that, this uses two 10x2-input mux'es
// which iterated allow the max 16 shift operation

reg [3:0] shcnt1, shcnt2, shcnt3, shcnt4, shcnt5, shcnt6;

reg shcnt_mod3, shcnt_mod4, shcnt_mod5;
reg [31:0] pcm2_mul;
wire signed [15:0] lin2s = {6'b0,lin2};

always @(*) begin
    shcnt_mod3 = shcnt3 != 0;
    shcnt_mod4 = shcnt4 != 0;
    shcnt_mod5 = shcnt5 != 0;
    pcm2_mul   = pcm2 * lin2s;
end

reg signed [15:0] pcm1, pcm2, pcm3, pcm4, pcm5, pcm6;
reg match2;

assign pcm_att = pcm1;

always @(posedge clk or negedge rst_n)
    if( !rst_n ) begin
        pcm1   <= 'd0; pcm2   <= 'd0;
        pcm3   <= 'd0; pcm4   <= 'd0;
        pcm5   <= 'd0; pcm6   <= 'd0;
        shcnt1 <= 'd0; shcnt2 <= 'd0;
        shcnt3 <= 'd0; shcnt4 <= 'd0;
        shcnt5 <= 'd0; shcnt6 <= 'd0;
    end else if(cen) begin
        // I
        pcm2    <= match ? pcm_in : pcm1;
        lin2    <= lin1;
        shcnt2  <= match ? sh1 : shcnt1;
        match2  <= match;
        // II
        pcm3    <= match2 ? pcm2_mul[24:9] : pcm2;
        shcnt3  <= shcnt2;
        // III, shift by 0 or 1
        if( shcnt_mod3 ) begin
            pcm4   <= pcm3>>>1;
            shcnt4 <= shcnt3-1'd1;
        end else begin
            pcm4   <= pcm3;
            shcnt4 <= shcnt3;
        end
        // IV, shift by 0 or 1
        if( shcnt_mod4 ) begin
            pcm5   <= pcm4>>>1;
            shcnt5 <= shcnt4-1'd1;
        end else begin
            pcm5   <= pcm4;
            shcnt5 <= shcnt4;
        end       
        // V, shift by 0 or 1
        if( shcnt_mod5 ) begin
            pcm6   <= pcm5>>>1;
            shcnt6 <= shcnt5-1'd1;
        end else begin
            pcm6   <= pcm5;
            shcnt6 <= shcnt5;
        end       
        // VI close the loop and output
        pcm1    <= pcm6;
        shcnt1  <= shcnt6;
    end

endmodule // jt10_adpcm_gain
