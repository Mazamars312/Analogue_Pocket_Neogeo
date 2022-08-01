/*
Using two large case statements:
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Module             | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48A1 | BUFG  | BUFIO | BUFR  | DCM   | PLL_ADV   | Full Hierarchical  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| eg_cnt/            |           | 9/13          | 13/19         | 15/18         | 0/3           | 0/0       | 0/0     | 1/1   | 0/0   | 0/0   | 0/0   | 0/0       | eg_cnt             |
| +u_cntsh           |           | 4/4           | 6/6           | 3/3           | 3/3           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_cnt/u_cntsh     |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Using one large case statement:
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Module             | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48A1 | BUFG  | BUFIO | BUFR  | DCM   | PLL_ADV   | Full Hierarchical  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| eg_cnt/            |           | 8/11          | 13/19         | 12/15         | 0/3           | 0/0       | 0/0     | 1/1   | 0/0   | 0/0   | 0/0   | 0/0       | eg_cnt             |
| +u_cntsh           |           | 3/3           | 6/6           | 3/3           | 3/3           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_cnt/u_cntsh     |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/

module eg_cnt(
	input clk,
	input clk_en,
	input rst,
	input [14:0] eg_cnt,
	input [2:0] state_IV,
	input [5:0] rate_IV,

	output reg [2:0] state_V,
	output reg [5:0] rate_V,
	output  [2:0] cnt_V,
	output reg sum_up
);

localparam ATTACK=3'd0, DECAY1=3'd1, DECAY2=3'd2, RELEASE=3'd7, HOLD=3'd3;
wire [2:0] cnt_out;
assign cnt_V = cnt_out;
reg lsb;
reg [2:0] cnt_in;
reg [3:0] mux_sel;

always @(*) begin
	mux_sel = (state_IV == ATTACK && rate_IV[5:2]!=4'hf) ? (rate_IV[5:2]+4'd1): rate_IV[5:2];
	case( mux_sel )
		4'h0: lsb = eg_cnt[12];
		4'h1: lsb = eg_cnt[11];
		4'h2: lsb = eg_cnt[10];
		4'h3: lsb = eg_cnt[ 9];
		4'h4: lsb = eg_cnt[ 8];
		4'h5: lsb = eg_cnt[ 7];
		4'h6: lsb = eg_cnt[ 6];
		4'h7: lsb = eg_cnt[ 5];
		4'h8: lsb = eg_cnt[ 4];
		4'h9: lsb = eg_cnt[ 3];
		4'ha: lsb = eg_cnt[ 2];
		4'hb: lsb = eg_cnt[ 1];
		default: lsb = eg_cnt[ 0];
	endcase
	cnt_in =lsb!=cnt_out ? (cnt_out+3'd1) : cnt_out;
end

always @(posedge clk) if( clk_en ) begin
	if( rst ) begin
		state_V	<= RELEASE;
		rate_V <= 6'h1F; // should it be 6'h3F? TODO
		//cnt_V<= 3'd0;
	end
	else begin
		state_V	<= state_IV;
		rate_V <= rate_IV;
	end
end

jt12_sh/*_rst*/ #( .width(3), .stages(24) ) u_cntsh(
	.clk	( clk		),
	.clk_en	( clk_en	),
//	.rst	( rst		),	
	.din	( cnt_in	),
	.drop	( cnt_out	)
);

always @(posedge clk) 
	if( clk_en )
		sum_up <= lsb!=cnt_out;

endmodule // eg_mux