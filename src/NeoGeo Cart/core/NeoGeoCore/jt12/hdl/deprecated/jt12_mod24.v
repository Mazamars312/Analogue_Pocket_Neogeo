`timescale 1ns / 1ps

module jt12_mod24(
	input	[4:0] base,
	input	[3:0] extra,
	output  [4:0] mod
);

wire [5:0]  sum = base+extra;
wire [4:0] wrap = base+extra-5'd24;

assign mod = sum > 6'd23 ? wrap : sum[4:0];

endmodule
