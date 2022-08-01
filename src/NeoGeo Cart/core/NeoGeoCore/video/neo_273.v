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

module neo_273(
	input [19:0] PBUS,
	input PCK1B,
	input PCK2B,
	input S2H1,
	output reg [19:0] C_LATCH,
	output reg [15:0] S_LATCH
);
	
	always @(posedge PCK1B)
	begin
		C_LATCH <= {PBUS[19:0]};
	end
	
	always @(posedge PCK2B)
	begin
		S_LATCH <= {PBUS[15:0]};
	end

endmodule
