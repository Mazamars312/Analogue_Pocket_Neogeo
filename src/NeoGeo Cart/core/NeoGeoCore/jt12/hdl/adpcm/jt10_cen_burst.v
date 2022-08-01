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

// Let a fixed number of clock enable pulses to pass through

module jt10_cen_burst #(parameter cntmax=3'd6, cntw=3)(
    input           rst_n,
    input           clk,
    input           cen,      // 8MHz cen
    input           start,
    input           start_cen,
    output          cen_out
);

reg [cntw-1:0] cnt;
reg last_start;
reg pass;

always @(posedge clk or negedge rst_n)
    if( !rst_n ) begin
        cnt  <= {cntw{1'b1}};
        pass <= 1'b0;
    end else if(cen) begin
        last_start <= start;
        if( start && start_cen ) begin
            cnt  <= 'd0;
            pass <= 1'b1;
        end else begin
            if(cnt != cntmax ) cnt <= cnt+1;
            else pass <= 1'b0;
        end
    end

reg pass_negedge;
assign cen_out = cen & pass_negedge;

always @(negedge clk) begin
    pass_negedge <= pass;
end

endmodule // jt10_cen_burst