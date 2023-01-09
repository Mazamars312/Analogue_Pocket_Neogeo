// NeoGeo logic definition
// Copyright (C) 2018 Sean Gonsalves
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// The funny 4-letter names correspond to those on the NEO-B1 die shot trace

/********************************************************* 

Mazamars312 changes: 

version 0.5.0 Aplha

Made the FIX_PAL_REG hold for on more 3mhz cycle to keep the SROM in the same pixel area

Version 0.6.0 Alpha

Made the ResetP signal come in to know if we are to keep to the High or Low of the CLK_1HB signal for the data muxing 
This helps keep these chips in sync with the PLL


***********************************************************/


module neo_b1(
	input CLK,					// For linebuffers RAM
	input CLK_6MB,				// Pixel clock
	input nRESETP,
	
	input [23:0] PBUS,		// Used to retrieve LB addresses loads, SPR palette # and FIX palette # from LSPC
	input [15:0] FIXD,			// 2 fix pixels
	input PCK1,
	input PCK2,
	input CHBL,					// Force PA to zeros
	input BNKB,					// For Watchdog and PA
	input [3:0] GAD, GBD,	// 2 sprite pixels
	input [3:0] WE,			// LB writes
	input [3:0] CK,			// LB address counter clocks
	input TMS0,					// LB flip
	input LD1, LD2,			// Load LB addresses
	input SS1, SS2,			// Clearing enable for each LB
	input S1H1,					// 3MHz offset from CLK_1HB
	input S2H1,					// 3MHz offset from CLK_1HB
	
	input A23I, A22I,
	output [11:0] PA,			// Palette address bus
	
	input nLDS,					// For watchdog kick
	input RW,
	input nAS,
	input [21:17] M68K_ADDR_U,
	input [12:1] M68K_ADDR_L,
	output nHALT,
	output nRESET,
	input nRST,
	
	input [4:0] pixel_mux_change,
	
	input EN_FIX
);

	reg nCPU_ACCESS;
	
	reg [7:0] FIXD_REG;
	reg [3:0] FIX_PAL_REG;
	wire [3:0] FIX_COLOR;
	wire [3:0] SPR_COLOR;
	wire [11:0] RAMBL_OUT;
	wire [11:0] RAMBR_OUT;
	wire [11:0] RAMTL_OUT;
	wire [11:0] RAMTR_OUT;
	wire [7:0] SPR_PAL;
	wire [1:0] MUX_BA;
	wire [11:0] PA_MUX_A;
	wire [11:0] PA_MUX_B;
	wire [11:0] RAM_MUX_OUT;
	reg [11:0] PA_VIDEO;

	// 2px fix data reg
	// BEKU AKUR...
	reg S2H1_REG;
	reg [15:0] FIXD_MAIN_REG;
	always @(posedge CLK) begin
		S2H1_REG <= S2H1;
		FIXD_MAIN_REG <= FIXD;
	end
		
	always @(negedge S1H1)
		FIXD_REG <= S2H1_REG ? FIXD_MAIN_REG[7:0] : FIXD_MAIN_REG[15:8];
	
	// Switch between odd/even fix pixel
	// BEVU AWEQ...
	
	
	// We want to see where the CLK_1HB from the PLL is. If the CLK_1HB on the rise of the resetp then 
	// S1H1 is equal to nRESETP_state. this is the opersite if the CLK_1HB is on the fall on resetp

	assign FIX_COLOR = S1H1 ? FIXD_REG[7:4] : FIXD_REG[3:0];

	// IDUF
	// EN_FIX gate for Neo CD only
	wire FIX_OPAQUE = |{FIX_COLOR};

	// GETU FUCA...
	always @(posedge PCK1)
		FIX_PAL_REG <= PBUS[19:16];


	assign SPR_PAL = PBUS[23:16];
	
	wire [3:0] GAD_MUX, GBD_MUX;
	
	// Test rig on the location of the bits during testing. Was able to figger out where each bit was for the CROM
	
	assign {GBD_MUX, GAD_MUX} = {GBD[0], GBD[2], GBD[1], GBD[3], GAD[0], GAD[2], GAD[1], GAD[3]};
	
	
	linebuffer RAMBR(CLK, CK[0], WE[0], LD1, SS1, GAD_MUX, PCK2, SPR_PAL, PBUS[7:0],  RAMBR_OUT);
	linebuffer RAMBL(CLK, CK[1], WE[1], LD1, SS1, GBD_MUX, PCK2, SPR_PAL, PBUS[15:8], RAMBL_OUT);
	linebuffer RAMTR(CLK, CK[2], WE[2], LD2, SS2, GAD_MUX, PCK2, SPR_PAL, PBUS[7:0],  RAMTR_OUT);
	linebuffer RAMTL(CLK, CK[3], WE[3], LD2, SS2, GBD_MUX, PCK2, SPR_PAL, PBUS[15:8], RAMTL_OUT);
	
	assign MUX_BA = {TMS0, S1H1};
	
	/*
	assign VORU = S1H1 & TMS0;
	assign VOTO = S1H1 & ~TMS0;
	assign VEZA = ~S1H1 & TMS0;
	assign VOKE = ~S1H1 & ~TMS0;
	*/
	
	// Output buffer select
	// MEGA MAKA MEJU ORUG...
	assign RAM_MUX_OUT = 
							(MUX_BA == 2'b00) ? RAMBR_OUT :
							(MUX_BA == 2'b01) ? RAMBL_OUT :
							(MUX_BA == 2'b10) ? RAMTR_OUT :
							RAMTL_OUT;
	
	// Priority for palette address bus (PA):
	// -CPU over everything else
	// -CHBL (h-blank)
	// -Fix pixel if opaque
	// -Line buffers (sprites) ouput
	
	// CPU palette RAM access decode
	// JAGU JURA...
	always @(negedge nAS)
		nCPU_ACCESS <= A23I | ~A22I;
	
	// Fix/Sprite/Blanking select
	// KUQA KUTU JARA...
	assign PA_MUX_A = FIX_OPAQUE ? {4'b0000, FIX_PAL_REG, FIX_COLOR} : RAM_MUX_OUT;
	assign PA_MUX_B = CHBL ? 12'h000 : PA_MUX_A;

	// KAWE KESE...
	always @(posedge CLK_6MB)
		PA_VIDEO <= PA_MUX_B;
	
	// KUTE KENU...
	assign PA = nCPU_ACCESS ? PA_VIDEO : M68K_ADDR_L;


	// Note: nRESET is sync'd to frame start
	watchdog WD(nLDS, RW, A23I, A22I, M68K_ADDR_U, BNKB, nHALT, nRESET, nRST);
	//assign nHALT = 1;
	//assign nRESET = 1;

endmodule
