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

module c1_inputs(
	input nCTRL1_ZONE,
	input nCTRL2_ZONE,
	input nSTATUSB_ZONE,
	output [15:8] M68K_DATA,
	input [9:0] P1_IN,
	input [9:0] P2_IN,
	input nWP, nCD2, nCD1,
	input SYSTEM_TYPE
);

	// REG_P1CNT
	assign M68K_DATA[15:8] = nCTRL1_ZONE ? 8'bzzzzzzzz : P1_IN[7:0];
	// REG_P2CNT
	assign M68K_DATA[15:8] = nCTRL2_ZONE ? 8'bzzzzzzzz : P2_IN[7:0];
	
	// REG_STATUS_B
	assign M68K_DATA[15:8] = nSTATUSB_ZONE ? 8'bzzzzzzzz : {SYSTEM_TYPE, nWP, nCD2, nCD1, P2_IN[9:8], P1_IN[9:8]};
	
endmodule
