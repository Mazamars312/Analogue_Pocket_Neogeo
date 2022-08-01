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

// ADPCM-A algorithm

module jt10_adpcm(
    input           rst_n,
    input           clk,        // CPU clock
    input           cen,        // optional clock enable, if not needed leave as 1'b1
    input   [3:0]   data,
    input           chon,       // high if this channel is on
    input           clr,
    output signed [15:0] pcm
);

localparam sigw = 12;

reg signed [sigw-1:0] x1, x2, x3, x4, x5, x6;
reg signed [sigw-1:0] inc4;
reg [5:0] step1, step2, step6, step3, step4, step5;
reg [5:0] step_next, step_1p;
reg       sign2, sign3, sign4, sign5, xsign5;

// All outputs from stage 1
assign pcm = { {16-sigw{x1[sigw-1]}}, x1 };

// This could be decomposed in more steps as the pipeline
// has room for it
always @(*) begin
    casez( data[2:0] )
        3'b0??: step_next = step1==6'd0 ? 6'd0 : (step1-1'd1);
        3'b100: step_next = step1+6'd2;
        3'b101: step_next = step1+6'd5;
        3'b110: step_next = step1+6'd7;
        3'b111: step_next = step1+6'd9;
    endcase
    step_1p = step_next > 6'd48 ? 6'd48 : step_next;
end

wire [11:0] inc3;
reg [8:0] lut_addr2;


jt10_adpcma_lut u_lut(
    .clk    ( clk        ),
    .rst_n  ( rst_n      ),
    .cen    ( cen        ),
    .addr   ( lut_addr2  ),
    .inc    ( inc3       )
);

// Original pipeline: 6 stages, 6 channels take 36 clock cycles
// 8 MHz -> /12 divider -> 666 kHz
// 666 kHz -> 18.5 kHz = 55.5/3 kHz

reg chon2, chon3, chon4;
wire [sigw-1:0] inc3_long = { {sigw-12{1'b0}},inc3 };

always @( posedge clk or negedge rst_n )
    if( ! rst_n ) begin
        x1 <= 'd0; step1 <= 0; 
        x2 <= 'd0; step2 <= 0;
        x3 <= 'd0; step3 <= 0;
        x4 <= 'd0; step4 <= 0;
        x5 <= 'd0; step5 <= 0;
        x6 <= 'd0; step6 <= 0;
        sign2 <= 'b0;
        chon2 <= 'b0;   chon3 <= 'b0; chon4 <= 'b0;
        lut_addr2 <= 'd0;
        inc4 <= 'd0;
    end else if(cen) begin
        // I
        sign2     <= data[3];
        x2        <= clr ? {sigw-1{1'b0}} : x1;
        step2     <= clr ? 6'd0 : (chon ? step_1p : step1);
        chon2     <= ~clr && chon;
        lut_addr2 <= { step1, data[2:0] };
        // II 2's complement of inc2 if necessary
        sign3     <= sign2;
        x3        <= x2;
        step3     <= step2;
        chon3     <= chon2;
        // III
        //sign4     <= sign3;
        inc4      <= sign3 ? ~inc3_long + 1'd1 : inc3_long;
        x4        <= x3;
        step4     <= step3;
        chon4     <= chon3;
        // IV
        //sign5     <= sign4;
        //xsign5    <= x4[sigw-1];
        x5        <= chon4 ? x4 + inc4 : x4;
        step5     <= step4;
        // V
        x6        <= x5;
        step6     <= step5;
        // VI: close the loop
        x1        <= x6;
        step1     <= step6;
    end

endmodule // jt10_adpcm    
