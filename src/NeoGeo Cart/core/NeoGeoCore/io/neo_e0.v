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

module neo_e0(
	input [23:1] 	M68K_ADDR,
	input [2:0] 	BNK,
	input 			nSROMOEU, nSROMOEL,
	output 			nSROMOE,
	input 			nVEC,
	output 			A23Z, A22Z,
	output [23:0] 	CDA
);

	assign nSROMOE = nSROMOEU & nSROMOEL;

	// Vector table swap
	// A2*Z = 1 if nVEC == 0 and A == 11000000000000000xxxxxxx
	assign {A23Z, A22Z} = M68K_ADDR[23:22] ^ {2{~|{M68K_ADDR[21:7], ^M68K_ADDR[23:22], nVEC}}};
	
//	wire greater = 
	
//	always @* begin
//		case ({nVEC, |{M68K_ADDR[21:7]}})
//			2'b10	: {A23Z, A22Z} <= {~M68K_ADDR[23], ~M68K_ADDR[22]};
//			2'b11	: {A23Z, A22Z} <= M68K_ADDR[23:22];
//			default	: {A23Z, A22Z} <= M68K_ADDR[23:22];
//		endcase
//	end
	
	// Todo: Check this on real hw (MV4 ?)
	// Memcard area is $800000~$BFFFFF, each word is mapped to one byte
	// 10000000 00000000 00000000
	// 10111111 11111111 11111111
	// --xxxxxx xxxxxxxx xxxxxxx-
	// bbbaaaaa aaaaaaaa aaaaaaaa
	assign CDA = {BNK, M68K_ADDR[21:1]};
	
endmodule
