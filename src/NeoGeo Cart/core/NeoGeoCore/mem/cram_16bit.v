/****************************************************************************************
	
	Main Ram Controller for the Neogeo
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following
	
	68k:	
		Program rom
		System Ram
		Backup Save Ram
		
	Z80:
		Program Rom

*****************************************************************************************/

module cram_16bit
(
	input 					reset_l_main, // This is used for init the ram core
	input 					nRESET,	 // This is used for init the Neogeo core
	input						sys_clk,
	
	input						cram_clock,
	
	output  [21:16]		cram_a,
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
	output				   cram_lb_n,
	
		// Pocket OS Access

	input						word_rd,
	input						word_wr,
	input	 		[23:0]	word_addr,
	input	 		[31:0]	word_data,
	output reg  [31:0]	word_q,
	output reg				word_busy,
	
		// Program ROM controls

	input      [20:1] 	M68K_ADDR,
	input      [15:0] 	M68K_DATA,
	input             	nAS,
	input             	nLDS,
	input             	nUDS,
	input             	DATA_TYPE,
	input             	nROMOE,
	input             	nPORTOE,
	input 					nSROMOE,
	input      [24:0] 	P2ROM_ADDR,
	output reg [15:0] 	PROM_DATA,
	output reg        	PROM_DATA_READY,
	
		// Backup SRAM controls
	
	input 					nBWL, 
	input 					nBWU,
	input 					nSRAMOE,
	output [15:0]			SRAM_DATA,
	
		// Work RAM controls
	
	input 					nWWL,
	input 					nWWU,
	input 					nWORKRAM,
	output [15:0]			WORK_RAM,

		// Z80 controls
	
	input 					z80_clk,
	input      [18:0] 	z80_rdaddr,
	output reg [7:0]  	z80_dout,
	input             	z80_nSDMRD,
	input             	z80_nSDROM,
	output reg        	z80_ready 
);

	wire 						data_output_en;
	wire [15:0] 			data_output;
	wire [15:0] 			data_ad_output;
	wire [21:0] 			address_output;
	
	reg	[31:0] 			RAM_ADDR_C;
	reg						M68K_RD_RUN;
	reg						M68K_RD_REQ;
	reg						M68K_WD_REQ;
	
	reg [7:0]				dout;
	
