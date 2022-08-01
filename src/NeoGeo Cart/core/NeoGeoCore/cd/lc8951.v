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

// This module handles the bare essentials to make the Neo CD system ROM happy with
// communicating with the LC8951 CD host chip
// The LC8953-LC8951 handshake signals aren't implemented, no functional need for
// that as it's all automatic while the 68k waits

// altera message_off 10036 10240

module lc8951(
	input nRESET,
	input CLK_12M,
	input nWR, nRD,
	input RS,	// Register select, 0=Access address register, 1=Access pointed register
	input [7:0] DIN,
	output reg [7:0] DOUT,
	
	input [7:0] MSF_M,	// To give back the system ROM what it expects to see
	input [7:0] MSF_S,	// Normally these come from the MSF data from the sector's header
	input [7:0] MSF_F,	// Maybe use the real header which would be given by the HPS instead ?
	input MSF_LATCH,
	
	input SECTOR_READY,
	input DMA_RUNNING,
	output reg CDC_nIRQ	// Triggers when SECTOR_READY or DMA_RUNNING rises and IRQ enabled
);

	reg [3:0] AR;		// Address Register
	reg [7:0] REGS_WRITE [16];
	
	reg [11:0] DBC;	// Byte counter for transfer
	reg [15:0] DAC;	// Transfer address - Can ignore ? Should always be set to 0000
	//reg [15:0] PT;	// Pointer to start of data block - Can always be 0004 ?
							// System ROM subtracts 4 to ignore MSF/Mode header
	reg [15:0] WA;		// Unused on Neo CD ?
	reg nDTBSY, nSTBSY, nDTEN, nSTEN, nVALST;
	reg [7:0] HEAD [4];
	
	// Bunch of decoder and error detection/correction flags which could be hardcoded
	// Can't have CD errors if there's no CD !
	reg CMDI_FLAG, DTEI_FLAG, DECI_FLAG;
	reg CMDIEN, DTEIEN, DECIEN, nCMDBRK, nDTWAI, nSTWAI, DOUTEN, SOUTEN;
	reg DTTRG;
	reg DECEN, EDCRQ, E01RQ, AUTORQ, ERAMRQ, WRRQ, QRQ, PRQ;
	reg SYIEN, SYDEN, DSCREN, COWREN, MODRQ, FORMRQ, SHDREN;
	
	reg nWR_PREV, nRD_PREV;
	reg SECTOR_READY_PREV, DMA_RUNNING_PREV, MSF_LATCH_PREV;
	
	// TODO: Should this be clocked with clk_sys ?
	always @(negedge CLK_12M or negedge nRESET)
	begin
		if (!nRESET)
		begin
			AR <= 4'd0;
			nWR_PREV <= 1;
			nRD_PREV <= 1;
			
			CDC_nIRQ <= 1;
			
			DBC <= 12'h000;
			DAC <= 16'h0000;
			//PT <= 16'h0000;
			WA <= 16'h0000;
			
			CMDI_FLAG <= 0;
			DTEI_FLAG <= 0;
			DECI_FLAG <= 0;
			nDTBSY <= 1;
			nSTBSY <= 1;
			nDTEN <= 1;
			nSTEN <= 1;
			
			HEAD[0] <= 8'h00;
			HEAD[1] <= 8'h00;
			HEAD[2] <= 8'h00;
			HEAD[3] <= 8'h00;
			
			nVALST <= 1;
			
			{CMDIEN, DTEIEN, DECIEN, nCMDBRK, nDTWAI, nSTWAI, DOUTEN, SOUTEN} <= 8'b00000000;
			DTTRG <= 0;
			{DECEN, EDCRQ, E01RQ, AUTORQ, ERAMRQ, WRRQ, QRQ, PRQ} <= 8'b00000000;
			{SYIEN, SYDEN, DSCREN, COWREN, MODRQ, FORMRQ, SHDREN} <= 7'b0000000;
			
			SECTOR_READY_PREV <= 0;
			DMA_RUNNING_PREV <= 0;
		end
		else
		begin
			SECTOR_READY_PREV <= SECTOR_READY;
			DMA_RUNNING_PREV <= DMA_RUNNING;
			MSF_LATCH_PREV <= MSF_LATCH;
			
			// Rising edge of SECTOR_READY: Set decoder IRQ flag
			if (~SECTOR_READY_PREV & SECTOR_READY)
			begin
				DECI_FLAG <= 1;
				nVALST <= 0;
			end
			
			// Falling edge of DMA_RUNNING: Set transfer end IRQ flag
			if (DMA_RUNNING_PREV & ~DMA_RUNNING)
				DTEI_FLAG <= 1;
			
			// Rising edge of MSF_LATCH
			if (~MSF_LATCH_PREV & MSF_LATCH)
			begin
				HEAD[0] <= MSF_M;
				HEAD[1] <= MSF_S;
				HEAD[2] <= MSF_F;
				//HEAD[3] <= 8'h01;
			end
			
			CDC_nIRQ <= ~|{(CMDI_FLAG & CMDIEN), (DTEI_FLAG & DTEIEN), (DECI_FLAG & DECIEN)};
		
			nWR_PREV <= nWR;
			nRD_PREV <= nRD;
			
			if (nWR_PREV & ~nWR)
			begin
				// Write
				if (~RS)
					AR <= DIN[3:0];
				else
				begin
					case(AR)
						4'd0:;	// COMIN - Is the command system used at all ?
						4'd1: {CMDIEN, DTEIEN, DECIEN, nCMDBRK, nDTWAI, nSTWAI, DOUTEN, SOUTEN} <= DIN;	// IFCTRL
						
						4'd2: DBC[7:0] <= DIN;		// DBCL - Data transfer byte counter
						4'd3: DBC[11:8] <= DIN[3:0];	// DBCH
						
						4'd4: DAC[7:0] <= DIN;		// DACL
						4'd5: DAC[15:8] <= DIN;		// DACH
						4'd6: DTTRG <= 1;
						4'd7: DTEI_FLAG <= 0;		// DTACK - Clears the transfer end IRQ flag
						
						4'd8: WA[7:0] <= DIN;		// WAL
						4'd9: WA[15:8] <= DIN;		// WAH
			
						4'd10: {DECEN, EDCRQ, E01RQ, AUTORQ, ERAMRQ, WRRQ, QRQ, PRQ} <= DIN;	// CTRL0
						4'd11: {SYIEN, SYDEN, DSCREN, COWREN, MODRQ, FORMRQ, SHDREN} <= {DIN[7:2], DIN[0]};	// CTRL1
						
						4'd12:; //PT[7:0] <= DIN;		// PTL
						4'd13:; //PT[15:8] <= DIN;		// PTH
						4'd14:;
						4'd15:;	// RESET - Unused ?
					endcase
					
					// Auto-inc if AR is nonzero
					if (|{AR})
						AR <= AR + 1'b1;
				end
			end
			else if (nRD_PREV & ~nRD)
			begin
				// Read
				if (~RS)
					DOUT <= {4'b0000, AR};
				else
				begin
					case(AR)
						4'd0: DOUT <= 8'b00000000;	// SBOUT - Is the command system used at all ?
						4'd1: DOUT <= {~CMDI_FLAG, ~DTEI_FLAG, ~DECI_FLAG, 1'b1, nDTBSY, nSTBSY, nDTEN, nSTEN};	// IFSTAT
						
						4'd2: DOUT <= DBC[7:0];		// DBCL - Data transfer byte counter
						4'd3: DOUT <= {{4{DTEI_FLAG}}, DBC[11:8]};	// DBCH
						
						4'd4: DOUT <= HEAD[0];
						4'd5: DOUT <= HEAD[1];
						4'd6: DOUT <= HEAD[2];
						4'd7: DOUT <= 8'h01;		//HEAD[3]; CD-ROM mode, always 1
						
						4'd8: DOUT <= 8'h04;	//PT[7:0];		// PTL
						4'd9: DOUT <= 8'h00;	//PT[15:8];		// PTH
			
						4'd10: DOUT <= WA[7:0];		// WAL - Datasheet says these are undefined after reset
						4'd11: DOUT <= WA[15:8];	// WAH
						
						4'd12: DOUT <= 8'b10000000;	// STAT0 - CRC OK
						4'd13: DOUT <= 8'b00000000;	// STAT1
						4'd14: DOUT <= 8'b00000000;	// STAT2 - MODE, FORM (Mode 1)
						4'd15:
						begin
							DOUT <= {nVALST, 7'b0000000};	// STAT3 - Reading clears the decoder IRQ
							DECI_FLAG <= 0;
						end
					endcase
				
					// Auto-inc if AR is nonzero
					if (|{AR})
						AR <= AR + 1'b1;
				end
			end
		end
	end
	
endmodule
