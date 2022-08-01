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

module memcard(
	input CLK_24M,
	input SYSTEM_CDx, 
	input [12:0] CDA,
	input CARD_WE,
	input [7:0] M68K_DATA,
	output [7:0] CDD,
	input clk_sys,
	input [11:0] memcard_addr,
	input memcard_wr,
	input [15:0] sd_buff_dout,
	output [15:0] sd_buff_din_memcard
);

	wire [7:0] CDD_L;
	wire [7:0] CDD_U;
	
	wire [11:0] CDA_MASKED = SYSTEM_CDx ? CDA[12:1] : {2'b00, CDA[10:1]};
	
	// Split the 8kB 8-bit memory card into two 1kB dual-port RAMs so the HPS
	// can access it in 16-bits. The lower address bit (CDA[0]) selects which
	// one is accessed from the NeoGeo side. The HPS always accesess in words.
	// In cart mode, there's one 2kB memory card for each game.
	// In CD mode, there's one 8kB memory card for all games.
	dpram #(.ADDRWIDTH(12)) MEMCARDL(
		.clock_a(CLK_24M),
		.address_a(CDA_MASKED),
		.wren_a(CARD_WE & CDA[0]),
		.data_a(M68K_DATA),
		.q_a(CDD_L),
		
		.clock_b(clk_sys),
		.address_b(memcard_addr),
		.wren_b(memcard_wr),
		.data_b(sd_buff_dout[7:0]),
		.q_b(sd_buff_din_memcard[7:0])
	);
	
	dpram #(.ADDRWIDTH(12)) MEMCARDU(
		.clock_a(CLK_24M),
		.address_a(CDA_MASKED),
		.wren_a(CARD_WE & ~CDA[0]),
		.data_a(M68K_DATA),
		.q_a(CDD_U),
		
		.clock_b(clk_sys),
		.address_b(memcard_addr),
		.wren_b(memcard_wr),
		.data_b(sd_buff_dout[15:8]),
		.q_b(sd_buff_din_memcard[15:8])
	);
	
	assign CDD = CDA[0] ? CDD_L : CDD_U;
	
endmodule
