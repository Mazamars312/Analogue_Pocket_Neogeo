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

module c1_regs(
	input nICOM_ZONE,
	input RW,
	inout [15:8] M68K_DATA,
	output [7:0] SDD_RD,
	input [7:0] SDD_WR,
	input nSDZ80R, nSDZ80W, nSDZ80CLR,
	output nSDW
);

	reg [7:0] SDD_LATCH_CMD;
	reg [7:0] SDD_LATCH_REP;
	
	// Z80 command read
	assign SDD_RD = SDD_LATCH_CMD;	//nSDZ80R ? 8'bzzzzzzzz : SDD_LATCH_CMD;
	
	// Z80 reply write
	always @(posedge nSDZ80W)
		SDD_LATCH_REP <= SDD_WR;
	
	// REG_SOUND read
	assign M68K_DATA = (RW & ~nICOM_ZONE) ? SDD_LATCH_REP : 8'bzzzzzzzz;
	
	// REG_SOUND write
	assign nSDW = (RW | nICOM_ZONE);		// Tells Z80 that 68k sent a command
	
	// REG_SOUND write
	always @(negedge nICOM_ZONE or negedge nSDZ80CLR)		// Which one has priority ?
	begin
		if (!nSDZ80CLR)
		begin
			SDD_LATCH_CMD <= 8'b00000000;
		end
		else
		begin
			if (!RW)
				SDD_LATCH_CMD <= M68K_DATA;
		end
	end
	
endmodule
