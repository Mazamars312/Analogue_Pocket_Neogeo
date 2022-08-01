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

module jt10_adpcm_drvA(
    input           rst_n,
    input           clk,    // CPU clock
    input           cen,    // same cen as MMR
    input           cen6,   // clk & cen = 666 kHz
    input           cen1,   // clk & cen = 111 kHz

    output  [19:0]  addr,  // real hardware has 10 pins multiplexed through RMPX pin
    output  [3:0]   bank,
    output          roe_n, // ADPCM-A ROM output enable

    // Control Registers
    input   [5:0]   atl,        // ADPCM Total Level
    input   [7:0]   lracl_in,
    input   [15:0]  addr_in,

    input   [2:0]   up_lracl,
    input           up_start,
    input           up_end,
    input   [2:0]   up_addr,

    input   [7:0]   aon_cmd,    // ADPCM ON equivalent to key on for FM
    input           up_aon,

    input   [7:0]   datain,

    // Flags
    output  [5:0]   flags,
    input   [5:0]   clr_flags,

    output signed [15:0]  pcm55_l,
    output signed [15:0]  pcm55_r,
	 input   [5:0]   ch_enable
);

/* verilator tracing_on */

reg  [5:0] cur_ch;
reg  [5:0] en_ch;
reg  [3:0] data;
wire nibble_sel;
wire signed [15:0] pcm_att;

always @(posedge clk or negedge rst_n)
    if( !rst_n ) begin
        data <= 4'd0;
    end else if(cen) begin
        data <= !nibble_sel ? datain[7:4] : datain[3:0];
    end

reg [ 5:0] aon_sr, aoff_sr;

reg [7:0] aon_cmd_cpy;

always @(posedge clk) if(cen) begin
        if( up_aon ) aon_cmd_cpy <= aon_cmd; else if(cur_ch[5] && cen6) aon_cmd_cpy <= 8'd0;
end

