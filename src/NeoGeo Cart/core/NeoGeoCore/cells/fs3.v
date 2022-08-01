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

module FS3(
	input CK,
	input [3:0] P,
	input SD, nL,
	output reg [3:0] Q = 4'd0
);
	
	always @(posedge CK, negedge nL)
	begin
		if (!nL)
			Q <= #2 P;					// Load
		else
			Q <= #1 {Q[2:0], SD};	// Shift
	end

endmodule
