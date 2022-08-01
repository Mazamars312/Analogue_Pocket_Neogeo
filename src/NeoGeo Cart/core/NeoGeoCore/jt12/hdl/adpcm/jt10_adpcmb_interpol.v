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

module jt10_adpcmb_interpol(
    input           rst_n,
    input           clk,
    input           cen,      // 8MHz cen
    input           cen55,    // clk & cen55  =  55 kHz
    input           adv,
    input  signed [15:0] pcmdec,
    output signed [15:0] pcmout
);

localparam stages=6;

reg signed [15:0] pcmlast, delta_x;
reg signed [16:0] pre_dx;
reg start_div=1'b0;
reg [3:0] deltan, pre_dn;
reg [stages-1:0] adv2;
reg signed [15:0] pcminter;
wire [15:0] next_step;
reg [15:0] step;
reg step_sign, next_step_sign;

assign pcmout = pcminter;

always @(posedge clk) if(cen) begin
    adv2 <= {adv2[stages-2:0], cen55 & adv }; // give some time to get the data from memory
end

always @(posedge clk) if(cen55) begin
    if ( adv ) begin
        pre_dn  <= 'd1;
        deltan  <= pre_dn;
    end else if ( pre_dn != 4'hF )
        pre_dn <= pre_dn + 1'd1;
end


always @(posedge clk) if(cen) begin
    start_div <= 1'b0;
    if(adv2[1]) begin
        pcmlast <= pcmdec;
    end
    if(adv2[4]) begin
        pre_dx <= { pcmdec[15], pcmdec } - { pcmlast[15], pcmlast };
    end
    if( adv2[5] ) begin
        start_div <= 1'b1;
        delta_x <= pre_dx[16] ? ~pre_dx[15:0]+1'd1 : pre_dx[15:0];
        next_step_sign <= pre_dx[16];
    end        
end

always @(posedge clk) if(cen55) begin
    if( adv ) begin
        step <= next_step;
        step_sign <= next_step_sign;
        pcminter <= pcmlast;
    end
    else pcminter <= ( (pcminter < pcmlast) == step_sign ) ? pcminter : step_sign ? pcminter - step : pcminter + step;
end

jt10_adpcm_div #(.dw(16)) u_div(
    .rst_n  ( rst_n       ),
    .clk    ( clk         ),
    .cen    ( cen         ),
    .start  ( start_div   ),
    .a      ( delta_x     ),
    .b      ( {12'd0, deltan }   ),
    .d      ( next_step   ),
    .r      (             ),
    .working(             )
);


endmodule // jt10_adpcmb_interpol