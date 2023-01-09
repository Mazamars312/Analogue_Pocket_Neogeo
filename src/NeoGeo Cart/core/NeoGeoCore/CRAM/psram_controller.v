/****************************************************************************************
	
	CRAM Ram Controller - (Async system)
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following
	
	32 bit writes
	16bit reads for each request
	
	ToDo: Add 32 bit reads

*****************************************************************************************/

module psram_controller (
    input [23:0]			OPB_ABus,
    input [3:0]			OPB_BE,
    input 					OPB_Clk,
    input [31:0]			OPB_DBus,
	 input					OPB_32Bit,
    input 					OPB_RNW,
    input 					OPB_Rst,
    input 					OPB_select,
    output reg [31:0]	Sln_DBus,
    output reg 			Sln_xferAck,

    input [15:0]			PSRAM_Mem_DQ_I,
    output reg [15:0] 	PSRAM_Mem_DQ_O,
    output reg 			PSRAM_Mem_DQ_OE,
    output reg [21:0]	PSRAM_Mem_A,
    output reg [1:0]		PSRAM_Mem_BE,
    output reg 			PSRAM_Mem_WE,
    output reg 			PSRAM_Mem_OEN,
    output reg 			PSRAM_Mem_CEN0,
	 output reg 			PSRAM_Mem_CEN1,
    output reg 			PSRAM_Mem_ADV
);
parameter		HIGH					=	1'b1,
					LOW					=	1'b0;
				

