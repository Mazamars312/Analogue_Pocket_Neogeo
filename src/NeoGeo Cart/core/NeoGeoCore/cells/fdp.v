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

module FDPCell(
	input CK,
	input D,
	input S, R,
	output reg Q = 1'b0,
	output nQ
);

	always @(posedge CK, negedge S, negedge R)
	begin
		if (!S)
			Q <= 1'b1;
		else if (!R)
			Q <= 1'b0;
		else
			Q <= #1 D;
	end
	
	assign nQ = ~Q;

endmodule
