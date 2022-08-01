//============================================================================
//  SNK NeoGeo for MiSTer
//
//  Copyright (C) 2019 Sean 'Furrtek' Gonsalves
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

module PCM(
	input CLK_68KCLKB,
	input nSDROE, SDRMPX,
	input nSDPOE, SDPMPX,
	inout [7:0] SDRAD,
	input [9:8] SDRA_L,
	input [23:20] SDRA_U,
	inout [7:0] SDPAD,
	input [11:8] SDPA,
	input [7:0] D,
	output [23:0] A
	);

	reg [1:0] COUNT;
	reg [7:0] RDLATCH;
	reg [7:0] PDLATCH;
	reg [23:0] RALATCH;
	reg [23:0] PALATCH;
	
	wire nSDRMPX = ~SDRMPX;
	wire nSDPMPX = ~SDPMPX;
	wire SDPOE = ~nSDPOE;
	wire CEN = ~COUNT[1];
	
	always @(posedge CLK_68KCLKB or negedge nSDPOE)
	begin
		if (!nSDPOE)
			COUNT <= 0;
		else
			if (CEN) COUNT <= COUNT + 1'b1;
	end
	
	assign SDRAD = nSDROE ? 8'bzzzzzzzz : RDLATCH;
	always @(*)
		if (COUNT[1]) RDLATCH <= D;
	
	assign SDPAD = nSDPOE ? 8'bzzzzzzzz : PDLATCH;
	always @(*)
		if (!nSDPOE) PDLATCH <= D;
	
	assign A = nSDPOE ? RALATCH : PALATCH;
	
	always @(posedge nSDRMPX)
	begin
		RALATCH[7:0] <= SDRAD[7:0];
		RALATCH[9:8] <= SDRA_L[9:8];
	end
	always @(posedge SDRMPX)
	begin
		RALATCH[17:10] <= SDRAD[7:0];
		RALATCH[23:18] <= {SDRA_U[23:20], SDRA_L[9:8]};
	end
	
	always @(posedge nSDPMPX)
	begin
		PALATCH[7:0] <= SDPAD[7:0];
		PALATCH[11:8] <= SDPA[11:8];
	end
	always @(posedge SDPMPX)
	begin
		PALATCH[19:12] <= SDPAD[7:0];
		PALATCH[23:20] <= SDPA[11:8];
	end

endmodule

