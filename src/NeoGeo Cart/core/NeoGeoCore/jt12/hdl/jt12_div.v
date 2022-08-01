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
    */

`timescale 1ns / 1ps

module jt12_div(
    input           rst,
    input           clk,
    input           cen /* synthesis direct_enable */,
    input   [1:0]   div_setting,
    output  reg     clk_en,      // after prescaler
    output  reg     clk_en_2,    // cen divided by 2
    output  reg     clk_en_ssg,
    output  reg     clk_en_666,  // 666 kHz
    output  reg     clk_en_111,  // 111 kHz
    output  reg     clk_en_55    //  55 kHz
);

parameter use_ssg=0;

reg [3:0] opn_pres, opn_cnt=4'd0;
reg [2:0] ssg_pres, ssg_cnt=3'd0;
reg [4:0] adpcm_cnt666  = 5'd0;
reg [2:0] adpcm_cnt111 = 3'd0, adpcm_cnt55=3'd0;
reg cen_int, cen_ssg_int, cen_adpcm_int, cen_adpcm3_int;

// prescaler values for FM
// reset: 1/3
// sel1/sel2
//    0 0    1/3
//    0 1    1/2
//    1 0    1/6  
//    1 1    1/2
//
// According to YM2608 document
//                  FM      SSG   div[1:0]
// reset value     1/6      1/4    10
// 2D              1/6      1/4    10   | 10
// 2D,2E           1/3      1/2    11   | 01
// 2F              1/2      1/1    00   & 00
//  

always @(*) begin

    casez( div_setting )
        2'b0?: begin // FM 1/2 - SSG 1/1
            opn_pres = 4'd2-4'd1;
            ssg_pres = 3'd0;
        end
        2'b10: begin // FM 1/6 - SSG 1/4 (reset value. Fixed for YM2610)
            opn_pres = 4'd6-4'd1;
            ssg_pres = 3'd3;
        end
        2'b11: begin // FM 1/3 - SSG 1/2
            opn_pres = 4'd3-4'd1;
            ssg_pres = 3'd1;
        end
    endcase // div_setting
end

`ifdef SIMULATION
initial clk_en_666 = 1'b0;
`endif

reg cen_55_int;
reg [1:0] div2=2'b0;

always @(negedge clk) begin
    cen_int        <= opn_cnt      == 4'd0;
    cen_ssg_int    <= ssg_cnt      == 3'd0;
    cen_adpcm_int  <= adpcm_cnt666 == 5'd0;
    cen_adpcm3_int <= adpcm_cnt111 == 3'd0;
    cen_55_int     <= adpcm_cnt55  == 3'd0;
    `ifdef FASTDIV
    // always enabled for fast sims (use with GYM output, timer will not work well)
    clk_en     <= 1'b1;
    clk_en2    <= 1'b1;
    clk_en_ssg <= 1'b1;
    clk_en_666 <= 1'b1;
    clk_en_55  <= 1'b1;
    `else
    clk_en     <= cen & cen_int;   
    clk_en_2   <= cen && (div2==2'b00);
    clk_en_ssg <= use_ssg ? (cen & cen_ssg_int) : 1'b0;
    clk_en_666 <= cen & cen_adpcm_int; 
    clk_en_111 <= cen & cen_adpcm_int & cen_adpcm3_int; 
    clk_en_55  <= cen & cen_adpcm_int & cen_adpcm3_int & cen_55_int;
    `endif
end

// Div/2
always @(posedge clk)
    if( cen ) begin
        div2 <= div2==2'b10 ? 2'b00 : (div2+2'b01);
    end

// OPN
always @(posedge clk)
    if( cen ) begin
        if( opn_cnt == opn_pres ) begin
            opn_cnt <= 4'd0;  
        end
        else opn_cnt <= opn_cnt + 4'd1;
    end

// SSG
always @(posedge clk)
    if( cen ) begin
        if( ssg_cnt == ssg_pres ) begin
            ssg_cnt <= 3'd0;            
        end
        else ssg_cnt <= ssg_cnt + 3'd1;
    end

// ADPCM-A
always @(posedge clk)
    if( cen ) begin
        adpcm_cnt666 <= adpcm_cnt666==5'd11 ? 5'd0 : adpcm_cnt666 + 5'd1;
        if( adpcm_cnt666==5'd0 ) begin
            adpcm_cnt111 <= adpcm_cnt111==3'd5 ? 3'd0 : adpcm_cnt111+3'd1;
            if( adpcm_cnt111==3'd0)
                adpcm_cnt55 <= adpcm_cnt55==3'd1 ? 3'd0: adpcm_cnt55+3'd1;
        end
    end

endmodule // jt12_div