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

    100% compared with Alexey Khokholov (Nuke.YKT) work with identical results.
*/

module jt12_pg_comb(
    input       [ 2:0]  block,
    input       [10:0]  fnum,
    // Phase Modulation
    input       [ 4:0]  lfo_mod,
    input       [ 2:0]  pms,
    // output       [ 7:0]  pm_out,

    // Detune
    input       [ 2:0]  detune,

    output  [ 4:0]  keycode,
    output  signed [5:0] detune_out,
    // Phase increment  
    output  [16:0]  phinc_out,
    // Phase add
    input       [ 3:0]  mul,
    input       [19:0]  phase_in,
    input               pg_rst,
    // input signed [7:0]   pm_in,
    input signed [5:0]  detune_in,
    input       [16:0]  phinc_in,

    output  [19:0]  phase_out,
    output  [ 9:0]  phase_op
);

wire signed [8:0] pm_offset;

/*  pm, pg_dt and pg_inc operate in parallel */ 
jt12_pm u_pm(
    .lfo_mod    ( lfo_mod       ),
    .fnum       ( fnum          ),
    .pms        ( pms           ),
    .pm_offset  ( pm_offset     )
);

jt12_pg_dt u_dt(
    .block      ( block     ),
    .fnum       ( fnum      ),
    .detune     ( detune    ),
    .keycode    ( keycode   ),
    .detune_signed( detune_out  )
);

jt12_pg_inc u_inc(
    .block      ( block     ),
    .fnum       ( fnum      ),
    .pm_offset  ( pm_offset ),
    .phinc_pure ( phinc_out )
);

// pg_sum uses the output from the previous blocks

jt12_pg_sum u_sum(
    .mul            ( mul           ),
    .phase_in       ( phase_in      ),
    .pg_rst         ( pg_rst        ),
    .detune_signed  ( detune_in     ),
    .phinc_pure     ( phinc_in      ),
    .phase_out      ( phase_out     ),
    .phase_op       ( phase_op      )
);

endmodule // jt12_pg_comb