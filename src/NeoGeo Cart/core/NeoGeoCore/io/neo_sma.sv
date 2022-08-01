//============================================================================
//  NEO-SMA
//
//  Copyright (C) 2019 Alexey Melnikov
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

module neo_sma
(
	input         nRESET,
	input         CLK_24M,

	input  [19:1] M68K_ADDR,
	inout  [15:0] M68K_DATA,
	input  [15:0] PROM_DATA,
	input         nPORTOEL, nPORTOEU,
	input         nPORTWEL, nPORTWEU,

	input   [2:0] TYPE,
	output [23:0] P2_ADDR
);

assign P2_ADDR = ENABLE ? bank + {M68K_ADDR,1'b0} : 24'bZ;

wire ENABLE   = (TYPE>=3);
wire BANK_SEL = (M68K_ADDR == BANK_ADDR);
wire ID_SEL   = (M68K_ADDR == 'h7F223);
wire RNG_SEL  = (M68K_ADDR == RNG_ADDR1 || M68K_ADDR == RNG_ADDR2);

reg [19:1] BANK_ADDR, RNG_ADDR1, RNG_ADDR2;
always @(posedge CLK_24M) begin
	case(TYPE)
		3: begin // kof99
				BANK_ADDR <= 'h7FFF8;
				RNG_ADDR1 <= 'h7FFFC;
				RNG_ADDR2 <= 'h7FFFD;
			end
		4,
		5: begin // garou,garouh
				BANK_ADDR <= 'h7FFE0;
				RNG_ADDR1 <= 'h7FFE6;
				RNG_ADDR2 <= 'h7FFF8;
			end
		6: begin // mslug3
				BANK_ADDR <= 'h7FFF2;
				//mslug3 has no RNG. (?)
				RNG_ADDR1 <= 'h7F223;
				RNG_ADDR2 <= 'h7F223;
			end
		7: begin // kof2000
				BANK_ADDR <= 'h7FFF6;
				RNG_ADDR1 <= 'h7FFEC;
				RNG_ADDR2 <= 'h7FFED;
			end
	endcase
end

assign M68K_DATA[7:0]  = (nPORTOEL | ~ENABLE) ? 8'bZ : ID_SEL ? 8'h37 : RNG_SEL ? rng[7:0]  : PROM_DATA[7:0];
assign M68K_DATA[15:8] = (nPORTOEU | ~ENABLE) ? 8'bZ : ID_SEL ? 8'h9A : RNG_SEL ? rng[15:8] : PROM_DATA[15:8];

wire nPORTWE = nPORTWEL & nPORTWEU;
wire nPORTOE = nPORTOEL & nPORTOEU;

////////////////////////////////////////////////////

wire [23:0] kof99_map[64] =
'{
	'h000000, 'h100000, 'h200000, 'h300000,
	'h3cc000, 'h4cc000, 'h3f2000, 'h4f2000,
	'h407800, 'h507800, 'h40d000, 'h50d000,
	'h417800, 'h517800, 'h420800, 'h520800,
	'h424800, 'h524800, 'h429000, 'h529000,
	'h42e800, 'h52e800, 'h431800, 'h531800,
	'h54d000, 'h551000, 'h567000, 'h592800,
	'h588800, 'h581800, 'h599800, 'h594800,
	'h598000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000, 
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000
};

wire [5:0] kof99_idx = {M68K_DATA[5],M68K_DATA[12],M68K_DATA[10],M68K_DATA[8],M68K_DATA[6],M68K_DATA[14]};
////////////////////////////////////////////////////

wire [23:0] garou_map[64] =
'{
	'h000000, 'h100000, 'h200000, 'h300000,
	'h280000, 'h380000, 'h2d0000, 'h3d0000,
	'h2f0000, 'h3f0000, 'h400000, 'h500000,
	'h420000, 'h520000, 'h440000, 'h540000,
	'h498000, 'h598000, 'h4a0000, 'h5a0000,
	'h4a8000, 'h5a8000, 'h4b0000, 'h5b0000,
	'h4b8000, 'h5b8000, 'h4c0000, 'h5c0000,
	'h4c8000, 'h5c8000, 'h4d0000, 'h5d0000,
	'h458000, 'h558000, 'h460000, 'h560000,
	'h468000, 'h568000, 'h470000, 'h570000,
	'h478000, 'h578000, 'h480000, 'h580000,
	'h488000, 'h588000, 'h490000, 'h590000,
	'h5d0000, 'h5d8000, 'h5e0000, 'h5e8000,
	'h5f0000, 'h5f8000, 'h600000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000 
};

