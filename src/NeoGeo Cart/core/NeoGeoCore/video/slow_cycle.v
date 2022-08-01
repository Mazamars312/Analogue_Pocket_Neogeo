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

// Slow VRAM is 120ns (3mclk or more, probably 3.5mclk)

module slow_cycle(
	input CLK_24M,
	input CLK_24MB,
	input LSPC_12M,
	input LSPC_6M,
	input LSPC_3M,
	input LSPC_1_5M,
	input RESETP,
	input [14:0] VRAM_ADDR,
	input [15:0] VRAM_WRITE,
	input REG_VRAMADDR_MSB,
	input PIXEL_H8,
	input PIXEL_H256,
	input [7:3] RASTERC,
	input [3:0] PIXEL_HPLUS,
	input [7:0] ACTIVE_RD,
	input nVRAM_WRITE_REQ,
	input [3:0] SPR_TILEMAP,
	output SPR_TILE_VFLIP,
	output SPR_TILE_HFLIP,
	output SPR_AA_3, SPR_AA_2,
	output [11:0] FIX_TILE,
	output [3:0] FIX_PAL,
	output [19:0] SPR_TILE,
	output [7:0] SPR_PAL,
	output [15:0] VRAM_LOW_READ,
	output nCPU_WR_LOW,
	input R91_nQ,
	output CLK_CPU_READ_LOW,
	output T160A_OUT,
	output T160B_OUT,
	input CLK_ACTIVE_RD,
	input ACTIVE_RD_PRE8,
	output Q174B_OUT,
	input D208B_OUT,
	input SPRITEMAP_ADDR_MSB,
	input CLK_SPR_TILE,
	input P222A_OUT,
	input P210A_OUT,
	
	output [14:0] SVRAM_ADDR,
	//input [15:0] SVRAM_DATA,
	input [15:0] SVRAM_DATA_IN,
	output [15:0] SVRAM_DATA_OUT,
	output BOE, BWE,
	
	output [14:0] FIXMAP_ADDR		// Extracted for NEO-CMC
);

	wire [14:0] B;
	wire [15:0] E;
	wire [15:0] FIX_MAP_READ;
	//wire [14:0] FIXMAP_ADDR;
	wire [14:0] SPRMAP_ADDR;
	wire [3:0] D233_Q;
	wire [3:0] D283_Q;
	wire [3:0] Q162_Q;
	
	assign SVRAM_ADDR = B;
	assign E = SVRAM_DATA_IN;
	assign SVRAM_DATA_OUT = VRAM_WRITE;

	// CPU read
	// H251 F269 F250 D214
	FDS16bit H251(~CLK_CPU_READ_LOW, SVRAM_DATA_IN, VRAM_LOW_READ);

	// Fix map read
	// E233 C269 B233 B200
	FDS16bit E233(Q174B_OUT, SVRAM_DATA_IN, FIX_MAP_READ);
	assign FIX_TILE = FIX_MAP_READ[11:0];
	FDSCell E251(~CLK_SPR_TILE, FIX_MAP_READ[15:12], FIX_PAL);
	
	// Sprite map read even
	// H233 C279 B250 C191
	FDS16bit H233(~CLK_SPR_TILE, SVRAM_DATA_IN, SPR_TILE[15:0]);
	
	// Sprite map read even
	// D233 D283 A249 C201
	FDS16bit D233(D208B_OUT, SVRAM_DATA_IN, {D233_Q, D283_Q, SPR_TILE[19:16], SPR_AA_3, SPR_AA_2, SPR_TILE_VFLIP, SPR_TILE_HFLIP});
	FDSCell C233(Q174B_OUT, D233_Q, SPR_PAL[7:4]);
	FDSCell D269(Q174B_OUT, D283_Q, SPR_PAL[3:0]);
	
	//assign E = VRAM_LOW_WRITE ? VRAM_WRITE : 16'bzzzzzzzzzzzzzzzz;
	
	// BOE and BWE outputs
	wire Q220_Q, R287A_OUT, R289_nQ;
	FD2 Q220(CLK_24MB, nCPU_WR_LOW, Q220_Q, BOE);
	FD2 R289(LSPC_12M, R287A_OUT, BWE, R289_nQ);
	assign R287A_OUT = Q220_Q | R289_nQ;
	//assign VRAM_LOW_WRITE = ~BWE;
	
	
	// Address mux
	// E54A F34 F30A
	// F39A J31A H39A H75A
	// F206A I75A E146A N177
	// N179A N182 N172A K169A
	assign B = ~N165_nQ ?
					~N160_Q ? SPRMAP_ADDR : 15'd0
					:
					~N160_Q ? FIXMAP_ADDR : VRAM_ADDR;
	
	assign FIXMAP_ADDR = {4'b1110, O62_nQ, PIXEL_HPLUS, ~PIXEL_H8, RASTERC[7:3]};
	assign SPRMAP_ADDR = {H57_Q, ACTIVE_RD, O185_Q, SPR_TILEMAP, K166_Q};
	
	wire O185_Q, H57_Q, K166_Q, N165_nQ, N169A_OUT, N160_Q;
	FDM O185(P222A_OUT, SPRITEMAP_ADDR_MSB, O185_Q);
	FDM H57(CLK_ACTIVE_RD, ACTIVE_RD_PRE8, H57_Q);
	FDM K166(CLK_24M, P210A_OUT, K166_Q);
	FDM N165(CLK_24M, Q174B_OUT, , N165_nQ);
	FDM N160(CLK_24M, N169A_OUT, N160_Q);
	
	FS1 Q162(LSPC_12M, R91_nQ, Q162_Q);
	assign Q174B_OUT = ~Q162_Q[3];
	assign N169A_OUT = ~|{Q174B_OUT, ~CLK_CPU_READ_LOW};
	
	wire T75_Q, O62_Q, O62_nQ;
	FDM T75(CLK_24M, T64A_OUT, T75_Q);
	assign CLK_CPU_READ_LOW = Q162_Q[1];
	assign T160B_OUT = ~|{T75_Q, ~Q162_Q[0]};
	assign T160A_OUT = ~|{Q162_Q[0], T75_Q};
	wire T64A_OUT = ~&{LSPC_12M, LSPC_6M, LSPC_3M};
	
	FDPCell O62(PIXEL_H8, PIXEL_H256, 1'b1, RESETP, O62_Q, O62_nQ);
	
	wire F58B_OUT = REG_VRAMADDR_MSB | nVRAM_WRITE_REQ;
	FDPCell Q106(~LSPC_1_5M, F58B_OUT, CLK_CPU_READ_LOW, 1'b1, nCPU_WR_LOW);
	
	
	//vram_slow_u VRAMLU(B, E[15:8], 1'b0, BOE, BWE);
	//vram_slow_l VRAMLL(B, E[7:0], 1'b0, BOE, BWE);

endmodule
