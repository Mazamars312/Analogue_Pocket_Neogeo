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

module jt12_dout(
    // input             rst_n,
    input             clk,        // CPU clock
    input             flag_A,
    input             flag_B,
    input             busy,
    input      [5:0]  adpcma_flags,
    input             adpcmb_flag,
    input      [7:0]  psg_dout,
    input      [1:0]  addr,
    output reg [7:0]  dout
);

parameter use_ssg=0, use_adpcm=0;

always @(posedge clk) begin
    casez( addr )
        2'b00: dout <= {busy, 5'd0, flag_B, flag_A }; // YM2203
        2'b01: dout <= (use_ssg  ==1) ? psg_dout : {busy, 5'd0, flag_B, flag_A };
        2'b1?: dout <= (use_adpcm==1) ?
            { adpcmb_flag, 1'b0, adpcma_flags } :
            { busy, 5'd0, flag_B, flag_A };
    endcase
end

endmodule // jt12_dout