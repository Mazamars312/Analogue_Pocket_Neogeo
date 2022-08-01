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
    Date: 30-10-2018

    */

module jt12_eg_comb(
    input               keyon_now,
    input               keyoff_now,
    input       [2:0]   state_in,
    input       [9:0]   eg_in,
    // envelope configuration   
    input       [4:0]   arate, // attack  rate
    input       [4:0]   rate1, // decay   rate
    input       [4:0]   rate2, // sustain rate
    input       [3:0]   rrate,
    input       [3:0]   sl,   // sustain level
    // SSG operation
    input               ssg_en,
    input       [2:0]   ssg_eg,
    // SSG output inversion
    input               ssg_inv_in,
    output          ssg_inv_out,

    output  [4:0]   base_rate,
    output  [2:0]   state_next,
    output          pg_rst,
    ///////////////////////////////////
    // II
    input           step_attack,
    input [ 4:0]    step_rate_in,
    input [ 4:0]    keycode,
    input [14:0]    eg_cnt,
    input           cnt_in,
    input [ 1:0]    ks,
    output          cnt_lsb,
    output        step,
    output  [5:0] step_rate_out,
    output          sum_up_out,
    ///////////////////////////////////
    // III
    input           pure_attack,
    input           pure_step,
    input [ 5:1]    pure_rate,
    input           pure_ssg_en,
    input [ 9:0]    pure_eg_in,
    output   [9:0]  pure_eg_out,
    input           sum_up_in,
    ///////////////////////////////////
    // IV
    input [ 6:0]    lfo_mod,
    input           amsen,
    input [ 1:0]    ams,
    input [ 6:0]    tl,
    input [ 9:0]    final_eg_in,
    input           final_ssg_inv,
    output  [9:0] final_eg_out
);

// I
jt12_eg_ctrl u_ctrl(    
    .keyon_now      ( keyon_now     ),
    .keyoff_now     ( keyoff_now    ),
    .state_in       ( state_in      ),
    .eg             ( eg_in         ),
    // envelope configuration   
    .arate          ( arate         ), // attack  rate
    .rate1          ( rate1         ), // decay   rate
    .rate2          ( rate2         ), // sustain rate
    .rrate          ( rrate         ),
    .sl             ( sl            ), // sustain level
    // SSG operation
    .ssg_en         ( ssg_en        ),
    .ssg_eg         ( ssg_eg        ),
    // SSG output inversion
    .ssg_inv_in     ( ssg_inv_in    ),
    .ssg_inv_out    ( ssg_inv_out   ),

    .base_rate      ( base_rate     ),
    .state_next     ( state_next    ),
    .pg_rst         ( pg_rst        )
);

// II

jt12_eg_step u_step(
    .attack     ( step_attack   ),
    .base_rate  ( step_rate_in  ),
    .keycode    ( keycode       ),
    .eg_cnt     ( eg_cnt        ),
    .cnt_in     ( cnt_in        ),
    .ks         ( ks            ),
    .cnt_lsb    ( cnt_lsb       ),
    .step       ( step          ),
    .rate       ( step_rate_out ),
    .sum_up     ( sum_up_out    )
);

// III

wire [9:0] egin, egout;
jt12_eg_pure u_pure(
    .attack ( pure_attack   ),
    .step   ( pure_step     ),
    .rate   ( pure_rate     ),
    .ssg_en ( pure_ssg_en   ),
    .eg_in  ( pure_eg_in    ),
    .eg_pure( pure_eg_out   ),
    .sum_up ( sum_up_in     )
);

// IV

jt12_eg_final u_final(
    .lfo_mod    ( lfo_mod       ),
    .amsen      ( amsen         ),
    .ams        ( ams           ),
    .tl         ( tl            ),
    .ssg_inv    ( final_ssg_inv ),
    .eg_pure_in ( final_eg_in   ),
    .eg_limited ( final_eg_out  )
);

endmodule // jt12_eg_comb