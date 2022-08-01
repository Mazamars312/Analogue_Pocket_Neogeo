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

    Note that detune produces an output even for fnum==0, is that correct?

    Based on jt51_phasegen.v, from JT51 
    
    */

module jt12_pg_dt(
    input       [ 2:0]  block,
    input       [10:0]  fnum,
    input       [ 2:0]  detune,

    output reg  [ 4:0]  keycode,
    output reg signed [5:0] detune_signed
);

reg [5:0] detune_kf;
reg [4:0] pow2;
reg [5:0] detune_unlimited;
reg [4:0] detune_limit, detune_limited;


always @(*) begin
    keycode = { block, fnum[10], fnum[10] ? (|fnum[9:7]) : (&fnum[9:7])};
    case( detune[1:0] )
        2'd1:   detune_kf   =   { 1'b0, keycode } - 6'd4;
        2'd2:   detune_kf   =   { 1'b0, keycode } + 6'd4;
        2'd3:   detune_kf   =   { 1'b0, keycode } + 6'd8;
        default:detune_kf   =   { 1'b0, keycode };
    endcase
    case( detune_kf[2:0] )
        3'd0: pow2 = 5'd16;
        3'd1: pow2 = 5'd17;
        3'd2: pow2 = 5'd19;
        3'd3: pow2 = 5'd20;
        3'd4: pow2 = 5'd22;
        3'd5: pow2 = 5'd24;
        3'd6: pow2 = 5'd26;
        3'd7: pow2 = 5'd29;
    endcase
    case( detune[1:0] )
        2'd0: detune_limit = 5'd0;
        2'd1: detune_limit = 5'd8;
        2'd2: detune_limit = 5'd16;
        2'd3: detune_limit = 5'd22;
    endcase
    case( detune_kf[5:3] )
        3'd0:   detune_unlimited = { 5'd0, pow2[4]   }; // <2
        3'd1:   detune_unlimited = { 4'd0, pow2[4:3] }; // <4
        3'd2:   detune_unlimited = { 3'd0, pow2[4:2] }; // <8
        3'd3:   detune_unlimited = { 2'd0, pow2[4:1] };
        3'd4:   detune_unlimited = { 1'd0, pow2[4:0] };
        3'd5:   detune_unlimited = { pow2[4:0], 1'd0 };
        default:detune_unlimited = 6'd0;
    endcase
    detune_limited = detune_unlimited > {1'b0, detune_limit} ? 
                            detune_limit : detune_unlimited[4:0];
    detune_signed = !detune[2] ? {1'b0,detune_limited} : (~{1'b0,detune_limited}+6'd1);
end

endmodule
