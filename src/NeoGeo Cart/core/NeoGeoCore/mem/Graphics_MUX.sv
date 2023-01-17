/****************************************************************************************
	
	CROM and SROM Ram Controller
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following
	
	Does 64 bit reads from the SDRAM at 133mhz for the CROM
	Dose address decoding for the tile system
	Decodes the SROM address to the SRAM - (Async)
	
	
	ToDo: move the SROM to the CRAM Will use the SRAM as ram for the 68K cpu or memory cards

*****************************************************************************************/

module Graphics_MUX(
	input             CLK,
	input 				sdram_clk,
	input             nRESET,


		// CROM access control
	
	input             PCK1,
	input      [23:0] CROM_ADDR,
	input 	  [25:0] CROM_MASK, 
	output reg [63:0] CR_DOUBLE,	// 8 pixels
	
		// SDRAM access control

	output reg			burst_rd, // must be synchronous to clk_ram
	output reg [25:0]	burst_addr,
	output reg [10:0]	burst_len,
	output reg 			burst_32bit,
	input		  [31:0]	burst_data,
	input					burst_data_valid,
	input					burst_data_done
);

//	assign sram_dq = sram_oe_n ? sram_data_output : 16'bz;

	reg [15:0] sram_data_output;
	reg [15:0] sram_data_output_low;
	reg        SDRAM_WR_BYTE_MODE;
	reg SROM_RD_RUN, CROM_RD_RUN;
	
	reg [25:0] SDRAM_ADDR;
	
	reg PCK1_reg2, PCK1_reg1;
	reg 			CA4_reg;

	wire REQ_CROM_RD_FIRST = PCK1 && ~PCK1_reg1;
	reg  REQ_CROM_RD_FIRST_REG;
	reg old_ready;
	
	reg [1:0]	sdram_state;
	
	parameter	sdram_idle		= 'd0;
	parameter	sdram_read_1	= 'd1;
	parameter	sdram_read_2	= 'd2;
	
	reg [31:0]	data_received;

	
	reg			CROM_request;
	
	always @(posedge sdram_clk) begin
			if (!nRESET) begin
				burst_rd		<= 'b0;
				burst_addr	<= 'b0;
				burst_len	<= 'd2;
				burst_32bit <= 'b1;
				CROM_request <= 1'b0;
			end
			burst_rd 	<= 'b0;
			burst_32bit	<= 1'b1;
			burst_len	<= 11'd4;
			REQ_CROM_RD_FIRST_REG <= REQ_CROM_RD_FIRST;			
			PCK1_reg1 <= PCK1;
			PCK1_reg2 <= PCK1_reg1;
						
			if (REQ_CROM_RD_FIRST_REG) begin
				CROM_request <= 1;
			end
			
			
			case (sdram_state)
				sdram_read_1 : begin
					if (burst_data_valid) begin
						CR_DOUBLE[63:32] <= burst_data;
						sdram_state <= sdram_read_2;
						CROM_request <= 1'b0;
					end
				end
				sdram_read_2 : begin
					if (burst_data_valid) begin
						CR_DOUBLE[31:0] <= burst_data;
						sdram_state <= sdram_idle;
						CROM_request <= 1'b0;
					end
				end
				default : begin
					if (REQ_CROM_RD_FIRST && nRESET) begin
						burst_addr	<= {CROM_ADDR[22:20], CROM_ADDR[15:0], CROM_ADDR[19:16], 3'b000} & {CROM_MASK[25:20], CROM_MASK[19:3], 3'b000}; // Demuxing
						burst_rd 	<= 'b1;
						sdram_state <= sdram_read_1;
					end
				end
			endcase
		end
			// SRAM Controller - we know that it is running at about 93mhz and we need to create a 55NS timer.
	
//	reg  sram_word_wr_reg;
//	
//	reg  PCK2_1_reg, REQ_SROM_RD_reg;
//	
//	wire sram_word_W_R = ~sram_word_wr_reg & |{sram_word_wr, sram_word_rd};
//	
//	wire REQ_SROM_RD = |{PCK2_1_reg & ~S2H1, S2H1 & ~PCK2_1_reg}; // We do a double check here.
//	
//	reg [1:0]	sram_state;
//	
//	parameter	sram_idle		= 'd0;
//	parameter	sram_read		= 'd1;
//	parameter	sram_write		= 'd2;
//	
//	parameter 	sram_time_delay = 'd6; // The amount of wait states for the delay for the read or writes
//	
//	reg 			sram_counter;
//	
//	reg [4:0]	sram_time_counter;
//	reg [15:0]	SROM_DATA_reg;
//	reg 			S_LATCH12reg;
	
