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

module backup(
	input CLK_24M,
	input [15:1] M68K_ADDR,
	input nBWL, nBWU,
	input [15:0] M68K_DATA,
	output [15:0] SRAM_OUT,
	input clk_sys,
	input [14:0] sram_addr,
	input sram_wr,
	input [15:0] sd_buff_dout,
	output [15:0] sd_buff_din_sram
);

	dpram #(.ADDRWIDTH(15)) SRAML(
		.clock_a(CLK_24M),
		.address_a(M68K_ADDR[15:1]),
		.wren_a(~nBWL),
		.data_a(M68K_DATA[7:0]),
		.q_a(SRAM_OUT[7:0]),
		
		.clock_b(clk_sys),
		.address_b(sram_addr),
		.wren_b(sram_wr),
		.data_b(sd_buff_dout[7:0]),
		.q_b(sd_buff_din_sram[7:0])
	);
	
	dpram #(.ADDRWIDTH(15)) SRAMU(
		.clock_a(CLK_24M),
		.address_a(M68K_ADDR[15:1]),
		.wren_a(~nBWU),
		.data_a(M68K_DATA[15:8]),
		.q_a(SRAM_OUT[15:8]),

		.clock_b(clk_sys),
		.address_b(sram_addr),
		.wren_b(sram_wr),
		.data_b(sd_buff_dout[15:8]),
		.q_b(sd_buff_din_sram[15:8])
	);
	
endmodule
