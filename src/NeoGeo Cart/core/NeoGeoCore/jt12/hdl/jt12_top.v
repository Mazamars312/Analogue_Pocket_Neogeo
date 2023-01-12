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
    Date: 14-2-2016

    Based on information posted by Nemesis on:
http://gendev.spritesmind.net/forum/viewtopic.php?t=386&postdays=0&postorder=asc&start=167

    Based on jt51_phasegen.v, from JT51

    */

module jt12_top (
    input           rst,        // rst should be at least 6 clk&cen cycles long
    input           clk,        // CPU clock
    input           cen,        // optional clock enable, it not needed leave as 1'b1
    input   [7:0]   din,
    input   [1:0]   addr,
    input           cs_n,
    input           wr_n,

    output  [7:0]   dout,
    output          irq_n,
    // Configuration
    input           en_hifi_pcm,  // high to enable PCM interpolation on YM2612 mode
    // ADPCM pins
    output  [19:0]  adpcma_addr,  // real hardware has 10 pins multiplexed through RMPX pin
    output  [ 3:0]  adpcma_bank,
    output          adpcma_roe_n, // ADPCM-A ROM output enable
    input   [ 7:0]  adpcma_data,  // Data from RAM
    output  [23:0]  adpcmb_addr,  // real hardware has 12 pins multiplexed through PMPX pin
    input   [ 7:0]  adpcmb_data,
    output          adpcmb_roe_n, // ADPCM-B ROM output enable
    // Separated output
    output          [ 7:0] psg_A,
    output          [ 7:0] psg_B,
    output          [ 7:0] psg_C,
    output  signed  [15:0] fm_snd_left,
    output  signed  [15:0] fm_snd_right,
    output  signed  [15:0] adpcmA_l,
    output  signed  [15:0] adpcmA_r,
    output  signed  [15:0] adpcmB_l,
    output  signed  [15:0] adpcmB_r,
    // combined output
    output          [ 9:0] psg_snd,
    output  signed  [15:0] snd_right, // FM+PSG
    output  signed  [15:0] snd_left,  // FM+PSG
    output                 snd_sample,
    input   [3:0]          snd_enable,
    input   [5:0]          ch_enable
);

// parameters to select the features for each chip type
// defaults to YM2612
parameter use_lfo=1, use_ssg=0, num_ch=6, use_pcm=1;
parameter use_adpcm=0, use_clkdiv=1;
parameter JT49_DIV=2;

wire flag_A, flag_B, busy;

wire write = !cs_n && !wr_n;
wire clk_en, clk_en_ssg;

// Timers
wire    [9:0]   value_A;
wire    [7:0]   value_B;
wire            load_A, load_B;
wire            enable_irq_A, enable_irq_B;
wire            clr_flag_A, clr_flag_B;
wire            overflow_A;
wire            fast_timers;

wire            zero; // Single-clock pulse at the begginig of s1_enters
// LFO
wire    [2:0]   lfo_freq;
wire            lfo_en;
// Operators
wire            amsen_IV;
wire    [ 2:0]  dt1_I;
wire    [ 3:0]  mul_II;
wire    [ 6:0]  tl_IV;

wire    [ 4:0]  keycode_II;
wire    [ 4:0]  ar_I;
wire    [ 4:0]  d1r_I;
wire    [ 4:0]  d2r_I;
wire    [ 3:0]  rr_I;
wire    [ 3:0]  sl_I;
wire    [ 1:0]  ks_II;
// SSG operation
wire            ssg_en_I;
wire    [2:0]   ssg_eg_I;
// envelope operation
wire            keyon_I;
wire    [9:0]   eg_IX;
wire            pg_rst_II;
// Channel
wire    [10:0]  fnum_I;
wire    [ 2:0]  block_I;
wire    [ 1:0]  rl;
wire    [ 2:0]  fb_II;
wire    [ 2:0]  alg_I;
wire    [ 2:0]  pms_I;
wire    [ 1:0]  ams_IV;
// PCM
wire            pcm_en, pcm_wr;
wire    [ 8:0]  pcm;
// Test
wire            pg_stop, eg_stop;

wire            ch6op;
wire    [ 2:0]  cur_ch;
wire    [ 1:0]  cur_op;

