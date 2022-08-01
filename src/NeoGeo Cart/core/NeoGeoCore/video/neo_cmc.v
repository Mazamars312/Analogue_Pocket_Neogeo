//============================================================================
//  NEO-CMC (bankswitching only)
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

module neo_cmc
(
	input             PCK2B,
	input      [14:0] PBUS,
	input      [10:0] ADDR,
	input       [1:0] TYPE,
	output reg  [1:0] BANK
);

always @(posedge PCK2B) begin
	reg [10:0] old_addr;
	reg        skip;
	reg [0:79] banks;
	reg  [3:0] map[32];
	reg  [4:0] line;

	if(ADDR == 'h7E2 && !PBUS[14:12]) begin
		skip <= 0;
		line <= 0;
		BANK <= 1; // for parental advisory (mslug4)
	end

	old_addr <= ADDR;
	if(old_addr == ADDR) begin
		if(TYPE[0]) begin
			if(ADDR[10:8] == 7 && !PBUS[14:12]) begin
				if(&map[line][3:2] && ~skip) begin
					BANK <= map[line][1:0];
					skip <= 1;
				end
				else begin
					line <= line + 1'd1;
					skip <= 0;
				end
			end

			// even words
			if ({ADDR[6],ADDR[0],ADDR[10:8]} == 5) begin
				if(ADDR[7]) map[ADDR[5:1]][2:0] <= {&PBUS[11:8], ~PBUS[1:0]}; // 7580~75BE
				       else map[ADDR[5:1]][3]   <= (PBUS[11:0] == 'h200);     // 7500~753E
			end
		end

		if(TYPE[1]) begin
			// 7500 - 75DF
			if(ADDR[10:8] == 5 && &PBUS[14:12]) banks[{1'b0,ADDR[7:5],3'b000}+{2'b00,ADDR[7:5],2'b00} +:12] <= ~PBUS[11:0];
			BANK <= banks[{ADDR[10:5],1'b0} +:2];
		end
	end

	if(~^TYPE) BANK <= 0;
end

endmodule
