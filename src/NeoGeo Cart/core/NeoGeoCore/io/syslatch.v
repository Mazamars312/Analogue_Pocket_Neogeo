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

module syslatch(
	input [4:1] M68K_ADDR,
	input nBITW1,
	input nRESET,
	output SHADOW, nVEC, nCARDWEN, CARDWENB, nREGEN, nSYSTEM, nSRAMWEN, PALBNK,
	input CLK_68KCLK
);

	reg [7:0] SLATCH;
	
	assign SHADOW = SLATCH[0];
	assign nVEC = SLATCH[1];
	assign nCARDWEN = SLATCH[2];
	assign CARDWENB = SLATCH[3];
	assign nREGEN = SLATCH[4];
	assign nSYSTEM = SLATCH[5];
	assign nSRAMWEN = ~SLATCH[6];		// See MVS schematics page 3
	assign PALBNK = SLATCH[7];
	
	
	always @(posedge CLK_68KCLK)	// M68K_ADDR[4:1] or nBITW1 or nRESET
	begin
		if (!nRESET)
		begin
			if (nBITW1)
				SLATCH <= 8'h00;	// Clear
			else
			begin						// Demux mode
				case (M68K_ADDR[3:1])
					0: SLATCH <= {7'b0000000, M68K_ADDR[4]};
					1: SLATCH <= {6'b000000, M68K_ADDR[4], 1'b0};
					2: SLATCH <= {5'b00000, M68K_ADDR[4], 2'b00};
					3: SLATCH <= {4'b0000, M68K_ADDR[4], 3'b000};
					4: SLATCH <= {3'b000, M68K_ADDR[4], 4'b0000};
					5: SLATCH <= {2'b00, M68K_ADDR[4], 5'b00000};
					6: SLATCH <= {1'b0, M68K_ADDR[4], 6'b000000};
					7: SLATCH <= {M68K_ADDR[4], 7'b0000000};
				endcase
			end
		end
		else if (!nBITW1)
		begin							// Latch mode
			SLATCH[M68K_ADDR[3:1]] <= M68K_ADDR[4];
		end
	end
	
endmodule
