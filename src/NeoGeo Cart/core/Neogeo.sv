//============================================================================
//  SNK NeoGeo for Pocket
//
//  Copyright (C) 2018 Sean 'Furrtek' Gonsalves
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

// Porting to the pocket:
// Pocket Moved over 27/06/2022:
// Ported by Mazamars312
// Big credit goes to Furrtek for his work on this and all I did was build around it 
//
// Version 0.5.0 Alpha
//
// Process done
// Created the CRAM cores
// SDRAM 100% used for the CROM
// SRAM for sfix rom - need to move this to the CRAM as KOF has a 512kbyte asset
// CRAM0 foir 68K and z80 roms and save memory locations
// CRAM1 for Voice/PCM/Music files
// Moved the Work Ram for the 68K to the CRAM0
// Moved the Backup Ram to the CRAM0. This helps saves as much resources as we can for the core - Waiting for saves for each game as well
//	 
// Version 0.6.0 Alpha
//
//	Created a PLL with most of the major Clocks to sync the video (LSPC2 and the B2 cores) - The compile times are higher as now quartus knows about these clocks
// Made the masking better with the APF framework so both V and C roms work correctly
// Also made a new Offset setup for the VROM so it is not required for double mirroring.
// All special chips are now activated in the 
//
// ToDo:
// Create a work ram clear system for boot. This will help in the bios reload issue (Do this in the 74mhz clock)
// Make access to the memory carts for saves
// Create a better 6mhz clock/6mhz 90 degree - Done in Alpha 0.6.0
// Checks on the 3mhz clock in the B1 core need to be 100% as sometimes the reset sync does not get correct at boot.

module emu
(
	//Master input clock
	input         		clk_74a,

	//Async reset from top-level module.
	//Can be used as initial reset.
	input         		reset_l_main,	
	input					debug_button,
	output				debug_led,			// these are used with the debuging cart

	//Must be passed to hps_io module
	inout	wire			bridge_spimosi,
	inout	wire			bridge_spimiso,
	inout	wire			bridge_spiclk,
	input	wire			bridge_spiss,
	inout	wire			bridge_1wire,

	output     			CLK_VIDEO,
	output   			CLK_VIDEO_90,

	//Multiple resolutions are supported using different CE_PIXEL rates.
	//Must be based on CLK_VIDEO
	output        		CE_PIXEL,

	output reg [7:0] 	VGA_R,
	output reg [7:0] 	VGA_G,
	output reg [7:0] 	VGA_B,
	output reg       	VGA_HS,
	output reg       	VGA_VS,
	output reg       	VGA_DE,    // = ~(VBlank | HBlank)
	output        		VGA_F1,
	output [1:0]  		VGA_SL,
	output        		VGA_SCALER, // Force VGA scaler

	// I/O board button press simulation (active high)
	// b[1]: user button
	// b[0]: osd button
	output  [1:0] 		BUTTONS,

	input         		CLK_AUDIO, // 24.576 MHz
	output [15:0] 		AUDIO_L,
	output [15:0] 		AUDIO_R,
	output        		AUDIO_S,   // 1 - signed audio samples, 0 - unsigned

	//SDRAM interface with lower latency
	output        		SDRAM_CLK,
	output        		SDRAM_CKE,
	output [12:0] 		SDRAM_A,
	output  [1:0] 		SDRAM_BA,
	inout  [15:0] 		SDRAM_DQ,
	output        		SDRAM_DQML,
	output        		SDRAM_DQMH,
	output        		SDRAM_nCS,
	output        		SDRAM_nCAS,
	output        		SDRAM_nRAS,
	output        		SDRAM_nWE,
	
	output [21:16]		cram0_a,
	inout  [15:0]		cram0_dq,
	input					cram0_wait,
	output				cram0_clk,
	output				cram0_adv_n,
	output				cram0_cre,
	output				cram0_ce0_n,
	output				cram0_ce1_n,
	output				cram0_oe_n,
	output				cram0_we_n,
	output				cram0_ub_n,
	output				cram0_lb_n,
	
	output	[21:16]	cram1_a,
	inout	[15:0]		cram1_dq,
	input					cram1_wait,
	output				cram1_clk,
	output				cram1_adv_n,
	output				cram1_cre,
	output				cram1_ce0_n,
	output				cram1_ce1_n,
	output				cram1_oe_n,
	output				cram1_we_n,
	output				cram1_ub_n,
	output				cram1_lb_n,

	output [16:0] 		sram_a,
	inout  [15:0] 		sram_dq,
	output		  		sram_oe_n,
	output		  		sram_we_n,
	output		  		sram_ub_n,
	output		  		sram_lb_n,

	input         		UART_CTS,
	output        		UART_RTS,
	input         		UART_RXD,
	output        		UART_TXD,
	output        		UART_DTR,
	input         		UART_DSR,

	// Open-drain User port.
	// 0 - D+/RX
	// 1 - D-/TX
	// 2..6 - USR2..USR6
	// Set USER_OUT to 1 to read from USER_IN.
	input   [6:0] 		USER_IN,
	output  [6:0] 		USER_OUT,

	input         		OSD_STATUS
);

assign USER_OUT = '1;
assign {UART_RTS, UART_TXD, UART_DTR} = 0;

assign AUDIO_S   = 1;		// Signed
assign AUDIO_L = snd_left;
assign AUDIO_R = snd_right;

wire FIX_EN = 1; // This is for the cart system

// Analogue wires

wire				sdram_word_rd;
wire				sdram_word_wr;
wire	[25:0]	sdram_word_addr;
wire	[31:0]	sdram_word_data;
wire	[31:0]	sdram_word_q;
wire				sdram_word_busy;

wire				sram_word_rd; 
wire				sram_word_wr;
wire	[23:0]	sram_word_addr;
wire	[31:0]	sram_word_data;
wire	[31:0]	sram_word_q;
wire				sram_word_busy;

wire				cram0_word_rd;
wire				cram0_word_wr;
wire				cram0_word_32bit;
wire	[24:0]	cram0_word_addr;
wire	[31:0]	cram0_word_data;
wire	[31:0]	cram0_word_q;
wire				cram0_word_busy;

wire				cram1_word_rd;
wire				cram1_word_wr;
wire	[24:0]	cram1_word_addr;
wire	[31:0]	cram1_word_data;
wire	[31:0]	cram1_word_q;
wire				cram1_word_busy;

// SDRAM Controller

wire 				clk_ram_controller;
wire 				clk_ram_chip;
wire 				clk_ram_90;

wire 				sdram_burst_rd; // must be synchronous to clk_ram
wire [25:0]		sdram_burst_addr;
wire [10:0]		sdram_burst_len;
wire 				sdram_burst_32bit;
wire [31:0]		sdram_burst_data;
wire				sdram_burst_data_valid;
wire				sdram_burst_data_done;

wire				sdram_burstwr;
wire [25:0]		sdram_burstwr_addr;
wire				sdram_burstwr_ready;
wire				sdram_burstwr_strobe;
wire [15:0]		sdram_burstwr_data;
wire				sdram_burstwr_done;

wire [31:0]		pixel_mux_change;


////////////////////   CLOCKS   ///////////////////

wire locked_1;
wire clk_sys;
wire CLK_24M = counter_p[1];
wire sdram_int_clk;

assign sdram_int_clk = clk_sys;

// Clocks
wire CLK_12M, CLK_12MB, CLK_68KCLK, CLK_68KCLKB, CLK_8M, CLK_6MB, CLK_4M, CLK_4MB;

pll pll_sys(
	.refclk(clk_74a),
	.rst(0),
	.outclk_0(clk_sys),
	.outclk_1(CLK_VIDEO),
	.outclk_2(CLK_VIDEO_90),
	.outclk_3(CLK_8M),
	.outclk_4(CLK_4M),
	.reconfig_to_pll(reconfig_to_pll),
	.reconfig_from_pll(reconfig_from_pll),
	.locked(locked_1)
);

reg [1:0] counter_p = 0;
always @(posedge clk_sys) counter_p <= counter_p + 1'd1;

wire [63:0] reconfig_to_pll;
wire [63:0] reconfig_from_pll;
wire        cfg_waitrequest;
reg         cfg_write;
reg   [5:0] cfg_address;
reg  [31:0] cfg_data;

pll_cfg pll_cfg
(
	.mgmt_clk(clk_74a),
	.mgmt_reset(0),
	.mgmt_waitrequest(cfg_waitrequest),
	.mgmt_read(0),
	.mgmt_readdata(),
	.mgmt_write(cfg_write),
	.mgmt_address(cfg_address),
	.mgmt_writedata(cfg_data),
	.reconfig_to_pll(reconfig_to_pll),
	.reconfig_from_pll(reconfig_from_pll)
);


	reg [2:0] state = 0;

