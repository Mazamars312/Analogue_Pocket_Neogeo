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

module lspc_regs(
	input RESET,
	input RESETP,
	
	input [3:1] M68K_ADDR,
	input [15:0] M68K_DATA,
	
	input LSPOE,
	input LSPWE,
	
	input VMODE,
	input [8:0] RASTERC,
	input [2:0] AA_COUNT,
	input [15:0] VRAM_LOW_READ,
	input [15:0] VRAM_HIGH_READ,
	
	
	output WR_VRAM_ADDR,
	output WR_VRAM_RW,
	output WR_TIMER_HIGH,
	output WR_TIMER_LOW,
	output WR_IRQ_ACK,
	
	output [15:0] REG_VRAMADDR,
	output [15:0] REG_VRAMMOD,
	output [15:0] REG_VRAMRW,
	output [15:0] REG_LSPCMODE,
	output [15:0] CPU_DATA_OUT,
	output [7:0] AA_SPEED,			// Auto-animation speed
	output [2:0] TIMER_MODE,		// Timer mode
	output TIMER_IRQ_EN,				// Timer interrupt enable
	output AA_DISABLE,				// Auto-animation disable
	output TIMER_STOP,
	output nVRAM_WRITE_REQ,
	input D112B_OUT
);

	reg [7:0] WR_DECODED /* synthesis keep */;		// DEBUG
	wire [15:0] CPU_DATA_MUX;
	
	// CPU address decode
	// C27
	always @(*)
	begin
		if (~LSPWE)
		begin
			case (M68K_ADDR)
				3'h0 : WR_DECODED <= 8'b11111110;
				3'h1 : WR_DECODED <= 8'b11111101;
				3'h2 : WR_DECODED <= 8'b11111011;
				3'h3 : WR_DECODED <= 8'b11110111;
				3'h4 : WR_DECODED <= 8'b11101111;
				3'h5 : WR_DECODED <= 8'b11011111;
				3'h6 : WR_DECODED <= 8'b10111111;
				3'h7 : WR_DECODED <= 8'b01111111;
			endcase
		end
		else
			WR_DECODED <= 8'b11111111;
	end
	
	assign WR_VRAM_ADDR = WR_DECODED[0];
	assign WR_VRAM_RW = WR_DECODED[1];
	wire WR_VRAM_MOD = WR_DECODED[2];
	wire WR_LSPC_MODE = WR_DECODED[3];
	assign WR_TIMER_HIGH = WR_DECODED[4];
	assign WR_TIMER_LOW = WR_DECODED[5];
	assign WR_IRQ_ACK = WR_DECODED[6];
	wire WR_TIMER_STOP = WR_DECODED[7];
	
	
	// CPU reads
	assign REG_LSPCMODE = {RASTERC, 3'b0, VMODE, AA_COUNT};
	
	// Read:                CPU_READ_SW:
	// $3C0000 REG_VRAMRW   REG_VRAMADDR_MSB
	// $3C0002 REG_VRAMRW   REG_VRAMADDR_MSB
	// $3C0004 REG_VRAMMOD  0
	// $3C0006 REG_LSPCMODE 1
	// C20A C22B C20B
	wire CPU_READ_SW = ~|{~|{M68K_ADDR[1], ~M68K_ADDR[2]}, ~|{REG_VRAMADDR[15], M68K_ADDR[2]}};
	
	// CPU read data select
	// F218A F221A F230 G252A
	// K172 F235 F232 G250
	// G274 G276A G267A H266A
	// I250A I253 I255A H264
	assign CPU_DATA_MUX = M68K_ADDR[2] ?
							CPU_READ_SW ? REG_LSPCMODE : REG_VRAMMOD
							:
							CPU_READ_SW ? VRAM_HIGH_READ : VRAM_LOW_READ;
	
	// CPU read data latch
	// B138 A123 A68 A28
	FDS16bit B138(~LSPOE, CPU_DATA_MUX, CPU_DATA_OUT);


	// CPU write to REG_VRAMRW
	// F155 D131 D121 E154
	FDS16bit F155(~WR_VRAM_RW, M68K_DATA, REG_VRAMRW);

	// CPU VRAM write request flag handling
	// Set by write to REG_VRAMRW, reset when write is done or write to REG_VRAMADDR
	wire D32A_OUT = D28_nQ & 1'b1;	// Used for test mode
	wire D38_Q, D28_nQ;
	FDPCell D38(~WR_VRAM_RW, 1'b1, 1'b1, D32A_OUT, D38_Q, nVRAM_WRITE_REQ);
	FDPCell D28(D112B_OUT, 1'b1, 1'b1, D38_Q, , D28_nQ);
	
	// CPU write to REG_VRAMMOD
	// H105 G105 F81 G123
	FDS16bit H105(~WR_VRAM_MOD, M68K_DATA, REG_VRAMMOD);
	
	// CPU write to REG_VRAMADDR
	// F47 D87 A79 C123
	FDS16bit F47(~WR_VRAM_ADDR, M68K_DATA, REG_VRAMADDR);

	// CPU write to REG_LSPCMODE
	FDSCell E105(WR_LSPC_MODE, M68K_DATA[15:12], AA_SPEED[7:4]);
	FDSCell C87(WR_LSPC_MODE, M68K_DATA[11:8], AA_SPEED[3:0]);
	FDPCell E74(WR_LSPC_MODE, M68K_DATA[7], 1'b1, RESET, TIMER_MODE[2]);
	FDRCell E61(WR_LSPC_MODE, M68K_DATA[6:3], RESET, {TIMER_MODE[1:0], TIMER_IRQ_EN, AA_DISABLE});
	
	// CPU write to REG_TIMERSTOP
	FDPCell D34(WR_TIMER_STOP, M68K_DATA[0], RESETP, 1'b1, , TIMER_STOP);

endmodule
