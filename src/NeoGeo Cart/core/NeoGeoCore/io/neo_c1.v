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

// Missing pin: VPA
// All address decoding was checked except BITW1, nCTRL1_ZONE, and nCTRL2_ZONE

module neo_c1(
	input [21:17] M68K_ADDR,
	inout [15:8] M68K_DATA,
	input A22Z, A23Z,
	input nLDS, nUDS,
	input RW, nAS,
	output nROMOEL, nROMOEU,
	output nPORTOEL, nPORTOEU,
	output nPORTWEL, nPORTWEU,
	output nPORT_ZONE,
	output nWRL, nWRU,
	output nWWL, nWWU,
	output nSROMOEL, nSROMOEU,
	output nSRAMOEL, nSRAMOEU,
	output nSRAMWEL, nSRAMWEU,
	output nLSPOE, nLSPWE,
	output nCRDO, nCRDW, nCRDC,
	output nSDW,
	input [9:0] P1_IN,
	input [9:0] P2_IN,
	input nCD1, nCD2, nWP,
	input nROMWAIT, nPWAIT0, nPWAIT1, PDTACK,
	input [7:0] SDD_WR,
	output [7:0] SDD_RD,
	input nSDZ80R, nSDZ80W, nSDZ80CLR,
	input CLK_68KCLK,
	output nDTACK,
	output nBITW0, nBITW1, nDIPRD0, nDIPRD1,
	output nPAL_ZONE,
	input [1:0] SYSTEM_TYPE
);

	wire nIO_ZONE;			// Internal
	wire nC1REGS_ZONE;	// Internal
	wire nROM_ZONE;		// Internal
	wire nWRAM_ZONE;		// Internal (external for PCB)
	wire nCTRL1_ZONE;		// Internal (external for PCB)
	wire nICOM_ZONE;		// Internal
	wire nCTRL2_ZONE;		// Internal (external for PCB)
	wire nSTATUSB_ZONE;	// Internal (external for PCB)
	wire nLSPC_ZONE;		// Internal
	wire nCARD_ZONE;		// Internal
	wire nSROM_ZONE;		// Internal
	wire nSRAM_ZONE;		// Internal (external for PCB)
	
	c1_regs C1REGS(nICOM_ZONE, RW, M68K_DATA, SDD_RD, SDD_WR, nSDZ80R, nSDZ80W, nSDZ80CLR, nSDW);
	
	c1_wait C1WAIT(CLK_68KCLK, nAS, SYSTEM_TYPE[1], nROM_ZONE, nWRAM_ZONE, nPORT_ZONE, nCARD_ZONE, nSROM_ZONE,
					nROMWAIT, nPWAIT0, nPWAIT1, PDTACK, nDTACK);
	
	c1_inputs C1INPUTS(nCTRL1_ZONE, nCTRL2_ZONE, nSTATUSB_ZONE, M68K_DATA, P1_IN, P2_IN,
						nWP, nCD2, nCD1, SYSTEM_TYPE[0]);
	
	// 000000~0FFFFF read/write
	assign nROM_ZONE = |{A23Z, A22Z, M68K_ADDR[21], M68K_ADDR[20]};
	
	// 100000~1FFFFF read/write
	assign nWRAM_ZONE = |{A23Z, A22Z, M68K_ADDR[21], ~M68K_ADDR[20]};
	
	// 200000~2FFFFF read/write
	assign nPORT_ZONE = |{A23Z, A22Z, ~M68K_ADDR[21], M68K_ADDR[20]};
	
	// 300000~3FFFFF read/write
	assign nIO_ZONE = |{A23Z, A22Z, ~M68K_ADDR[21], ~M68K_ADDR[20]};
	
	// 300000~3FFFFE even bytes read/write
	assign nC1REGS_ZONE = nUDS | nIO_ZONE;
		
	// 300000~31FFFE even bytes read only
	assign nCTRL1_ZONE = nC1REGS_ZONE | ~RW | |{M68K_ADDR[19], M68K_ADDR[18], M68K_ADDR[17]};
			
	// 320000~33FFFE even bytes read/write
	assign nICOM_ZONE = nC1REGS_ZONE | |{M68K_ADDR[19], M68K_ADDR[18], ~M68K_ADDR[17]};
	
	// 340000~35FFFE even bytes read only - Todo: MAME says A17 is used, see right below
	assign nCTRL2_ZONE = nC1REGS_ZONE | ~RW | |{M68K_ADDR[19], ~M68K_ADDR[18], M68K_ADDR[17]};
	// 360000~37FFFF is not mapped ?

	// 30xxxx 31xxxx odd bytes read only
	assign nDIPRD0 = |{nIO_ZONE, M68K_ADDR[19], M68K_ADDR[18], M68K_ADDR[17], ~RW, nLDS};
	
	// 32xxxx 33xxxx odd bytes read only
	assign nDIPRD1 = |{nIO_ZONE, M68K_ADDR[19], M68K_ADDR[18], ~M68K_ADDR[17], ~RW, nLDS};
	
	// 38xxxx 39xxxx odd bytes write only
	assign nBITW0 = |{nIO_ZONE, ~M68K_ADDR[19], M68K_ADDR[18], M68K_ADDR[17], RW, nLDS};
	
	// 380000~39FFFE even bytes read only
	assign nSTATUSB_ZONE = nC1REGS_ZONE | ~RW | |{~M68K_ADDR[19], M68K_ADDR[18], M68K_ADDR[17]};
	
	// 3A0001~3BFFFF odd bytes write only
	assign nBITW1 = |{nIO_ZONE, ~M68K_ADDR[19], M68K_ADDR[18], ~M68K_ADDR[17], RW, nLDS};
	
	// 3C0000~3DFFFF
	assign nLSPC_ZONE = |{nIO_ZONE, ~M68K_ADDR[19], ~M68K_ADDR[18], M68K_ADDR[17]};
	
	// 3E0000~3FFFFF is not mapped ? To check
	
	// 400000~7FFFFF
	assign nPAL_ZONE = |{A23Z, ~A22Z, (nLDS & nUDS)};
	
	// 800000~BFFFFF
	assign nCARD_ZONE = |{~A23Z, A22Z};
	
	// C00000~CFFFFF
	assign nSROM_ZONE = |{~A23Z, ~A22Z, M68K_ADDR[21], M68K_ADDR[20]};
	
	// D00000~DFFFFF
	assign nSRAM_ZONE = |{~A23Z, ~A22Z, M68K_ADDR[21], ~M68K_ADDR[20]};

	// Outputs:
	assign nROMOEL = ~RW | nLDS | nROM_ZONE;
	assign nROMOEU = ~RW | nUDS | nROM_ZONE;
	assign nPORTOEL = ~RW | nLDS | nPORT_ZONE;
	assign nPORTOEU = ~RW | nUDS | nPORT_ZONE;
	assign nPORTWEL = RW | nLDS | nPORT_ZONE;
	assign nPORTWEU = RW | nUDS | nPORT_ZONE;
	assign nWRL = ~RW | nLDS | nWRAM_ZONE;
	assign nWRU = ~RW | nUDS | nWRAM_ZONE;
	assign nWWL = RW | nLDS | nWRAM_ZONE;
	assign nWWU = RW | nUDS | nWRAM_ZONE;
	assign nSROMOEL = ~RW | nLDS | nSROM_ZONE;
	assign nSROMOEU = ~RW | nUDS | nSROM_ZONE;
	assign nSRAMOEL = ~RW | nLDS | nSRAM_ZONE;
	assign nSRAMOEU = ~RW | nUDS | nSRAM_ZONE;
	assign nSRAMWEL = RW | nLDS | nSRAM_ZONE;
	assign nSRAMWEU = RW | nUDS | nSRAM_ZONE;
	
	// Todo: Check if TG68k duplicates byte on data bus on byte writes (it should !)
	assign nLSPWE = RW | nUDS | nLSPC_ZONE;
	assign nLSPOE = ~RW | nUDS | nLSPC_ZONE;
	
	assign nCRDO = ~RW | nCARD_ZONE | nLDS;
	assign nCRDW = RW | nCARD_ZONE | nLDS;
	assign nCRDC = nCARD_ZONE | nAS;

endmodule
