/****************************************************************************************
	
	CRAM Ram Wrapper - (ASync)
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following
	
	CRAM Wrapper for a 32 bit write from the APF
	16bit reads for each request

*****************************************************************************************/


module opb_psram_v(
		input [23:0] 			OPB_ABus,
      input [3:0]				OPB_BE,
      input 					OPB_Clk,
      input [31:0]			OPB_DBus,
		input 					OPB_32Bit,
      input 					OPB_RNW,
      input 					OPB_Rst,
      input 					OPB_select,
      output [31:0]			Sln_DBus,
      output 					Sln_xferAck,
		
      output [21:16]			cram_a,
		inout	 [15:0]			cram_dq,
		input						cram_wait,
		output					cram_clk,
		output 					cram_adv_n,
		output 					cram_cre,
		output 					cram_ce0_n,
		output 					cram_ce1_n,
		output 					cram_oe_n,
		output 					cram_we_n,
		output				   cram_ub_n,
		output				   cram_lb_n
);

  // internal Signals
  wire 			PSRAM_Mem_CLK_EN;
  wire [15:0]	PSRAM_Mem_DQ_I;
  wire [15:0]	PSRAM_Mem_DQ_O;
  wire [21:0] 	PSRAM_Mem_A;
  wire [1:0]	PSRAM_Mem_BE;
  wire			PSRAM_Mem_OEN;

psram_controller psram_controller (
		.OPB_ABus            (OPB_ABus),
      .OPB_BE              (OPB_BE),
      .OPB_Clk             (OPB_Clk),
      .OPB_DBus            (OPB_DBus),
      .OPB_RNW             (OPB_RNW),
		.OPB_32Bit				(OPB_32Bit),
      .OPB_Rst             (OPB_Rst),
      .OPB_select          (OPB_select),
      .Sln_DBus            (Sln_DBus),
      .Sln_xferAck         (Sln_xferAck),
      .PSRAM_Mem_DQ_I  		(PSRAM_Mem_DQ_I),
      .PSRAM_Mem_DQ_O  		(PSRAM_Mem_DQ_O),
      .PSRAM_Mem_DQ_OE 		(cram_oe_n),
		.PSRAM_Mem_CEN0		(cram_ce0_n),
		.PSRAM_Mem_CEN1		(cram_ce1_n),
      .PSRAM_Mem_A     		(PSRAM_Mem_A),
		.PSRAM_Mem_ADV			(cram_adv_n),
      .PSRAM_Mem_BE    		(PSRAM_Mem_BE),
      .PSRAM_Mem_WE    		(cram_we_n),
      .PSRAM_Mem_OEN   		(PSRAM_Mem_OEN)

);

assign {cram_ub_n,cram_lb_n} 	= PSRAM_Mem_BE;

assign cram_a[21:16] 			= PSRAM_Mem_A[21:16];

assign cram_dq 					= PSRAM_Mem_OEN ? PSRAM_Mem_DQ_O : 16'hzzzz;

assign PSRAM_Mem_DQ_I 			= PSRAM_Mem_OEN ? 16'b0 			: cram_dq;

assign cram_clk 					= 1'b0;
assign cram_cre 					= 1'b0;

endmodule