parameter		idle					=	'd1,

					wr_write_s_msb		=	'd2,
					wr_wait_msb			=	'd3,
               wr_write_d_msb		=	'd4,
					wr_complete_msb	=	'd5,
					
					wr_address_lsb		=	'd6,
					wr_write_s_lsb		=	'd7,
					wr_wait_lsb			=	'd8,
               wr_write_d_lsb		=	'd9,
					wr_complete_lsb	=	'd10,
					
               rd_read_s_lsb		=	'd11,
               rd_wait_s_lsb		=	'd12,
               rd_complete_s_lsb	=	'd13;


	reg	[3:0]	cram_status;
	
								
	reg [7:0]	cnt;
	reg [31:0]	write_data;
	reg [1:0]	write_be;
	reg [15:0]	read_data;
	reg			OPB_select_reg_1, OPB_select_reg_2;
	
	always @(posedge OPB_Clk or negedge OPB_Rst) begin
		if (~OPB_Rst) begin 
			PSRAM_Mem_DQ_O		<= 15'b0;
			PSRAM_Mem_DQ_OE	<= HIGH;
			PSRAM_Mem_A			<= 22'h0;
			PSRAM_Mem_BE		<= 2'b11;
			PSRAM_Mem_WE		<= HIGH;
			PSRAM_Mem_OEN		<= HIGH;
			PSRAM_Mem_CEN0		<= HIGH;
			PSRAM_Mem_CEN1		<= HIGH;
			PSRAM_Mem_ADV		<= HIGH;
			Sln_DBus				<= 32'h0;
			Sln_xferAck			<= LOW;
			cnt					<= 8'd0;
			write_data			<= 32'h0;
			cram_status			<= idle;
			read_data			<= 16'b0;
			write_be				<= 4'b1111;
		end
		else begin
			OPB_select_reg_1 <= OPB_select;
			OPB_select_reg_2 <= OPB_select_reg_1;
			
			case (cram_status)
				idle : begin 
					// this will help keep the CRAM not going into sleep mode
					PSRAM_Mem_ADV 			<= HIGH;
					PSRAM_Mem_DQ_OE 		<= HIGH;
					PSRAM_Mem_BE			<= 2'b11;
					PSRAM_Mem_CEN0 		<= HIGH;
					PSRAM_Mem_CEN1 		<= HIGH;
					PSRAM_Mem_OEN			<= HIGH;
					PSRAM_Mem_WE			<= HIGH;
					
					if (OPB_select == HIGH && OPB_select_reg_1 == LOW) begin // We want the HIGH change of the clock and sync it
						Sln_xferAck			<= LOW;
						PSRAM_Mem_ADV 		<= LOW;
						PSRAM_Mem_CEN0 	<=  OPB_ABus[23];
						PSRAM_Mem_CEN1 	<= ~OPB_ABus[23];
						write_data        <= OPB_DBus;
						write_be          <= ~OPB_BE[1:0];
						
						if (OPB_RNW == LOW) begin 
							PSRAM_Mem_A   		<=  OPB_32Bit ? {OPB_ABus[22:2], 1'b0} : OPB_ABus[22:1]; // This is so we can do the 16bit writes
							PSRAM_Mem_DQ_O  	<=  OPB_32Bit ? {OPB_ABus[16:2], 1'b0} : OPB_ABus[22:1];
							cram_status       <=  OPB_32Bit ? wr_write_s_msb : wr_write_s_lsb;				// drop to the last write stage
							PSRAM_Mem_BE		<= ~OPB_BE[3:2];
						end
						
						else begin 
							PSRAM_Mem_A   		<= OPB_ABus[22:1];
							PSRAM_Mem_DQ_O  	<= OPB_ABus[16:1];
							PSRAM_Mem_WE  		<= HIGH;
							PSRAM_Mem_BE  		<= 2'b00;
							cram_status       <= rd_read_s_lsb;
						end
					end
				end 
				
				// Write Core
					wr_write_s_msb	: begin
						PSRAM_Mem_WE  		<= LOW;
						cram_status			<= wr_wait_msb;
					end
					wr_wait_msb	: begin
						PSRAM_Mem_ADV 		<= HIGH;
						cram_status			<= wr_write_d_msb;
						cnt 					<= 8'h3;
					end
               wr_write_d_msb	: begin
						PSRAM_Mem_DQ_O		<= write_data[31:16];
						if (cnt != 8'h0) cnt <= cnt - 8'h1;
						else begin	
							cram_status <= wr_complete_msb;
							cnt			<= 8'h2;
						end
					end
					wr_complete_msb	: begin
						PSRAM_Mem_ADV 			<= HIGH;
						PSRAM_Mem_DQ_OE 		<= LOW;
						PSRAM_Mem_BE			<= 2'b11;
						PSRAM_Mem_CEN0 		<= HIGH;
						PSRAM_Mem_CEN1 		<= HIGH;
						PSRAM_Mem_OEN			<= HIGH;
						PSRAM_Mem_WE			<= HIGH;
						if (cnt != 8'h0) cnt <= cnt - 8'h1;
						else cram_status <= wr_address_lsb;
					end
					
					wr_address_lsb	: begin
						PSRAM_Mem_A   		<= {OPB_ABus[22:2], 1'b1};
						PSRAM_Mem_DQ_O  	<= {OPB_ABus[16:2], 1'b1};
						cram_status       <= wr_write_s_lsb;
						PSRAM_Mem_BE		<= write_be;
						PSRAM_Mem_DQ_OE	<= HIGH;
						PSRAM_Mem_ADV 		<= LOW;
						PSRAM_Mem_CEN0 	<=  OPB_ABus[23];
						PSRAM_Mem_CEN1 	<= ~OPB_ABus[23];
					end
					wr_write_s_lsb	: begin
						PSRAM_Mem_WE  		<= LOW;
						cram_status			<= wr_wait_lsb;
					end
					wr_wait_lsb	: begin
						PSRAM_Mem_ADV 		<= HIGH;
						cram_status			<= wr_write_d_lsb;
						cnt 					<= 8'h3;
					end
               wr_write_d_lsb	: begin
						PSRAM_Mem_DQ_O		<= write_data[15: 0];
						if (cnt != 8'h0) cnt <= cnt - 8'h1;
						else begin	
							cram_status <= wr_complete_lsb;
							cnt			<= 8'h2;
						end
					end
					wr_complete_lsb	: begin
						PSRAM_Mem_ADV 			<= HIGH;
						PSRAM_Mem_DQ_OE 		<= HIGH;
						PSRAM_Mem_BE			<= 2'b11;
						PSRAM_Mem_CEN0 		<= HIGH;
						PSRAM_Mem_CEN1 		<= HIGH;
						PSRAM_Mem_OEN			<= HIGH;
						PSRAM_Mem_WE			<= HIGH;
						Sln_xferAck				<= HIGH;
						cram_status				<= idle;
					end
				
				
				// Read Core
				
					rd_read_s_lsb : begin
						PSRAM_Mem_ADV 			<= HIGH;
						cram_status				<= rd_wait_s_lsb;
					end
					rd_wait_s_lsb : begin
						PSRAM_Mem_OEN			<= LOW;
						cnt						<= 8'h3;
						PSRAM_Mem_DQ_OE 		<= LOW;
						cram_status				<= rd_complete_s_lsb;
					end
					rd_complete_s_lsb : begin
						if (cnt != 8'h0) begin
							cnt <= cnt - 1;
						end
						else begin
							Sln_DBus					<= {2{PSRAM_Mem_DQ_I}};
							PSRAM_Mem_ADV 			<= HIGH;
							PSRAM_Mem_DQ_OE 		<= HIGH;
							PSRAM_Mem_BE			<= 2'b11;
							PSRAM_Mem_CEN0 		<= HIGH;
							PSRAM_Mem_CEN1 		<= HIGH;
							PSRAM_Mem_OEN			<= HIGH;
							PSRAM_Mem_WE			<= HIGH;
							cram_status				<= idle;
							Sln_xferAck				<= HIGH;
						end
					end

				
				
				default : begin
					cram_status     <= idle;
				end
			endcase
		end
	end
endmodule