// Operator
wire            xuse_internal, yuse_internal;
wire            xuse_prevprev1, xuse_prev2, yuse_prev1, yuse_prev2;
wire    [ 9:0]  phase_VIII;
wire            s1_enters, s2_enters, s3_enters, s4_enters;
wire            rst_int;
// LFO
wire    [6:0]   lfo_mod;
wire            lfo_rst;
// PSG
wire    [3:0]   psg_addr;
wire    [7:0]   psg_data, psg_dout;
wire            psg_wr_n;
// ADPCM-A
wire [15:0] addr_a;
wire [ 2:0] up_addr, up_lracl;
wire        up_start, up_end;
wire [ 7:0] aon_a, lracl;
wire [ 5:0] atl_a;     // ADPCM Total Level
wire        up_aon;
// APDCM-B
wire        acmd_on_b;     // Control - Process start, Key On
wire        acmd_rep_b;    // Control - Repeat
wire        acmd_rst_b;    // Control - Reset
wire        acmd_up_b;     // Control - New cmd received
wire [ 1:0] alr_b;         // Left / Right
wire [15:0] astart_b;      // Start address
wire [15:0] aend_b;        // End   address
wire [15:0] adeltan_b;     // Delta-N
wire [ 7:0] aeg_b;         // Envelope Generator Control
wire [ 5:0] adpcma_flags;  // ADPMC-A read over flags
wire        adpcmb_flag;
wire [ 6:0] flag_ctl;
wire [ 6:0] flag_mask;


wire clk_en_2, clk_en_666, clk_en_111, clk_en_55;
wire  signed  [15:0] adpcmAt_l;
wire  signed  [15:0] adpcmAt_r;
wire  signed  [15:0] adpcmBt_l;
wire  signed  [15:0] adpcmBt_r;
assign adpcmA_l = snd_enable[1] ? adpcmAt_l : 16'd0;
assign adpcmA_r = snd_enable[1] ? adpcmAt_r : 16'd0;
assign adpcmB_l = snd_enable[2] ? adpcmBt_l : 16'd0;
assign adpcmB_r = snd_enable[2] ? adpcmBt_r : 16'd0;
wire  [13:0] op_result_hdt;
assign op_result_hd = snd_enable[0] ? op_result_hdt : 14'd0;

generate
if( use_adpcm==1 ) begin: gen_adpcm
    wire rst_n;

    jt12_rst u_rst(
        .rst    ( rst   ),
        .clk    ( clk   ),
        .rst_n  ( rst_n )
    );

    jt10_adpcm_drvA u_adpcm_a(
        .rst_n      ( rst_n         ),
        .clk        ( clk           ),
        .cen        ( cen           ),
        .cen6       ( clk_en_666    ),  // clk & cen must be 666  kHz
        .cen1       ( clk_en_111    ),  // clk & cen must be 111 kHz

        .addr       ( adpcma_addr   ),  // real hardware has 10 pins multiplexed through RMPX pin
        .bank       ( adpcma_bank   ),
        .roe_n      ( adpcma_roe_n  ),  // ADPCM-A ROM output enable
        .datain     ( adpcma_data   ),

        // Control Registers
        .atl        ( atl_a         ),        // ADPCM Total Level
        .addr_in    ( addr_a        ),
        .lracl_in   ( lracl         ),
        .up_start   ( up_start      ),
        .up_end     ( up_end        ),
        .up_addr    ( up_addr       ),
        .up_lracl   ( up_lracl      ),

        .aon_cmd    ( aon_a         ),    // ADPCM ON equivalent to key on for FM
        .up_aon     ( up_aon        ),
        // Flags
        .flags      ( adpcma_flags  ),
        .clr_flags  ( flag_ctl[5:0] ),

        .pcm55_l    ( adpcmAt_l      ),
        .pcm55_r    ( adpcmAt_r      ),
        .ch_enable  ( ch_enable      )
    );
    /* verilator tracing_on */
    jt10_adpcm_drvB u_adpcm_b(
        .rst_n      ( rst_n         ),
        .clk        ( clk           ),
        .cen        ( cen           ),
        .cen55      ( clk_en_55     ),
        
        // Control
        .acmd_on_b  ( acmd_on_b     ),  // Control - Process start, Key On
        .acmd_rep_b ( acmd_rep_b    ),  // Control - Repeat
        .acmd_rst_b ( acmd_rst_b    ),  // Control - Reset
		  .acmd_up_b  ( acmd_up_b     ),  // Control - New command received
        .alr_b      ( alr_b         ),  // Left / Right
        .astart_b   ( astart_b      ),  // Start address
        .aend_b     ( aend_b        ),  // End   address
        .adeltan_b  ( adeltan_b     ),  // Delta-N
        .aeg_b      ( aeg_b         ),  // Envelope Generator Control
        // Flag
        .flag       ( adpcmb_flag   ),
        .clr_flag   ( flag_ctl[6]   ),
        // memory
        .addr       ( adpcmb_addr   ),
        .data       ( adpcmb_data   ),
        .roe_n      ( adpcmb_roe_n  ),

        .pcm55_l    ( adpcmBt_l      ),
        .pcm55_r    ( adpcmBt_r      )
    );

    /* verilator tracing_on */
    assign snd_sample   = zero;        
    jt10_acc u_acc(
        .clk        ( clk           ),
        .clk_en     ( clk_en        ),
        .op_result  ( op_result_hd  ),
        .rl         ( rl            ),
        .zero       ( zero          ),
        .s1_enters  ( s2_enters     ),
        .s2_enters  ( s1_enters     ),
        .s3_enters  ( s4_enters     ),
        .s4_enters  ( s3_enters     ),
        .cur_ch     ( cur_ch        ),
        .cur_op     ( cur_op        ),
        .alg        ( alg_I         ),
        .adpcmA_l   ( adpcmA_l      ),
        .adpcmA_r   ( adpcmA_r      ),
        .adpcmB_l   ( adpcmB_l      ),
        .adpcmB_r   ( adpcmB_r      ),
        // combined output
        .left       ( fm_snd_left   ),
        .right      ( fm_snd_right  )
    );