//	always @(posedge sys_clk) begin
//		z80dout <= dout;
//		rd_ack  <= z80_rd_ack;
//	end

	/*********************************************************************************
	// Address Decoder for the CRAM for the Downloading having full access
	// 68k is mostly in the firs slice of the CRAM 0 and the Bios in the second slice
	// shared with the Z80 CPU's 512K ram	
	**********************************************************************************/

	
	parameter P2ROM_OFFSET = 24'h10_0000;
	
	/**************************************************************************************
	
		Cram addressing map
		
		32'h1000_0000 - 107F-FFFF (8Mbytes for Program 2 rom)
		32'h1080_0000 - 109F-FFFF (2Mbytes for Program rom)
		32'h10A0_0000 - 10A1-FFFF (128Kbyte for Bios)
		32'h10A2_0000 - 10A2-FFFF (64Kbyte for Work Ram)
		32'h10A3_0000 - 10A3-FFFF (64Kbyte for Backup Ram)
		32'h10F8_0000 - 10FF-FFFF (512Kbyte for the Z80 RAM)
	
	
	
	**************************************************************************************/
	

	/**************************************************************************************
	
		Now for the state system to control the Ram access between the two CPU's and
		the downloading core
	
	
	***************************************************************************************/
	
	parameter	init_reset						=	'd0;
	parameter	idle								=	'd1;
	parameter	read_16bit						=	'd2;
	parameter	read_32bit						=	'd3;
	parameter	write_32bit						=	'd4;
	parameter	write_16bit						=	'd5;
	
	reg [2:0] 	ram_state;
	reg [31:0]	RAM_DATA_WRITE;
	reg [24:0] 	RAM_ADDR;
	wire [31:0]	Sln_DBus;
	reg 			RAM_READ;
	reg			RAM_Access;
	
	wire 			Sln_xferAck;
	reg			Sln_xferAck_reg;
	
	reg [2:0]	channel_read;
	
	reg [24:0]	address_write_reg;
	reg [3:0]	masking_write_reg;
	
	reg [15:0]	M68K_DATA_SAVE;
	
	// Write masking
	reg [3:0]	OPB_BE;
	
	// check for address access
	reg			nAS_PREV;
	reg  			REQ_M68K_RD_SIG_REG;
	reg			REQ_M68K_WD_SIG_REG;
	reg			z80clk_reg;
	reg 			z80Highclock;
	reg			OPB_32Bit; // are we doing a 32 or 16 bit transfer
	reg [20:1] 	M68K_ADDR_REG;
	reg [24:1] 	P2ROM_ADDR_REG;
	reg			REQ_Z80_RD_SIG_REG;
	
	wire REQ_M68K_RD_SIG = ~&{nROMOE, nPORTOE, nSROMOE, nSRAMOE, nWORKRAM};
	wire REQ_M68K_RD 		= (~REQ_M68K_RD_SIG_REG & REQ_M68K_RD_SIG);
	
	wire REQ_M68K_WD_SIG = ~&{nBWU, nBWL, nWWL, nWWU};
	wire REQ_M68K_WD 		= (~REQ_M68K_WD_SIG_REG & REQ_M68K_WD_SIG);
	
	wire REQ_Z80_RD_SIG 	= &{~z80_nSDROM, ~z80_nSDMRD};
	wire REQ_Z80_RD 		=  (~REQ_Z80_RD_SIG_REG & REQ_Z80_RD_SIG);
	
	reg [7:0] REQ_Z80_RD_counter;
	reg REQ_Z80_REQ;
	reg M68K_RD_REQ_1;
	reg old_clk;
	reg z80_ready_reg;
	
	always @(posedge sys_clk or negedge reset_l_main) begin
		if (~reset_l_main) begin
			PROM_DATA_READY 		<=  1'b0;
			RAM_Access 				<= 'b0;
			word_busy 				<= 'b0;
			ram_state 				<= init_reset;
			OPB_BE 					<= 4'hf;
			nAS_PREV 				<= 'b0;
			REQ_M68K_RD_SIG_REG	<= 'b0;
			REQ_M68K_WD_SIG_REG	<= 'b0;
			RAM_DATA_WRITE			<= 'b0;
			M68K_RD_REQ 			<= 0;
			z80clk_reg				<= 0;
			OPB_32Bit				<= 1'b1;
			M68K_WD_REQ				<= 1'b0;
			SRAM_DATA				<= 16'b0;
			M68K_DATA_SAVE			<= 16'h0;
			address_write_reg		<= 25'h0;
			WORK_RAM					<= 16'h0;
			M68K_ADDR_REG			<= 'b0;
			P2ROM_ADDR_REG			<= 'b0;
			REQ_Z80_RD_SIG_REG	<= 'b0;
			z80_ready_reg			<= 1'b1;
			REQ_Z80_REQ				<= 1'b0;
			M68K_RD_REQ_1			<= 1'b0;
			old_clk					<= 1'b0;
			z80_ready				<= 1'b1;
			REQ_Z80_RD_counter 	<= 1'b0;
		end
		else begin
			
			Sln_xferAck_reg 		<= Sln_xferAck;
			
			z80clk_reg				<= z80_clk;
			
			M68K_RD_REQ_1			<= M68K_RD_REQ; // We need another delay for the core
			
			// This is for the 68K core Access
			if (nRESET) begin
				REQ_M68K_RD_SIG_REG 							<= REQ_M68K_RD_SIG;
				REQ_M68K_WD_SIG_REG							<= REQ_M68K_WD_SIG;
				REQ_Z80_RD_SIG_REG							<= REQ_Z80_RD_SIG;
				nAS_PREV 										<= nAS;
				
				old_clk <= z80_clk;
				z80_ready <= z80_ready_reg;
				
				if (REQ_M68K_RD) 	M68K_RD_REQ 			<= 1;
				
				if (REQ_Z80_RD) 	begin	
					REQ_Z80_REQ 								<= 1'b1;
					z80_ready_reg								<= 1'b0;
					z80_ready									<= 1'b0;
				end
				
				if (~nAS_PREV & nAS) begin
					PROM_DATA_READY 							<= 1'b0;
					P2ROM_ADDR_REG								<= P2ROM_ADDR;
					M68K_ADDR_REG								<= M68K_ADDR;
				end
				
				if (REQ_M68K_WD) begin
					M68K_WD_REQ 								<= 1'b1;
					M68K_DATA_SAVE 							<= M68K_DATA;
		
					casez({ &{nBWU, nBWL} , &{nWWL,nWWU}})
						// 32'h10A3_0000 - 10A3-FFFF (64Kbyte for Backup Ram)
						2'b0z : begin
							address_write_reg <= {8'b1010_0011, M68K_ADDR[15:1],1'b0};
							masking_write_reg <= {2{~nBWU,~nBWL}};
						end
						// 32'h10A2_0000 - 10A2-FFFF (64Kbyte for Work Ram)
						default : begin
							address_write_reg <= {8'b1010_0010, M68K_ADDR[15:1],1'b0};
							masking_write_reg <= {2{~nWWU,~nWWL}};
						end
					endcase
				end
				
			end
			else begin // Reset cores
				REQ_M68K_RD_SIG_REG 							<= 1'b0;
				REQ_M68K_WD_SIG_REG 							<= 1'b0;
				M68K_RD_RUN 									<= 1'b0;
				nAS_PREV											<= 1'b0;
				M68K_RD_REQ 									<= 0;
				REQ_Z80_RD_SIG_REG							<= 0;
				z80clk_reg										<= 0;
				z80_ready_reg									<= 1'b1;
			end
			
			// Z80 Rise and fall signal to the controller.
			
			
			case (ram_state)
				idle : begin
					word_busy 			<= 1'b0;
					if (|{word_rd, word_wr}) begin
						RAM_READ 			<= word_rd;
						RAM_Access 			<= 1'b1;
						ram_state 			<= (word_rd ? read_32bit : write_32bit);
						word_busy 			<= 1'b1;
						OPB_BE 				<= 4'hF;
						RAM_DATA_WRITE		<= word_data;
						channel_read		<= 3'd0;
						RAM_ADDR 			<= word_addr; // Add the address MUX in the waiter
						OPB_32Bit			<= 1'b1;
					end
					
					else if(M68K_RD_REQ) begin
						RAM_READ 			<= 1'b1;
						RAM_Access 			<= 1'b1;
						word_busy 			<= 1'b1;
						OPB_32Bit			<= 1'b0;
						ram_state 			<= read_16bit;
						RAM_DATA_WRITE		<= {2{M68K_DATA}};
						channel_read		<= 3'd1;
						OPB_BE 				<= 4'hF;
						casez ({nWORKRAM, nSRAMOE, nROMOE, nPORTOE})
							// Work Ram 32'h0102_0000 - 0102_FFFF
							4'b0zzz: begin
								RAM_ADDR 		<= {8'b1010_0010, M68K_ADDR[15:1],1'b0};
								channel_read	<= 3'd4;
							end
							// backup Ram 32'h0103_0000 - 0103_FFFF
							4'b10zz: begin
								RAM_ADDR 		<= {8'b1010_0011, M68K_ADDR[15:1],1'b0};
								channel_read	<= 3'd1;
							end
							// P1 ROM 32'h1000_0000 - 100F_FFFF
							4'b110z: begin
								RAM_ADDR 		<= {4'b0000, M68K_ADDR[19:1],1'b0};
								channel_read	<= 3'd3;
							end
							// P2 ROM (cart) 32'h108f_ffff - 0000_0000 - We give this a full 8Mbytes
							4'b1110: begin
								RAM_ADDR 		<= {1'b0, P2ROM_ADDR[22:1],1'b0} + P2ROM_OFFSET;
								channel_read	<= 3'd3;
							end
							// System ROM (cart)	32'h0100_0000 - 010F_FFFF We can allow the full 128kb size
							default : begin
								RAM_ADDR 		<= {7'b1010_000, M68K_ADDR[16:1],1'b0} ;
								channel_read	<= 3'd3;
							end
						endcase
					end
					
					else if(M68K_WD_REQ) begin
						RAM_READ 			<= 1'b0;
						RAM_Access 			<= 1'b1;
						ram_state 			<= write_16bit;
						word_busy 			<= 1'b1;
						RAM_DATA_WRITE		<= {2{M68K_DATA}};
						channel_read		<= 3'd4;
						RAM_ADDR 			<= address_write_reg; // Add the address MUX in the waiter
						OPB_32Bit			<= 1'b0;
						OPB_BE 				<= masking_write_reg;
					end
					
					
					else if(REQ_Z80_REQ) begin
						RAM_READ 		<= 1'b1;
						RAM_Access 		<= 1'b1;
						word_busy 		<= 1'b1;
						ram_state 		<= read_16bit;
						channel_read	<= 3'd2;
						RAM_ADDR 		<= {5'b1111_1, z80_rdaddr}; // bloody weird sizes
						OPB_BE 			<= 4'hF;
					end
				end
				read_32bit, // need to work on this next
				read_16bit : begin
					if (Sln_xferAck && ~Sln_xferAck_reg) begin
						ram_state 		<= idle;
						word_busy 		<= 1'b0;
						RAM_Access 		<= 1'b0;
						case (channel_read)
							3'd0 : begin
								word_q <= Sln_DBus;
							end
							3'd1 : begin
								SRAM_DATA 			<= Sln_DBus[15:0];
								M68K_RD_REQ		 	<= 1'b0;
								PROM_DATA_READY 	<= 1'b1;
							end
							3'd2 : begin
								case (RAM_ADDR[0])
									1'b1 		: z80_dout <= Sln_DBus[15: 8];
									default 	: z80_dout <= Sln_DBus[ 7: 0];
								endcase
								z80_ready_reg		<= 1'b1;
								REQ_Z80_REQ			<= 1'b0;
							end
							3'd4 : begin
								WORK_RAM				<= Sln_DBus[15:0];
								M68K_RD_REQ		 	<= 1'b0;
								PROM_DATA_READY 	<= 1'b1;
							end
							default : begin
								PROM_DATA 			<= Sln_DBus[15:0]; 
								M68K_RD_REQ		 	<= 1'b0;
								PROM_DATA_READY 	<= 1'b1;
							end
						endcase
					end
					else begin
						word_busy <= 'b1;
					end
				end
				write_16bit,
				write_32bit : begin
					if (Sln_xferAck && ~Sln_xferAck_reg) begin
						ram_state 	<= idle;
						word_busy 	<= 1'b0;
						RAM_Access 	<= 1'b0;
						M68K_WD_REQ <= 1'b0;
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
      .OPB_Clk         	(cram_clock),
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