always @(posedge clk_74a) begin
	reg sys_mvs = 0, sys_mvs2 = 0;
	reg sys_mvs_r;

	sys_mvs  <= SYSTEM_MVS;
	sys_mvs2 <= sys_mvs;
	cfg_write <= 0;
	if(sys_mvs2 == sys_mvs && sys_mvs2 != sys_mvs_r) begin
		state <= 1;
		sys_mvs_r <= sys_mvs2;
	end

	if(!cfg_waitrequest) begin
		if(state) state<=state+1'd1;
		case(state)
			1: begin
					cfg_address <= 0;
					cfg_data <= 0;
					cfg_write <= 1;
				end
			5: begin
					cfg_address <= 7;
					cfg_data <= sys_mvs_r ? 216917482 : 488741884;//74.25mhz
					cfg_write <= 1;
				end
			7: begin
					cfg_address <= 2;
					cfg_data <= 0;
					cfg_write <= 1;
				end
		endcase
	end
end

wire  SYSTEM_TYPE;
reg nRESET;
always @(posedge CLK_24M) begin
	if (start_system && reset_l_main && locked_1 && state == 0) begin
			nRESET <= 1'b1;
		end
		else begin
			nRESET <= 1'b0;
		end
end


//////////////////   Pocket I/O Controller  ///////////////////


wire [15:0] joystick_0;	// ----HNLS DCBAUDLR
wire [15:0] joystick_1;
wire  [8:0] spinner_0, spinner_1;
wire  [1:0] buttons;
wire [10:0] ps2_key;
wire [24:0] ps2_mouse;
wire        forced_scandoubler;
wire 			video_mode;

wire [3:0] 	cart_pchip;
wire       	use_pcm;
wire [1:0] 	cart_chip;
wire [1:0] 	cmc_chip;

wire [1:0]	use_mouse_reg;

wire [1:0]	memory_card_enable;

wire [7:0]	DIPSW;

wire [63:0] rtc;
wire 			rtc_valid;

wire [3:0]	snd_enable;
wire [5:0]	ch_enable;

wire 			LO_RAM_word_wr;
wire [16:0]	LO_RAM_word_addr;
wire [7:0]	LO_RAM_word_data;
wire [7:0]	LO_RAM_word_q;

wire [15:0]		backup_ram_addr;
wire [31:0]		backup_ram_dout;
wire 				backup_ram_wr;
wire [31:0]		backup_ram_din;

wire SYSTEM_MVS = SYSTEM_TYPE;
wire SYSTEM_CDx = 1'b0;

wire [23:0] P2ROM_MASK; 
wire [25:0] CROM_MASK;
wire [23:0] V1ROM_MASK; 
wire [18:0] MROM_MASK;
wire [23:0]	V2_offset;
wire [18:0] SROM_MASK;

wire 			start_system;

wire [31:0]	screen_x_pos;
wire [31:0]	screen_y_pos;
wire [2:0]	APF_Video_ratio;
wire [23:0] V2ROM_MASK;
wire [2:0]  C1_wait;

apf_io apf_io
(
	.clk_74a						(clk_74a),
	.clk_sys						(clk_sys),
	.debug_button				(debug_button),
	.debug_led					(debug_led),
	
	.bridge_1wire				(bridge_1wire),
	
	.bridge_spimosi			(bridge_spimosi),
	.bridge_spimiso			(bridge_spimiso),
	.bridge_spiclk				(bridge_spiclk),
	.bridge_spiss				(bridge_spiss),

	.EXT_BUS						(),
	.reset_l_main				(reset_l_main),
	.locked_1					(locked_1),
	.locked_2					(locked_1),

	.joystick_0					(joystick_0), 
	.joystick_1					(joystick_1),
	.spinner_0					(spinner_0), 
	.spinner_1					(spinner_1),
	.ps2_mouse					(ps2_mouse),
	.ps2_key						(ps2_key),

	.start_system				(start_system),
	.rtc_time_bcd				(rtc[31:0]),
	.rtc_date_bcd				(rtc[63:32]),
	.rtc_valid					(rtc_valid),
	.DIPSW						(DIPSW),
	.SYSTEM_TYPE				(SYSTEM_TYPE),
	.memory_card_enable		(memory_card_enable),
	.use_mouse_reg				(use_mouse_reg),
	.video_mode					(video_mode),
	.APF_Video_ratio			(APF_Video_ratio),
	.snd_enable					(snd_enable),
	.ch_enable					(ch_enable),
	
	.cart_pchip					(cart_pchip),
	.use_pcm						(use_pcm),
	.cart_chip					(cart_chip),
	.cmc_chip					(cmc_chip),

	
	.P2ROM_MASK					(P2ROM_MASK), 
	.CROM_MASK					(CROM_MASK), 
	.SROM_MASK					(SROM_MASK),
	.V1ROM_MASK					(V1ROM_MASK), 
	.MROM_MASK					(MROM_MASK),
	.V2_offset					(V2_offset),
	.V2ROM_MASK					(V2ROM_MASK),
	.C1_wait						(C1_wait),
	
	.sdram_word_rd				(sdram_word_rd),
	.sdram_word_wr				(sdram_word_wr),
	.sdram_word_addr			(sdram_word_addr),
	.sdram_word_data			(sdram_word_data),
	.sdram_word_q				(sdram_word_q),
	.sdram_word_busy			(sdram_word_busy),	
	
	.sram_word_rd				(sram_word_rd),
	.sram_word_wr				(sram_word_wr),
	.sram_word_addr			(sram_word_addr),
	.sram_word_data			(sram_word_data),
	.sram_word_q				(sram_word_q),
	.sram_word_busy			(sram_word_busy),
	
	.cram0_word_rd				(cram0_word_rd),
	.cram0_word_wr				(cram0_word_wr),
	.cram0_word_32bit			(cram0_word_32bit),
	.cram0_word_addr			(cram0_word_addr),
	.cram0_word_data			(cram0_word_data),
	.cram0_word_q				(cram0_word_q),
	.cram0_word_busy			(cram0_word_busy),
	
	.cram1_word_rd				(cram1_word_rd),
	.cram1_word_wr				(cram1_word_wr),
	.cram1_word_addr			(cram1_word_addr),
	.cram1_word_data			(cram1_word_data),
	.cram1_word_q				(cram1_word_q),
	.cram1_word_busy			(cram1_word_busy),
	
	.LO_RAM_word_wr			(LO_RAM_word_wr),
	.LO_RAM_word_addr			(LO_RAM_word_addr),
	.LO_RAM_word_data			(LO_RAM_word_data),
	.LO_RAM_word_q				(LO_RAM_word_q),
	
	.neogeo_memcard_addr		(neogeo_memcard_addr),
	.neogeo_memcard_wr		(neogeo_memcard_wr),
	.neogeo_memcard_dout		(neogeo_memcard_dout),
	.neogeo_memcard_din		(neogeo_memcard_din),
	.backup_ram_addr			(backup_ram_addr),
	.backup_ram_dout			(backup_ram_dout),
	.backup_ram_wr				(backup_ram_wr),
	.backup_ram_din			(backup_ram_din),
	
	.screen_x_pos				(screen_x_pos),
	.screen_y_pos				(screen_y_pos)

);

//////////////////   Her Majesty   ///////////////////

wire [31:0] cfg;
wire [15:0] snd_right;
wire [15:0] snd_left;

wire nRESETP, nSYSTEM, CARD_WE, SHADOW, nVEC, nREGEN, nSRAMWEN, PALBNK;
wire CD_nRESET_Z80;


// 68k stuff
wire [15:0] M68K_DATA;
wire [23:1] M68K_ADDR;
wire A22Z, A23Z;
wire M68K_RW, nAS, nLDS, nUDS, nDTACK, nHALT, nBR, nBG, nBGACK;
wire [15:0] M68K_DATA_BYTE_MASK;
wire [15:0] FX68K_DATAIN;
wire [15:0] FX68K_DATAOUT;
wire IPL0, IPL1;
wire FC0, FC1, FC2;
reg [3:0] P_BANK;

// RTC stuff
wire RTC_DOUT, RTC_DIN, RTC_CLK, RTC_STROBE, RTC_TP;

