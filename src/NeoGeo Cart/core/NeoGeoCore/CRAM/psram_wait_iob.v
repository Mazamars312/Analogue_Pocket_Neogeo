module psram_wait_iob (
	 input 	iff_d,
    output reg iff_q,
    input 	iff_clk,
    input 	iff_en
);

initial begin
	iff_q <= 'b0;
end


always @(posedge iff_clk) if (iff_en) iff_q <= iff_d;

endmodule



module psram_off_iob(
    input 	off_d,
    output reg off_q,
    input 	off_clk
	 );
	 
initial begin
	off_q <= 'b0;
end


always @(posedge off_clk) off_q <= off_d; 
	 
endmodule


module psram_data_iob(
    input 	iff_d,
    output reg iff_q,
    input 	iff_clk,
    input 	off_d,
    output reg off_q,
    input 	off_clk
	 );

initial begin
	iff_q <= 'b0;
	off_q <= 'b0;
end
	 
always @(posedge iff_clk) iff_q <= iff_d;
always @(posedge off_clk) off_q <= off_d;
	 
endmodule

module psram_clk_iob(
    input 	clk,    
	 input 	clk_en, 
	 output	clk_q  
	 );


	 cram_clock_en cram_clock_en(
		.inclk 	(clk),
		.ena		(clk_en),
		.outclk 	(clk_q)
	 
	 );
	 
endmodule