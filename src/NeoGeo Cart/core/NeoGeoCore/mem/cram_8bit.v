
/****************************************************************************************
	
	Sound Rom Controller for the Neogeo
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following
	
	ADPCM A and B Channel access as 8 bits from the CRAM cores

*****************************************************************************************/

module cram_8bit
(
	input 				reset_l_main, // This is used for init the ram core
	input 				nRESET, // This is used for init the Neogeo core
	input					sys_clk,
	output [21:16]		cram_a,
	inout	 [15:0]		cram_dq,
	input					cram_wait,
	output				cram_clk,
	output 				cram_adv_n,
	output 				cram_cre,
	output 				cram_ce0_n,
	output 				cram_ce1_n,
	output 				cram_oe_n,
	output 				cram_we_n,
	output 				cram_ub_n,
	output 				cram_lb_n,

	input					word_rd,
	input					word_wr,
	input	 [23:0]		word_addr, // this is a 32bit address
	input	 [31:0]		word_data, // this is a 
	output reg [31:0]	word_q,
	output reg			word_busy,
	
	input					clk_8M,
	
	input  	  [23:0] rdaddr1,
	output reg [7:0]  ADPCMA_DATA,
	input             ADPCMA_READ_REQ,
	output reg        ADPCMA_READ_ACK,

	input      [23:0] rdaddr2,
	output reg [7:0]  ADPCMB_DATA,
	input             ADPCMB_READ_REQ,
	output reg        ADPCMB_READ_ACK
);

	/**************************************************************************************
	
		Now for the state system to control the Ram access between the two CPU's and
		the downloading core
	
	
	***************************************************************************************/
	
	parameter	init_reset						=	'd0;
	parameter	idle								=	'd1;
	parameter	read_single						=	'd2;
	parameter	write_single					=	'd3;
	
	reg [1:0] 	ram_state;
	reg [31:0]	RAM_DATA_WRITE;
	reg [23:0] 	RAM_ADDR;
	wire [31:0]	Sln_DBus;
	reg 			RAM_READ;
	reg			RAM_Access;
	
	wire 			Sln_xferAck;
	reg			Sln_xferAck_reg;
	reg [1:0]	channel;
	reg [3:0]	OPB_BE;
	reg			rd_req1_reg;
	reg			rd_req2_reg;
	
	reg 			OPB_32Bit;
	
	reg [31:0] 	counter;
	
	always @(posedge clk_8M) begin
		counter <= counter + 1;
	end
	
	reg ADPCMA_READ_REQ_REG;
	reg ADPCMB_READ_REQ_REG;
	
		
	always @(posedge sys_clk or negedge reset_l_main) begin
		if (~reset_l_main) begin
			rd_req1_reg				<= 'b0;
			rd_req2_reg				<= 'b0;
			RAM_Access 				<= 'b0;
			word_busy 				<= 'b0;
			ram_state 				<= init_reset;
			OPB_BE 					<= 4'hf;
			RAM_DATA_WRITE			<= 'b0;
			Sln_xferAck_reg		<= 'b0;
			OPB_32Bit				<= 'b0;
			ADPCMA_READ_REQ_REG	<= 1'b0;
			ADPCMB_READ_REQ_REG	<= 1'b0;
		end
		else begin

			Sln_xferAck_reg 		<= Sln_xferAck;
			OPB_BE 					<= 4'hf;
				
			
			case (ram_state)
				idle : begin
					word_busy 				<= 'b0;
					if (|{word_rd, word_wr}) begin
						RAM_READ 			<= word_rd;
						RAM_Access 			<= 1'b1;
						word_busy 			<= 1'b1;
						ram_state 			<= (word_rd ? read_single : write_single);
						RAM_DATA_WRITE		<= word_data;
						channel				<= 2'd0;
						RAM_ADDR 			<= word_addr[23:0]; // Add the address MUX in the waiter
						OPB_32Bit				<= 'b1;
					end
					
					else if(ADPCMA_READ_REQ != ADPCMA_READ_ACK) begin
						RAM_READ 	<= 1'b1;
						RAM_Access 	<= 'b1;
						word_busy 	<= 'b1;
						ram_state 	<= read_single;
						channel		<= 2'd1;
						RAM_ADDR 	<= rdaddr1;
						OPB_32Bit	<= 'b0;
					end
					else if(ADPCMB_READ_REQ != ADPCMB_READ_ACK) begin
						RAM_READ 	<= 1'b1;
						RAM_Access 	<= 'b1;
						word_busy 	<= 'b1;
						ram_state 	<= read_single;
						channel		<= 2'd2;
						RAM_ADDR 	<= rdaddr2;
						OPB_32Bit	<= 'b0;
					end
				end
				
				read_single : begin
					if (Sln_xferAck && ~Sln_xferAck_reg) begin
						ram_state 		<= idle;
						word_busy 		<= 1'b0;
						RAM_Access 		<= 1'b0;
						case (channel)
							2'd1 : begin
								case (RAM_ADDR[0])
									1'b1 		: ADPCMA_DATA <= Sln_DBus[15: 8];
									default 	: ADPCMA_DATA <= Sln_DBus[ 7: 0];
								endcase
								ADPCMA_READ_ACK <= ADPCMA_READ_REQ;
							end
							2'd2 : begin
								case (RAM_ADDR[0])
									1'b1 		: ADPCMB_DATA <= Sln_DBus[15: 8];
									default 	: ADPCMB_DATA <= Sln_DBus[ 7: 0];
								endcase
								ADPCMB_READ_ACK <= ADPCMB_READ_REQ;
							end
							default : begin
								word_q <= Sln_DBus; 
							end
						endcase
					end
					else begin
						word_busy <= 'b1;
					end
				end
				
				write_single : begin
					if (Sln_xferAck && ~Sln_xferAck_reg) begin
						ram_state 	<= idle;
						word_busy 	<= 1'b0;
						RAM_Access 	<= 1'b0;
					end
				end
				
				default : begin
					ram_state <= idle;
				end
			endcase
		end
	end

	// CRAM Controller
	
	opb_psram_v opb_psram_v(
      .OPB_ABus        	(RAM_ADDR),
      .OPB_BE          	(OPB_BE),
      .OPB_Clk         	(sys_clk),
      .OPB_DBus        	(RAM_DATA_WRITE),
		.OPB_32Bit			(OPB_32Bit),
      .OPB_RNW         	(RAM_READ),
      .OPB_Rst         	(reset_l_main),
      .OPB_select      	(RAM_Access),
      .Sln_DBus        	(Sln_DBus),
      .Sln_xferAck     	(Sln_xferAck),


      .cram_a 				(cram_a),
      .cram_dq 			(cram_dq),
      .cram_wait 			(cram_wait),
      .cram_clk 			(cram_clk),
      .cram_adv_n 		(cram_adv_n),
      .cram_cre 			(cram_cre),
      .cram_ce0_n 		(cram_ce0_n),
      .cram_ce1_n 		(cram_ce1_n),
      .cram_oe_n 			(cram_oe_n),
      .cram_we_n 			(cram_we_n),
      .cram_ub_n 			(cram_ub_n),
      .cram_lb_n 			(cram_lb_n)
		);

endmodule