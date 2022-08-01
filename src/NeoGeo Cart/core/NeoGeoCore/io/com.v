//============================================================================
//  SNK NeoGeo for MiSTer
//
//  Copyright (C) 2019 Sean 'Furrtek' Gonsalves
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

// This simulates the COM MCU idle reply to make Riding Hero run at normal speed

module com(
	input nRESET,
	input CLK_24M,
	input nPORTOEL,
	input nPORTOEU,
	input nPORTWEL,
	output [15:0] M68K_DIN
);

reg nPORTWEL_PREV, TOGGLE_BIT;

assign M68K_DIN[15:8] = nPORTOEU ? 8'bzzzzzzzz : {4'b0000, TOGGLE_BIT ,3'b000};
assign M68K_DIN[7:0] = nPORTOEL ? 8'bzzzzzzzz : 8'h00;

always @(posedge CLK_24M)
begin
	if (!nRESET)
	begin
		TOGGLE_BIT <= 1'b0;
	end
	else
	begin
		nPORTWEL_PREV <= nPORTWEL;
		
		// Detect rising edge of nPORTWEL
		if (~nPORTWEL_PREV & nPORTWEL)
			TOGGLE_BIT <= ~TOGGLE_BIT;
	end
end

endmodule
