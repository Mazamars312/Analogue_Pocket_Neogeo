module SRAM_CONTROLLER_NEOGEO (
	input 					clk,
	input						reset_n,
		
	output  		[16:0] 	sram_a,
	inout  		[15:0] 	sram_dq,
	output  	  				sram_oe_n,
	output  	  				sram_we_n,
	output  	  				sram_ub_n,
	output  	  				sram_lb_n,
	
	input 		[15:0]	M68K_ADDR_RAM,
	input 		[15:0]	M68K_DATA_RAM,
	output 		[15:0]	SRAM_OUT,
	input 					nWRL,
	input						nWRU,
	input 					sram_nWWL,
	input 					sram_nWWU

);

	// this will clean the SRAM everytime it is booted. Has to run at 12mhz as this is just a counter and direct access.
	reg [19:0] reset_counter = 0;
	
	always @(posedge clk) begin
		reset_counter <= reset_counter + 1;
	end
	
	assign sram_a = 			reset_n ? {2'b0, M68K_ADDR_RAM[15:1]} 						: reset_counter[16:1];
	assign sram_dq[7:0]  = 	reset_n ? (sram_nWWL ? 8'bzz : M68K_DATA_RAM[7:0]) 	: reset_counter[10:3];
	assign sram_dq[15:8] = 	reset_n ? (sram_nWWU ? 8'bzz : M68K_DATA_RAM[15:8]) 	: reset_counter[11:4];
	assign sram_oe_n = 		reset_n ? &{nWRL, nWRU} 										: 1'b1;
	assign sram_we_n = 		reset_n ? &{sram_nWWL, sram_nWWU} 							: 1'b0;
	assign sram_ub_n = 		reset_n ? &{sram_nWWU, nWRU} 									: 1'b0;
	assign sram_lb_n = 		reset_n ? &{sram_nWWL, nWRL} 									: 1'b0;

	assign SRAM_OUT = sram_dq;
	
endmodule