// OEs and WEs
wire nSROMOEL, nSROMOEU, nSROMOE;
wire nROMOEL, nROMOEU;
wire nPORTOEL, nPORTOEU, nPORTWEL, nPORTWEU, nPORTADRS;
wire nSRAMOEL, nSRAMOEU, nSRAMWEL, nSRAMWEU;
wire nWRL, nWRU, nWWL, nWWU;
wire nLSPOE, nLSPWE;
wire nPAL, nPAL_WE;
wire nBITW0, nBITW1, nBITWD0, nDIPRD0, nDIPRD1;
wire nSDROE, nSDPOE;


// Memory card stuff
wire [23:0] CDA;
wire [2:0] BNK;
wire [7:0] CDD;
wire nCD1, nCD2;
wire nCRDO, nCRDW, nCRDC;
wire nCARDWEN, CARDWENB;

// Z80 stuff
wire [7:0] SDD_IN;
wire [7:0] SDD_OUT;
wire [7:0] SDD_RD_C1;
wire [15:0] SDA;
wire nSDRD, nSDWR, nMREQ, nIORQ;
wire nZ80INT, nZ80NMI, nSDW, nSDZ80R, nSDZ80W, nSDZ80CLR;
wire nSDROM, nSDMRD, nSDMWR, SDRD0, SDRD1, nZRAMCS;
wire n2610CS, n2610RD, n2610WR;

// Graphics stuff
wire [23:0] PBUS;
wire [7:0] LO_ROM_DATA;
wire nPBUS_OUT_EN;

wire [19:0] C_LATCH;
reg   [3:0] C_LATCH_EXT;
wire [63:0] CR_DOUBLE;
wire [23:0] CROM_ADDR;

wire [1:0] FIX_BANK;
wire [15:0] S_LATCH;
wire [7:0] FIXD;
wire [10:0] FIXMAP_ADDR;

wire CWE, BWE, BOE;

wire [14:0] SLOW_VRAM_ADDR;
reg [15:0] SLOW_VRAM_DATA_IN;
wire [15:0] SLOW_VRAM_DATA_OUT;

wire [10:0] FAST_VRAM_ADDR;
wire [15:0] FAST_VRAM_DATA_IN;
wire [15:0] FAST_VRAM_DATA_OUT;

wire [11:0] PAL_RAM_ADDR;
wire [15:0] PAL_RAM_DATA;
reg [15:0] PAL_RAM_REG;

wire PCK1, PCK2, EVEN1, EVEN2, LOAD, H;
wire DOTA, DOTB;
wire CA4, S1H1, S2H1;
wire CHBL, nBNKB, VCS;
wire CHG, LD1, LD2, SS1, SS2;
wire [3:0] GAD;
wire [3:0] GBD;
wire [3:0] WE;
wire [3:0] CK;

wire CD_VIDEO_EN, CD_FIX_EN, CD_SPR_EN;

// SDRAM multiplexing stuff
wire [15:0] SROM_DATA;
wire [15:0] PROM_DATA;

// Memory card and backup ram image save/load

reg sram_slot_we;
always @(posedge clk_sys) begin
	sram_slot_we <= 0;
	if(~nBWL | ~nBWU) begin
		sram_slot_we <= (M68K_ADDR[15:1] >= 'h190 && M68K_ADDR[15:1] < 'h4190);
	end
end


wire nROMOE = nROMOEL & nROMOEU;
wire nPORTOE = nPORTOEL & nPORTOEU;


/*******************************************************************

	68K and Z80 Ram controller using CRAM and sram core 0


*******************************************************************/
wire PROM_DATA_READY;

wire [15:0] neogeo_memcard_addr;
wire 			neogeo_memcard_wr;
wire [31:0] neogeo_memcard_dout;
wire [31:0] neogeo_memcard_din;

wire 			z80rd_req, z80_ready;

// RAM outputs
wire [15:0] backup_data;
wire [15:0] WORK_RAM;

// Backup RAM
wire nBWL = nSRAMWEL | nSRAMWEN_G;
wire nBWU = nSRAMWEU | nSRAMWEN_G;