end else begin : gen_adpcm_no
    assign adpcmA_l     = 'd0;
    assign adpcmA_r     = 'd0;
    assign adpcmB_l     = 'd0;
    assign adpcmB_r     = 'd0;
    assign adpcma_addr  = 'd0;
    assign adpcma_bank  = 'd0;
    assign adpcma_roe_n = 'b1;
    assign adpcmb_addr  = 'd0;
    assign adpcmb_roe_n = 'd1;
end
endgenerate

/* verilator tracing_off */
jt12_dout #(.use_ssg(use_ssg),.use_adpcm(use_adpcm)) u_dout(
//    .rst_n          ( rst_n         ),
    .clk            ( clk           ),        // CPU clock
    .flag_A         ( flag_A        ),
    .flag_B         ( flag_B        ),
    .busy           ( busy          ),
    .adpcma_flags   ( adpcma_flags & flag_mask[5:0] ),
    .adpcmb_flag    ( adpcmb_flag & flag_mask[6]    ),
    .psg_dout       ( psg_dout      ),
    .addr           ( addr          ),
    .dout           ( dout          )
);


/* verilator tracing_off */
jt12_mmr #(.use_ssg(use_ssg),.num_ch(num_ch),.use_pcm(use_pcm), .use_adpcm(use_adpcm), .use_clkdiv(use_clkdiv))
    u_mmr(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .cen        ( cen       ),  // external clock enable
    .clk_en     ( clk_en    ),  // internal clock enable
    .clk_en_2   ( clk_en_2  ),  // input cen divided by 2
    .clk_en_ssg ( clk_en_ssg),  // internal clock enable
    .clk_en_666 ( clk_en_666),
    .clk_en_111 ( clk_en_111),
    .clk_en_55  ( clk_en_55 ),
    .din        ( din       ),
    .write      ( write     ),
    .addr       ( addr      ),
    .busy       ( busy      ),
    .ch6op      ( ch6op     ),
    .cur_ch     ( cur_ch    ),
    .cur_op     ( cur_op    ),
    // LFO
    .lfo_freq   ( lfo_freq  ),
    .lfo_en     ( lfo_en    ),
    // Timers
    .value_A    ( value_A   ),
    .value_B    ( value_B   ),
    .load_A     ( load_A    ),
    .load_B     ( load_B    ),
    .enable_irq_A   ( enable_irq_A  ),
    .enable_irq_B   ( enable_irq_B  ),
    .clr_flag_A ( clr_flag_A    ),
    .clr_flag_B ( clr_flag_B    ),
    .flag_A     ( flag_A        ),
    .overflow_A ( overflow_A    ),
    .fast_timers( fast_timers   ),
    // PCM
    .pcm        ( pcm           ),
    .pcm_en     ( pcm_en        ),
    .pcm_wr     ( pcm_wr        ),
    // ADPCM-A
    .aon_a      ( aon_a         ),   // ON
    .atl_a      ( atl_a         ),   // TL
    .addr_a     ( addr_a        ),   // address latch
    .lracl      ( lracl         ),   // L/R ADPCM Channel Level
    .up_start   ( up_start      ),   // write enable start address latch
    .up_end     ( up_end        ),   // write enable end address latch
    .up_addr    ( up_addr       ),   // write enable end address latch
    .up_lracl   ( up_lracl      ),
    .up_aon     ( up_aon        ),
    // ADPCM-B
    .acmd_on_b  ( acmd_on_b     ),  // Control - Process start, Key On
    .acmd_rep_b ( acmd_rep_b    ),  // Control - Repeat
    .acmd_rst_b ( acmd_rst_b    ),  // Control - Reset
    .acmd_up_b  ( acmd_up_b     ),  // Control - New command received
    .alr_b      ( alr_b         ),  // Left / Right
    .astart_b   ( astart_b      ),  // Start address
    .aend_b     ( aend_b        ),  // End   address
    .adeltan_b  ( adeltan_b     ),  // Delta-N
    .aeg_b      ( aeg_b         ),  // Envelope Generator Control    
    .flag_ctl   ( flag_ctl      ),
    .flag_mask  ( flag_mask     ),
    // Operator
    .xuse_prevprev1 ( xuse_prevprev1  ),
    .xuse_internal  ( xuse_internal   ),
    .yuse_internal  ( yuse_internal   ),
    .xuse_prev2     ( xuse_prev2      ),
    .yuse_prev1     ( yuse_prev1      ),
    .yuse_prev2     ( yuse_prev2      ),
    // PG
    .fnum_I     ( fnum_I    ),
    .block_I    ( block_I   ),
    .pg_stop    ( pg_stop   ),
    // EG
    .rl         ( rl        ),
    .fb_II      ( fb_II     ),
    .alg_I      ( alg_I     ),
    .pms_I      ( pms_I     ),
    .ams_IV     ( ams_IV    ),
    .amsen_IV   ( amsen_IV  ),
    .dt1_I      ( dt1_I     ),
    .mul_II     ( mul_II    ),
    .tl_IV      ( tl_IV     ),

    .ar_I       ( ar_I      ),
    .d1r_I      ( d1r_I     ),
    .d2r_I      ( d2r_I     ),
    .rr_I       ( rr_I      ),
    .sl_I       ( sl_I      ),
    .ks_II      ( ks_II     ),

    .eg_stop    ( eg_stop   ),
    // SSG operation
    .ssg_en_I   ( ssg_en_I  ),
    .ssg_eg_I   ( ssg_eg_I  ),

    .keyon_I    ( keyon_I   ),
    // Operator
    .zero       ( zero      ),
    .s1_enters  ( s1_enters ),
    .s2_enters  ( s2_enters ),
    .s3_enters  ( s3_enters ),
    .s4_enters  ( s4_enters ),
    // PSG interace
    .psg_addr   ( psg_addr  ),
    .psg_data   ( psg_data  ),
    .psg_wr_n   ( psg_wr_n  )
);

