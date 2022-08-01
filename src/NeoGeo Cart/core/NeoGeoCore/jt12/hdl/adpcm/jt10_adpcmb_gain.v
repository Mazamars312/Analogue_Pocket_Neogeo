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

// Gain is assumed to be 0.75dB per bit.

module jt10_adpcmb_gain(
    input                    rst_n,
    input                    clk,        // CPU clock
    input                    cen55,
    input             [ 7:0] tl,         // ADPCM Total Level
    input      signed [15:0] pcm_in,
    output reg signed [15:0] pcm_out
);

wire signed [15:0] factor = {8'd0, tl};
wire signed [31:0] pcm_mul = pcm_in * factor; // linear gain

always @(posedge clk) if(cen55)
    pcm_out <= pcm_mul[23:8];

endmodule // jt10_adpcm_gain
