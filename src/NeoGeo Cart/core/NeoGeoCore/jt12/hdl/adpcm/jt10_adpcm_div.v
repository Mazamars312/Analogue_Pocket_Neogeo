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

// calculates d=a/b
// a = b*d + r

module jt10_adpcm_div #(parameter dw=16)(
    input               rst_n,
    input               clk,    // CPU clock
    input               cen,
    input               start,  // strobe
    input      [dw-1:0] a,
    input      [dw-1:0] b,
    output reg [dw-1:0] d,
    output reg [dw-1:0] r,
    output              working
);

reg  [dw-1:0] cycle;
assign working = cycle[0];

wire [dw:0] sub = { r[dw-2:0], d[dw-1] } - b;  

always @(posedge clk or negedge rst_n)
    if( !rst_n ) begin
        cycle <= 'd0;
    end else if(cen) begin
        if( start ) begin
            cycle <= ~16'd0;
            r     <=  16'd0;
            d     <= a;
        end else if(cycle[0]) begin
            cycle <= { 1'b0, cycle[dw-1:1] };
            if( sub[dw] == 0 ) begin
                r <= sub[dw-1:0];
                d <= { d[dw-2:0], 1'b1};
            end else begin
                r <= { r[dw-2:0], d[dw-1] };
                d <= { d[dw-2:0], 1'b0 };
            end
        end
    end

endmodule // jt10_adpcm_div