SRAM_CONTROLLER_NEOGEO SRAM_CONTROLLER_NEOGEO (

	.clk				(CLK_24M),
	.reset_n			(nRESET),
	
	.sram_a			(sram_a),
	.sram_dq			(sram_dq),
	.sram_oe_n		(sram_oe_n),
	.sram_we_n		(sram_we_n),
	.sram_ub_n		(sram_ub_n),
	.sram_lb_n		(sram_lb_n),
	
	.M68K_ADDR_RAM	({M68K_ADDR_RAM[15:1], 1'b0}),
	.M68K_DATA_RAM	(M68K_DATA_RAM),
	.SRAM_OUT		(WORK_RAM),
	.nWRL				(nWRL),
	.nWRU				(nWRU),
	.sram_nWWL		(sram_nWWL),
	.sram_nWWU		(sram_nWWU)

);

// 68k work RAM
//dpram #(15) WRAML(
//	.clock_a(CLK_24M),
//	.address_a(M68K_ADDR[15:1]),
//	.data_a(M68K_DATA[7:0]),
//	.wren_a(~nWWL),
//	.q_a(WORK_RAM[7:0]),
//
//	.clock_b(CLK_24M),
//	.address_b(reset_counter),
//	.data_b(reset_counter[7:0]),
//	.wren_b(~nRESET)
//);
//
//dpram #(15) WRAMU(
//	.clock_a(CLK_24M),
//	.address_a(M68K_ADDR[15:1]),
//	.data_a(M68K_DATA[15:8]),
//	.wren_a(~nWWU),
//	.q_a(WORK_RAM[15:8]),
//
//	.clock_b(CLK_24M),
//	.address_b(reset_counter),
//	.data_b(reset_counter[7:0]),
//	.wren_b(~nRESET)
//);



// Work RAM or CD extended RAM read
assign M68K_DATA[7:0]  = nWRL ? 8'bzzzzzzzz : WORK_RAM[7:0];
assign M68K_DATA[15:8] = nWRU ? 8'bzzzzzzzz : WORK_RAM[15:8];

//wire nDTACK_ADJ = ~&{nSROMOE, nROMOE, nPORTOE} ? ~PROM_DATA_READY | nDTACK : nDTACK;

reg nDTACK_ADJ;

always @* begin
	casez (~&{nSROMOE, nROMOE, nPORTOE})
		'b1 : nDTACK_ADJ <= ~PROM_DATA_READY | nDTACK;
		default : nDTACK_ADJ <= nDTACK; // Normal
	
	endcase
end

wire sram_nWWL = nWWL;
wire sram_nWWU = nWWU;

wire [15:0]	M68K_DATA_RAM = M68K_DATA;
wire [20:1] M68K_ADDR_RAM = M68K_ADDR;

backup BACKUP(
	.CLK_24M(CLK_24M),
	.M68K_ADDR({M68K_ADDR[15:1], 1'b0}),
	.M68K_DATA(M68K_DATA),
	.nBWL(nBWL), .nBWU(nBWU),
	.SRAM_OUT(backup_data),
	.clk_sys(clk_74a),
	.sram_addr(backup_ram_addr[15:0]),
	.sram_wr(backup_ram_wr),
	.sd_buff_dout(backup_ram_dout),
	.sd_buff_din_sram(backup_ram_din)
);

assign M68K_DATA[7:0]  = (nSRAMOEL | ~SYSTEM_MVS) ? 8'bzzzzzzzz : backup_data[7:0];
assign M68K_DATA[15:8] = (nSRAMOEU | ~SYSTEM_MVS) ? 8'bzzzzzzzz : backup_data[15:8];

cram_16bit CPU68K_z80_RAM_CONTROLLER(
	.reset_l_main		(reset_l_main),
	.nRESET				(nRESET_WD),
	.sys_clk				(clk_sys),
	.cram_clock			(clk_sys), // We will speed this up :-)
	
	.cram_a				(cram0_a),
	.cram_dq				(cram0_dq),
	.cram_wait			(cram0_wait),
	.cram_clk			(cram0_clk),
	.cram_adv_n			(cram0_adv_n),
	.cram_cre			(cram0_cre),
	.cram_ce0_n			(cram0_ce0_n),
	.cram_ce1_n			(cram0_ce1_n),
	.cram_oe_n			(cram0_oe_n),
	.cram_we_n			(cram0_we_n),
	.cram_ub_n			(cram0_ub_n),
	.cram_lb_n			(cram0_lb_n),
	
	.word_rd				(cram0_word_rd),
	.word_wr				(cram0_word_wr),
	.word_32bit			(cram0_word_32bit),
	.word_addr			(cram0_word_addr),
	.word_data			(cram0_word_data),
	.word_q				(cram0_word_q),
	.word_busy			(cram0_word_busy),
	
	.nSYSTEM_G			(nSYSTEM_G),
	.SROM_MASK			(SROM_MASK),
	.PBUS					(PBUS[15:0]),
	.PCK2					(PCK2),
	.FIX_BANK			(FIX_BANK),
	.SROM_DATA			(SROM_DATA),	
	
	.M68K_ADDR			(M68K_ADDR_RAM),
	.M68K_DATA			(M68K_DATA_RAM),
	.nAS					(nAS | (FC1 == FC0)),
	.nLDS					(nLDS),
	.nUDS					(nUDS),
	.nROMOE				(nROMOE),
	.nPORTOE				(nPORTOE),
	.nSROMOE				(nSROMOE),
	.DATA_TYPE			(~FC1 & FC0), // 0 - program, 1 - data, 
	.P2ROM_ADDR			(P2ROM_ADDR & P2ROM_MASK),
	.PROM_DATA			(PROM_DATA),
	.PROM_DATA_READY	(PROM_DATA_READY),
	// Z80 Core
	.z80_clk				(CLK_4M),
	.z80_rdaddr			({MA & MROM_MASK[18:11],SDA[10:0]}),
	.z80_dout			(M1_ROM_DATA),
	.z80_nSDMRD			(nSDMRD),
	.z80_nSDROM			(nSDROM),
	.z80_ready			(z80_ready)
);

wire SDRAM_WR;
wire SDRAM_RD;
wire SDRAM_BURST;
wire [1:0] SDRAM_BS;
wire sdr2_en;

Graphics_MUX Graphics_MUX(
	.CLK					(clk_sys),
	.sdram_clk			(sdram_int_clk),
	.nRESET				(nRESET),

	.PCK1					(PCK1),
	.CROM_ADDR			(PBUS[23:0]),
	.CROM_MASK			(CROM_MASK),
	.CR_DOUBLE			(CR_DOUBLE),

	.burst_rd			(sdram_burst_rd ),
	.burst_addr			(sdram_burst_addr ),
	.burst_len			(sdram_burst_len ),
	.burst_32bit		(sdram_burst_32bit ),
	.burst_data			(sdram_burst_data ),
	.burst_data_valid	(sdram_burst_data_valid ),
	.burst_data_done	(sdram_burst_data_done )
	
);

io_sdram io_sdram (
	.controller_clk 	(sdram_int_clk),
	.chip_clk			(sdram_int_clk),
	.clk_90				(sdram_int_clk),
	.clk_74a				(clk_74a),
	.reset_n				(reset_l_main && locked_1), // We want this to run once the PLL is running
	
	.phy_cke				(SDRAM_CKE ),
	.phy_clk				(SDRAM_CLK ),
	.phy_cas				(SDRAM_nCAS ),
	.phy_ras				(SDRAM_nRAS ),
	.phy_we				(SDRAM_nWE ),
	.phy_ba				(SDRAM_BA ),
	.phy_a				(SDRAM_A ),
	.phy_dq				(SDRAM_DQ ),
	.phy_dqm				({SDRAM_DQMH, SDRAM_DQML} ),
	// Thisi is for external cores to reg to the SDRAM
	.burst_rd			(sdram_burst_rd),
	.burst_addr			(sdram_burst_addr),
	.burst_len			(sdram_burst_len),
	.burst_32bit		(sdram_burst_32bit),
	.burst_data			(sdram_burst_data),
	.burst_data_valid	(sdram_burst_data_valid),
	.burst_data_done	(sdram_burst_data_done),
	// Thisi is for external cores to write to the SDRAM
	.burstwr				(sdram_burstwr),
	.burstwr_addr		(sdram_burstwr_addr),
	.burstwr_ready		(sdram_burstwr_ready),
	.burstwr_strobe	(sdram_burstwr_strobe),
	.burstwr_data		(sdram_burstwr_data),
	.burstwr_done		(sdram_burstwr_done),
	// Thisi is for IO core to write/read to the SDRAM
	.word_rd				(sdram_word_rd),
	.word_wr				(sdram_word_wr),
	.word_addr			(sdram_word_addr),
	.word_data			(sdram_word_data),
	.word_q				(sdram_word_q),
	.word_busy			(sdram_word_busy),
);

neo_d0 D0(
	.CLK_24M				(CLK_24M),
	.nRESET				(nRESET), 
	.nRESETP				(nRESETP),
	.CLK_12M				(CLK_12M),
	.CLK_68KCLK			(CLK_68KCLK), 
	.CLK_68KCLKB		(CLK_68KCLKB), 
//	.CLK_6MB				(CLK_6MB), 
	.M68K_ADDR_A4		(M68K_ADDR[4]),
	.M68K_DATA			(M68K_DATA[5:0]),
	.nBITWD0				(nBITWD0),
	.SDA_H				(SDA[15:11]), 
	.SDA_L				(SDA[4:2]),
	.nSDRD				(nSDRD),	
	.nSDWR				(nSDWR), 
	.nMREQ				(nMREQ),	
	.nIORQ				(nIORQ),
	.nZ80NMI				(nZ80NMI),
	.nSDW					(nSDW), 
	.nSDZ80R				(nSDZ80R), 
	.nSDZ80W				(nSDZ80W),	
	.nSDZ80CLR			(nSDZ80CLR),
	.nSDROM				(nSDROM), 
	.nSDMRD				(nSDMRD), 
	.nSDMWR				(nSDMWR), 
	.nZRAMCS				(nZRAMCS),
	.SDRD0				(SDRD0),	
	.SDRD1				(SDRD1),
	.n2610CS				(n2610CS), 
	.n2610RD				(n2610RD), 
	.n2610WR				(n2610WR),
	.BNK					(BNK)
);

// Re-priority-encode the interrupt lines with the CD_IRQ one (IPL* are active-low)
// Also swap IPL0 and IPL1 for CD systems
//                      Cartridge     		CD
// CD_IRQ IPL1 IPL0		IPL2 IPL1 IPL0		IPL2 IPL1 IPL0
//    0     1    1		  1    1    1  	  1    1    1	No IRQ
//    0     1    0        1    1    0		  1    0    1	Vblank
//    0     0    1        1    0    1		  1    1    0  Timer
//    0     0    0        1    0    0		  1    0    0	Cold boot
//    1     x    x        1    1    1  	  0    1    1	CD vectored IRQ
wire IPL0_OUT = IPL0;
wire IPL1_OUT = IPL1;
wire IPL2_OUT = 1'b1;

cpu_68k M68KCPU(
	.CLK_24M			(CLK_24M),
	.nRESET			(nRESET_WD),
	.M68K_ADDR		(M68K_ADDR),
	.FX68K_DATAIN	(FX68K_DATAIN), 
	.FX68K_DATAOUT	(FX68K_DATAOUT),
	.nLDS				(nLDS), 
	.nUDS				(nUDS), 
	.nAS				(nAS), 
	.M68K_RW			(M68K_RW),
	.nDTACK			(nDTACK_ADJ),	// nDTACK
	.IPL2				(IPL2_OUT), 
	.IPL1				(IPL1_OUT), 
	.IPL0				(IPL0_OUT),
	.FC2				(FC2), 
	.FC1				(FC1), 
	.FC0				(FC0),
	.nBG				(nBG), 
	.nBR				(nBR), 
	.nBGACK			(nBGACK)
);

always @(posedge CLK_24M) begin
	if (nRESET_WD) begin
		nBR <= 1;
		nBGACK <= 1;
	end
	else begin
		nBR <= 1;
		nBGACK <= 1;
	end
end

wire IACK = &{FC2, FC1, FC0};

// FX68K doesn't like byte masking with Z's, replace with 0's:
assign M68K_DATA_BYTE_MASK = (~|{nLDS, nUDS}) ? M68K_DATA :
										(~nLDS) ? {8'h00, M68K_DATA[7:0]} :
										(~nUDS) ? {M68K_DATA[15:8], 8'h00} :
										16'h0000;

assign M68K_DATA = M68K_RW ? 16'bzzzzzzzz_zzzzzzzz : FX68K_DATAOUT;
assign FX68K_DATAIN = M68K_RW ? M68K_DATA_BYTE_MASK : 16'h0000;

// Disable ROM read in PORT zone if the game uses a special chip
assign M68K_DATA = (nROMOE & nSROMOE & |{nPORTOE, cart_chip, cart_pchip}) ? 16'bzzzzzzzzzzzzzzzz : PROM_DATA;

wire [23:0] P2ROM_ADDR = (!cart_pchip) ? {P_BANK, M68K_ADDR[19:1], 1'b0} : 24'bZ;

neo_pvc neo_pvc
(
	.nRESET(nRESET),
	.CLK_24M(CLK_24M),
	.ENABLE(cart_pchip == 2),
	.M68K_ADDR(M68K_ADDR),
	.M68K_DATA(M68K_DATA),
	.PROM_DATA(PROM_DATA),
	.nPORTOEL(nPORTOEL),
	.nPORTOEU(nPORTOEU),
	.nPORTWEL(nPORTWEL),
	.nPORTWEU(nPORTWEU),
	.P2_ADDR(P2ROM_ADDR)
);

neo_sma neo_sma
(
	.nRESET(nRESET),
	.CLK_24M(CLK_24M),
	.TYPE(cart_pchip),
	.M68K_ADDR(M68K_ADDR),
	.M68K_DATA(M68K_DATA),
	.PROM_DATA(PROM_DATA),
	.nPORTOEL(nPORTOEL),
	.nPORTOEU(nPORTOEU),
	.nPORTWEL(nPORTWEL),
	.nPORTWEU(nPORTWEU),
	.P2_ADDR(P2ROM_ADDR)
);

// Memory card
assign {nCD1, nCD2} = memory_card_enable;	// Always plugged in CD systems
assign CARD_WE = ((~nCARDWEN & CARDWENB)) & ~nCRDW;



memcard MEMCARD(
	.CLK_24M					(CLK_24M),
	.SYSTEM_CDx				(1'b0),
	.CDA						(CDA), 
	.CDD						(CDD),
	.CARD_WE					(CARD_WE),
	.M68K_DATA				(M68K_DATA[7:0]),
	.clk_sys					(clk_74a),
	.memcard_addr			(neogeo_memcard_addr[15:0]),
	.memcard_wr				(neogeo_memcard_wr),
	.sd_buff_dout			(neogeo_memcard_dout),
	.sd_buff_din_memcard	(neogeo_memcard_din)
);

// Feed save file writer with backup RAM data or memory card data

assign CROM_ADDR = {C_LATCH_EXT, C_LATCH};

zmc ZMC(
	.nRESET(nRESET),
	.nSDRD0(SDRD0),
	.SDA_L(SDA[1:0]), 
	.SDA_U(SDA[15:8]),
	.MA(MA)
);

// Bankswitching for the PORT zone, do all games use a 1MB window ?
// P_BANK stays at 0 for CD systems
always @(posedge nPORTWEL or negedge nRESET)
begin
	if (!nRESET)
		P_BANK <= 0;
	else
		P_BANK <= M68K_DATA[3:0];
end

// PRO-CT0 used as security chip
wire [3:0] GAD_SEC;
wire [3:0] GBD_SEC;

zmc2_dot ZMC2DOT(
	.CLK_12M(nPORTWEL),
	.EVEN(M68K_ADDR[2]), 
	.LOAD(M68K_ADDR[1]), 
	.H(M68K_ADDR[3]),
	.CR({
		M68K_ADDR[19], M68K_ADDR[15], M68K_ADDR[18], M68K_ADDR[14],
		M68K_ADDR[17], M68K_ADDR[13], M68K_ADDR[16], M68K_ADDR[12],
		M68K_ADDR[11], M68K_ADDR[7], M68K_ADDR[10], M68K_ADDR[6],
		M68K_ADDR[9], M68K_ADDR[5], M68K_ADDR[8], M68K_ADDR[4],
		M68K_DATA[15], M68K_DATA[11], M68K_DATA[14], M68K_DATA[10],
		M68K_DATA[13], M68K_DATA[9], M68K_DATA[12], M68K_DATA[8],
		M68K_DATA[7], M68K_DATA[3], M68K_DATA[6], M68K_DATA[2],
		M68K_DATA[5], M68K_DATA[1], M68K_DATA[4], M68K_DATA[0]
		}),
	.GAD(GAD_SEC), 
	.GBD(GBD_SEC)
);	

assign M68K_DATA[7:0] = ((cart_chip == 1) & ~nPORTOEL) ?
								{GBD_SEC[1], GBD_SEC[0], GBD_SEC[3], GBD_SEC[2],
								GAD_SEC[1], GAD_SEC[0], GAD_SEC[3], GAD_SEC[2]} : 8'bzzzzzzzz;

neo_273 NEO273(
	.PBUS(PBUS[19:0]),
	.PCK1B(~PCK1), 
	.PCK2B(~PCK2),
	.S2H1(S2H1),
	.C_LATCH(C_LATCH), 
	.S_LATCH(S_LATCH)
);

// 4 MSBs not handled by NEO-273
always @(negedge PCK1)
	C_LATCH_EXT <= PBUS[23:20];

neo_cmc neo_cmc(
	.PCK2B(~PCK2),
	.PBUS(PBUS[14:0]),
	.TYPE(cmc_chip),
	.ADDR(FIXMAP_ADDR),
	.BANK(FIX_BANK)
);


// Fake COM MCU
wire [15:0] COM_DOUT;

com COM(
	.nRESET(nRESET),
	.CLK_24M(CLK_24M),
	.nPORTOEL(nPORTOEL), 
	.nPORTOEU(nPORTOEU), 
	.nPORTWEL(nPORTWEL),
	.M68K_DIN(COM_DOUT)
);

assign M68K_DATA = (cart_chip == 2) ? COM_DOUT : 16'bzzzzzzzz_zzzzzzzz;

syslatch SL(
	.nRESET(nRESET),
	.CLK_68KCLK(CLK_68KCLK),
	.M68K_ADDR(M68K_ADDR[4:1]),
	.nBITW1(nBITW1),
	.SHADOW(SHADOW), 
	.nVEC(nVEC), 
	.nCARDWEN(nCARDWEN),	
	.CARDWENB(CARDWENB), 
	.nREGEN(nREGEN), 
	.nSYSTEM(nSYSTEM), 
	.nSRAMWEN(nSRAMWEN), 
	.PALBNK(PALBNK)
);

wire nSRAMWEN_G = SYSTEM_MVS ? nSRAMWEN : 1'b1;	// nSRAMWEN is only for MVS
wire nSYSTEM_G = SYSTEM_MVS ? nSYSTEM : 1'b1;	// nSYSTEM is only for MVS

neo_e0 E0(
	.M68K_ADDR(M68K_ADDR[23:1]),
	.BNK(BNK),
	.nSROMOEU(nSROMOEU),	
	.nSROMOEL(nSROMOEL), 
	.nSROMOE(nSROMOE),
	.nVEC(nVEC),
	.A23Z(A23Z), 
	.A22Z(A22Z),
	.CDA(CDA)
);

neo_f0 F0(
	.nRESET(nRESET),
	.nDIPRD0(nDIPRD0), 
	.nDIPRD1(nDIPRD1),
	.nBITW0(nBITW0), 
	.nBITWD0(nBITWD0),
	.DIPSW(DIPSW),
	.COIN1(~joystick_0[9]), .COIN2(~joystick_1[10]),
	.M68K_ADDR(M68K_ADDR[7:4]),
	.M68K_DATA(M68K_DATA[7:0]),
	.SYSTEMB(~nSYSTEM_G),
	.RTC_DOUT(RTC_DOUT), 
	.RTC_TP(RTC_TP), 
	.RTC_DIN(RTC_DIN), 
	.RTC_CLK(RTC_CLK), 
	.RTC_STROBE(RTC_STROBE),
	.SYSTEM_TYPE(SYSTEM_MVS)
);

uPD4990 RTC(
	.clk_74a(clk_74a),
	.rtc(rtc),
	.rtc_valid(rtc_valid),
	.nRESET(nRESET),
	.CLK(CLK_12M),
	.DATA_CLK(RTC_CLK), 
	.STROBE(RTC_STROBE),
	.DATA_IN(RTC_DIN), 
	.DATA_OUT(RTC_DOUT),
	.CS(1'b1), 
	.OE(1'b1),
	.TP(RTC_TP)
);

neo_g0 G0(
	.M68K_DATA(M68K_DATA),
	.G0(nCRDC), 
	.G1(nPAL), 
	.DIR(M68K_RW), 
	.WE(nPAL_WE),
	.CDD({8'hFF, CDD}), 
	.PC(PAL_RAM_DATA)
);

neo_c1 C1(
	.M68K_ADDR	(M68K_ADDR[21:17]),
	.M68K_DATA	(M68K_DATA[15:8]), 
	.A22Z			(A22Z), 
	.A23Z			(A23Z),
	.nLDS			(nLDS), 
	.nUDS			(nUDS), 
	.RW			(M68K_RW), 
	.nAS			(nAS),
	.nROMOEL		(nROMOEL), 
	.nROMOEU		(nROMOEU),
	.nPORTOEL	(nPORTOEL), 
	.nPORTOEU	(nPORTOEU), 
	.nPORTWEL	(nPORTWEL), 
	.nPORTWEU	(nPORTWEU),
	.nPORT_ZONE	(nPORTADRS),
	.nWRL			(nWRL), 
	.nWRU			(nWRU), 
	.nWWL			(nWWL), 
	.nWWU			(nWWU),
	.nSROMOEL	(nSROMOEL), 
	.nSROMOEU	(nSROMOEU),
	.nSRAMOEL	(nSRAMOEL), 
	.nSRAMOEU	(nSRAMOEU), 
	.nSRAMWEL	(nSRAMWEL), 
	.nSRAMWEU	(nSRAMWEU),
	.nLSPOE		(nLSPOE), 
	.nLSPWE		(nLSPWE),
	.nCRDO		(nCRDO), 
	.nCRDW		(nCRDW), 
	.nCRDC		(nCRDC),
	.nSDW			(nSDW),
	.P1_IN(~{(joystick_0[9:8]|ps2_mouse[2]), {use_mouse ? ms_pos : use_sp ? {|{joystick_0[7:4],ps2_mouse[1:0]},sp0} : {joystick_0[7:4]|{3{joystick_0[11]}}, joystick_0[0], joystick_0[1], joystick_0[2], joystick_0[3]}}}),
	.P2_IN(~{ joystick_1[9:8],               {use_mouse ? ms_btn : use_sp ? {|{joystick_1[7:4]},               sp1} : {joystick_1[7:4]|{3{joystick_1[11]}}, joystick_1[0], joystick_1[1], joystick_1[2], joystick_1[3]}}}),
	.nCD1			(nCD1), 
	.nCD2			(nCD2),
	.nWP			(0),			// Memory card is never write-protected
	// Fix by paulb-nl -09/01/2023
	.nROMWAIT	(~C1_wait[2]), 
	.nPWAIT0		(~C1_wait[0]), 
	.nPWAIT1		(~C1_wait[1]), 
	.PDTACK		(1),
	.SDD_WR		(SDD_OUT),
	.SDD_RD		(SDD_RD_C1),
	.nSDZ80R		(nSDZ80R), 
	.nSDZ80W		(nSDZ80W), 
	.nSDZ80CLR	(nSDZ80CLR),
	.CLK_68KCLK	(CLK_68KCLK),
	.nDTACK		(nDTACK),
	.nBITW0		(nBITW0), 
	.nBITW1		(nBITW1),
	.nDIPRD0		(nDIPRD0), 
	.nDIPRD1		(nDIPRD1),
	.nPAL_ZONE	(nPAL),
	.SYSTEM_TYPE({1'b0,SYSTEM_TYPE})
);

reg       use_sp;
reg [6:0] sp0, sp1;
always @(posedge clk_sys) begin
	reg old_sp0, old_sp1, old_ms;

	old_sp0 <= spinner_0[8];
	if(old_sp0 ^ spinner_0[8]) sp0 <= sp0 - spinner_0[6:0];
	
	old_ms <= ps2_mouse[24];
	if(old_ms ^ ps2_mouse[24]) sp0 <= sp0 - ps2_mouse[14:8];

	old_sp1 <= spinner_1[8];
	if(old_sp1 ^ spinner_1[8]) sp1 <= sp1 - spinner_1[6:0];

	if(use_mouse_reg[1]) use_sp <= 1;
	else if(use_mouse_reg[0]) use_sp <= 0;
	else begin
		if((old_sp0 ^ spinner_0[8]) || (old_sp1 ^ spinner_1[8]) || (old_ms ^ ps2_mouse[24])) use_sp <= 1;
		if(joystick_0[3:0] || joystick_1[3:0]) use_sp <= 0;
	end
end

wire       use_mouse = use_mouse_reg;

reg        ms_xy;
reg  [7:0] ms_x, ms_y;
wire [7:0] ms_pos = ms_xy ? ms_y : ms_x;
wire [7:0] ms_btn = {2'b00, ps2_mouse[1:0], 4'b0000};

always @(posedge clk_sys) begin
	reg old_ms;

	if(!nBITW0 && !M68K_ADDR[6:3]) ms_xy <= M68K_DATA[0];

	old_ms <= ps2_mouse[24];
	if(old_ms ^ ps2_mouse[24]) begin
		ms_x <= ms_x + ps2_mouse[15:8];
		ms_y <= ms_y - ps2_mouse[23:16];
	end
end

// This is used to split burst-read sprite gfx data in half at the right time
reg LOAD_SR;
reg CA4_REG;

always @(posedge CLK_24M) begin
	LOAD_SR <= LOAD;
	if (~LOAD_SR & LOAD) CA4_REG <= CA4;
end

// Had to change this for how assets are stored in the SDRAM
wire [31:0] CR = CA4_REG ?  {CR_DOUBLE[47:32], CR_DOUBLE[15:0] } : {CR_DOUBLE[63:48], CR_DOUBLE[31:16]};

neo_zmc2 ZMC2(
	.CLK_12M(CLK_12MB),
	.EVEN(EVEN1), 
	.LOAD(LOAD), 
	.H(H),
	.CR(CR),
	.GAD(GAD), 
	.GBD(GBD),
	.DOTA(DOTA), 
	.DOTB(DOTB)
);


dpram #(16, 8)  LO_RAM(
	.clock_a		(clk_sys),
	.address_a	(LO_RAM_word_addr[16:0]),
	.data_a		(LO_RAM_word_data),
	.wren_a		(LO_RAM_word_wr),
	.q_a			(LO_RAM_word_q),
	.clock_b		(CLK_24M),
	.address_b	({1'b0,PBUS[15:0]}),
	.ce_b			(1'b1),
	.q_b			(LO_ROM_DATA)
);


// VCS is normally used as the LO ROM's nOE but the NeoGeo relies on the fact that the LO ROM
// will still have its output active for a short moment (~50ns) after nOE goes high
// nPBUS_OUT_EN is used internally by LSPC2 but it's broken out here to use the additional
// half mclk cycle it provides compared to VCS. This makes sure LO_ROM_DATA is valid when latched.
assign PBUS[23:16] = nPBUS_OUT_EN ? LO_ROM_DATA : 8'bzzzzzzzz;

spram #(11,16) UFV(
	.clock		(CLK_24M),	//~CLK_24M,		// Is just CLK ok ?
	.address		(FAST_VRAM_ADDR),
	.data			(FAST_VRAM_DATA_OUT),
	.wren			(~CWE),
	.q				(FAST_VRAM_DATA_IN)
);

spram #(15,16) USV(
	.clock		(CLK_24M),	//~CLK_24M,		// Is just CLK ok ?
	.address		(SLOW_VRAM_ADDR),
	.data			(SLOW_VRAM_DATA_OUT),
	.wren			(~BWE),
	.q				(SLOW_VRAM_DATA_IN)
);

wire [18:11] MA;
wire [7:0] Z80_RAM_DATA;

spram #(11) Z80RAM(
	.clock		(CLK_4M), 
	.address		(SDA[10:0]), 
	.data			(SDD_OUT), 
	.wren			(~(nZRAMCS | nSDMWR)), 
	.q				(Z80_RAM_DATA));	// Fast enough ?

assign SDD_IN = 	(~nSDZ80R) ? SDD_RD_C1 :
						(~nSDMRD & ~nSDROM) ? M1_ROM_DATA :
						(~nSDMRD & ~nZRAMCS) ? Z80_RAM_DATA :
						(~n2610CS & ~n2610RD) ? YM2610_DOUT :
						8'b00000000;

wire Z80_nRESET = nRESET_WD;

wire [7:0] M1_ROM_DATA;


cpu_z80 Z80CPU(
	.CLK_4M	(CLK_4M),
	.nRESET	(Z80_nRESET),
	.SDA		(SDA), 
	.SDD_IN	(SDD_IN), 
	.SDD_OUT	(SDD_OUT),
	.nIORQ	(nIORQ),	
	.nMREQ	(nMREQ),	
	.nRD		(nSDRD), 
	.nWR		(nSDWR),
	.nINT		(nZ80INT), 
	.nNMI		(nZ80NMI), 
	.nWAIT	(z80_ready)
);

wire [19:0] ADPCMA_ADDR;
wire [3:0]  ADPCMA_BANK;
wire [23:0] ADPCMB_ADDR;

// CRAM access that is 8bits per channel

cram_8bit voice_samples_8bit(
	.reset_l_main		(reset_l_main),
	.nRESET				(nRESET_WD),
	.sys_clk				(clk_sys),
	.cram_a				(cram1_a),
	.cram_dq				(cram1_dq),
	.cram_wait			(cram1_wait),
	.cram_clk			(cram1_clk),
	.cram_adv_n			(cram1_adv_n),
	.cram_cre			(cram1_cre),
	.cram_ce0_n			(cram1_ce0_n),
	.cram_ce1_n			(cram1_ce1_n),
	.cram_oe_n			(cram1_oe_n),
	.cram_we_n			(cram1_we_n),
	.cram_ub_n			(cram1_ub_n),
	.cram_lb_n			(cram1_lb_n),
	
	.word_rd				(cram1_word_rd),
	.word_wr				(cram1_word_wr),
	.word_addr			(cram1_word_addr),
	.word_data			(cram1_word_data),
	.word_q				(cram1_word_q),
	.word_busy			(cram1_word_busy),
	
	.clk_8M				(CLK_8M),
	
	.rdaddr1				(ADPCMA_ADDR_LATCH),
	.ADPCMA_DATA		(ADPCMA_DATA),
	.ADPCMA_READ_REQ	(ADPCMA_READ_REQ),
	.ADPCMA_READ_ACK	(ADPCMA_READ_ACK),

	.rdaddr2				(ADPCMB_ADDR_LATCH),
	.ADPCMB_DATA		(ADPCMB_DATA),
	.ADPCMB_READ_REQ	(ADPCMB_READ_REQ),
	.ADPCMB_READ_ACK	(ADPCMB_READ_ACK)
);


// The  request and ack signals work on either edge
// To trigger a read request, just set adpcm_rd to ~adpcm_rdack

reg ADPCMA_READ_REQ, ADPCMB_READ_REQ;
reg ADPCMA_READ_ACK, ADPCMB_READ_ACK;
reg [23:0] ADPCMA_ADDR_LATCH;	// 16MB
reg [23:0] ADPCMB_ADDR_LATCH;	// 16MB
reg [7:0] ADPCMA_ACK_COUNTER;
reg [10:0] ADPCMB_ACK_COUNTER;
reg 			ADPCMA_COUNTER_ZERO;
reg 			ADPCMB_COUNTER_ZERO;
wire ADPCMA_DATA_READY = ~((ADPCMA_READ_REQ ^ ADPCMA_READ_ACK) & ADPCMA_COUNTER_ZERO);
wire ADPCMB_DATA_READY = ~((ADPCMB_READ_REQ ^ ADPCMB_READ_ACK) & ADPCMB_COUNTER_ZERO);
reg [1:0] ADPCMA_OE_SR;
reg [1:0] ADPCMB_OE_SR;
always @(posedge clk_sys or negedge nRESET) begin
	if (~nRESET) begin
		ADPCMA_OE_SR <= 'b0;
		ADPCMB_OE_SR <= 'b0;
		ADPCMA_READ_REQ <= 'b0;
		ADPCMB_READ_REQ <= 'b0;
		ADPCMA_ADDR_LATCH <= 'b0;
		ADPCMB_ADDR_LATCH <= 'b0;
		ADPCMA_ACK_COUNTER <= 8'd127; 
		ADPCMB_ACK_COUNTER <= 11'd1579; 
		ADPCMA_COUNTER_ZERO	<= 'd1;
		ADPCMB_COUNTER_ZERO	<= 'd1;
	end
	else begin
		ADPCMA_OE_SR <= {ADPCMA_OE_SR[0], nSDROE};
		ADPCMA_ACK_COUNTER <= ADPCMA_ACK_COUNTER == 8'd0 ? 8'd0 : ADPCMA_ACK_COUNTER - 8'd1;
		ADPCMB_ACK_COUNTER <= ADPCMB_ACK_COUNTER == 11'd0 ? 11'd0 : ADPCMB_ACK_COUNTER - 11'd1;
		//
		ADPCMA_COUNTER_ZERO = (ADPCMA_ACK_COUNTER == 8'd0);
		ADPCMB_COUNTER_ZERO = (ADPCMB_ACK_COUNTER == 11'd0);
		
		// Trigger ADPCM A data read on nSDROE falling edge
		if (ADPCMA_OE_SR == 2'b10) begin
			ADPCMA_READ_REQ <= ~ADPCMA_READ_REQ;
			ADPCMA_ADDR_LATCH <= {ADPCMA_BANK[3:0], ADPCMA_ADDR} & V1ROM_MASK[23:0];
// Data is needed on one previous 8MHz clk before next 666KHz clock->(96MHz/666KHz = 144)-12-4=128
// We do not require these for the Darksoft roms once we get the chip32 this will move things correcly
			ADPCMA_ACK_COUNTER <= 8'd127;
//			ADPCMA_DATA_READY	<= 1'b0;
		end
		
		// Trigger ADPCM A data read on nSDPOE falling edge
		ADPCMB_OE_SR <= {ADPCMB_OE_SR[0], nSDPOE};
		if (ADPCMB_OE_SR == 2'b10) begin
			ADPCMB_READ_REQ <= ~ADPCMB_READ_REQ;
//			ADPCMB_ADDR_LATCH <= use_pcm ? {1'b1, ADPCMB_ADDR[22:0] & V1ROM_MASK[22:0]} : ADPCMB_ADDR[23:0] & V1ROM_MASK[23:0];
// We do not require these for the Darksoft roms once we get the chip32 this will move things correcly
			ADPCMB_ADDR_LATCH <= use_pcm ? (ADPCMB_ADDR[23:0] & V2ROM_MASK[23:0]) + V2_offset  : ADPCMB_ADDR[23:0]  & V1ROM_MASK[23:0];
			// Data is needed on one previous 8MHz clk before next 55KHz clock->(96MHz/55KHz = 1728)-144-4=1580
			ADPCMB_ACK_COUNTER <= 11'd1579;
//			ADPCMB_DATA_READY	<= 1'b0;
		end
	end
end

wire [7:0] ADPCMA_DATA;
wire [7:0] ADPCMB_DATA;
wire [7:0] YM2610_DOUT;

jt10 YM2610(
	.rst					(~nRESET_WD),
	.clk					(CLK_8M), 
	.cen					(&{ADPCMA_DATA_READY, ADPCMB_DATA_READY}),
	.addr					(SDA[1:0]),
	.din					(SDD_OUT), 
	.dout					(YM2610_DOUT),
	.cs_n					(n2610CS), 
	.wr_n					(n2610WR),
	.irq_n				(nZ80INT),
	.adpcma_addr		(ADPCMA_ADDR), 
	.adpcma_bank		(ADPCMA_BANK), 
	.adpcma_roe_n		(nSDROE), 
	.adpcma_data		(ADPCMA_DATA),
	.adpcmb_addr		(ADPCMB_ADDR), 
	.adpcmb_roe_n		(nSDPOE), 
	.adpcmb_data		(ADPCMB_DATA),	// CD has no ADPCM-B
	.snd_right			(snd_right), 
	.snd_left			(snd_left), 
	.snd_enable			(snd_enable), 
	.ch_enable			(ch_enable)
);

wire DOTA_GATED = DOTA;
wire DOTB_GATED = DOTB;
wire HSync,VSync;

lspc2_a2	LSPC(
	.CLK_24M				(CLK_24M),
	.RESET				(nRESET),
	.nRESETP				(nRESETP),
	.CLK_6MB				(CLK_6MB),
	.CLK_12MB			(CLK_12MB),
//	.LSPC_8M				(CLK_8M), 
//	.LSPC_4M				(CLK_4M),
	.M68K_ADDR			(M68K_ADDR[3:1]), 
	.M68K_DATA			(M68K_DATA),
	.IPL0					(IPL0), 
	.IPL1					(IPL1),
	.LSPOE				(nLSPOE), 
	.LSPWE				(nLSPWE),
	.PBUS_OUT			(PBUS[15:0]), 
	.PBUS_IO				(PBUS[23:16]),
	.nPBUS_OUT_EN		(nPBUS_OUT_EN),
	.DOTA					(DOTA_GATED), 
	.DOTB					(DOTB_GATED),
	.CA4					(CA4), 
	.S2H1					(S2H1), 
	.S1H1					(S1H1),
	.LOAD					(LOAD), 
	.H						(H), 
	.EVEN1				(EVEN1), 
	.EVEN2				(EVEN2),
	.PCK1					(PCK1), 
	.PCK2					(PCK2),
	.CHG					(CHG),
	.LD1					(LD1), 
	.LD2					(LD2),
	.WE					(WE), 
	.CK					(CK),	
	.SS1					(SS1), 
	.SS2					(SS2),
	.HSYNC				(HSync), 
	.VSYNC				(VSync),
	.CHBL					(CHBL), 
	.BNKB					(nBNKB),
	.VCS					(VCS),
	.SVRAM_ADDR			(SLOW_VRAM_ADDR),
	.SVRAM_DATA_IN		(SLOW_VRAM_DATA_IN), 
	.SVRAM_DATA_OUT	(SLOW_VRAM_DATA_OUT),
	.BOE					(BOE), 
	.BWE					(BWE),
	.FVRAM_ADDR			(FAST_VRAM_ADDR),
	.FVRAM_DATA_IN		(FAST_VRAM_DATA_IN), 
	.FVRAM_DATA_OUT	(FAST_VRAM_DATA_OUT),
	.CWE					(CWE),
	.VMODE				(video_mode),
	.FIXMAP_ADDR		(FIXMAP_ADDR)	// Extracted for NEO-CMC
);

wire nRESET_WD;
neo_b1 B1(
	.CLK				(CLK_24M),	
	.CLK_6MB			(CLK_6MB), 
	.nRESETP			(nRESETP),
	.S1H1				(S1H1),
	.S2H1				(S2H1),
	.A23I				(A23Z), 
	.A22I				(A22Z),
	.M68K_ADDR_U	(M68K_ADDR[21:17]), 
	.M68K_ADDR_L	(M68K_ADDR[12:1]),
	.nLDS				(nLDS), 
	.RW				(M68K_RW), 
	.nAS				(nAS),
	.PBUS				(PBUS),
	.FIXD				(SROM_DATA),
	.PCK1				(PCK1), 
	.PCK2				(PCK2),
	.CHBL				(CHBL), 
	.BNKB				(nBNKB),
	.GAD				(GAD), 
	.GBD				(GBD),
	.WE				(WE), 
	.CK				(CK),
	.TMS0				(CHG), 
	.LD1				(LD1), 
	.LD2				(LD2), 
	.SS1				(SS1), 
	.SS2				(SS2),
	.PA				(PAL_RAM_ADDR),
	.EN_FIX			(FIX_EN),
	.nRST				(nRESET),
	.nRESET			(nRESET_WD),
	.pixel_mux_change	(pixel_mux_change)
);


wire [15:0] PAL_RAM_DATA_WIRE;

dpram #(13,16)  PALRAM(
	.clock_a		(CLK_24M),
	.address_a	({PALBNK, PAL_RAM_ADDR}),
	.data_a		(M68K_DATA),
	.wren_a		(~nPAL_WE),
	.q_a			(PAL_RAM_DATA),
	.clock_b		(CLK_VIDEO),
	.address_b	({PALBNK, PAL_RAM_ADDR}),
	.ce_b			(1'b1),
	.q_b			(PAL_RAM_DATA_WIRE)
);



reg [15:0] PAL_RAM_DATA_reg;

always @(posedge CLK_VIDEO) begin
	PAL_RAM_DATA_reg <= (x_count >= 8 + 6 && x_count < 320 + 6 + 28) ? PAL_RAM_DATA_WIRE : 16'h8000;
end

wire [6:0] R6 = {1'b0, PAL_RAM_DATA_reg[11:8], PAL_RAM_DATA_reg[14], PAL_RAM_DATA_reg[11]} - PAL_RAM_DATA_reg[15];
wire [6:0] G6 = {1'b0, PAL_RAM_DATA_reg[7:4],  PAL_RAM_DATA_reg[13], PAL_RAM_DATA_reg[7] } - PAL_RAM_DATA_reg[15];
wire [6:0] B6 = {1'b0, PAL_RAM_DATA_reg[3:0],  PAL_RAM_DATA_reg[12], PAL_RAM_DATA_reg[3] } - PAL_RAM_DATA_reg[15];

wire [7:0] VGA_R_wire = R6[6] ? 8'd0 : {R6[5:0],  R6[4:3]};
wire [7:0] VGA_G_wire = G6[6] ? 8'd0 : {G6[5:0],  G6[4:3]};
wire [7:0] VGA_B_wire = B6[6] ? 8'd0 : {B6[5:0],  B6[4:3]};

/*******************************************************************

	Here is the video output core for the Analogue Pocket
	We can send out the native signal at 6mhz.
	
	We will run this at the system clock at 24mhz as we do
	need to make a 6mhz offset of 90degrees. We can do this in
	the clock reg

*******************************************************************/

	localparam		VID_H_BPORCH_SD = 10'd38;
	localparam		VID_H_BPORCH_HD = 10'd30;
	localparam		VID_H_ACTIVE = 10'd304;
	localparam		VID_H_ACTIVE_HD = 10'd320;
   localparam		VID_V_ACTIVE = 10'd224;
	localparam		VID_V_BPORCH_NTSC = 10'd16;
	localparam		VID_V_BPORCH_PAL = 10'd43;
	
	reg [9:0] x_count, y_count;
	reg HSync_reg;
	reg VSync_reg;
	reg [9:0] VID_H_ACTIVE_REG;
	reg [9:0] VID_V_BPORCH;
	reg [9:0] VID_H_BPORCH;
	
	reg [2:0] res_reg;
	reg video_mode_reg;
	
reg [7:0]	VGA_R_reg;
reg [7:0]	VGA_G_reg;
reg [7:0]	VGA_B_reg;
	
always @(posedge CLK_VIDEO) begin
	VGA_DE <= 0;
	VGA_R <= 8'h0;
	VGA_G <= 8'h0;
	VGA_B <= 8'h0; // This is where we change the scaler between both pal to ntsc Will work on this shortly
	VGA_HS <= 0;
	HSync_reg <= HSync;
	VSync_reg <= VSync;
	VGA_VS <= 0;
	
	
	if (HSync_reg && ~HSync) x_count <= 'd0;
	else x_count <= x_count + 1'b1;
	
	if (VSync_reg && ~VSync) begin
		y_count <= 'b0;
		VGA_VS <= 1;
		VID_V_BPORCH <= (video_mode_reg ? VID_V_BPORCH_PAL : VID_V_BPORCH_NTSC) + screen_y_pos;
		VID_H_BPORCH <= APF_Video_ratio[2] ? VID_H_BPORCH_HD - screen_x_pos : VID_H_BPORCH_SD - screen_x_pos;
	end
	else if (HSync_reg && ~HSync)	begin
		y_count <= y_count + 1'b1;
		res_reg <= APF_Video_ratio; 
		video_mode_reg <= video_mode;
		VID_H_ACTIVE_REG <= APF_Video_ratio[2] ? VID_H_ACTIVE_HD : VID_H_ACTIVE;
		VGA_HS <= 1;
	end
	
	// inactive screen areas are black
	VGA_R_reg <= ~SHADOW ? VGA_R_wire : {1'b0, VGA_R_wire[7:1]};
	VGA_G_reg <= ~SHADOW ? VGA_G_wire : {1'b0, VGA_G_wire[7:1]};
	VGA_B_reg <= ~SHADOW ? VGA_B_wire : {1'b0, VGA_B_wire[7:1]};
	
	// Video Output and select video mode to scaler
	if(x_count >= VID_H_BPORCH && x_count < VID_H_ACTIVE_REG + VID_H_BPORCH) begin
		if((y_count >= VID_V_BPORCH) && (y_count < (VID_V_ACTIVE + VID_V_BPORCH))) begin
			// data enable. this is the active region of the line
			VGA_R <= VGA_R_reg;
			VGA_G <= VGA_G_reg;
			VGA_B <= VGA_B_reg;
		end 
	end
	else if ((x_count == VID_H_ACTIVE_REG + VID_H_BPORCH) && 
				(y_count >= VID_V_BPORCH) && (y_count < (VID_V_ACTIVE + VID_V_BPORCH))) begin
		case (res_reg)
			3'd7		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h7, 13'd0};
			3'd6		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h6, 13'd0};
			3'd5		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h5, 13'd0};
			3'd4		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h4, 13'd0};
			3'd3		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h3, 13'd0};
			3'd2		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h2, 13'd0};
			3'd1		: {VGA_R, VGA_G, VGA_B} 	<= {10'd0, 3'h1, 13'd0};
			default : {VGA_R, VGA_G, VGA_B} 	<= 24'h0;
		endcase
	end
	
	// Video Enable
	if(x_count >= VID_H_BPORCH && x_count < VID_H_ACTIVE_REG + VID_H_BPORCH) begin
		if((y_count >= VID_V_BPORCH) && (y_count < (VID_V_ACTIVE + VID_V_BPORCH))) begin
			// data enable. this is the active region of the line
			VGA_DE <= 1'b1;
		end 
	end	
end



endmodule