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

module FJD(
	input CK,
	input J, K,
	input nCL,
	output reg Q = 1'b0,
	output nQ
);
	
	always @(posedge CK, negedge nCL)
	begin
		if (~nCL)
			Q <= #1 1'b0;
		else
		begin
			case({J, K})
				2'b00 : Q <= #2 Q;
				2'b01 : Q <= #2 1'b0;
				2'b10 : Q <= #2 1'b1;
				2'b11 : Q <= #2 ~Q;
			endcase
		end
	end
	
	assign nQ = ~Q;

endmodule
