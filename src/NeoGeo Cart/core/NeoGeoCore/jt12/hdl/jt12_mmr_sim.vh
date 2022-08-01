`ifdef SIMULATION
/* verilator lint_off PINMISSING */

reg [4:0] sep24_cnt;
reg mmr_dump;

always @(posedge clk ) if(clk_en)
	sep24_cnt <= !zero ? sep24_cnt+1'b1 : 5'd0;

wire [10:0] fnum_ch0s1, fnum_ch1s1, fnum_ch2s1, fnum_ch3s1,
		 fnum_ch4s1, fnum_ch5s1, fnum_ch0s2, fnum_ch1s2,
		 fnum_ch2s2, fnum_ch3s2, fnum_ch4s2, fnum_ch5s2,
		 fnum_ch0s3, fnum_ch1s3, fnum_ch2s3, fnum_ch3s3,
		 fnum_ch4s3, fnum_ch5s3, fnum_ch0s4, fnum_ch1s4,
		 fnum_ch2s4, fnum_ch3s4, fnum_ch4s4, fnum_ch5s4;

sep24 #( .width(11), .pos0(1) ) fnum_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( fnum_I	),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (fnum_ch0s1),
	.ch1s1 (fnum_ch1s1),
	.ch2s1 (fnum_ch2s1),
	.ch3s1 (fnum_ch3s1),
	.ch4s1 (fnum_ch4s1),
	.ch5s1 (fnum_ch5s1),

	.ch0s2 (fnum_ch0s2),
	.ch1s2 (fnum_ch1s2),
	.ch2s2 (fnum_ch2s2),
	.ch3s2 (fnum_ch3s2),
	.ch4s2 (fnum_ch4s2),
	.ch5s2 (fnum_ch5s2),

	.ch0s3 (fnum_ch0s3),
	.ch1s3 (fnum_ch1s3),
	.ch2s3 (fnum_ch2s3),
	.ch3s3 (fnum_ch3s3),
	.ch4s3 (fnum_ch4s3),
	.ch5s3 (fnum_ch5s3),

	.ch0s4 (fnum_ch0s4),
	.ch1s4 (fnum_ch1s4),
	.ch2s4 (fnum_ch2s4),
	.ch3s4 (fnum_ch3s4),
	.ch4s4 (fnum_ch4s4),
	.ch5s4 (fnum_ch5s4)
);

wire [2:0] block_ch0s1, block_ch1s1, block_ch2s1, block_ch3s1,
		 block_ch4s1, block_ch5s1, block_ch0s2, block_ch1s2,
		 block_ch2s2, block_ch3s2, block_ch4s2, block_ch5s2,
		 block_ch0s3, block_ch1s3, block_ch2s3, block_ch3s3,
		 block_ch4s3, block_ch5s3, block_ch0s4, block_ch1s4,
		 block_ch2s4, block_ch3s4, block_ch4s4, block_ch5s4;

sep24 #( .width(3), .pos0(1) ) block_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( block_I	),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (block_ch0s1),
	.ch1s1 (block_ch1s1),
	.ch2s1 (block_ch2s1),
	.ch3s1 (block_ch3s1),
	.ch4s1 (block_ch4s1),
	.ch5s1 (block_ch5s1),

	.ch0s2 (block_ch0s2),
	.ch1s2 (block_ch1s2),
	.ch2s2 (block_ch2s2),
	.ch3s2 (block_ch3s2),
	.ch4s2 (block_ch4s2),
	.ch5s2 (block_ch5s2),

	.ch0s3 (block_ch0s3),
	.ch1s3 (block_ch1s3),
	.ch2s3 (block_ch2s3),
	.ch3s3 (block_ch3s3),
	.ch4s3 (block_ch4s3),
	.ch5s3 (block_ch5s3),

	.ch0s4 (block_ch0s4),
	.ch1s4 (block_ch1s4),
	.ch2s4 (block_ch2s4),
	.ch3s4 (block_ch3s4),
	.ch4s4 (block_ch4s4),
	.ch5s4 (block_ch5s4)
);

wire [1:0] rl_ch0s1, rl_ch1s1, rl_ch2s1, rl_ch3s1,
		 rl_ch4s1, rl_ch5s1, rl_ch0s2, rl_ch1s2,
		 rl_ch2s2, rl_ch3s2, rl_ch4s2, rl_ch5s2,
		 rl_ch0s3, rl_ch1s3, rl_ch2s3, rl_ch3s3,
		 rl_ch4s3, rl_ch5s3, rl_ch0s4, rl_ch1s4,
		 rl_ch2s4, rl_ch3s4, rl_ch4s4, rl_ch5s4;

sep24 #( .width(2), .pos0(1) ) rl_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( rl		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (rl_ch0s1),
	.ch1s1 (rl_ch1s1),
	.ch2s1 (rl_ch2s1),
	.ch3s1 (rl_ch3s1),
	.ch4s1 (rl_ch4s1),
	.ch5s1 (rl_ch5s1),

	.ch0s2 (rl_ch0s2),
	.ch1s2 (rl_ch1s2),
	.ch2s2 (rl_ch2s2),
	.ch3s2 (rl_ch3s2),
	.ch4s2 (rl_ch4s2),
	.ch5s2 (rl_ch5s2),

	.ch0s3 (rl_ch0s3),
	.ch1s3 (rl_ch1s3),
	.ch2s3 (rl_ch2s3),
	.ch3s3 (rl_ch3s3),
	.ch4s3 (rl_ch4s3),
	.ch5s3 (rl_ch5s3),

	.ch0s4 (rl_ch0s4),
	.ch1s4 (rl_ch1s4),
	.ch2s4 (rl_ch2s4),
	.ch3s4 (rl_ch3s4),
	.ch4s4 (rl_ch4s4),
	.ch5s4 (rl_ch5s4)
);

wire [2:0] fb_ch0s1, fb_ch1s1, fb_ch2s1, fb_ch3s1,
		 fb_ch4s1, fb_ch5s1, fb_ch0s2, fb_ch1s2,
		 fb_ch2s2, fb_ch3s2, fb_ch4s2, fb_ch5s2,
		 fb_ch0s3, fb_ch1s3, fb_ch2s3, fb_ch3s3,
		 fb_ch4s3, fb_ch5s3, fb_ch0s4, fb_ch1s4,
		 fb_ch2s4, fb_ch3s4, fb_ch4s4, fb_ch5s4;

sep24 #( .width(3), .pos0(0) ) fb_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( fb_II		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (fb_ch0s1),
	.ch1s1 (fb_ch1s1),
	.ch2s1 (fb_ch2s1),
	.ch3s1 (fb_ch3s1),
	.ch4s1 (fb_ch4s1),
	.ch5s1 (fb_ch5s1),

	.ch0s2 (fb_ch0s2),
	.ch1s2 (fb_ch1s2),
	.ch2s2 (fb_ch2s2),
	.ch3s2 (fb_ch3s2),
	.ch4s2 (fb_ch4s2),
	.ch5s2 (fb_ch5s2),

	.ch0s3 (fb_ch0s3),
	.ch1s3 (fb_ch1s3),
	.ch2s3 (fb_ch2s3),
	.ch3s3 (fb_ch3s3),
	.ch4s3 (fb_ch4s3),
	.ch5s3 (fb_ch5s3),

	.ch0s4 (fb_ch0s4),
	.ch1s4 (fb_ch1s4),
	.ch2s4 (fb_ch2s4),
	.ch3s4 (fb_ch3s4),
	.ch4s4 (fb_ch4s4),
	.ch5s4 (fb_ch5s4)
);

wire [2:0] alg_ch0s1, alg_ch1s1, alg_ch2s1, alg_ch3s1,
		 alg_ch4s1, alg_ch5s1, alg_ch0s2, alg_ch1s2,
		 alg_ch2s2, alg_ch3s2, alg_ch4s2, alg_ch5s2,
		 alg_ch0s3, alg_ch1s3, alg_ch2s3, alg_ch3s3,
		 alg_ch4s3, alg_ch5s3, alg_ch0s4, alg_ch1s4,
		 alg_ch2s4, alg_ch3s4, alg_ch4s4, alg_ch5s4;

sep24 #( .width(3), .pos0(1) ) alg_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( alg		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (alg_ch0s1),
	.ch1s1 (alg_ch1s1),
	.ch2s1 (alg_ch2s1),
	.ch3s1 (alg_ch3s1),
	.ch4s1 (alg_ch4s1),
	.ch5s1 (alg_ch5s1),

	.ch0s2 (alg_ch0s2),
	.ch1s2 (alg_ch1s2),
	.ch2s2 (alg_ch2s2),
	.ch3s2 (alg_ch3s2),
	.ch4s2 (alg_ch4s2),
	.ch5s2 (alg_ch5s2),

	.ch0s3 (alg_ch0s3),
	.ch1s3 (alg_ch1s3),
	.ch2s3 (alg_ch2s3),
	.ch3s3 (alg_ch3s3),
	.ch4s3 (alg_ch4s3),
	.ch5s3 (alg_ch5s3),

	.ch0s4 (alg_ch0s4),
	.ch1s4 (alg_ch1s4),
	.ch2s4 (alg_ch2s4),
	.ch3s4 (alg_ch3s4),
	.ch4s4 (alg_ch4s4),
	.ch5s4 (alg_ch5s4)
);

wire [2:0] dt1_ch0s1, dt1_ch1s1, dt1_ch2s1, dt1_ch3s1,
		 dt1_ch4s1, dt1_ch5s1, dt1_ch0s2, dt1_ch1s2,
		 dt1_ch2s2, dt1_ch3s2, dt1_ch4s2, dt1_ch5s2,
		 dt1_ch0s3, dt1_ch1s3, dt1_ch2s3, dt1_ch3s3,
		 dt1_ch4s3, dt1_ch5s3, dt1_ch0s4, dt1_ch1s4,
		 dt1_ch2s4, dt1_ch3s4, dt1_ch4s4, dt1_ch5s4;

sep24 #( .width(3), .pos0(0) ) dt1_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( dt1_II	),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (dt1_ch0s1),
	.ch1s1 (dt1_ch1s1),
	.ch2s1 (dt1_ch2s1),
	.ch3s1 (dt1_ch3s1),
	.ch4s1 (dt1_ch4s1),
	.ch5s1 (dt1_ch5s1),

	.ch0s2 (dt1_ch0s2),
	.ch1s2 (dt1_ch1s2),
	.ch2s2 (dt1_ch2s2),
	.ch3s2 (dt1_ch3s2),
	.ch4s2 (dt1_ch4s2),
	.ch5s2 (dt1_ch5s2),

	.ch0s3 (dt1_ch0s3),
	.ch1s3 (dt1_ch1s3),
	.ch2s3 (dt1_ch2s3),
	.ch3s3 (dt1_ch3s3),
	.ch4s3 (dt1_ch4s3),
	.ch5s3 (dt1_ch5s3),

	.ch0s4 (dt1_ch0s4),
	.ch1s4 (dt1_ch1s4),
	.ch2s4 (dt1_ch2s4),
	.ch3s4 (dt1_ch3s4),
	.ch4s4 (dt1_ch4s4),
	.ch5s4 (dt1_ch5s4)
);

wire [3:0] mul_ch0s1, mul_ch1s1, mul_ch2s1, mul_ch3s1,
		 mul_ch4s1, mul_ch5s1, mul_ch0s2, mul_ch1s2,
		 mul_ch2s2, mul_ch3s2, mul_ch4s2, mul_ch5s2,
		 mul_ch0s3, mul_ch1s3, mul_ch2s3, mul_ch3s3,
		 mul_ch4s3, mul_ch5s3, mul_ch0s4, mul_ch1s4,
		 mul_ch2s4, mul_ch3s4, mul_ch4s4, mul_ch5s4;

sep24 #( .width(4), .pos0(21) ) mul_sep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( mul_V		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (mul_ch0s1),
	.ch1s1 (mul_ch1s1),
	.ch2s1 (mul_ch2s1),
	.ch3s1 (mul_ch3s1),
	.ch4s1 (mul_ch4s1),
	.ch5s1 (mul_ch5s1),

	.ch0s2 (mul_ch0s2),
	.ch1s2 (mul_ch1s2),
	.ch2s2 (mul_ch2s2),
	.ch3s2 (mul_ch3s2),
	.ch4s2 (mul_ch4s2),
	.ch5s2 (mul_ch5s2),

	.ch0s3 (mul_ch0s3),
	.ch1s3 (mul_ch1s3),
	.ch2s3 (mul_ch2s3),
	.ch3s3 (mul_ch3s3),
	.ch4s3 (mul_ch4s3),
	.ch5s3 (mul_ch5s3),

	.ch0s4 (mul_ch0s4),
	.ch1s4 (mul_ch1s4),
	.ch2s4 (mul_ch2s4),
	.ch3s4 (mul_ch3s4),
	.ch4s4 (mul_ch4s4),
	.ch5s4 (mul_ch5s4)
);

wire [6:0] tl_ch0s1, tl_ch1s1, tl_ch2s1, tl_ch3s1,
		 tl_ch4s1, tl_ch5s1, tl_ch0s2, tl_ch1s2,
		 tl_ch2s2, tl_ch3s2, tl_ch4s2, tl_ch5s2,
		 tl_ch0s3, tl_ch1s3, tl_ch2s3, tl_ch3s3,
		 tl_ch4s3, tl_ch5s3, tl_ch0s4, tl_ch1s4,
		 tl_ch2s4, tl_ch3s4, tl_ch4s4, tl_ch5s4;

sep24 #( .width(7), .pos0(22) ) tl_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( tl_IV		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (tl_ch0s1),
	.ch1s1 (tl_ch1s1),
	.ch2s1 (tl_ch2s1),
	.ch3s1 (tl_ch3s1),
	.ch4s1 (tl_ch4s1),
	.ch5s1 (tl_ch5s1),

	.ch0s2 (tl_ch0s2),
	.ch1s2 (tl_ch1s2),
	.ch2s2 (tl_ch2s2),
	.ch3s2 (tl_ch3s2),
	.ch4s2 (tl_ch4s2),
	.ch5s2 (tl_ch5s2),

	.ch0s3 (tl_ch0s3),
	.ch1s3 (tl_ch1s3),
	.ch2s3 (tl_ch2s3),
	.ch3s3 (tl_ch3s3),
	.ch4s3 (tl_ch4s3),
	.ch5s3 (tl_ch5s3),

	.ch0s4 (tl_ch0s4),
	.ch1s4 (tl_ch1s4),
	.ch2s4 (tl_ch2s4),
	.ch3s4 (tl_ch3s4),
	.ch4s4 (tl_ch4s4),
	.ch5s4 (tl_ch5s4)
);

wire [4:0] ar_ch0s1, ar_ch1s1, ar_ch2s1, ar_ch3s1,
		 ar_ch4s1, ar_ch5s1, ar_ch0s2, ar_ch1s2,
		 ar_ch2s2, ar_ch3s2, ar_ch4s2, ar_ch5s2,
		 ar_ch0s3, ar_ch1s3, ar_ch2s3, ar_ch3s3,
		 ar_ch4s3, ar_ch5s3, ar_ch0s4, ar_ch1s4,
		 ar_ch2s4, ar_ch3s4, ar_ch4s4, ar_ch5s4;

sep24 #( .width(5), .pos0(1) ) ar_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( ar_I		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (ar_ch0s1),
	.ch1s1 (ar_ch1s1),
	.ch2s1 (ar_ch2s1),
	.ch3s1 (ar_ch3s1),
	.ch4s1 (ar_ch4s1),
	.ch5s1 (ar_ch5s1),

	.ch0s2 (ar_ch0s2),
	.ch1s2 (ar_ch1s2),
	.ch2s2 (ar_ch2s2),
	.ch3s2 (ar_ch3s2),
	.ch4s2 (ar_ch4s2),
	.ch5s2 (ar_ch5s2),

	.ch0s3 (ar_ch0s3),
	.ch1s3 (ar_ch1s3),
	.ch2s3 (ar_ch2s3),
	.ch3s3 (ar_ch3s3),
	.ch4s3 (ar_ch4s3),
	.ch5s3 (ar_ch5s3),

	.ch0s4 (ar_ch0s4),
	.ch1s4 (ar_ch1s4),
	.ch2s4 (ar_ch2s4),
	.ch3s4 (ar_ch3s4),
	.ch4s4 (ar_ch4s4),
	.ch5s4 (ar_ch5s4)
);

wire [4:0] d1r_ch0s1, d1r_ch1s1, d1r_ch2s1, d1r_ch3s1,
		 d1r_ch4s1, d1r_ch5s1, d1r_ch0s2, d1r_ch1s2,
		 d1r_ch2s2, d1r_ch3s2, d1r_ch4s2, d1r_ch5s2,
		 d1r_ch0s3, d1r_ch1s3, d1r_ch2s3, d1r_ch3s3,
		 d1r_ch4s3, d1r_ch5s3, d1r_ch0s4, d1r_ch1s4,
		 d1r_ch2s4, d1r_ch3s4, d1r_ch4s4, d1r_ch5s4;

sep24 #( .width(5), .pos0(1) ) d1r_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( d1r_I		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (d1r_ch0s1),
	.ch1s1 (d1r_ch1s1),
	.ch2s1 (d1r_ch2s1),
	.ch3s1 (d1r_ch3s1),
	.ch4s1 (d1r_ch4s1),
	.ch5s1 (d1r_ch5s1),

	.ch0s2 (d1r_ch0s2),
	.ch1s2 (d1r_ch1s2),
	.ch2s2 (d1r_ch2s2),
	.ch3s2 (d1r_ch3s2),
	.ch4s2 (d1r_ch4s2),
	.ch5s2 (d1r_ch5s2),

	.ch0s3 (d1r_ch0s3),
	.ch1s3 (d1r_ch1s3),
	.ch2s3 (d1r_ch2s3),
	.ch3s3 (d1r_ch3s3),
	.ch4s3 (d1r_ch4s3),
	.ch5s3 (d1r_ch5s3),

	.ch0s4 (d1r_ch0s4),
	.ch1s4 (d1r_ch1s4),
	.ch2s4 (d1r_ch2s4),
	.ch3s4 (d1r_ch3s4),
	.ch4s4 (d1r_ch4s4),
	.ch5s4 (d1r_ch5s4)
);

wire [4:0] d2r_ch0s1, d2r_ch1s1, d2r_ch2s1, d2r_ch3s1,
		 d2r_ch4s1, d2r_ch5s1, d2r_ch0s2, d2r_ch1s2,
		 d2r_ch2s2, d2r_ch3s2, d2r_ch4s2, d2r_ch5s2,
		 d2r_ch0s3, d2r_ch1s3, d2r_ch2s3, d2r_ch3s3,
		 d2r_ch4s3, d2r_ch5s3, d2r_ch0s4, d2r_ch1s4,
		 d2r_ch2s4, d2r_ch3s4, d2r_ch4s4, d2r_ch5s4;

sep24 #( .width(5), .pos0(1) ) d2r_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( d2r_I		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (d2r_ch0s1),
	.ch1s1 (d2r_ch1s1),
	.ch2s1 (d2r_ch2s1),
	.ch3s1 (d2r_ch3s1),
	.ch4s1 (d2r_ch4s1),
	.ch5s1 (d2r_ch5s1),

	.ch0s2 (d2r_ch0s2),
	.ch1s2 (d2r_ch1s2),
	.ch2s2 (d2r_ch2s2),
	.ch3s2 (d2r_ch3s2),
	.ch4s2 (d2r_ch4s2),
	.ch5s2 (d2r_ch5s2),

	.ch0s3 (d2r_ch0s3),
	.ch1s3 (d2r_ch1s3),
	.ch2s3 (d2r_ch2s3),
	.ch3s3 (d2r_ch3s3),
	.ch4s3 (d2r_ch4s3),
	.ch5s3 (d2r_ch5s3),

	.ch0s4 (d2r_ch0s4),
	.ch1s4 (d2r_ch1s4),
	.ch2s4 (d2r_ch2s4),
	.ch3s4 (d2r_ch3s4),
	.ch4s4 (d2r_ch4s4),
	.ch5s4 (d2r_ch5s4)
);

wire [3:0] rr_ch0s1, rr_ch1s1, rr_ch2s1, rr_ch3s1,
		 rr_ch4s1, rr_ch5s1, rr_ch0s2, rr_ch1s2,
		 rr_ch2s2, rr_ch3s2, rr_ch4s2, rr_ch5s2,
		 rr_ch0s3, rr_ch1s3, rr_ch2s3, rr_ch3s3,
		 rr_ch4s3, rr_ch5s3, rr_ch0s4, rr_ch1s4,
		 rr_ch2s4, rr_ch3s4, rr_ch4s4, rr_ch5s4;

sep24 #( .width(4), .pos0(1) ) rr_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( rr_I		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (rr_ch0s1),
	.ch1s1 (rr_ch1s1),
	.ch2s1 (rr_ch2s1),
	.ch3s1 (rr_ch3s1),
	.ch4s1 (rr_ch4s1),
	.ch5s1 (rr_ch5s1),

	.ch0s2 (rr_ch0s2),
	.ch1s2 (rr_ch1s2),
	.ch2s2 (rr_ch2s2),
	.ch3s2 (rr_ch3s2),
	.ch4s2 (rr_ch4s2),
	.ch5s2 (rr_ch5s2),

	.ch0s3 (rr_ch0s3),
	.ch1s3 (rr_ch1s3),
	.ch2s3 (rr_ch2s3),
	.ch3s3 (rr_ch3s3),
	.ch4s3 (rr_ch4s3),
	.ch5s3 (rr_ch5s3),

	.ch0s4 (rr_ch0s4),
	.ch1s4 (rr_ch1s4),
	.ch2s4 (rr_ch2s4),
	.ch3s4 (rr_ch3s4),
	.ch4s4 (rr_ch4s4),
	.ch5s4 (rr_ch5s4)
);

wire [3:0] d1l_ch0s1, d1l_ch1s1, d1l_ch2s1, d1l_ch3s1,
		 d1l_ch4s1, d1l_ch5s1, d1l_ch0s2, d1l_ch1s2,
		 d1l_ch2s2, d1l_ch3s2, d1l_ch4s2, d1l_ch5s2,
		 d1l_ch0s3, d1l_ch1s3, d1l_ch2s3, d1l_ch3s3,
		 d1l_ch4s3, d1l_ch5s3, d1l_ch0s4, d1l_ch1s4,
		 d1l_ch2s4, d1l_ch3s4, d1l_ch4s4, d1l_ch5s4;

sep24 #( .width(4), .pos0(1) ) d1l_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( sl_I		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (d1l_ch0s1),
	.ch1s1 (d1l_ch1s1),
	.ch2s1 (d1l_ch2s1),
	.ch3s1 (d1l_ch3s1),
	.ch4s1 (d1l_ch4s1),
	.ch5s1 (d1l_ch5s1),

	.ch0s2 (d1l_ch0s2),
	.ch1s2 (d1l_ch1s2),
	.ch2s2 (d1l_ch2s2),
	.ch3s2 (d1l_ch3s2),
	.ch4s2 (d1l_ch4s2),
	.ch5s2 (d1l_ch5s2),

	.ch0s3 (d1l_ch0s3),
	.ch1s3 (d1l_ch1s3),
	.ch2s3 (d1l_ch2s3),
	.ch3s3 (d1l_ch3s3),
	.ch4s3 (d1l_ch4s3),
	.ch5s3 (d1l_ch5s3),

	.ch0s4 (d1l_ch0s4),
	.ch1s4 (d1l_ch1s4),
	.ch2s4 (d1l_ch2s4),
	.ch3s4 (d1l_ch3s4),
	.ch4s4 (d1l_ch4s4),
	.ch5s4 (d1l_ch5s4)
);

wire [1:0] ks_ch0s1, ks_ch1s1, ks_ch2s1, ks_ch3s1,
		 ks_ch4s1, ks_ch5s1, ks_ch0s2, ks_ch1s2,
		 ks_ch2s2, ks_ch3s2, ks_ch4s2, ks_ch5s2,
		 ks_ch0s3, ks_ch1s3, ks_ch2s3, ks_ch3s3,
		 ks_ch4s3, ks_ch5s3, ks_ch0s4, ks_ch1s4,
		 ks_ch2s4, ks_ch3s4, ks_ch4s4, ks_ch5s4;

sep24 #( .width(2), .pos0(0) ) ks_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( ks_II		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (ks_ch0s1),
	.ch1s1 (ks_ch1s1),
	.ch2s1 (ks_ch2s1),
	.ch3s1 (ks_ch3s1),
	.ch4s1 (ks_ch4s1),
	.ch5s1 (ks_ch5s1),

	.ch0s2 (ks_ch0s2),
	.ch1s2 (ks_ch1s2),
	.ch2s2 (ks_ch2s2),
	.ch3s2 (ks_ch3s2),
	.ch4s2 (ks_ch4s2),
	.ch5s2 (ks_ch5s2),

	.ch0s3 (ks_ch0s3),
	.ch1s3 (ks_ch1s3),
	.ch2s3 (ks_ch2s3),
	.ch3s3 (ks_ch3s3),
	.ch4s3 (ks_ch4s3),
	.ch5s3 (ks_ch5s3),

	.ch0s4 (ks_ch0s4),
	.ch1s4 (ks_ch1s4),
	.ch2s4 (ks_ch2s4),
	.ch3s4 (ks_ch3s4),
	.ch4s4 (ks_ch4s4),
	.ch5s4 (ks_ch5s4)
);

wire [3:0] ssg_I = {ssg_en_I, ssg_eg_I};

wire [3:0] ssg_ch0s1, ssg_ch1s1, ssg_ch2s1, ssg_ch3s1,
		 ssg_ch4s1, ssg_ch5s1, ssg_ch0s2, ssg_ch1s2,
		 ssg_ch2s2, ssg_ch3s2, ssg_ch4s2, ssg_ch5s2,
		 ssg_ch0s3, ssg_ch1s3, ssg_ch2s3, ssg_ch3s3,
		 ssg_ch4s3, ssg_ch5s3, ssg_ch0s4, ssg_ch1s4,
		 ssg_ch2s4, ssg_ch3s4, ssg_ch4s4, ssg_ch5s4;

sep24 #( .width(4), .pos0(1) ) ssg_step
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( ssg_I		),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (ssg_ch0s1),
	.ch1s1 (ssg_ch1s1),
	.ch2s1 (ssg_ch2s1),
	.ch3s1 (ssg_ch3s1),
	.ch4s1 (ssg_ch4s1),
	.ch5s1 (ssg_ch5s1),

	.ch0s2 (ssg_ch0s2),
	.ch1s2 (ssg_ch1s2),
	.ch2s2 (ssg_ch2s2),
	.ch3s2 (ssg_ch3s2),
	.ch4s2 (ssg_ch4s2),
	.ch5s2 (ssg_ch5s2),

	.ch0s3 (ssg_ch0s3),
	.ch1s3 (ssg_ch1s3),
	.ch2s3 (ssg_ch2s3),
	.ch3s3 (ssg_ch3s3),
	.ch4s3 (ssg_ch4s3),
	.ch5s3 (ssg_ch5s3),

	.ch0s4 (ssg_ch0s4),
	.ch1s4 (ssg_ch1s4),
	.ch2s4 (ssg_ch2s4),
	.ch3s4 (ssg_ch3s4),
	.ch4s4 (ssg_ch4s4),
	.ch5s4 (ssg_ch5s4)
);

wire	 kon_ch0s1, kon_ch1s1, kon_ch2s1, kon_ch3s1,
		 kon_ch4s1, kon_ch5s1, kon_ch0s2, kon_ch1s2,
		 kon_ch2s2, kon_ch3s2, kon_ch4s2, kon_ch5s2,
		 kon_ch0s3, kon_ch1s3, kon_ch2s3, kon_ch3s3,
		 kon_ch4s3, kon_ch5s3, kon_ch0s4, kon_ch1s4,
		 kon_ch2s4, kon_ch3s4, kon_ch4s4, kon_ch5s4;

sep24 #( .width(1), .pos0(1) ) konstep
(
	.clk	( clk		),
	.clk_en	( clk_en	),
	.mixed	( keyon_I	),
	.mask	( 24'd0		),
	.cnt	( sep24_cnt	),

	.ch0s1 (kon_ch0s1),
	.ch1s1 (kon_ch1s1),
	.ch2s1 (kon_ch2s1),
	.ch3s1 (kon_ch3s1),
	.ch4s1 (kon_ch4s1),
	.ch5s1 (kon_ch5s1),

	.ch0s2 (kon_ch0s2),
	.ch1s2 (kon_ch1s2),
	.ch2s2 (kon_ch2s2),
	.ch3s2 (kon_ch3s2),
	.ch4s2 (kon_ch4s2),
	.ch5s2 (kon_ch5s2),

	.ch0s3 (kon_ch0s3),
	.ch1s3 (kon_ch1s3),
	.ch2s3 (kon_ch2s3),
	.ch3s3 (kon_ch3s3),
	.ch4s3 (kon_ch4s3),
	.ch5s3 (kon_ch5s3),

	.ch0s4 (kon_ch0s4),
	.ch1s4 (kon_ch1s4),
	.ch2s4 (kon_ch2s4),
	.ch3s4 (kon_ch3s4),
	.ch4s4 (kon_ch4s4),
	.ch5s4 (kon_ch5s4)
);

/* Dump all registers on request */
integer fmmr;
initial begin
	fmmr=$fopen("mmr_dump.log","w");
end

always @(posedge clk )
if (mmr_dump ) begin
	$fdisplay( fmmr, "-------------------------------");
	// Channel 0
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch0s1, fnum_ch0s1, rl_ch0s1, fb_ch0s1, alg_ch0s1,
		dt1_ch0s1, mul_ch0s1, tl_ch0s1, ar_ch0s1, d1r_ch0s1,
		d2r_ch0s1, rr_ch0s1, d1l_ch0s1, ks_ch0s1, ssg_ch0s1,
		kon_ch0s1 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch0s2, fnum_ch0s2, rl_ch0s2, fb_ch0s2, alg_ch0s2,
		dt1_ch0s2, mul_ch0s2, tl_ch0s2, ar_ch0s2, d1r_ch0s2,
		d2r_ch0s2, rr_ch0s2, d1l_ch0s2, ks_ch0s2, ssg_ch0s2,
		kon_ch0s2 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch0s1, fnum_ch0s3, rl_ch0s3, fb_ch0s3, alg_ch0s3,
		dt1_ch0s3, mul_ch0s3, tl_ch0s3, ar_ch0s3, d1r_ch0s3,
		d2r_ch0s3, rr_ch0s3, d1l_ch0s3, ks_ch0s3, ssg_ch0s3,
		kon_ch0s3 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch0s4, fnum_ch0s4, rl_ch0s4, fb_ch0s4, alg_ch0s4,
		dt1_ch0s4, mul_ch0s4, tl_ch0s4, ar_ch0s4, d1r_ch0s4,
		d2r_ch0s4, rr_ch0s4, d1l_ch0s4, ks_ch0s4, ssg_ch0s4,
		kon_ch0s4 );
	// Channel 1
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch1s1, fnum_ch1s1, rl_ch1s1, fb_ch1s1, alg_ch1s1,
		dt1_ch1s1, mul_ch1s1, tl_ch1s1, ar_ch1s1, d1r_ch1s1,
		d2r_ch1s1, rr_ch1s1, d1l_ch1s1, ks_ch1s1, ssg_ch1s1,
		kon_ch1s1 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch1s2, fnum_ch1s2, rl_ch1s2, fb_ch1s2, alg_ch1s2,
		dt1_ch1s2, mul_ch1s2, tl_ch1s2, ar_ch1s2, d1r_ch1s2,
		d2r_ch1s2, rr_ch1s2, d1l_ch1s2, ks_ch1s2, ssg_ch1s2,
		kon_ch1s2 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch1s3, fnum_ch1s3, rl_ch1s3, fb_ch1s3, alg_ch1s3,
		dt1_ch1s3, mul_ch1s3, tl_ch1s3, ar_ch1s3, d1r_ch1s3,
		d2r_ch1s3, rr_ch1s3, d1l_ch1s3, ks_ch1s3, ssg_ch1s3,
		kon_ch1s3 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch1s4, fnum_ch1s4, rl_ch1s4, fb_ch1s4, alg_ch1s4,
		dt1_ch1s4, mul_ch1s4, tl_ch1s4, ar_ch1s4, d1r_ch1s4,
		d2r_ch1s4, rr_ch1s4, d1l_ch1s4, ks_ch1s4, ssg_ch1s4,
		kon_ch1s4 );
	// Channel 2
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch2s1, fnum_ch2s1, rl_ch2s1, fb_ch2s1, alg_ch2s1,
		dt1_ch2s1, mul_ch2s1, tl_ch2s1, ar_ch2s1, d1r_ch2s1,
		d2r_ch2s1, rr_ch2s1, d1l_ch2s1, ks_ch2s1, ssg_ch2s1,
		kon_ch2s1 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch2s2, fnum_ch2s2, rl_ch2s2, fb_ch2s2, alg_ch2s2,
		dt1_ch2s2, mul_ch2s2, tl_ch2s2, ar_ch2s2, d1r_ch2s2,
		d2r_ch2s2, rr_ch2s2, d1l_ch2s2, ks_ch2s2, ssg_ch2s2,
		kon_ch2s2 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch2s3, fnum_ch2s3, rl_ch2s3, fb_ch2s3, alg_ch2s3,
		dt1_ch2s3, mul_ch2s3, tl_ch2s3, ar_ch2s3, d1r_ch2s3,
		d2r_ch2s3, rr_ch2s3, d1l_ch2s3, ks_ch2s3, ssg_ch2s3,
		kon_ch2s3 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch2s4, fnum_ch2s4, rl_ch2s4, fb_ch2s4, alg_ch2s4,
		dt1_ch2s4, mul_ch2s4, tl_ch2s4, ar_ch2s4, d1r_ch2s4,
		d2r_ch2s4, rr_ch2s4, d1l_ch2s4, ks_ch2s4, ssg_ch2s4,
		kon_ch2s4 );
	// Channel 3
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch3s1, fnum_ch3s1, rl_ch3s1, fb_ch3s1, alg_ch3s1,
		dt1_ch3s1, mul_ch3s1, tl_ch3s1, ar_ch3s1, d1r_ch3s1,
		d2r_ch3s1, rr_ch3s1, d1l_ch3s1, ks_ch3s1, ssg_ch3s1,
		kon_ch3s1 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch3s2, fnum_ch3s2, rl_ch3s2, fb_ch3s2, alg_ch3s2,
		dt1_ch3s2, mul_ch3s2, tl_ch3s2, ar_ch3s2, d1r_ch3s2,
		d2r_ch3s2, rr_ch3s2, d1l_ch3s2, ks_ch3s2, ssg_ch3s2,
		kon_ch3s2 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch3s3, fnum_ch3s3, rl_ch3s3, fb_ch3s3, alg_ch3s3,
		dt1_ch3s3, mul_ch3s3, tl_ch3s3, ar_ch3s3, d1r_ch3s3,
		d2r_ch3s3, rr_ch3s3, d1l_ch3s3, ks_ch3s3, ssg_ch3s3,
		kon_ch3s3 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch3s4, fnum_ch3s4, rl_ch3s4, fb_ch3s4, alg_ch3s4,
		dt1_ch3s4, mul_ch3s4, tl_ch3s4, ar_ch3s4, d1r_ch3s4,
		d2r_ch3s4, rr_ch3s4, d1l_ch3s4, ks_ch3s4, ssg_ch3s4,
		kon_ch3s4 );
	// Channel 4
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch4s1, fnum_ch4s1, rl_ch4s1, fb_ch4s1, alg_ch4s1,
		dt1_ch4s1, mul_ch4s1, tl_ch4s1, ar_ch4s1, d1r_ch4s1,
		d2r_ch4s1, rr_ch4s1, d1l_ch4s1, ks_ch4s1, ssg_ch4s1,
		kon_ch4s1 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch4s2, fnum_ch4s2, rl_ch4s2, fb_ch4s2, alg_ch4s2,
		dt1_ch4s2, mul_ch4s2, tl_ch4s2, ar_ch4s2, d1r_ch4s2,
		d2r_ch4s2, rr_ch4s2, d1l_ch4s2, ks_ch4s2, ssg_ch4s2,
		kon_ch4s2 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch4s3, fnum_ch4s3, rl_ch4s3, fb_ch4s3, alg_ch4s3,
		dt1_ch4s3, mul_ch4s3, tl_ch4s3, ar_ch4s3, d1r_ch4s3,
		d2r_ch4s3, rr_ch4s3, d1l_ch4s3, ks_ch4s3, ssg_ch4s3,
		kon_ch4s3 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch4s4, fnum_ch4s4, rl_ch4s4, fb_ch4s4, alg_ch4s4,
		dt1_ch4s4, mul_ch4s4, tl_ch4s4, ar_ch4s4, d1r_ch4s4,
		d2r_ch4s4, rr_ch4s4, d1l_ch4s4, ks_ch4s4, ssg_ch4s4,
		kon_ch4s4 );
	// Channel 5
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch5s1, fnum_ch5s1, rl_ch5s1, fb_ch5s1, alg_ch5s1,
		dt1_ch5s1, mul_ch5s1, tl_ch5s1, ar_ch5s1, d1r_ch5s1,
		d2r_ch5s1, rr_ch5s1, d1l_ch5s1, ks_ch5s1, ssg_ch5s1,
		kon_ch5s1 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch5s2, fnum_ch5s2, rl_ch5s2, fb_ch5s2, alg_ch5s2,
		dt1_ch5s2, mul_ch5s2, tl_ch5s2, ar_ch5s2, d1r_ch5s2,
		d2r_ch5s2, rr_ch5s2, d1l_ch5s2, ks_ch5s2, ssg_ch5s2,
		kon_ch5s2 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch5s3, fnum_ch5s3, rl_ch5s3, fb_ch5s3, alg_ch5s3,
		dt1_ch5s3, mul_ch5s3, tl_ch5s3, ar_ch5s3, d1r_ch5s3,
		d2r_ch5s3, rr_ch5s3, d1l_ch5s3, ks_ch5s3, ssg_ch5s3,
		kon_ch5s3 );
	$fdisplay( fmmr, "%x %x %x %x %x, %x %x %x %x %x %x, %x %x %x %x %x",
		block_ch5s4, fnum_ch5s4, rl_ch5s4, fb_ch5s4, alg_ch5s4,
		dt1_ch5s4, mul_ch5s4, tl_ch5s4, ar_ch5s4, d1r_ch5s4,
		d2r_ch5s4, rr_ch5s4, d1l_ch5s4, ks_ch5s4, ssg_ch5s4,
		kon_ch5s4 );
end
/* verilator lint_on PINMISSING */
`endif

