/*
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Module             | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48A1 | BUFG  | BUFIO | BUFR  | DCM   | PLL_ADV   | Full Hierarchical  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| eg_comb/           |           | 49/49         | 0/0           | 153/153       | 0/0           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_comb            |
| eg_comb/           |           | 42/42         | 0/0           | 134/134       | 0/0           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_comb            |
| eg_comb/           |           | 39/39         | 0/0           | 129/129       | 0/0           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_comb            |
| eg_comb/           |           | 43/43         | 0/0           | 122/122       | 0/0           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_comb            |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

This module represents all the envelope generator calculations.
Everything is combinational. The testbench ver/eg2 checks the 
functionality of this module.

*/

module eg_comb(
	input attack,
	input [ 4:0] base_rate,
	input [ 4:0] keycode,
	input [14:0] eg_cnt,
	input        cnt_in,
	input [ 1:0] ks,
	input [ 9:0] eg_in,
	input [ 6:0] lfo_mod,
	input        amsen,
	input [ 1:0] ams,
	input [ 6:0] tl,
	output       cnt_lsb,
	output reg	[9:0] eg_limited,
	output reg  [9:0] eg_pure
);

reg		[6:0]	pre_rate;
reg		[5:0]	rate;

always @(*) begin : pre_rate_calc
	if( base_rate == 5'd0 )
		pre_rate = 7'd0;
	else
		case( ks )
			2'd3:	pre_rate = { base_rate, 1'b0 } + { 1'b0, keycode };
			2'd2:	pre_rate = { base_rate, 1'b0 } + { 2'b0, keycode[4:1] };
			2'd1:	pre_rate = { base_rate, 1'b0 } + { 3'b0, keycode[4:2] };
			2'd0:	pre_rate = { base_rate, 1'b0 } + { 4'b0, keycode[4:3] };
		endcase
end

always @(*)
	rate = pre_rate[6] ? 6'd63 : pre_rate[5:0];

reg	[2:0] cnt;

reg [4:0] mux_sel;
always @(*) begin
	mux_sel = attack ? (rate[5:2]+4'd1): {1'b0,rate[5:2]};
end // always @(*)

always @(*) 
	case( mux_sel )
		5'h0: cnt = eg_cnt[14:12];
		5'h1: cnt = eg_cnt[13:11];
		5'h2: cnt = eg_cnt[12:10];
		5'h3: cnt = eg_cnt[11: 9];
		5'h4: cnt = eg_cnt[10: 8];
		5'h5: cnt = eg_cnt[ 9: 7];
		5'h6: cnt = eg_cnt[ 8: 6];
		5'h7: cnt = eg_cnt[ 7: 5];
		5'h8: cnt = eg_cnt[ 6: 4];
		5'h9: cnt = eg_cnt[ 5: 3];
		5'ha: cnt = eg_cnt[ 4: 2];
		5'hb: cnt = eg_cnt[ 3: 1];
		default: cnt = eg_cnt[ 2: 0];
	endcase

////////////////////////////////
reg step;
reg [7:0] step_idx;

always @(*) begin : rate_step
	if( rate[5:4]==2'b11 ) begin // 0 means 1x, 1 means 2x
		if( rate[5:2]==4'hf && attack)
			step_idx = 8'b11111111; // Maximum attack speed, rates 60&61
		else
		case( rate[1:0] )
			2'd0: step_idx = 8'b00000000;
			2'd1: step_idx = 8'b10001000; // 2
			2'd2: step_idx = 8'b10101010; // 4
			2'd3: step_idx = 8'b11101110; // 6
		endcase
	end
	else begin
		if( rate[5:2]==4'd0 && !attack)
			step_idx = 8'b11111110; // limit slowest decay rate
		else
		case( rate[1:0] )
			2'd0: step_idx = 8'b10101010; // 4
			2'd1: step_idx = 8'b11101010; // 5
			2'd2: step_idx = 8'b11101110; // 6
			2'd3: step_idx = 8'b11111110; // 7
		endcase
	end
	// a rate of zero keeps the level still
	step = rate[5:1]==5'd0 ? 1'b0 : step_idx[ cnt ];
end

reg sum_up;
assign cnt_lsb = cnt[0];
always @(*) begin
	sum_up = cnt[0] != cnt_in;
end
//////////////////////////////////////////////////////////////
// cnt/cnt_lsb/cnt_in not used below this point

reg [3:0] 	dr_sum;
reg	[10:0]	dr_result;

always @(*) begin
	case( rate[5:2] )
		4'b1100: dr_sum = { 2'b0, step, ~step }; // 12
		4'b1101: dr_sum = { 1'b0, step, ~step, 1'b0 }; // 13
		4'b1110: dr_sum = { step, ~step, 2'b0 }; // 14
		4'b1111: dr_sum = 4'd8;// 15
		default: dr_sum = { 2'b0, step, 1'b0 };
	endcase
	dr_result = {6'd0, dr_sum} + eg_in;
end

reg [ 7:0] ar_sum0;
reg [ 8:0] ar_sum1;
reg [10:0] ar_result;
reg [ 9:0] ar_sum;

always @(*) begin : ar_calculation
	casez( rate[5:2] )
		default: ar_sum0 = {2'd0, eg_in[9:4]};
		4'b1101: ar_sum0 = {1'd0, eg_in[9:3]};
		4'b111?: ar_sum0 = eg_in[9:2];
	endcase
	ar_sum1 = ar_sum0+9'd1;
	if( rate[5:4] == 2'b11 )
		ar_sum = step ? { ar_sum1, 1'b0 } : { 1'b0, ar_sum1 };
	else
		ar_sum = step ? { 1'b0, ar_sum1 } : 10'd0;
	ar_result = rate[5:1]==5'h1F ? 11'd0 : eg_in-ar_sum;
end
///////////////////////////////////////////////////////////
// rate not used below this point
always @(*) begin
	if(sum_up) begin
		if( attack  )
			eg_pure = ar_result[10] ? 10'd0: ar_result[9:0];
		else 
			eg_pure = dr_result[10] ? 10'h3FF : dr_result[9:0];
	end
	else eg_pure = eg_in;
end

//////////////////////////////////////////////////////////////
reg	[ 8:0]	am_final;
reg	[10:0]	sum_eg_tl;
reg	[11:0]	sum_eg_tl_am;
reg	[ 5:0]	am_inverted;

always @(*) begin
	am_inverted = lfo_mod[6] ? ~lfo_mod[5:0] : lfo_mod[5:0];
end

always @(*) begin
	casez( {amsen, ams } )
		default: am_final = 9'd0;
		3'b1_01: am_final = { 5'd0, am_inverted[5:2]	};
		3'b1_10: am_final = { 3'd0, am_inverted 		};
		3'b1_11: am_final = { 2'd0, am_inverted, 1'b0	};
	endcase
	sum_eg_tl = {  tl,   3'd0 } + eg_pure;
	sum_eg_tl_am = sum_eg_tl + { 3'd0, am_final };
end

always @(*)  
	eg_limited = sum_eg_tl_am[11:10]==2'd0 ? sum_eg_tl_am[9:0] : 10'h3ff;


endmodule // eg_comb