wire [5:0] garou_idx = {M68K_DATA[12],M68K_DATA[14],M68K_DATA[6],M68K_DATA[7],M68K_DATA[9],M68K_DATA[5]};
////////////////////////////////////////////////////

wire [23:0] garouh_map[64] =
'{
	'h000000, 'h100000, 'h200000, 'h300000,
	'h280000, 'h380000, 'h2d0000, 'h3d0000,
	'h2c8000, 'h3c8000, 'h400000, 'h500000,
	'h420000, 'h520000, 'h440000, 'h540000,
	'h598000, 'h698000, 'h5a0000, 'h6a0000,
	'h5a8000, 'h6a8000, 'h5b0000, 'h6b0000,
	'h5b8000, 'h6b8000, 'h5c0000, 'h6c0000,
	'h5c8000, 'h6c8000, 'h5d0000, 'h6d0000,
	'h458000, 'h558000, 'h460000, 'h560000,
	'h468000, 'h568000, 'h470000, 'h570000,
	'h478000, 'h578000, 'h480000, 'h580000,
	'h488000, 'h588000, 'h490000, 'h590000,
	'h5d8000, 'h6d8000, 'h5e0000, 'h6e0000,
	'h5e8000, 'h6e8000, 'h6e8000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000
};

wire [5:0] garouh_idx = {M68K_DATA[13],M68K_DATA[11],M68K_DATA[2],M68K_DATA[14],M68K_DATA[8],M68K_DATA[4]};
////////////////////////////////////////////////////

wire [23:0] mslug3_map[64] =
'{
	'h000000, 'h020000, 'h040000, 'h060000,
	'h070000, 'h090000, 'h0b0000, 'h0d0000,
	'h0e0000, 'h0f0000, 'h120000, 'h130000,
	'h140000, 'h150000, 'h180000, 'h190000,
	'h1a0000, 'h1b0000, 'h1e0000, 'h1f0000,
	'h200000, 'h210000, 'h240000, 'h250000,
	'h260000, 'h270000, 'h2a0000, 'h2b0000,
	'h2c0000, 'h2d0000, 'h300000, 'h310000,
	'h320000, 'h330000, 'h360000, 'h370000,
	'h380000, 'h390000, 'h3c0000, 'h3d0000,
	'h400000, 'h410000, 'h440000, 'h450000,
	'h460000, 'h470000, 'h4a0000, 'h4b0000,
	'h4c0000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000 
};

wire [5:0] mslug3_idx = {M68K_DATA[9],M68K_DATA[3],M68K_DATA[6],M68K_DATA[15],M68K_DATA[12],M68K_DATA[14]};
////////////////////////////////////////////////////

wire [23:0] kof2000_map[64] =
'{
	'h000000, 'h100000, 'h200000, 'h300000,
	'h3f7800, 'h4f7800, 'h3ff800, 'h4ff800,
	'h407800, 'h507800, 'h40f800, 'h50f800,
	'h416800, 'h516800, 'h41d800, 'h51d800,
	'h424000, 'h524000, 'h523800, 'h623800,
	'h526000, 'h626000, 'h528000, 'h628000,
	'h52a000, 'h62a000, 'h52b800, 'h62b800,
	'h52d000, 'h62d000, 'h52e800, 'h62e800,
	'h618000, 'h619000, 'h61a000, 'h61a800,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000,
	'h000000, 'h000000, 'h000000, 'h000000
};

wire [5:0] kof2000_idx = {M68K_DATA[5],M68K_DATA[10],M68K_DATA[3],M68K_DATA[7],M68K_DATA[14],M68K_DATA[15]};
////////////////////////////////////////////////////


reg [23:0] bank = 0;
always @(negedge nPORTWE or negedge nRESET) begin
	if(~nRESET) bank <= 0;
	else if(BANK_SEL) begin
		case(TYPE)
			3: bank <= kof99_map[kof99_idx];
			4: bank <= garou_map[garou_idx];
			5: bank <= garouh_map[garouh_idx];
			6: bank <= mslug3_map[mslug3_idx];
			7: bank <= kof2000_map[kof2000_idx];
		endcase
	end
end

reg [15:0] rng = 0;
always @(negedge nPORTOE or negedge nRESET) begin
	reg rst = 0;
	if(~nRESET) rst = 1;
	else begin
		if(rst) rng <= 'h2345;
		else rng <= {rng[14:0], rng[2] ^ rng[3] ^ rng[5] ^ rng[6] ^ rng[7] ^ rng[11] ^ rng[12] ^ rng[15]};
		rst <= 0;
	end
end

endmodule
