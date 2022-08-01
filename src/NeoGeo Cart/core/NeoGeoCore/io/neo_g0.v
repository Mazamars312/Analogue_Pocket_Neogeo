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

module neo_g0(
	output [15:0] M68K_DATA,
	input G0, G1,
	input DIR,
	input [15:0] CDD,
	input [15:0] PC,
	output WE
);

	// G0 G1 DIR												M68K_DATA	CDD		PC			WE
	// 0  0  0   Should not happen, write to both	hi-z			active	active	0
	// 0  0  1   Should not happen, read memcard ?	active		hi-z		hi-z		1
	// 0  1  0   Write to memcard							hi-z			active	hi-z		1
	// 0  1  1   Read from memcard						active		hi-z		hi-z		1
	// 1  0  0   Write to palette							hi-z			hi-z		active	0
	// 1  0  1   Read from palette						active		hi-z		hi-z		1
	// 1  1  0   Do nothing									hi-z			hi-z		hi-z		1
	// 1  1  1   Do nothing									hi-z			hi-z		hi-z		1
	
	wire [15:0] READ_DATA = G0 ? PC : CDD;
	assign M68K_DATA = (~(G0 & G1) & DIR) ? READ_DATA : 16'bzzzzzzzz_zzzzzzzz;
	
	assign WE = G1 | DIR;
	
	// CDD output is done in the higher-level module
	//assign CDD = G0 | DIR ? 16'bzzzzzzzz_zzzzzzzz : M68K_DOUT;
	
	// PC output is done in the higher-level module
	//assign PC = WE ? 16'bzzzzzzzz_zzzzzzzz : M68K_DOUT;
	
endmodule
