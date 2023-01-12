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
	output reg [7:0] CDD,
	input clk_sys,
	input [12:0] memcard_addr,
	input memcard_wr,
	input [31:0] sd_buff_dout,
	output [31:0] sd_buff_din_memcard
);
	
wire [12:0] CDA_MASKED = SYSTEM_CDx ? CDA[12:0] : {2'b00, CDA[10:0]};

wire [7:0] CDD_7, CDD_15, CDD_23, CDD_31;
	
Mem_card_APF Mem_card_APF_1 (
	.clock_a		(CLK_24M),
	.address_a	(CDA_MASKED[12:2]),
	.wren_a		((CARD_WE && (CDA_MASKED[1:0] == 0))),
	.data_a		(M68K_DATA),
	.q_a			(CDD_7),
	
	.clock_b		(clk_sys),
	.address_b	(memcard_addr[12:2]),
	.wren_b		(memcard_wr),
	.data_b		(sd_buff_dout[7:0]),
	.q_b			(sd_buff_din_memcard[7:0]));

Mem_card_APF Mem_card_APF_2 (
	.clock_a		(CLK_24M),
	.address_a	(CDA_MASKED[12:2]),
	.wren_a		((CARD_WE && (CDA_MASKED[1:0] == 1))),
	.data_a		(M68K_DATA),
	.q_a			(CDD_15),
	
	.clock_b		(clk_sys),
	.address_b	(memcard_addr[12:2]),
	.wren_b		(memcard_wr),
	.data_b		(sd_buff_dout[15:8]),
	.q_b			(sd_buff_din_memcard[15:8]));

Mem_card_APF Mem_card_APF_3 (
	.clock_a		(CLK_24M),
	.address_a	(CDA_MASKED[12:2]),
	.wren_a		((CARD_WE && (CDA_MASKED[1:0] == 2))),
	.data_a		(M68K_DATA),
	.q_a			(CDD_23),
	
	.clock_b		(clk_sys),
	.address_b	(memcard_addr[12:2]),
	.wren_b		(memcard_wr),
	.data_b		(sd_buff_dout[23:16]),
	.q_b			(sd_buff_din_memcard[23:16]));
	
Mem_card_APF Mem_card_APF_4 (
	.clock_a		(CLK_24M),
	.address_a	(CDA_MASKED[12:2]),
	.wren_a		((CARD_WE && (CDA_MASKED[1:0] == 3))),
	.data_a		(M68K_DATA),
	.q_a			(CDD_31),
	
	.clock_b		(clk_sys),
	.address_b	(memcard_addr[12:2]),
	.wren_b		(memcard_wr),
	.data_b		(sd_buff_dout[31:24]),
	.q_b			(sd_buff_din_memcard[31:24]));
	
always @* begin
	case (CDA_MASKED[1:0])
		2'b11 	: CDD <= CDD_31;
		2'b10 	: CDD <= CDD_23;
		2'b01 	: CDD <= CDD_15;
		default 	: CDD <= CDD_7;
	endcase
end
	
endmodule
