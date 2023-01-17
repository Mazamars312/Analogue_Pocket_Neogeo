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
	input						word_32bit,
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
	
		// SROM access control
	
	input             	nSYSTEM_G,
	input 	  [18:0]		SROM_MASK,
	input      [15:0] 	PBUS,
	input       [1:0] 	FIX_BANK,
	input 					PCK2,
	output reg [15:0]  	SROM_DATA,	// 4 pixels


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
	parameter	write_8bit						=	'd5;
	
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
	reg 			z80Highclock;
	reg			OPB_32Bit; // are we doing a 32 or 16 bit transfer
	reg [20:1] 	M68K_ADDR_REG;
	reg [24:1] 	P2ROM_ADDR_REG;
	reg			REQ_Z80_RD_SIG_REG;
	
	wire REQ_M68K_RD_SIG = ~&{nROMOE, nPORTOE, nSROMOE};
	wire REQ_M68K_RD 		= (~REQ_M68K_RD_SIG_REG & REQ_M68K_RD_SIG);
		
	wire REQ_Z80_RD_SIG 	= &{~z80_nSDROM, ~z80_nSDMRD};
	wire REQ_Z80_RD 		=  (~REQ_Z80_RD_SIG_REG & REQ_Z80_RD_SIG);
	
	wire REQ_SROM_RD = PCK2_reg_1 & ~PCK2;
	
	reg [7:0] REQ_Z80_RD_counter;
	reg REQ_Z80_REQ;
	reg old_clk;
	reg z80_ready_reg;
	
	reg 			REQ_SROM_REQ;
	reg 			S_LATCH12reg;
	reg 			PCK2_reg_1, PCK2_reg_2, PCK2_reg_3;
	reg [15:0]	PBUS_REG;
	reg 			S2H1_reg;
	reg [6:0]	Ram_wait;
	
	reg [31:0]	word_q_reg;
	reg [ 7:0]	z80_dout_reg;
	reg [15:0]	SROM_DATA_reg;
	reg [15:0]	SROM_DATA_reg_1;
	reg [15:0]	PROM_DATA_reg;
	
	reg			PROM_DATA_READY_C;
	
	wire [17:0] SROM_ADDRESS = {FIX_BANK[1:0],PBUS_REG[15:0]} & SROM_MASK[17:0];
	
	always @(posedge sys_clk or negedge reset_l_main) begin
		if (~reset_l_main) begin
			PROM_DATA_READY_C 		<=  1'b0;
			RAM_Access 				<= 'b0;
			word_busy 				<= 'b0;
			ram_state 				<= init_reset;
			OPB_BE 					<= 4'hf;
			nAS_PREV 				<= 'b0;
			REQ_M68K_RD_SIG_REG	<= 'b0;
			REQ_M68K_WD_SIG_REG	<= 'b0;
			RAM_DATA_WRITE			<= 'b0;
			M68K_RD_REQ 			<= 0;
			OPB_32Bit				<= 1'b1;
			M68K_WD_REQ				<= 1'b0;
			M68K_DATA_SAVE			<= 16'h0;
			address_write_reg		<= 25'h0;
			M68K_ADDR_REG			<= 'b0;
			P2ROM_ADDR_REG			<= 'b0;
			REQ_Z80_RD_SIG_REG	<= 'b0;
			z80_ready_reg			<= 1'b1;
			REQ_Z80_REQ				<= 1'b0;
			old_clk					<= 1'b0;
			REQ_Z80_RD_counter 	<= 1'b0;
			REQ_SROM_REQ			<= 1'b0;
			S_LATCH12reg			<= 1'b0;
			PCK2_reg_1					<= 1'b0;
			PCK2_reg_2					<= 1'b0;
			PCK2_reg_3					<= 1'b0;
		end
		else begin
			
			Sln_xferAck_reg 		<= Sln_xferAck;
			
			S_LATCH12reg 			<= PBUS_REG[12];
			PCK2_reg_1				<= PCK2;
			PCK2_reg_2				<= PCK2_reg_1;
			PCK2_reg_3				<= PCK2_reg_2;
			// This is for the 68K core Access
			if (nRESET) begin
				REQ_M68K_RD_SIG_REG 							<= REQ_M68K_RD_SIG;
				REQ_Z80_RD_SIG_REG							<= REQ_Z80_RD_SIG;
				nAS_PREV 										<= nAS;
				
				old_clk <= z80_clk;
				
				if (REQ_SROM_RD) 	begin	
					REQ_SROM_REQ 								<= 1'b1;
					PBUS_REG										<= PBUS;
				end
				
				if (REQ_M68K_RD) 	M68K_RD_REQ 			<= 1;
				
				if (REQ_Z80_RD) 	begin	
					REQ_Z80_REQ 								<= 1'b1;
					z80_ready_reg								<= 1'b0;
				end
				else z80_ready_reg		<= z80_ready;
				
				if (~nAS_PREV & nAS) begin
					PROM_DATA_READY_C							<= 1'b0;
					P2ROM_ADDR_REG								<= P2ROM_ADDR;
					M68K_ADDR_REG								<= M68K_ADDR;
				end
				else begin
					PROM_DATA_READY_C <= PROM_DATA_READY;
				end
				if (REQ_SROM_RD) Ram_wait <= 1'd0;
				else Ram_wait <= Ram_wait + 1;
				
			end
			else begin // Reset cores
				REQ_M68K_RD_SIG_REG 							<= 1'b0;
				REQ_M68K_WD_SIG_REG 							<= 1'b0;
				REQ_SROM_REQ									<= 1'b0;
				PROM_DATA_READY_C								<= 1;
				M68K_RD_RUN 									<= 1'b0;
				nAS_PREV											<= 1'b0;
				M68K_RD_REQ 									<= 0;
				REQ_Z80_RD_SIG_REG							<= 0;
				REQ_Z80_REQ										<= 0;
				z80_ready_reg									<= 1'b1;
				Ram_wait											<= 0;
			end
			
			// Z80 Rise and fall signal to the controller.
			word_q_reg 		<= word_q;
			z80_dout_reg 	<= z80_dout;
			SROM_DATA_reg	<= SROM_DATA;
			PROM_DATA_reg 	<= PROM_DATA;
			
			case (ram_state)
				idle : begin
					word_busy 			<= 1'b0;
					// APF Access for writting
					if (|{word_rd, word_wr}) begin
						RAM_READ 			<= word_rd;
						RAM_Access 			<= 1'b1;
						case ({word_rd, word_32bit})
							2'b11		: ram_state <= read_32bit;
							2'b10		: ram_state <= read_16bit;
							2'b01		: ram_state <= write_32bit;
							default 	: ram_state <= write_8bit;
						endcase
						word_busy 			<= 1'b1; 
						OPB_BE 				<= word_32bit ? 4'hF : {2{~word_addr[0], word_addr[0]}};
						RAM_DATA_WRITE		<= word_data;
						channel_read		<= 3'd0;
						RAM_ADDR 			<= word_addr; // Add the address MUX in the waiter
						OPB_32Bit			<= word_32bit;
					end			
					// 68K cpu access
					else if(|{REQ_M68K_RD, M68K_RD_REQ}) begin
						RAM_READ 			<= 1'b1;
						RAM_Access 			<= 1'b1;
						word_busy 			<= 1'b1;
						OPB_32Bit			<= 1'b0;
						ram_state 			<= read_16bit;
						RAM_DATA_WRITE		<= {2{M68K_DATA}};
						channel_read		<= 3'd1;
						OPB_BE 				<= 4'hF;
						casez ({nROMOE, nPORTOE})
							// P1 ROM 32'h1000_0000 - 100F_FFFF
							2'b0z: begin
								RAM_ADDR 		<= {4'b0000, M68K_ADDR[19:1],1'b0};
							end
							// P2 ROM (cart) 32'h108f_ffff - 0000_0000 - We give this a full 8Mbytes
							2'b10: begin
								RAM_ADDR 		<= {P2ROM_ADDR[23:1],1'b0} + P2ROM_OFFSET;
							end
							// System ROM (cart)	32'h0100_0000 - 010F_FFFF We can allow the full 128kb size
							default : begin
								RAM_ADDR 		<= {7'b1010_000, M68K_ADDR[16:1],1'b0} ;
							end
						endcase
					end
					// srom access
					else if(REQ_SROM_REQ) begin
						RAM_READ 		<= 1'b1;
						RAM_Access 		<= 1'b1;
						word_busy 		<= 1'b1;
						ram_state 		<= read_16bit;
						channel_read	<= 3'd3;
						OPB_32Bit			<= 1'b0;
						RAM_ADDR 		<= nSYSTEM_G ? {4'b1100, 1'b0, SROM_ADDRESS[17:16], SROM_ADDRESS[11:0], SROM_ADDRESS[14:12], SROM_ADDRESS[15], 1'b0}: 
																{4'b1101, 1'b0, 2'b00, PBUS_REG[11:0], PBUS_REG[14:12], PBUS_REG[15], 1'b0};
						OPB_BE 			<= 4'hF;
					end
					// Z80 CPU
					else if(|{REQ_Z80_RD ,REQ_Z80_REQ} && Ram_wait <= 'd53) begin
						RAM_READ 		<= 1'b1;
						RAM_Access 		<= 1'b1;
						word_busy 		<= 1'b1;
						ram_state 		<= read_16bit;
						channel_read	<= 3'd2;
						RAM_ADDR 		<= {5'b1111_1, z80_rdaddr};
						OPB_BE 			<= 4'hF;
						OPB_32Bit			<= 1'b0;
					end
				end
				read_32bit, // need to work on this next
				read_16bit : begin
					RAM_Access 		<= 1'b0;
					if (Sln_xferAck && ~Sln_xferAck_reg) begin
						ram_state 		<= idle;
						word_busy 		<= 1'b0;
						RAM_Access 		<= 1'b0;
						case (channel_read)
							3'd2 : begin
								REQ_Z80_REQ			<= 1'b0;
							end
							
							3'd3 : begin
								REQ_SROM_REQ	   <= 1'b0;
							end
							
							default : begin
								M68K_RD_REQ		 	<= 1'b0;
							end
						endcase
					end
					else begin
						word_busy <= 'b1;
					end
				end
				write_8bit,
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

	// 68K core
	always @* begin
		if (&{channel_read == 3'd1, Sln_xferAck, ~Sln_xferAck_reg}) begin 
			PROM_DATA <= Sln_DBus;
			PROM_DATA_READY 	<= 1'b1;
		end
		else begin
			PROM_DATA_READY 	<= PROM_DATA_READY_C;
			PROM_DATA 			<= PROM_DATA_reg;
		end
	end
	
	// SROM core
	always @* begin
		if (&{channel_read == 3'd3, Sln_xferAck, ~Sln_xferAck_reg}) begin 
			SROM_DATA <= Sln_DBus;
		end
		else SROM_DATA <= SROM_DATA_reg;
	end
	
	// Z80 core
	always @* begin
		if (&{channel_read == 3'd2, Sln_xferAck, ~Sln_xferAck_reg}) begin 
			case (RAM_ADDR[0])
				1'b1 		: z80_dout <= Sln_DBus[15: 8];
				default 	: z80_dout <= Sln_DBus[ 7: 0];
			endcase
			z80_ready <= 1;
		end
		else begin
			z80_ready <= z80_ready_reg;
			z80_dout <= z80_dout_reg;
		end
	end
	
	// APF core
	always @* begin
		case (ram_state)
			read_32bit, // need to work on this next
			read_16bit : begin
				if (&{channel_read == 3'd0, Sln_xferAck, ~Sln_xferAck_reg}) begin 
					word_q <= Sln_DBus;
				end
			end
			default : begin
			 word_q <= word_q_reg;
			end
		endcase
	end
	
	// CRAM Controller
	
	// Fast Access times
	
	
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