/* verilator tracing_off */
// YM2203 seems to use a fixed cen/3 clock for the timers, regardless 
// of the prescaler setting
wire timer_cen = num_ch==3 ? clk_en_2 : ( fast_timers ? cen : clk_en);
jt12_timers u_timers(
    .clk        ( clk           ),
    .clk_en     ( timer_cen     ),
    .rst        ( rst           ),
    .value_A    ( value_A       ),
    .value_B    ( value_B       ),
    .load_A     ( load_A        ),
    .load_B     ( load_B        ),
    .enable_irq_A( enable_irq_A ),
    .enable_irq_B( enable_irq_B ),
    .clr_flag_A ( clr_flag_A    ),
    .clr_flag_B ( clr_flag_B    ),
    .flag_A     ( flag_A        ),
    .flag_B     ( flag_B        ),
    .overflow_A ( overflow_A    ),
    .irq_n      ( irq_n         )
);

// YM2203 does not have LFO
generate
if( use_lfo== 1) begin : gen_lfo
    jt12_lfo u_lfo(
        .rst        ( rst       ),
        .clk        ( clk       ),
        .clk_en     ( clk_en    ),
        .zero       ( zero      ),
        `ifdef NOLFO
        .lfo_rst    ( 1'b1      ),
        `else
        .lfo_rst    ( 1'b0      ),
        `endif
        .lfo_en     ( lfo_en    ),
        .lfo_freq   ( lfo_freq  ),
        .lfo_mod    ( lfo_mod   )
    );
end else begin : gen_nolfo
    assign lfo_mod = 7'd0;
end
endgenerate

// YM2203/YM2610 have a PSG

`ifndef NOSSG
generate
    if( use_ssg==1 ) begin : gen_ssg
        jt49 #(.COMP(2'b01), .CLKDIV(JT49_DIV)) 
            u_psg( // note that input ports are not multiplexed
            .rst_n      ( ~rst      ),
            .clk        ( clk       ),    // signal on positive edge
            .clk_en     ( clk_en_ssg),    // clock enable on negative edge
            .addr       ( psg_addr  ),
            .cs_n       ( 1'b0      ),
            .wr_n       ( psg_wr_n  ),  // write
            .din        ( psg_data  ),
            .sound      ( psg_snd   ),  // combined output
            .A          ( psg_A     ),
            .B          ( psg_B     ),
            .C          ( psg_C     ),
            .dout       ( psg_dout  ),
            .sel        ( 1'b1      ),  // half clock speed
            // Unused:
            .IOA_out    (),
            .IOB_out    (),
            .IOA_in     (8'd0),
            .IOB_in     (8'd0)
        );
        assign snd_left  = snd_enable[3] ? fm_snd_left  + { 1'b0, psg_snd[9:0],5'd0} : fm_snd_left;
        assign snd_right = snd_enable[3] ? fm_snd_right + { 1'b0, psg_snd[9:0],5'd0} : fm_snd_right;
    end else begin : gen_nossg
        assign psg_snd  = 10'd0;
        assign snd_left = fm_snd_left;
        assign snd_right= fm_snd_right;
        assign psg_dout = 8'd0;
        assign psg_A    = 8'd0;
        assign psg_B    = 8'd0;
        assign psg_C    = 8'd0;
    end
endgenerate
`else
    assign psg_snd  = 10'd0;
    assign snd_left = fm_snd_left;
    assign snd_right= fm_snd_right;
    assign psg_dout = 8'd0;
`endif

wire    [ 8:0]  op_result;
wire    [13:0]  op_result_hd;
`ifndef NOFM
/* verilator tracing_off */
jt12_pg #(.num_ch(num_ch)) u_pg(
    .rst        ( rst           ),
    .clk        ( clk           ),
    .clk_en     ( clk_en        ),
    // Channel frequency
    .fnum_I     ( fnum_I        ),
    .block_I    ( block_I       ),
    // Operator multiplying
    .mul_II     ( mul_II        ),
    // Operator detuning
    .dt1_I      ( dt1_I         ), // same as JT51's DT1
    // Phase modulation by LFO
    .lfo_mod    ( lfo_mod       ),
    .pms_I      ( pms_I         ),
    // phase operation
    .pg_rst_II  ( pg_rst_II     ),
    .pg_stop    ( pg_stop       ),
    .keycode_II ( keycode_II    ),
    .phase_VIII ( phase_VIII    )
);

wire [9:0] eg_V;

jt12_eg #(.num_ch(num_ch)) u_eg(
    .rst            ( rst           ),
    .clk            ( clk           ),
    .clk_en         ( clk_en        ),
    .zero           ( zero          ),
    .eg_stop        ( eg_stop       ),
    // envelope configuration
    .keycode_II     ( keycode_II    ),
    .arate_I        ( ar_I          ), // attack  rate
    .rate1_I        ( d1r_I         ), // decay   rate
    .rate2_I        ( d2r_I         ), // sustain rate
    .rrate_I        ( rr_I          ), // release rate
    .sl_I           ( sl_I          ), // sustain level
    .ks_II          ( ks_II         ), // key scale
    // SSG operation
    .ssg_en_I       ( ssg_en_I      ),
    .ssg_eg_I       ( ssg_eg_I      ),
    // envelope operation
    .keyon_I        ( keyon_I       ),
    // envelope number
    .lfo_mod        ( lfo_mod       ),
    .tl_IV          ( tl_IV         ),
    .ams_IV         ( ams_IV        ),
    .amsen_IV       ( amsen_IV      ),

    .eg_V           ( eg_V          ),
    .pg_rst_II      ( pg_rst_II     )
);

jt12_sh #(.width(10),.stages(4)) u_egpad(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .din    ( eg_V      ),
    .drop   ( eg_IX     )
);

jt12_op #(.num_ch(num_ch)) u_op(
    .rst            ( rst           ),
    .clk            ( clk           ),
    .clk_en         ( clk_en        ),
    .pg_phase_VIII  ( phase_VIII    ),
    .eg_atten_IX    ( eg_IX         ),
    .fb_II          ( fb_II         ),

    .test_214       ( 1'b0          ),
    .s1_enters      ( s1_enters     ),
    .s2_enters      ( s2_enters     ),
    .s3_enters      ( s3_enters     ),
    .s4_enters      ( s4_enters     ),
    .xuse_prevprev1 ( xuse_prevprev1),
    .xuse_internal  ( xuse_internal ),
    .yuse_internal  ( yuse_internal ),
    .xuse_prev2     ( xuse_prev2    ),
    .yuse_prev1     ( yuse_prev1    ),
    .yuse_prev2     ( yuse_prev2    ),
    .zero           ( zero          ),
    .op_result      ( op_result     ),
    .full_result    ( op_result_hdt  )
);
`else 
assign op_result    = 'd0;
assign op_result_hd = 'd0;
`endif

/* verilator tracing_on */

generate
    if( use_pcm==1 ) begin: gen_pcm_acc // YM2612 accumulator
        assign fm_snd_right[3:0] = 4'd0;
        assign fm_snd_left [3:0] = 4'd0;
        assign snd_sample        = zero;
        reg signed [8:0] pcm2;

        // interpolate PCM samples with automatic sample rate detection
        // this feature is not present in original YM2612
        // this improves PCM sample sound greatly
        /*
        jt12_pcm u_pcm(
            .rst        ( rst       ),
            .clk        ( clk       ),
            .clk_en     ( clk_en    ),
            .zero       ( zero      ),
            .pcm        ( pcm       ),
            .pcm_wr     ( pcm_wr    ),
            .pcm_resampled ( pcm2   )
        );
        */
        wire rst_pcm_n;

        jt12_rst u_rst_pcm(
            .rst    ( rst       ),
            .clk    ( clk       ),
            .rst_n  ( rst_pcm_n )
        );

        `ifndef NOPCMLINEAR
        wire signed [10:0] pcm_full;
        always @(*)
            pcm2 = en_hifi_pcm ? pcm_full[9:1] : pcm;
            
        jt12_pcm_interpol #(.dw(11), .stepw(5)) u_pcm (
            .rst_n ( rst_pcm_n      ),
            .clk   ( clk            ),
            .cen   ( clk_en         ),
            .cen55 ( clk_en_55      ),
            .pcm_wr( pcm_wr         ),
            .pcmin ( {pcm[8],pcm, 1'b0}    ),
            .pcmout( pcm_full       )
        );
        `else
        assign pcm2 = pcm;
        `endif

        jt12_acc u_acc(
            .rst        ( rst       ),
            .clk        ( clk       ),
            .clk_en     ( clk_en    ),
            .op_result  ( op_result ),
            .rl         ( rl        ),
            // note that the order changes to deal
            // with the operator pipeline delay
            .zero       ( zero      ),
            .s1_enters  ( s2_enters ),
            .s2_enters  ( s1_enters ),
            .s3_enters  ( s4_enters ),
            .s4_enters  ( s3_enters ),
            .ch6op      ( ch6op     ),
            .pcm_en     ( pcm_en    ),  // only enabled for channel 6
            .pcm        ( pcm2      ),
            .alg        ( alg_I     ),
            // combined output
            .left       ( fm_snd_left [15:4]  ),
            .right      ( fm_snd_right[15:4]  )
        );
    end
    if( use_pcm==0 && use_adpcm==0 ) begin : gen_2203_acc // YM2203 accumulator
        wire signed [15:0] mono_snd;
        assign fm_snd_left  = mono_snd;
        assign fm_snd_right = mono_snd;
        assign snd_sample   = zero;
        jt03_acc u_acc(
            .rst        ( rst       ),
            .clk        ( clk       ),
            .clk_en     ( clk_en    ),
            .op_result  ( op_result_hd ),
            // note that the order changes to deal
            // with the operator pipeline delay
            .s1_enters  ( s1_enters ),
            .s2_enters  ( s2_enters ),
            .s3_enters  ( s3_enters ),
            .s4_enters  ( s4_enters ),
            .alg        ( alg_I     ),
            .zero       ( zero      ),
            // combined output
            .snd        ( mono_snd  )
        );
    end
endgenerate
endmodule
