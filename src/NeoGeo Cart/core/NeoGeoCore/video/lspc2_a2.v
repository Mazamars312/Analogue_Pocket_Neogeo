//============================================================================
//  SNK NeoGeo for MiSTer
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

// All pins listed ok. REF, DIVI and DIVO only used on AES for video PLL hack

// Version 0.6.0 Alpha
// Mazamars312 : Added the 6mhz clock to this so we can sync the LSCP to the PLL Also using the clk_sys to help in this
// Moved all the clocks to the 

module lspc2_a2(
	input CLK_24M,
	output CLK_12MB,
	output CLK_6MB,
	input RESET,
	output [15:0] PBUS_OUT,
	inout [23:16] PBUS_IO,
	input [3:1] M68K_ADDR,
	inout [15:0] M68K_DATA,
	input LSPOE, LSPWE,
	input DOTA, DOTB,
	output CA4,
	output S2H1,
	output S1H1,
	output LOAD,
	output reg H,
	output EVEN1,						// For ZMC2
	output reg EVEN2,
	output IPL0, IPL1,
	output CHG,							// Also called TMS0
	output LD1, LD2,					// Buffer address load
	output reg PCK1, PCK2,
	output [3:0] WE,
	output [3:0] CK,
	output SS1, SS2,					// Buffer pair selection for B1
	output nRESETP,
	output HSYNC,
	output VSYNC,
	output CHBL,
	output BNKB,
	output VCS,							// LO ROM output enable
	output LSPC_8M,
	output LSPC_4M,
	
	output [14:0] SVRAM_ADDR,
	input  [15:0] SVRAM_DATA_IN,
	output [15:0] SVRAM_DATA_OUT,
	output BOE, BWE,
	
	output [10:0] FVRAM_ADDR,
	input  [15:0] FVRAM_DATA_IN,
	output [15:0] FVRAM_DATA_OUT,
	output CWE,
	
	output nPBUS_OUT_EN,
	
	input VMODE,
	
	output [14:0] FIXMAP_ADDR		// Extracted for NEO-CMC
);

	wire [8:0] PIXELC;
	wire [3:0] PIXEL_HPLUS;
	wire [8:0] RASTERC;
	
	wire [7:0] AA_SPEED;
	wire [2:0] AA_COUNT;				// Auto-animation tile #
	
	wire [15:0] CPU_DATA_OUT;
	
	wire [15:0] VRAM_LOW_READ;
	wire [15:0] VRAM_HIGH_READ;
	wire [15:0] REG_VRAMADDR;
	wire [15:0] VRAM_ADDR;
	wire [15:0] VRAM_ADDR_MUX;
	wire [15:0] VRAM_ADDR_AUTOINC;
	wire [15:0] REG_VRAMRW;
	wire [15:0] VRAM_WRITE;
	
	wire [15:0] REG_VRAMMOD;
	wire [15:0] REG_LSPCMODE;
	
	wire [2:0] TIMER_MODE;
	
	wire [3:0] T31_P;
	wire [3:0] U24_P;
	wire [3:0] O227_Q;
	
	wire [7:0] P_MUX_HIGH;
	wire [7:0] P_MUX_LOW;
	wire [23:0] P_OUT_MUX;
	
	wire [3:0] VSHRINK_INDEX;
	wire [3:0] VSHRINK_LINE;
	wire [8:0] XPOS;
	wire [7:0] XPOS_ROUND_UP;
	wire [2:0] SPR_TILE_AA;
	wire [3:0] G233_Q;
	wire [7:0] SPR_Y_LOOKAHEAD;
	wire [8:0] SPR_Y_ADD;
	wire [7:0] LO_LINE_A;
	wire [7:0] LO_LINE_B;
	wire [8:0] SPR_Y_SHRINK;
	wire [3:0] SPR_LINE;
	wire [7:0] LO_LINE_MUX;
	wire [19:0] SPR_TILE;
	wire [7:0] YSHRINK;
	wire [8:0] SPR_Y;
	wire [7:0] SPR_PAL;
	wire [3:0] FIX_PAL;
	wire [11:0] FIX_TILE;
	wire [3:0] HSHRINK;
	wire [13:0] PIPE_C;
	wire [3:0] SPR_TILEMAP;
	wire [7:0] ACTIVE_RD;
	wire [3:0] P201_Q;
	
	reg D112B_OUT_DELAY;
	

	
	assign S1H1 = LSPC_3M;
	assign S2H1 = LSPC_1_5M;
	assign CLK_6MB = LSPC_6M;
	assign CLK_12MB = LSPC_12M;
	//FD2 T168A(CLK_24M, T160A_OUT, PCK1, nPCK1);
	//FD2 T162A(CLK_24M, T160B_OUT, PCK2);
	//FDM T172(nPCK1, SPR_TILE_HFLIP, T172_Q);
	//FD2 U167(~PCK2, T172_Q, H);
	
	// PCK1, PCK2, H
	reg T172_Q;
	//reg nPCK1;
	always @(negedge CLK_24M)
	begin
		// FD2 T168A(CLK_24M, T160A_OUT, PCK1, nPCK1);
		PCK1 <= T160A_OUT;
		//nPCK1 <= ~T160A_OUT;
		// FD2 T162A(CLK_24M, T160B_OUT, PCK2);
		PCK2 <= T160B_OUT;
		// FDM T172(nPCK1, SPR_TILE_HFLIP, T172_Q);
		if (PCK1 & ~T160A_OUT)
			T172_Q <= SPR_TILE_HFLIP;
		// FD2 U167(~PCK2, T172_Q, H);
		if (~PCK2 & T160B_OUT)
			H <= T172_Q;
	end
	
	assign CA4 = T172_Q ^ LSPC_1_5M;
	
	// EVEN1, EVEN2
	wire U105A_OUT = ~&{nHSHRINK_OUT_A, nHSHRINK_OUT_B, nEVEN_ODD};
	wire U107_OUT = ~&{nHSHRINK_OUT_A, EVEN_nODD, HSHRINK_OUT_B};
	wire U109_OUT = ~&{HSHRINK_OUT_A, nEVEN_ODD};
	wire U112_OUT = ~&{U105A_OUT, U107_OUT, U109_OUT};
	//assign #13 EVEN1 = U112_OUT;	// BD5 U162
	assign EVEN1 = U112_OUT;
	
	// Pixel parity select
	wire nPARITY_INIT = ~&{nCHAINED, S53A_OUT};	// R42A
	wire nXPOS_ZERO = ~PIPE_C[0];
	wire S58A_OUT = ~|{nXPOS_ZERO, nPARITY_INIT};
	wire ONE_PIXEL = HSHRINK_OUT_A ^ HSHRINK_OUT_B;	// U83
	wire U72_OUT = ONE_PIXEL ^ nEVEN_ODD;
	wire U57B_OUT = nPARITY_INIT & U72_OUT;
	wire U56A_OUT = ~|{S58A_OUT, U57B_OUT};
	wire CLK_24MB, LSPC_12M;
	
	wire CK_HSHRINK_REG, U68A_nQ, EVEN_nODD, nEVEN_ODD;
	FD2 U68A(CLK_24MB, ~LSPC_12M, CK_HSHRINK_REG, U68A_nQ);
	FD2 U74A(~U68A_nQ, U56A_OUT, EVEN_nODD, nEVEN_ODD);


	
	// CPU VRAM address update select
	// $3C0000 REG_VRAMADDR	0 (update with written value)
	// $3C0002 REG_VRAMRW   1 (update with REG_VRAMMOD)
	wire C22A_OUT = ~&{WR_VRAM_RW, WR_VRAM_ADDR};
	wire VRAM_ADDR_UPD_TYPE;
	FDM B18(C22A_OUT, M68K_ADDR[1], VRAM_ADDR_UPD_TYPE);
	
	// VRAM_ADDR with REG_VRAMMOD applied
	// G18 G81 F91 F127
	assign VRAM_ADDR_AUTOINC = REG_VRAMMOD + VRAM_ADDR;
	
	// CPU VRAM address update mux
	// C144A C142A C140B C138B
	// A112B A111A A109A A110B
	// D110B D106B D108B D85A
	// F10A F12A F26A F12B
	assign VRAM_ADDR_MUX = VRAM_ADDR_UPD_TYPE ? VRAM_ADDR_AUTOINC : REG_VRAMADDR;
	
	// VRAM address update FFs
	// F14 D48 C105 C164
	// TESTING
	always @(negedge CLK_24M)
		D112B_OUT_DELAY <= D112B_OUT;
	FDS16bit F14(D112B_OUT_DELAY, VRAM_ADDR_MUX, VRAM_ADDR);
	
	// ...Second stage
	// F165 D178 D141 E196
	FDS16bit E196(O108B_OUT, REG_VRAMRW, VRAM_WRITE);
	
	// Pulse for updating internal VRAM address
	// nCPU_WR_HIGH and nCPU_WR_LOW are "write done" pulses for both VRAM zones
	// Happens when write is done or write to REG_VRAMADDR
	wire O108B_OUT = ~&{nCPU_WR_HIGH, nCPU_WR_LOW};
	wire D112B_OUT = ~|{~WR_VRAM_ADDR, O108B_OUT};
	
	// CPU read data output. Outputs are not enabled all at once, this is strange.
	// Transient current spike reduction ?
	// After LSPOE goes low, at least 1.5mclk is required for all outputs to be enabled.
	wire C71_Q, LSPOE_SEQB, LSPOE_SEQA, C68_Q, LSPOE_SEQC;
	FDM C71(CLK_24M, LSPOE, C71_Q, LSPOE_SEQA);
	FDM C68(CLK_24MB, C71_Q, C68_Q, LSPOE_SEQB);
	FDM C75(CLK_24M, C68_Q, , LSPOE_SEQC);
	
	assign M68K_DATA[1:0] = LSPOE ? 2'bzz : CPU_DATA_OUT[1:0];				// No delay
	wire   B71_OUT = ~&{~LSPOE, LSPOE_SEQA};
	assign M68K_DATA[7:2] = B71_OUT ? 6'bzzzzzz : CPU_DATA_OUT[7:2];		// t+1
	wire   B75A_OUT = ~&{~LSPOE, LSPOE_SEQB};
	assign M68K_DATA[9:8] = B75A_OUT ? 2'bzz : CPU_DATA_OUT[9:8];			// t+2
	wire   B74_OUT = ~&{~LSPOE, LSPOE_SEQC};
	assign M68K_DATA[15:10] = B74_OUT ? 6'bzzzzzz : CPU_DATA_OUT[15:10];	// t+3
	
	
	// Auto-animation bit enables
	// C184A
	wire   AUTOANIM3_EN = SPR_AA_3 & ~AA_DISABLE;
	wire   C186A_OUT = SPR_AA_2 & ~AA_DISABLE;
	// B180B
	wire   AUTOANIM2_EN = AUTOANIM3_EN | C186A_OUT;
	
	
	// Timing/sequencing stuff
	// This doesn't mean anything special, it just outputs periodic signals to get everything moving
	wire   T56A_OUT = ~&{LSPC_6M, LSPC_3M};
	wire   T58A_OUT = ~&{LSPC_6M, LSPC_3M};
	wire T53_Q, U53_Q;
	FDM T53(LSPC_12M, T56A_OUT, T53_Q);
	FDM U53(CLK_24M, T53_Q, U53_Q);
	assign nPBUS_OUT_EN = U53_Q & T53_Q;
	
	reg T69_nQ;
	
	always @(posedge CLK_24MB or negedge nRESETP)
	begin
		//FDPCell T69(LSPC_12M, LSPC_3M, nRESETP, 1'b1, , T69_nQ);
		if (!nRESETP)
		begin
			T69_nQ <= 1'b0;
		end
		else
		begin
			if (!LSPC_12M)
				T69_nQ <= ~LSPC_3M;
		end
	end
	
	wire T73A_OUT = LSPC_3M | T69_nQ;
	
	reg T140_Q, T134_Q;
	always @(posedge CLK_24M or negedge T73A_OUT)
	begin
		if (!T73A_OUT)
		begin
			T140_Q <= 1'b0;
			T134_Q <= 1'b0;
		end
		else
		begin
			//FJD T140(CLK_24M, T134_nQ, 1'b1, T73A_OUT, T140_Q);
			T140_Q <= (~T134_Q) ? ~T140_Q : 1'b0;
			//FJD T134(CLK_24M, T140_Q, 1'b1, T73A_OUT, , T134_nQ);
			T134_Q <= (T140_Q) ? ~T134_Q : 1'b0;
		end
	end
	
	reg U129A_Q;
	always @(negedge CLK_24M)
	begin
		//FD2 U129A(CLK_24M, ~T134_Q, U129A_Q, U129A_nQ);
		U129A_Q <= ~T134_Q;
		//FD2 U144A(CLK_24M, U112_OUT, EVEN2);
		EVEN2 <= U112_OUT;
	end
	
	wire T125A_OUT = ~U129A_Q | T140_Q;
	wire Q174B_OUT, P198A_OUT;
	BD3 P198A(Q174B_OUT, P198A_OUT);
	FS1 P201(LSPC_12M, P198A_OUT, P201_Q);
	wire P219A_OUT = ~|{O159_QB, ~P201_Q[0]};
	wire P222A_OUT = ~&{P219A_OUT, ~P201_Q[1]};
	wire CLK_SPR_TILE = P201_Q[1];
	wire R94A_OUT = ~&{P201_Q[2], R91_Q};
	wire D208B_OUT = ~P201_Q[3];
	
	
	// NEO-B1 control signals
	
	// Latch for CK1/2 and WE1/2
	LT4 T31(LSPC_12M, {T38A_OUT, T28_OUT, T29A_OUT, T20B_OUT}, T31_P);
	// Latch for CK3/4 and WE3/4
	LT4 U24(LSPC_12M, {U37B_OUT, U21B_OUT, U35A_OUT, U31A_OUT}, U24_P);
	
	// CKs and WEs can only be low when LSPC_12M is high
	wire WE1 = ~&{T31_P[0], LSPC_12M};
	wire WE2 = ~&{T31_P[1], LSPC_12M};
	wire CK1 = ~&{T31_P[2], LSPC_12M};
	wire CK2 = ~&{T31_P[3], LSPC_12M};
	
	wire WE3 = ~&{U24_P[2], LSPC_12M};
	wire WE4 = ~&{U24_P[3], LSPC_12M};
	wire CK3 = ~&{U24_P[0], LSPC_12M};
	wire CK4 = ~&{U24_P[1], LSPC_12M};
	
	assign WE = {WE4, WE3, WE2, WE1};
	assign CK = {CK4, CK3, CK2, CK1};
	
	// Most of the following NAND gates are making 2:1 muxes like on the Alpha68k
	
	wire WRITEPX_A, WRITEPX_B;
	// For buffer A:
	// Clearing write pulses gates
	wire T22A_OUT = ~&{T50B_OUT, SS1};
	wire T40B_OUT = ~&{T48A_OUT, SS1};
	// WRITEPX* gates
	wire T50A_OUT = ~&{WRITEPX_A, CHG_D};
	wire T40A_OUT = ~&{WRITEPX_B, CHG_D};
	// Enable writes for opaque pixels only
	wire T17A_OUT = ~&{DOTA, ~T50A_OUT};
	wire T22B_OUT = ~&{DOTB, ~T40A_OUT};
	// Merge writes with clearing write pulses
	wire T20B_OUT = ~&{T22A_OUT, T17A_OUT};
	wire T29A_OUT = ~&{T40B_OUT, T22B_OUT};
	// Merge clocks with LD1_D pulses
	wire T28_OUT = ~&{T22A_OUT, LD1_D, T50A_OUT};
	wire T38A_OUT = ~&{T40B_OUT, T40A_OUT, LD1_D};
	
	// For buffer B:
	// Clearing write pulses gates
	wire U33B_OUT = ~&{T48A_OUT, SS2};
	wire T20A_OUT = ~&{T50B_OUT, SS2};
	// WRITEPX* gates
	wire U51B_OUT = ~&{WRITEPX_A, nCHG_D};
	wire U39B_OUT = ~&{WRITEPX_B, nCHG_D};
	// Enable writes for opaque pixels only
	wire U18A_OUT = ~&{DOTA, ~U51B_OUT};
	wire U38A_OUT = ~&{DOTB, ~U39B_OUT};
	// Merge writes with clearing write pulses
	wire U21B_OUT = ~&{T20A_OUT, U18A_OUT};
	wire U37B_OUT = ~&{U33B_OUT, U38A_OUT};
	// Merge clocks with LD1_D pulses
	wire U35A_OUT = ~&{LD2_D, U33B_OUT, U39B_OUT};
	wire U31A_OUT = ~&{LD2_D, T20A_OUT, U51B_OUT};
	
	
	wire LSPC_3M;
	
	
	
	// Buffer shift-out clocks, alternates between odd/even
	wire T50B_OUT = LSPC_3M & LSPC_6M;
	wire T48A_OUT = ~LSPC_3M & LSPC_6M;
	
	
	// Pixel write pulse selection (odd/even)
	wire U89A_OUT = ~&{nHSHRINK_OUT_B, nEVEN_ODD, HSHRINK_OUT_A};
	wire U92A_OUT = ~&{nHSHRINK_OUT_A, nEVEN_ODD, HSHRINK_OUT_B};
	wire U91_OUT = ~&{nHSHRINK_OUT_B, EVEN_nODD, HSHRINK_OUT_A};
	wire U94_OUT = ~&{nHSHRINK_OUT_A, EVEN_nODD, HSHRINK_OUT_B};
	// Enabled write pulses only if pixel is not skipped for h-shrink
	wire U88B_OUT = HSHRINK_OUT_A | HSHRINK_OUT_B;
	wire U85_OUT = &{U89A_OUT, U92A_OUT, U88B_OUT};
	wire U86A_OUT = &{U88B_OUT, U94_OUT, U91_OUT};
	// Final FFs
	FD2 T82A(CLK_24M, U85_OUT, WRITEPX_A);
	FD2 T86(CLK_24M, U86A_OUT, WRITEPX_B);
	
	
	// LD1/2 signal generation. Those are used to tell NEO-B1 to reload the write address (X position)
	// Get which buffer should have the rendering pulses, and which should have the reset pulse
	wire FLIP_nQ, R50_Q, R50_nQ;
	FDM R50(LSPC_3M, FLIP_nQ, R50_Q, R50_nQ);
	
	// Periodic signals
	wire LSPC_1_5M, R69_Q, R69_nQ;
	FDM R69(LSPC_3M, LSPC_1_5M, R69_Q, R69_nQ);
	FDM S55(LSPC_12M, LSPC_3M, S55_Q);
	wire S55_Q;
	wire S53A_OUT = S55_Q & LSPC_6M;
	// LOAD output
	FD2 R35A(CLK_24MB, S53A_OUT, LOAD);
	
	// For LD1:
	// Gate with chain bit (prevents address reload)
	wire nCHAINED = ~|{PIPE_C[13], R69_nQ};
	// Gate reset LD pulse (once at start of line being shifted out)
	wire R44B_OUT = ~&{R50_nQ, R53_Q};
	// Gate rendering LD pulses
	wire R48B_OUT = ~&{nCHAINED, R50_Q};
	// Merge
	wire R42B_OUT = ~&{R44B_OUT, R48B_OUT};
	// Sync
	wire LD1_D = ~&{R42B_OUT, S53A_OUT};
	FD2 R32(CLK_24MB, LD1_D, LD1);
	
	// For LD2:
	// Gate reset LD pulse (once at start of line being shifted out)
	wire R44A_OUT = ~&{R53_Q, R50_Q};
	// Gate rendering LD pulses
	wire R46A_OUT = ~&{R50_nQ, nCHAINED};
	// Merge
	wire R46B_OUT = ~&{R44A_OUT, R46A_OUT};
	// Sync
	wire LD2_D = ~&{R46B_OUT, S53A_OUT};
	FD2 R28A(CLK_24MB, LD2_D, LD2);
	
	// Reset LD pulse generation. This tells NEO-B1 to reload the address before shifting out a buffer
	// At this very moment, the address should be 000 on the P bus
	// Triggers at pixel #264
	wire O62_Q, P74_Q, R53_Q, R74_nQ;
	FDPCell O62(PIXELC[3], PIXELC[8], 1'b1, nRESETP, O62_Q);
	// Triggers at pixel #268
	FDPCell P74(PIXELC[2], O62_Q, 1'b1, nRESETP, P74_Q);
	// Make unique pulse
	FDM R53(LSPC_3M, R67A_OUT, R53_Q);
	wire R67A_OUT = R74_nQ & P74_Q;
	FDPCell R74(LSPC_1_5M, P74_Q, 1'b1, nRESETP, , R74_nQ);
	
	// Reload pulse for the h-shrink shift registers
	// Perdiodic as all sprites take the same time to render regardless of h-shrink value
	wire R48A_OUT = ~&{S53A_OUT, R69_Q};
	wire LD_HSHRINK_REG;
	FD2 R56A(CLK_24MB, R48A_OUT, LD_HSHRINK_REG);
	
	
	// CHG output
	wire CHG_D;
	FDPCell S137(LSPC_1_5M, CHG_D, 1'b1, nRESETP, CHG);
	
	// SS1/2 outputs, periodic
	wire nFLIP, nCHG_D, R15_QD, S48_nQ;
	
	// Credit to paulb-nl
	// Latch nFLIP at pixel 264 (O62_Q). That will make the line buffers switch at pixel 267.
	// The first write of the new line to the line buffer happens at pixel 268.
	//FDPCell O69(CLK_24MB, nFLIP, nRESETP, 1'b1, , FLIP_nQ);
	FDPCell O69(O62_Q, nFLIP, nRESETP, 1'b1, , FLIP_nQ);
	FDPCell R63(PIXELC[2], FLIP_nQ, 1'b1, nRESETP, CHG_D, nCHG_D);
	FDM S48(LSPC_3M, R15_QD, , S48_nQ);
	// S40A
	assign SS1 = ~|{S48_nQ, CHG_D};
	// S39
	assign SS2 = ~|{nCHG_D, S48_nQ};
	
	
	// 16-pixel lookahead for fix tiles
	wire J20A_OUT = ~&{PIXELC[8:7]};
	// I51
	assign PIXEL_HPLUS = 4'd15 + {~J20A_OUT, PIXELC[6:4]} + PIXELC[3];
	
	
	// V-shrink mirroring and pipeline
	wire R179_Q, SPR_CONTINUOUS;
	FDM R179(VCS, SPR_CONTINUOUS, R179_Q);
	// Mirror V-shrink values for second half of sprite if needed
	wire S186_OUT = ~(~P235_OUT ^ R179_Q);
	wire SPRITEMAP_ADDR_MSB = ~S186_OUT;
	wire S166_OUT = VSHRINK_LINE[3] ^ ~S186_OUT;
	wire S164_OUT = VSHRINK_LINE[2] ^ ~S186_OUT;
	wire S162_OUT = VSHRINK_LINE[1] ^ ~S186_OUT;
	wire S168_OUT = VSHRINK_LINE[0] ^ ~S186_OUT;
	FDSCell O227(P222A_OUT, {S166_OUT, S164_OUT, S162_OUT, S168_OUT}, O227_Q);
	FDSCell G233(~P201_Q[1], O227_Q, G233_Q);
	assign SPR_LINE[0] = SPR_TILE_VFLIP ^ G233_Q[0];
	assign SPR_LINE[1] = SPR_TILE_VFLIP ^ G233_Q[1];
	assign SPR_LINE[2] = SPR_TILE_VFLIP ^ G233_Q[2];
	assign SPR_LINE[3] = SPR_TILE_VFLIP ^ G233_Q[3];
	wire Q184_OUT = VSHRINK_INDEX[3] ^ ~S186_OUT;
	wire Q182_OUT = VSHRINK_INDEX[2] ^ ~S186_OUT;
	wire Q186_OUT = VSHRINK_INDEX[1] ^ ~S186_OUT;
	wire Q172_OUT = VSHRINK_INDEX[0] ^ ~S186_OUT;
	FDSCell O175(P222A_OUT, {Q184_OUT, Q182_OUT, Q186_OUT, Q172_OUT}, SPR_TILEMAP);
	
	
	// P bus stuff
	// Lookup ROM data latch
	FDSCell Q87(VCS, PBUS_IO[23:20], VSHRINK_INDEX);
	FDSCell S141(VCS, PBUS_IO[19:16], VSHRINK_LINE);
	
	wire R88_Q, R88_nQ;
	FDM R88(CLK_24M, R94A_OUT, R88_Q, R88_nQ);
	assign VCS = ~R88_nQ;
	
	
	wire T185B_OUT = PCK1 | PCK2;
	// Data select lines
	wire S171_Q, S171_nQ, S183_Q, S183_Q_DELAYED;
	FDM S183(T185B_OUT, S171_Q, S183_Q);
	BD3 P196(S183_Q, S183_Q_DELAYED);
	FDM S171(U53_Q, LSPC_1_5M, S171_Q, S171_nQ);
	
	assign XPOS = PIPE_C[8:0];
	
	assign SPR_TILE_AA[2] = AUTOANIM3_EN ? AA_COUNT[2] : SPR_TILE[2];
	assign SPR_TILE_AA[1:0] = AUTOANIM2_EN ? AA_COUNT[1:0] : SPR_TILE[1:0];
	
	// Q125 R120
	assign XPOS_ROUND_UP = XPOS[8:1] + XPOS[0];
	
	// K143A K145A K147A K149A
	// Q111A Q113B Q113A Q111B
	assign P_MUX_HIGH = R88_Q ? XPOS[8:1] : YSHRINK;
	
	// R185A R185B R183A R183B
	// R277A R277B R275A R275B
	assign LO_LINE_MUX = SPR_CONTINUOUS ? ~LO_LINE_B : LO_LINE_A;		// Might be swapped
	
	// R149A R149B R147A R147B
	// Q149A Q120A Q121B Q149B
	assign P_MUX_LOW = R88_Q ? XPOS_ROUND_UP : LO_LINE_MUX;
	
	
	// Output mux
	// C250 A238A A232 A234A
	// E271 E273A E268A D255
	assign P_OUT_MUX[23:16] = ~S183_Q_DELAYED ? 
										~S171_nQ ? 
											{SPR_PAL}
											:
											{SPR_TILE[19:16], SPR_LINE}
										:
										~S171_nQ ?
											{8'b00000000}
											:
											{4'b0000, FIX_PAL};
	
	// J39A M230A L228A L247A
	// C256 B269A B273A B276A
	// B220 C248 B217A B215
	// B197A B130A B128 B148A
	assign P_OUT_MUX[15:0] = ~S183_Q_DELAYED ?
										~S171_nQ ?
											{P_MUX_HIGH, P_MUX_LOW}
											:
											{SPR_TILE[15:8], SPR_TILE[7:3], SPR_TILE_AA}
										:
										~S171_nQ ?
											{PIXELC[2], RASTERC[2:1], FLIP, FIX_TILE[11:8], FIX_TILE[7:0]}
											:
											{8'b00000000, 8'b00000000};
	
	assign PBUS_IO = nPBUS_OUT_EN ? 8'bzzzzzzzz : P_OUT_MUX[23:16];
	assign PBUS_OUT = P_OUT_MUX[15:0];
	
	
	// Y position stuff
	// O268 O237
	assign SPR_Y_LOOKAHEAD = {RASTERC[7:1], FLIP} + 1'b1;
	// P261 P237
	assign SPR_Y_ADD = SPR_Y_LOOKAHEAD + SPR_Y[7:0];
	// R216 R218 R238 R241
	// R281 R283 Q289 Q291
	assign LO_LINE_A = SPR_Y_ADD[7:0] ^ {8{~P235_OUT}};
	wire P235_OUT = ~(SPR_Y[8] ^ SPR_Y_ADD[8]);
	// Q237 R189
	assign SPR_Y_SHRINK = LO_LINE_A + {1'b0, ~YSHRINK};
	// Q265 R151
	assign LO_LINE_B = LO_LINE_A + {~YSHRINK[6:0], 1'b0};
	
	// Special #33 height detection
	// R222A
	assign SPR_CONTINUOUS = &{SPR_SIZE0, SPR_SIZE5, SPR_Y_SHRINK[8]};
	
	wire WR_VRAM_ADDR, WR_VRAM_RW, WR_TIMER_HIGH, WR_TIMER_LOW, WR_IRQ_ACK, TIMER_IRQ_EN, AA_DISABLE, TIMER_STOP, nVRAM_WRITE_REQ;
	lspc_regs REGS(RESET, nRESETP, M68K_ADDR, M68K_DATA, LSPOE, LSPWE, VMODE, RASTERC, AA_COUNT, VRAM_LOW_READ,
					VRAM_HIGH_READ, WR_VRAM_ADDR, WR_VRAM_RW, WR_TIMER_HIGH, WR_TIMER_LOW, WR_IRQ_ACK, REG_VRAMADDR,
					REG_VRAMMOD, REG_VRAMRW, REG_LSPCMODE, CPU_DATA_OUT, AA_SPEED,	TIMER_MODE,	TIMER_IRQ_EN,
					AA_DISABLE, TIMER_STOP, nVRAM_WRITE_REQ, D112B_OUT);
	
	wire LSPC_6M; 
	
	wire D46A_OUT;
	lspc_timer TIMER(LSPC_6M, nRESETP, M68K_DATA, WR_TIMER_HIGH, WR_TIMER_LOW, VMODE, TIMER_MODE, TIMER_STOP,
						RASTERC, TIMER_IRQ_EN, R74_nQ, BNKB, D46A_OUT);
	
	resetp RSTP(CLK_24MB, RESET, nRESETP);
	
	wire BNK;
	irq IRQ(WR_IRQ_ACK, M68K_DATA[2:0], RESET, D46A_OUT, BNK, LSPC_6M, IPL0, IPL1);
	
	wire Q53_CO, FLIP, P50_CO;
	videosync VS(CLK_24MB, LSPC_3M, LSPC_1_5M, Q53_CO, nRESETP, VMODE, PIXELC, RASTERC, HSYNC, VSYNC, BNK,
						BNKB, CHBL, R15_QD, FLIP, nFLIP, P50_CO);

	lspc2_clk LSPCCLK(
	.CLK_24M		(CLK_24M), 
	.nRESETP		(nRESETP), 
	.CLK_24MB	(CLK_24MB), 
	.LSPC_12M	(LSPC_12M), 
	.LSPC_8M		(LSPC_8M), 
	.LSPC_6M		(LSPC_6M), 
	.LSPC_4M		(LSPC_4M), 
	.LSPC_3M		(LSPC_3M), 
	.LSPC_1_5M	(LSPC_1_5M),
	.Q53_CO		(Q53_CO));
	
	wire SPR_TILE_VFLIP, SPR_TILE_HFLIP, SPR_AA_3, SPR_AA_2, nCPU_WR_LOW, R91_nQ, CLK_CPU_READ_LOW, T160A_OUT, T160B_OUT, CLK_ACTIVE_RD;
	wire ACTIVE_RD_PRE8;
	slow_cycle SCY(CLK_24M, CLK_24MB, LSPC_12M, LSPC_6M, LSPC_3M, LSPC_1_5M, nRESETP, VRAM_ADDR[14:0], VRAM_WRITE,
							REG_VRAMADDR[15], PIXELC[3], PIXELC[8], RASTERC[7:3], PIXEL_HPLUS, ACTIVE_RD,
							nVRAM_WRITE_REQ, SPR_TILEMAP, SPR_TILE_VFLIP, SPR_TILE_HFLIP, SPR_AA_3, SPR_AA_2,
							FIX_TILE, FIX_PAL, SPR_TILE, SPR_PAL, VRAM_LOW_READ, nCPU_WR_LOW, R91_nQ,
							CLK_CPU_READ_LOW, T160A_OUT, T160B_OUT, CLK_ACTIVE_RD, ACTIVE_RD_PRE8, Q174B_OUT,
							D208B_OUT, SPRITEMAP_ADDR_MSB, CLK_SPR_TILE, P222A_OUT, ~P201_Q[1],
							SVRAM_ADDR, SVRAM_DATA_IN, SVRAM_DATA_OUT, BOE, BWE, FIXMAP_ADDR);
	
	wire nCPU_WR_HIGH, R91_Q, SPR_SIZE0, SPR_SIZE5, O159_QB;
	fast_cycle FCY(CLK_24M, LSPC_12M, LSPC_6M, LSPC_3M, LSPC_1_5M, nRESETP, nVRAM_WRITE_REQ,
							VRAM_ADDR, VRAM_WRITE, REG_VRAMADDR[15], FLIP, nFLIP,
							PIXELC, RASTERC, P50_CO, nCPU_WR_HIGH, HSHRINK, PIPE_C, VRAM_HIGH_READ,
							ACTIVE_RD, R91_Q, R91_nQ, T140_Q, T58A_OUT, T73A_OUT, U129A_Q, T125A_OUT,
							CLK_ACTIVE_RD, ACTIVE_RD_PRE8, SPR_Y, YSHRINK, SPR_SIZE0, SPR_SIZE5, O159_QB,
							FVRAM_ADDR, FVRAM_DATA_IN, FVRAM_DATA_OUT, CWE);
	
	autoanim AA(RASTERC[8], nRESETP, AA_SPEED, AA_COUNT);
	
	wire HSHRINK_OUT_A, HSHRINK_OUT_B;
	hshrink HSH(HSHRINK, CK_HSHRINK_REG, LD_HSHRINK_REG, HSHRINK_OUT_A, HSHRINK_OUT_B);
	wire nHSHRINK_OUT_A = ~HSHRINK_OUT_A;
	wire nHSHRINK_OUT_B = ~HSHRINK_OUT_B;
	
endmodule
