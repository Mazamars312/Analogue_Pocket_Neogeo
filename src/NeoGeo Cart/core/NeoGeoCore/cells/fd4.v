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

module FD4(
	input CK,
	input D,
	input PR, CL,
	output reg Q = 1'b0,
	output nQ
);

	always @(negedge CK, negedge PR, negedge CL)
	begin
		if (~PR)
			Q <= #1 1'b1;
		else if (~CL)
			Q <= #1 1'b0;
		else
			Q <= #1 D;
	end
	
	assign nQ = ~Q;

endmodule
