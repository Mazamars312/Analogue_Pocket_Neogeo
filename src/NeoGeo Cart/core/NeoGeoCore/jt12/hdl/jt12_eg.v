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
    Date: 29-10-2018

    */

module jt12_eg (
    input               rst,
    input               clk,
    input               clk_en /* synthesis direct_enable */,
    input               zero,
    input               eg_stop,
    // envelope configuration
    input       [4:0]   keycode_II,
    input       [4:0]   arate_I, // attack  rate
    input       [4:0]   rate1_I, // decay   rate
    input       [4:0]   rate2_I, // sustain rate
    input       [3:0]   rrate_I, // release rate
    input       [3:0]   sl_I,   // sustain level
    input       [1:0]   ks_II,     // key scale
    // SSG operation
    input               ssg_en_I,
    input       [2:0]   ssg_eg_I,
    // envelope operation
    input               keyon_I,
    // envelope number
    input       [6:0]   lfo_mod,
    input               amsen_IV,
    input       [1:0]   ams_IV,
    input       [6:0]   tl_IV,

    output  reg [9:0]   eg_V,
    output  reg         pg_rst_II
);

parameter num_ch=6;

wire [14:0] eg_cnt;

jt12_eg_cnt u_egcnt(
    .rst    ( rst   ),
    .clk    ( clk   ),
    .clk_en ( clk_en & ~eg_stop ),
    .zero   ( zero  ),
    .eg_cnt ( eg_cnt)
);

wire keyon_last_I;
wire keyon_now_I  = !keyon_last_I && keyon_I;
wire keyoff_now_I = keyon_last_I && !keyon_I;

wire cnt_in_II, cnt_lsb_II, step_II, pg_rst_I;

wire ssg_inv_in_I, ssg_inv_out_I;
reg  ssg_inv_II, ssg_inv_III, ssg_inv_IV;
wire [2:0] state_in_I, state_next_I;

reg attack_II, attack_III;
wire [4:0] base_rate_I;
reg  [4:0] base_rate_II;
wire  [5:0] rate_out_II;
reg  [5:1] rate_in_III;
reg step_III, ssg_en_II, ssg_en_III;
wire sum_out_II;
reg sum_in_III;

wire [9:0] eg_in_I, pure_eg_out_III, eg_next_III, eg_out_IV;
reg  [9:0] eg_in_II, eg_in_III, eg_in_IV;



jt12_eg_comb u_comb(
    ///////////////////////////////////
    // I
    .keyon_now      ( keyon_now_I   ),
    .keyoff_now     ( keyoff_now_I  ),
    .state_in       ( state_in_I    ),
    .eg_in          ( eg_in_I       ),
    // envelope configuration   
    .arate          ( arate_I       ), // attack  rate
    .rate1          ( rate1_I       ), // decay   rate
    .rate2          ( rate2_I       ), // sustain rate
    .rrate          ( rrate_I       ),
    .sl             ( sl_I          ),   // sustain level
    // SSG operation
    .ssg_en         ( ssg_en_I      ),
    .ssg_eg         ( ssg_eg_I      ),
    // SSG output inversion
    .ssg_inv_in     ( ssg_inv_in_I  ),
    .ssg_inv_out    ( ssg_inv_out_I ),

    .base_rate      ( base_rate_I   ),
    .state_next     ( state_next_I  ),
    .pg_rst         ( pg_rst_I      ),
    ///////////////////////////////////
    // II
    .step_attack    ( attack_II     ),
    .step_rate_in   ( base_rate_II  ),
    .keycode        ( keycode_II    ),
    .eg_cnt         ( eg_cnt        ),
    .cnt_in         ( cnt_in_II     ),
    .ks             ( ks_II         ),
    .cnt_lsb        ( cnt_lsb_II    ),
    .step           ( step_II       ),
    .step_rate_out  ( rate_out_II   ),
    .sum_up_out     ( sum_out_II    ),
    ///////////////////////////////////
    // III
    .pure_attack    ( attack_III        ),
    .pure_step      ( step_III          ),
    .pure_rate      ( rate_in_III[5:1]  ),
    .pure_ssg_en    ( ssg_en_III        ), 
    .pure_eg_in     ( eg_in_III         ),
    .pure_eg_out    ( pure_eg_out_III   ),
    .sum_up_in      ( sum_in_III        ),
    ///////////////////////////////////
    // IV
    .lfo_mod        ( lfo_mod       ),
    .amsen          ( amsen_IV      ),
    .ams            ( ams_IV        ),
    .tl             ( tl_IV         ),
    .final_ssg_inv  ( ssg_inv_IV    ), 
    .final_eg_in    ( eg_in_IV      ),
    .final_eg_out   ( eg_out_IV     )
);

always @(posedge clk) if(clk_en) begin
    eg_in_II    <= eg_in_I;
    attack_II   <= state_next_I[0];
    base_rate_II<= base_rate_I;
    ssg_en_II   <= ssg_en_I;
    ssg_inv_II  <= ssg_inv_out_I;
    pg_rst_II   <= pg_rst_I;

    eg_in_III   <= eg_in_II;
    attack_III  <= attack_II;
    rate_in_III <= rate_out_II[5:1];
    ssg_en_III  <= ssg_en_II;
    ssg_inv_III <= ssg_inv_II;
    step_III    <= step_II;
    sum_in_III  <= sum_out_II;

    ssg_inv_IV  <= ssg_inv_III;
    eg_in_IV    <= pure_eg_out_III;
    eg_V        <= eg_out_IV;
end

jt12_sh #( .width(1), .stages(4*num_ch) ) u_cntsh(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .din    ( cnt_lsb_II),
    .drop   ( cnt_in_II )
);

jt12_sh_rst #( .width(10), .stages(4*num_ch-3), .rstval(1'b1) ) u_egsh(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .rst    ( rst       ),
    .din    ( eg_in_IV  ),
    .drop   ( eg_in_I   )
);

jt12_sh_rst #( .width(3), .stages(4*num_ch), .rstval(1'b1) ) u_egstate(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .rst    ( rst       ),
    .din    ( state_next_I  ),
    .drop   ( state_in_I    )
);

jt12_sh_rst #( .width(1), .stages(4*num_ch-3), .rstval(1'b0) ) u_ssg_inv(
    .clk    ( clk           ),
    .clk_en ( clk_en        ),
    .rst    ( rst           ),
    .din    ( ssg_inv_IV    ),
    .drop   ( ssg_inv_in_I  )
);

jt12_sh_rst #( .width(1), .stages(4*num_ch), .rstval(1'b0) ) u_konsh(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .rst    ( rst       ),  
    .din    ( keyon_I   ),
    .drop   ( keyon_last_I  )
);


endmodule // jt12_eg