//	always @* begin
//		case({pixel_mux_change[31],S_LATCH12reg})
//			2'b10 	: SROM_DATA <= SROM_DATA_reg[15:8];
//			2'b11 	: SROM_DATA <= SROM_DATA_reg[ 7:0];
//			2'b01 	: SROM_DATA <= SROM_DATA_reg[15:8];
//			default 	: SROM_DATA <= SROM_DATA_reg[ 7:0];
//		endcase
//	end
	
//	always @(posedge CLK) begin
//			sram_word_busy				<= 'b0;
//			PCK2_1_reg <= S2H1;
//			REQ_SROM_RD_reg <= REQ_SROM_RD;
//			S_LATCH12reg <= S_LATCH[12];
//			sram_word_wr_reg <= |{sram_word_wr, sram_word_rd};
//			case (sram_state)
//				sram_idle : begin
//					sram_time_counter <= 'b0;
//					if (sram_word_W_R) begin
//						sram_a 						<=  {sram_word_addr[24:2], 1'b0};
//						sram_we_n 					<=  sram_word_rd;
//						sram_oe_n 					<= ~sram_word_rd;
//						sram_data_output 			<=  sram_word_data[31:16];
//						sram_data_output_low 	<=  sram_word_data[15: 0];
//						sram_counter 				<= 'b0;
//						sram_lb_n					<= 'b0;
//						sram_ub_n					<= 'b0;
//						sram_word_busy				<= 'b1;
//						if (sram_word_rd) sram_state <= sram_read;
//						else sram_state 				  <= sram_write;
//					end
//					else if(REQ_SROM_RD_reg && nRESET && ~FIX_BANK[1]) begin
//						sram_a 						<= {FIX_BANK[0], S_LATCH[11:0], S_LATCH[15], ~S2H1, S_LATCH[14:13]};
//						sram_we_n 					<= 'b1;
//						sram_counter 				<= 'b1;
//						sram_oe_n					<= 'b0;
//						sram_lb_n					<= 'b0;
//						sram_ub_n					<= 'b0;
//						sram_word_busy				<= 'b1;
//						sram_state 					<= sram_read;
//					end
//					else begin
//						sram_oe_n					<= 'b1;
//						sram_we_n 					<= 'b1;
//						sram_lb_n					<= 'b1;
//						sram_ub_n					<= 'b1;
//						sram_word_busy				<= 'b0;
//						sram_state 					<= sram_idle;
//					end
//				end
//				sram_read : begin
//					sram_time_counter <= sram_time_counter + 1;
//					if (sram_time_counter == sram_time_delay) begin
//						sram_time_counter <= 'b0;
//						if (sram_counter) begin
//							sram_state 				<= sram_idle;
//							SROM_DATA_reg 			<= sram_dq;
//							sram_word_q[15: 0] 	<= 16'd0;
//							sram_we_n 				<= 1'b1;
//							sram_oe_n 				<= 1'b1;
//						end
//						else begin
//							sram_a 					<= {sram_a[16:1],1'b1};
//							sram_word_q[31:16] 	<= sram_dq;
//							sram_counter 			<= 'b1;
//						end
//					end
//				end	
//				sram_write : begin
//					sram_time_counter <= sram_time_counter + 1;
//					if (sram_time_counter == sram_time_delay) begin
//						sram_time_counter <= 'b0;
//						if (sram_counter) begin
//							sram_state 				<= sram_idle;
//							sram_we_n 				<= 1'b1;
//							sram_oe_n 				<= 1'b1;
//						end
//						else begin
//							sram_a 					<= {sram_a[16:1],1'b1};
//							sram_data_output 		<= sram_data_output_low;
//							sram_counter 			<= 'b1;
//						end
//					end
//				end
//				default : begin
//					sram_state <= sram_idle;
//				end				
//			endcase	
//	end
endmodule
