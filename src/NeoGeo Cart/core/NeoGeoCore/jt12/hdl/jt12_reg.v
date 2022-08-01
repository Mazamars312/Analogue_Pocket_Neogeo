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
    Date: 14-2-2017 

*/

module jt12_reg(
    input           rst,
    input           clk,
    input           clk_en /* synthesis direct_enable */,
    input   [7:0]   din,
    
    input   [2:0]   ch,     // channel to update
    input   [1:0]   op,
    
    input           csm,
    input           flag_A,
    input           overflow_A,

    input           up_keyon,   
    input           up_alg, 
    input           up_fnumlo,
    input           up_pms,
    input           up_dt1,
    input           up_tl,
    input           up_ks_ar,
    input           up_amen_dr,
    input           up_sr,
        
    input           up_sl_rr,
    input           up_ssgeg,

    output reg       ch6op,  // 1 when the operator belongs to CH6
    output reg [2:0] cur_ch,
    output reg [1:0] cur_op,
    
    // CH3 Effect-mode operation
    input           effect,
    input   [10:0]  fnum_ch3op2,
    input   [10:0]  fnum_ch3op3, 
    input   [10:0]  fnum_ch3op1,
    input   [ 2:0]  block_ch3op2,
    input   [ 2:0]  block_ch3op3,
    input   [ 2:0]  block_ch3op1,
    input   [ 5:0]  latch_fnum,
    // Pipeline order
    output  reg     zero,
    output          s1_enters,
    output          s2_enters,
    output          s3_enters,
    output          s4_enters,
    
    // Operator
    output          xuse_prevprev1,
    output          xuse_internal,
    output          yuse_internal, 
    output          xuse_prev2,
    output          yuse_prev1,
    output          yuse_prev2,
    
    // PG
    output      [10:0]  fnum_I,
    output      [ 2:0]  block_I,
    // channel configuration
    output      [1:0]   rl,
    output reg  [2:0]   fb_II,
    output      [2:0]   alg_I,
    // Operator multiplying
    output      [ 3:0]  mul_II,
    // Operator detuning
    output      [ 2:0]  dt1_I,
    
    // EG
    output      [4:0]   ar_I,   // attack  rate
    output      [4:0]   d1r_I, // decay   rate
    output      [4:0]   d2r_I, // sustain rate
    output      [3:0]   rr_I,   // release rate
    output      [3:0]   sl_I,   // sustain level
    output      [1:0]   ks_II,     // key scale
    output              ssg_en_I,
    output      [2:0]   ssg_eg_I,
    output      [6:0]   tl_IV,
    output      [2:0]   pms_I,
    output      [1:0]   ams_IV,
    output              amsen_IV,

    // envelope operation
    output          keyon_I
);

parameter num_ch=6; // Use only 3 (YM2203/YM2610) or 6 (YM2612/YM2608)


reg  [1:0] next_op;
reg  [2:0] next_ch;
reg last;

`ifdef SIMULATION
// These signals need to operate during rst
// initial state is not relevant (or critical) in real life
// but we need a clear value during simulation
// This does not work with NCVERILOG
initial begin
    cur_op = 2'd0;
    cur_ch = 3'd0;
    next_op = 2'd0;
    next_ch = 3'd1;
    last    = 1'b0;
    zero    = 1'b1;
end
`endif

assign s1_enters = cur_op == 2'b00;
assign s3_enters = cur_op == 2'b01;
assign s2_enters = cur_op == 2'b10;
assign s4_enters = cur_op == 2'b11;

wire [4:0] next = { next_op, next_ch };
wire [4:0] cur  = {  cur_op,  cur_ch };

wire [2:0] fb_I;

always @(posedge clk) if( clk_en ) begin
    fb_II <= fb_I;
    ch6op <= next_ch==3'd6;
end 

