// NeoGeo logic definition
// Copyright (C) 2018 Sean Gonsalves
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

module linebuffer(
	//input TEST_MODE,
	//input [7:0] GBD,
	input CLK,
	input CK,
	input WE,
	input LOAD,
	input CLEARING,
	input [3:0] COLOR_INDEX,
	input PCK2,
	input [7:0] SPR_PAL,
	input [7:0] ADDR_LOAD,
	output [11:0] DATA_OUT
);
	// 192 pixels * 12 bits
	//reg [11:0] LB_RAM[0:255];	// TODO: Add a check, should never go over 191
	reg [7:0] PAL_REG;
	reg [7:0] ADDR_COUNTER;
	reg [7:0] ADDR_LATCH;
	wire [7:0] ADDR_MUX;
	wire [11:0] DATA_IN;
	wire [3:0] COLOR_GATED;
	
	// Switch between color index or backdrop clear
	// BL: NUDE NOSY...
	// BR: NEGA NACO...
	// TL: MOZA MAKO...
	// TR: NUDE NOSY...
	assign COLOR_GATED = COLOR_INDEX | {4{CLEARING}};
	
	// Select color index or test data (unused)
	// BL: NODO NUJA...
	// BR: NOFA NYKO...
	// TL: MAPE MUCA...
	// TR: LANO LODO...
	assign DATA_IN[3:0] = COLOR_GATED;	// TEST_MODE ? GBD : COLOR_GATED;
	
	// Latch sprite palette from P bus
	// BL: MANA NAKA...
	// BR: MESY NEPA...
	// TL: JETU JUMA...
	// TR: GENA HARU...
	always @(posedge PCK2)
		PAL_REG <= SPR_PAL;
	
	// Switch between sprite palette or backdrop clear
	// BL: MORA NOKU...
	// BR: MECY NUXA...
	// TL: JEZA JODE...
	// TR: GUSU HYKU...
	assign DATA_IN[11:4] = PAL_REG | {8{CLEARING}};
	
	// Switch between address inc or address reload
	// BL: RUFY QAZU...
	// BR: PECU QUNY...
	// TL: BAME CUNU...
	// TR: EGED DUGA...
	assign ADDR_MUX = LOAD ? (ADDR_COUNTER + 1'b1) : ADDR_LOAD;

	// Address counter update
	// BL: REVA QEVU...
	// BR: PAJE QATA...
	// TL: BEWA CENA...
	// TR: EPAQ DAFU...
	always @(posedge CK)
		ADDR_COUNTER <= ADDR_MUX;
	
	// Address counter latch
	// BL: NACY OKYS...
	// BR: PEXU QUVU...
	// TL: ERYV ENOG...
	// TR: EDYZ ASYX...
	always @(posedge CLK) if(WE) ADDR_LATCH <= ADDR_COUNTER;

	spram #(8,12) UR(
		.clock(CLK),
		.address(ADDR_LATCH),
		.data(DATA_IN),
		.wren(~WE),
		.q(DATA_OUT)
	);

endmodule