always @(posedge clk) if(cen6) begin
    if( cur_ch[5] ) begin
        aon_sr  <= ~{6{aon_cmd_cpy[7]}} & aon_cmd_cpy[5:0];
        aoff_sr <=  {6{aon_cmd_cpy[7]}} & aon_cmd_cpy[5:0];
    end else begin
        aon_sr  <= { 1'b0,  aon_sr[5:1] };
        aoff_sr <= { 1'b0, aoff_sr[5:1] };
    end
end

reg match; // high when cur_ch==en_ch, but calculated one clock cycle ahead
    // so it can be latched
wire [5:0] cur_next = { cur_ch[4:0], cur_ch[5] };
wire [5:0]  en_next = {  en_ch[0],  en_ch[5:1] };

always @(posedge clk or negedge rst_n) 
    if( !rst_n ) begin
        cur_ch <= 6'b1;  en_ch  <= 6'b1;
        match  <= 0;
    end else if( cen6 ) begin
        cur_ch <= cur_next;
        if( cur_ch[5] ) en_ch <= en_next;
        match <= cur_next == (cur_ch[5] ? en_next : en_ch);
    end

wire [15:0] start_top, end_top;

wire clr_dec, decon;

jt10_adpcm_cnt u_cnt(
    .rst_n       ( rst_n           ),
    .clk         ( clk             ),
    .cen         ( cen6            ),
    // Pipeline
    .cur_ch      ( cur_ch          ),
    .en_ch       ( en_ch           ),
    // START/END update
    .addr_in     ( addr_in         ),
    .addr_ch     ( up_addr         ),
    .up_start    ( up_start        ),
    .up_end      ( up_end          ),
    // Control
    .aon         ( aon_sr[0]       ),
    .aoff        ( aoff_sr[0]      ),
    .clr         ( clr_dec         ),
    // ROM driver
    .addr_out    ( addr            ),
    .bank        ( bank            ),
    .sel         ( nibble_sel      ),
    .roe_n       ( roe_n           ),
    .decon       ( decon           ),
    // Flags
    .flags       ( flags           ),
    .clr_flags   ( clr_flags       ),
    .start_top   ( start_top       ),
    .end_top     ( end_top         )
);

// wire chactive = chon & cen6;
wire signed [15:0] pcmdec;

jt10_adpcm u_decoder(
    .rst_n  ( rst_n     ),
    .clk    ( clk       ),
    .cen    ( cen6      ),
    .data   ( data      ),
    .chon   ( decon     ),
    .clr    ( clr_dec   ),
    .pcm    ( pcmdec    )
);
/*

always @(posedge clk) begin
    if( cen3 && chon ) begin
        pcm55_l <= pre_pcm55_l;
        pcm55_r <= pre_pcm55_r;
    end
end
*/

wire [1:0] lr;

jt10_adpcm_gain u_gain(
    .rst_n  ( rst_n          ),
    .clk    ( clk            ),
    .cen    ( cen6           ),
    // Pipeline
    .cur_ch ( cur_ch         ),
    .en_ch  ( en_ch          ),
    .match  ( match          ),
    // Gain control
    .atl    ( atl            ),        // ADPCM Total Level
    .lracl  ( lracl_in       ),
    .up_ch  ( up_lracl       ),

    .lr     ( lr             ),
    .pcm_in ( pcmdec         ),
    .pcm_att( pcm_att        )
);

wire signed [15:0] pre_pcm55_l, pre_pcm55_r;

assign pcm55_l = pre_pcm55_l;
assign pcm55_r = pre_pcm55_r;

jt10_adpcm_acc u_acc_left(
    .rst_n  ( rst_n     ),
    .clk    ( clk       ),
    .cen    ( cen6      ),
    // Pipeline
    .cur_ch ( cur_ch    ),
    .en_ch  ( en_ch     ),
    .match  ( match     ),
    // left/right enable
    .en_sum ( lr[1] && (ch_enable & cur_ch) ),

    .pcm_in ( pcm_att   ),    // 18.5 kHz
    .pcm_out( pre_pcm55_l   )     // 55.5 kHz
);

jt10_adpcm_acc u_acc_right(
    .rst_n  ( rst_n     ),
    .clk    ( clk       ),
    .cen    ( cen6      ),
    // Pipeline
    .cur_ch ( cur_ch    ),
    .en_ch  ( en_ch     ),
    .match  ( match     ),
    // left/right enable
    .en_sum ( lr[0] && (ch_enable & cur_ch) ),

    .pcm_in ( pcm_att   ),    // 18.5 kHz
    .pcm_out( pre_pcm55_r   )     // 55.5 kHz
);


`ifdef SIMULATION
integer fch0, fch1, fch2, fch3, fch4, fch5;
initial begin
    fch0 = $fopen("ch0.dec","w");
    fch1 = $fopen("ch1.dec","w");
    fch2 = $fopen("ch2.dec","w");
    fch3 = $fopen("ch3.dec","w");
    fch4 = $fopen("ch4.dec","w");
    fch5 = $fopen("ch5.dec","w");
end

reg signed [15:0] pcm_ch0, pcm_ch1, pcm_ch2, pcm_ch3, pcm_ch4, pcm_ch5;
always @(posedge cen6) if(en_ch[0]) begin
    if(cur_ch[0]) begin
        pcm_ch0 <= pcmdec;
        $fwrite( fch0, "%d\n", pcmdec );
    end
    if(cur_ch[1]) begin
        pcm_ch1 <= pcmdec;
        $fwrite( fch1, "%d\n", pcmdec );
    end
    if(cur_ch[2]) begin
        pcm_ch2 <= pcmdec;
        $fwrite( fch2, "%d\n", pcmdec );
    end
    if(cur_ch[3]) begin
        pcm_ch3 <= pcmdec;
        $fwrite( fch3, "%d\n", pcmdec );
    end
    if(cur_ch[4]) begin
        pcm_ch4 <= pcmdec;
        $fwrite( fch4, "%d\n", pcmdec );
    end
    if(cur_ch[5]) begin
        pcm_ch5 <= pcmdec;
        $fwrite( fch5, "%d\n", pcmdec );
    end
end

reg [15:0] sim_start0, sim_start1, sim_start2, sim_start3, sim_start4, sim_start5;
reg [15:0] sim_end0, sim_end1, sim_end2, sim_end3, sim_end4, sim_end5;
reg [ 7:0] sim_lracl0, sim_lracl1, sim_lracl2, sim_lracl3, sim_lracl4, sim_lracl5;
/*
reg div3b;
reg [2:0] chframe;
always @(posedge clk) div3b<=div3;
always @(negedge div3b) chframe <= chfast;


reg [7:0] aon_cpy, aon_cpy2;
always @(posedge clk) begin
    aon_cpy<=aon_cmd; // This prevents a Verilator circular-logic warning 
    aon_cpy2 <= aon_cmd;
end

always @(posedge aon_cpy[0]) if(!aon_cpy2[7]) $display("INFO: ADPCM-A ON 0 - %X",sim_start0);
always @(posedge aon_cpy[1]) if(!aon_cpy2[7]) $display("INFO: ADPCM-A ON 1 - %X",sim_start1);
always @(posedge aon_cpy[2]) if(!aon_cpy2[7]) $display("INFO: ADPCM-A ON 2 - %X",sim_start2);
always @(posedge aon_cpy[3]) if(!aon_cpy2[7]) $display("INFO: ADPCM-A ON 3 - %X",sim_start3);
always @(posedge aon_cpy[4]) if(!aon_cpy2[7]) $display("INFO: ADPCM-A ON 4 - %X",sim_start4);
always @(posedge aon_cpy[5]) if(!aon_cpy2[7]) $display("INFO: ADPCM-A ON 5 - %X",sim_start5);
*/
always @(posedge cen6) if(up_start)
    case(up_addr)
        3'd0: sim_start0 <= addr_in;
        3'd1: sim_start1 <= addr_in;
        3'd2: sim_start2 <= addr_in;
        3'd3: sim_start3 <= addr_in;
        3'd4: sim_start4 <= addr_in;
        3'd5: sim_start5 <= addr_in;
        default:;
    endcase // up_addr

always @(posedge cen6) if(up_end)
    case(up_addr)
        3'd0: sim_end0 <= addr_in;
        3'd1: sim_end1 <= addr_in;
        3'd2: sim_end2 <= addr_in;
        3'd3: sim_end3 <= addr_in;
        3'd4: sim_end4 <= addr_in;
        3'd5: sim_end5 <= addr_in;
        default:;
    endcase // up_addr

always @(posedge cen6)
    case(up_lracl)
        3'd0: sim_lracl0 <= lracl_in;
        3'd1: sim_lracl1 <= lracl_in;
        3'd2: sim_lracl2 <= lracl_in;
        3'd3: sim_lracl3 <= lracl_in;
        3'd4: sim_lracl4 <= lracl_in;
        3'd5: sim_lracl5 <= lracl_in;
        default:;
    endcase // up_addr

    /*
reg start_error, end_error;
always @(posedge cen6) begin
    case(chframe)
        3'd0: start_error <= start_top != sim_start0;
        3'd1: start_error <= start_top != sim_start1;
        3'd2: start_error <= start_top != sim_start2;
        3'd3: start_error <= start_top != sim_start3;
        3'd4: start_error <= start_top != sim_start4;
        3'd5: start_error <= start_top != sim_start5;
        default:;
    endcase
    case(chframe)
        3'd0: end_error <= end_top != sim_end0;
        3'd1: end_error <= end_top != sim_end1;
        3'd2: end_error <= end_top != sim_end2;
        3'd3: end_error <= end_top != sim_end3;
        3'd4: end_error <= end_top != sim_end4;
        3'd5: end_error <= end_top != sim_end5;
        default:;
    endcase
end
*/
`endif

endmodule // jt10_adpcm_drvA