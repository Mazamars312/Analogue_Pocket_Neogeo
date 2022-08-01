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

module FD3(
	input nCK,
	input D,
	input nSET,
	output reg Q = 1'b0,
	output nQ
);

	always @(posedge nCK, negedge nSET)	// Databook says negedge but makes no sense with use in LSPC shematic
	begin
		if (!nSET)
			Q <= 1'b1;
		else
			Q <= D;
	end
	
	assign nQ = ~Q;

endmodule
