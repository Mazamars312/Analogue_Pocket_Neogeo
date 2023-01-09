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

module c1_wait(
	input CLK_68KCLK, nAS,
	input SYSTEM_CDx,
	input nROM_ZONE, nWRAM_ZONE, nPORT_ZONE, nCARD_ZONE, nSROM_ZONE,
	input nROMWAIT, nPWAIT0, nPWAIT1, PDTACK,
	output nDTACK
);

	reg [2:0] WAIT_CNT;
	
	//assign nPDTACK = ~(nPORT_ZONE | PDTACK);		// Really a NOR ? May stall CPU if PDTACK = GND
	
	assign nDTACK = nAS | WAIT_MUX;
	
	// When nROMWAIT == 1, nDTACK = nAS for nROM_ZONE (no wait)
	wire WAIT_MUX = (!nROM_ZONE & !nROMWAIT) ? (WAIT_CNT > 3) :
			// Fix by paulb-nl -09/01/2023
			(!nPORT_ZONE & ( nPWAIT1 & !nPWAIT0)) ? (WAIT_CNT > 3) :
			(!nPORT_ZONE & (!nPWAIT1 &  nPWAIT0)) ? (WAIT_CNT > 2) :
			(!nCARD_ZONE) ? (WAIT_CNT > 3) :		// Maybe 2 but not important here, used JEIDA compliance
			1'b0;
	
	always @(posedge CLK_68KCLK)
	begin
		if (!nAS)
		begin
			if (WAIT_CNT)
				WAIT_CNT <= WAIT_CNT - 1'b1;
		end
		else
		begin
			WAIT_CNT <= 5;
		end
	end
	
endmodule