// FNUM and BLOCK
wire    [10:0]  fnum_I_raw;
wire    [ 2:0]  block_I_raw;
wire    effect_on = effect && (cur_ch==3'd2);
wire    effect_on_s1 = effect_on && (cur_op == 2'd0 );
wire    effect_on_s3 = effect_on && (cur_op == 2'd1 );
wire    effect_on_s2 = effect_on && (cur_op == 2'd2 );
wire    noeffect     = ~|{effect_on_s1, effect_on_s3, effect_on_s2};
assign fnum_I = ( {11{effect_on_s1}} & fnum_ch3op1 ) |
                ( {11{effect_on_s2}} & fnum_ch3op2 ) |
                ( {11{effect_on_s3}} & fnum_ch3op3 ) |
                ( {11{noeffect}}     & fnum_I_raw  );

assign block_I =( {3{effect_on_s1}} & block_ch3op1 ) |
                ( {3{effect_on_s2}} & block_ch3op2 ) |
                ( {3{effect_on_s3}} & block_ch3op3 ) |
                ( {3{noeffect}}  & block_I_raw  );
                
wire [4:0] req_opch_I = { op, ch };
wire [4:0]  req_opch_II, req_opch_III, 
            req_opch_IV, req_opch_V; //, req_opch_VI;
                
jt12_sumch #(.num_ch(num_ch)) u_opch_II ( .chin(req_opch_I  ), .chout(req_opch_II ) );
jt12_sumch #(.num_ch(num_ch)) u_opch_III( .chin(req_opch_II ), .chout(req_opch_III) );
jt12_sumch #(.num_ch(num_ch)) u_opch_IV ( .chin(req_opch_III), .chout(req_opch_IV ) );
jt12_sumch #(.num_ch(num_ch)) u_opch_V  ( .chin(req_opch_IV ), .chout(req_opch_V  ) );
// jt12_sumch #(.num_ch(num_ch)) u_opch_VI ( .chin(req_opch_V  ), .chout(req_opch_VI)  );

wire update_op_I  = cur == req_opch_I;
wire update_op_II = cur == req_opch_II;
// wire update_op_III= cur == req_opch_III;
wire update_op_IV = cur == req_opch_IV;
// wire update_op_V  = cur == req_opch_V;
// wire update_op_VI = cur == opch_VI;
// wire [2:0] op_plus1 = op+2'd1;
// wire update_op_VII= cur == { op_plus1[1:0], ch };

// key on/off
wire    [3:0]   keyon_op = din[7:4];
wire    [2:0]   keyon_ch = din[2:0];
// channel data
wire    [2:0]   fb_in   = din[5:3];
wire    [2:0]   alg_in  = din[2:0];
wire    [2:0]   pms_in  = din[2:0];
wire    [1:0]   ams_in  = din[5:4];
wire    [7:0]   fnlo_in = din;


wire    update_ch_I  = cur_ch == ch;
wire    update_ch_IV = num_ch==6 ? 
    { ~cur_ch[2], cur_ch[1:0]} == ch : // 6 channels
    cur[1:0] == ch[1:0]; // 3 channels

wire up_alg_ch  = up_alg    & update_ch_I;
wire up_fnumlo_ch=up_fnumlo & update_ch_I;
wire up_pms_ch  = up_pms    & update_ch_I;
wire up_ams_ch  = up_pms    & update_ch_IV;

always @(*) begin
    // next = cur==5'd23 ? 5'd0 : cur +1'b1;
    if( num_ch==6 ) begin
        next_op = cur_ch==3'd6 ? cur_op+1'b1 : cur_op;
        next_ch = cur_ch[1:0]==2'b10 ? cur_ch+2'd2 : cur_ch+1'd1;
    end else begin // 3 channels
        next_op = cur_ch==3'd2 ? cur_op+1'b1 : cur_op;
        next_ch = cur_ch[1:0]==2'b10 ? 3'd0 : cur_ch+1'd1;      
    end
end

always @(posedge clk) begin : up_counter
    if( clk_en ) begin
        { cur_op, cur_ch }  <= { next_op, next_ch };
        zero    <= next == 5'd0;
    end
end

`ifndef NOFM
jt12_kon #(.num_ch(num_ch)) u_kon(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .clk_en     ( clk_en    ),
    .keyon_op   ( keyon_op  ),
    .keyon_ch   ( keyon_ch  ),
    .next_op    ( next_op   ),
    .next_ch    ( next_ch   ),
    .up_keyon   ( up_keyon  ),
    .csm        ( csm       ),
    // .flag_A      ( flag_A    ),
    .overflow_A ( overflow_A),
    
    .keyon_I    ( keyon_I   )
);

jt12_mod #(.num_ch(num_ch)) u_mod(
    .alg_I      ( alg_I     ),
    .s1_enters  ( s1_enters ),
    .s3_enters  ( s3_enters ),
    .s2_enters  ( s2_enters ),
    .s4_enters  ( s4_enters ),
    
    .xuse_prevprev1 ( xuse_prevprev1  ),
    .xuse_internal  ( xuse_internal   ),
    .yuse_internal  ( yuse_internal   ),  
    .xuse_prev2     ( xuse_prev2      ),
    .yuse_prev1     ( yuse_prev1      ),
    .yuse_prev2     ( yuse_prev2      )
);

wire [43:0] shift_out;

generate
    if( num_ch==6 ) begin
        // YM2612 / YM3438: Two CSR.
        wire [43:0] shift_middle;

        jt12_csr u_csr0(
            .rst            ( rst           ),
            .clk            ( clk           ),
            .clk_en         ( clk_en        ),
            .din            ( din           ),
            .shift_in       ( shift_out     ),
            .shift_out      ( shift_middle  ),
            .up_tl          ( up_tl         ),     
            .up_dt1         ( up_dt1        ),    
            .up_ks_ar       ( up_ks_ar      ),  
            .up_amen_dr     ( up_amen_dr    ),
            .up_sr          ( up_sr         ),     
            .up_sl_rr       ( up_sl_rr      ),  
            .up_ssgeg       ( up_ssgeg      ),  
            .update_op_I    ( update_op_I   ),
            .update_op_II   ( update_op_II  ),
            .update_op_IV   ( update_op_IV  )
        );

        wire up_midop_I  = { ~cur[4], cur[3:0] } == req_opch_I;
        wire up_midop_II = { ~cur[4], cur[3:0] } == req_opch_II;
        wire up_midop_IV = { ~cur[4], cur[3:0] } == req_opch_IV;

        jt12_csr u_csr1(
            .rst            ( rst           ),
            .clk            ( clk           ),
            .clk_en         ( clk_en        ),
            .din            ( din           ),
            .shift_in       ( shift_middle  ),
            .shift_out      ( shift_out     ),
            .up_tl          ( up_tl         ),     
            .up_dt1         ( up_dt1        ),    
            .up_ks_ar       ( up_ks_ar      ),  
            .up_amen_dr     ( up_amen_dr    ),
            .up_sr          ( up_sr         ),     
            .up_sl_rr       ( up_sl_rr      ),  
            .up_ssgeg       ( up_ssgeg      ),  
            // update in the middle:
            .update_op_I    ( up_midop_I    ),
            .update_op_II   ( up_midop_II   ),
            .update_op_IV   ( up_midop_IV   )
        );
    end
    else begin // YM2203 only has one CSR
        jt12_csr u_csr0(
            .rst            ( rst           ),
            .clk            ( clk           ),
            .clk_en         ( clk_en        ),
            .din            ( din           ),
            .shift_in       ( shift_out     ),
            .shift_out      ( shift_out     ),
            .up_tl          ( up_tl         ),     
            .up_dt1         ( up_dt1        ),    
            .up_ks_ar       ( up_ks_ar      ),  
            .up_amen_dr     ( up_amen_dr    ),
            .up_sr          ( up_sr         ),     
            .up_sl_rr       ( up_sl_rr      ),  
            .up_ssgeg       ( up_ssgeg      ),  
            .update_op_I    ( update_op_I   ),
            .update_op_II   ( update_op_II  ),
            .update_op_IV   ( update_op_IV  )
        );
    end // else
endgenerate

assign { tl_IV,   dt1_I,    mul_II,    ks_II, 
         ar_I,    amsen_IV, d1r_I,     d2r_I, 
         sl_I,    rr_I,     ssg_en_I,  ssg_eg_I } = shift_out;


// memory for CH registers
// Block/fnum data is latched until fnum low byte is written to
// Trying to synthesize this memory as M-9K RAM in Altera devices
// turns out worse in terms of resource utilization. Probably because
// this memory is already very small. It is better to leave it as it is.
localparam regch_width=25;
wire [regch_width-1:0] regch_out;
wire [regch_width-1:0] regch_in = {
    up_fnumlo_ch? { latch_fnum, fnlo_in } : { block_I_raw, fnum_I_raw }, // 14
    up_alg_ch   ? { fb_in, alg_in } : { fb_I, alg_I },//3+3
    up_ams_ch   ?            ams_in : ams_IV, //2
    up_pms_ch   ?            pms_in : pms_I   //3
}; 

assign {    block_I_raw, fnum_I_raw, 
            fb_I, alg_I, ams_IV, pms_I } = regch_out;

jt12_sh_rst #(.width(regch_width),.stages(num_ch)) u_regch(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .rst    ( rst       ),
    .din    ( regch_in  ),
    .drop   ( regch_out )
);

generate
if( num_ch==6 ) begin
    // RL is on a different register to 
    // have the reset to 1
    wire [1:0] rl_in   = din[7:6];	 
    jt12_sh_rst #(.width(2),.stages(num_ch),.rstval(1'b1)) u_regch_rl(
        .clk    ( clk       ),
        .clk_en ( clk_en    ),
        .rst    ( rst       ),
        .din    ( up_pms_ch ? rl_in :  rl   ),
        .drop   ( rl    )
    );
end else begin // YM2203 has no stereo output
    assign rl=2'b11;
end
    
endgenerate
`endif
endmodule
