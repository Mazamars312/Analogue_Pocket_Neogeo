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
    Date: 2-11-2018
    
    Based on information posted by Nemesis on:
http://gendev.spritesmind.net/forum/viewtopic.php?t=386&postdays=0&postorder=asc&start=167

    Based on jt51_phasegen.v, from JT51 
    
    */

module jt12_pg_inc (
    input       [ 2:0] block,
    input       [10:0] fnum,
    input signed [8:0] pm_offset,
    output reg  [16:0] phinc_pure
);

reg [11:0] fnum_mod;

always @(*) begin 
    fnum_mod = {fnum,1'b0} + {{3{pm_offset[8]}},pm_offset};
    case ( block )
        3'd0: phinc_pure = { 7'd0, fnum_mod[11:2] };
        3'd1: phinc_pure = { 6'd0, fnum_mod[11:1] };
        3'd2: phinc_pure = { 5'd0, fnum_mod[11:0] };
        3'd3: phinc_pure = { 4'd0, fnum_mod, 1'd0 };
        3'd4: phinc_pure = { 3'd0, fnum_mod, 2'd0 };
        3'd5: phinc_pure = { 2'd0, fnum_mod, 3'd0 };
        3'd6: phinc_pure = { 1'd0, fnum_mod, 4'd0 };
        3'd7: phinc_pure = {       fnum_mod, 5'd0 };
    endcase
end

endmodule // jt12_pg_inc