/*
Using two large case statements:
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Module             | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48A1 | BUFG  | BUFIO | BUFR  | DCM   | PLL_ADV   | Full Hierarchical  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| eg_mux/            |           | 11/12         | 13/14         | 31/31         | 1/1           | 0/0       | 0/0     | 1/1   | 0/0   | 0/0   | 0/0   | 0/0       | eg_mux             |
| +u_cntsh           |           | 1/1           | 1/1           | 0/0           | 0/0           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_mux/u_cntsh     |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
Using one large case statement:
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Module             | Partition | Slices*       | Slice Reg     | LUTs          | LUTRAM        | BRAM/FIFO | DSP48A1 | BUFG  | BUFIO | BUFR  | DCM   | PLL_ADV   | Full Hierarchical  |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| eg_mux/            |           | 11/12         | 13/14         | 21/21         | 1/1           | 0/0       | 0/0     | 1/1   | 0/0   | 0/0   | 0/0   | 0/0       | eg_mux             |
| +u_cntsh           |           | 1/1           | 1/1           | 0/0           | 0/0           | 0/0       | 0/0     | 0/0   | 0/0   | 0/0   | 0/0   | 0/0       | eg_mux/u_cntsh     |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/

module eg_mux(
	input clk,
	input clk_en,
	input rst,
	input [14:0] eg_cnt,
	input [2:0] state_IV,
	input [5:0] rate_IV,

	output reg [2:0] state_V,
	output reg [5:0] rate_V,
	output reg [2:0] cnt_V,
	output reg sum_up
);

localparam ATTACK=3'd0, DECAY1=3'd1, DECAY2=3'd2, RELEASE=3'd7, HOLD=3'd3;
wire cnt_out;
reg [3:0] mux_sel;

always @(*) begin
	mux_sel = (state_IV == ATTACK && rate_IV[5:2]!=4'hf) ? (rate_IV[5:2]+4'd1): rate_IV[5:2];
end // always @(*)

always @(posedge clk) if( clk_en ) begin
	if( rst ) begin
		state_V	<= RELEASE;
		rate_V <= 6'h1F; // should it be 6'h3F? TODO
		//cnt_V<= 3'd0;
	end
	else begin
		state_V	<= state_IV;
		rate_V <= rate_IV;
		case( mux_sel )
			4'h0: cnt_V <= eg_cnt[14:12];
			4'h1: cnt_V <= eg_cnt[13:11];
			4'h2: cnt_V <= eg_cnt[12:10];
			4'h3: cnt_V <= eg_cnt[11: 9];
			4'h4: cnt_V <= eg_cnt[10: 8];
			4'h5: cnt_V <= eg_cnt[ 9: 7];
			4'h6: cnt_V <= eg_cnt[ 8: 6];
			4'h7: cnt_V <= eg_cnt[ 7: 5];
			4'h8: cnt_V <= eg_cnt[ 6: 4];
			4'h9: cnt_V <= eg_cnt[ 5: 3];
			4'ha: cnt_V <= eg_cnt[ 4: 2];
			4'hb: cnt_V <= eg_cnt[ 3: 1];
			default: cnt_V <= eg_cnt[ 2: 0];
		endcase
	end
end

jt12_sh/*_rst*/ #( .width(1), .stages(24) ) u_cntsh(
	.clk	( clk		),
	.clk_en	( clk_en	),
//	.rst	( rst		),	
	.din	( cnt_V[0]	),
	.drop	( cnt_out	)
);

always @(posedge clk) 
	if( clk_en )
		sum_up <= cnt_V[0] != cnt_out;

endmodule // eg_mux