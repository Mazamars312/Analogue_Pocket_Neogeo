//============================================================================
//  SNK NeoGeo for MiSTer
//
//  Copyright (C) 2018 Sean 'Furrtek' Gonsalves
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

module lspc2_clk(
	input CLK_24M,
	input nRESETP,
	
	output CLK_24MB,
	output LSPC_12M,
	output LSPC_8M,
	output LSPC_6M,
	output LSPC_4M,
	output LSPC_3M,
	output LSPC_1_5M,
	
	output reg Q53_CO
);
	reg [3:0] Q53_Q;
	reg S276_Q;
	reg R262_Q, R268_Q;
	
	assign CLK_24MB = ~CLK_24M;
	assign LSPC_1_5M = Q53_Q[3];
	assign LSPC_3M = Q53_Q[2];
	assign LSPC_6M = Q53_Q[1];
	assign LSPC_12M = Q53_Q[0];
	
	always @(posedge CLK_24MB)
	begin
		// C43 Q53(CLK_24MB, 4'b0010, RESETP, 1'b1, 1'b1, 1'b1, {LSPC_1_5M, LSPC_3M, LSPC_6M, LSPC_12M}, Q53_CO);
		if (!nRESETP)
		begin
			Q53_Q <= 4'b0010;
			Q53_CO <= 1'b0;
		end
		else
		begin
			Q53_Q <= Q53_Q + 1'd1;
			Q53_CO <= (Q53_Q == 4'd14);
			
			// FDM S276(CLK_24MB, R262_Q, S276_Q);
			S276_Q <= R262_Q;
		end
	end
	
	always @(posedge CLK_24M)
	begin
		// FJD R262(CLK_24M, R268_Q, 1'b1, 1'b1, R262_Q, R262_nQ);
		/*case({R268_Q, 1'b1})
			2'b00 : R262_Q <= #2 Q;
			2'b01 : R262_Q <= #2 1'b0;
			2'b10 : R262_Q <= #2 1'b1;
			2'b11 : R262_Q <= #2 ~Q;
		endcase*/
		R262_Q <= R268_Q ? ~R262_Q : 1'b0;
		
		// FJD R268(CLK_24M, R262_nQ, 1'b1, 1'b1, R268_Q);
		/*case({~R262_Q, 1'b1})
			2'b00 : R268_Q <= #2 Q;
			2'b01 : R268_Q <= #2 1'b0;
			2'b10 : R268_Q <= #2 1'b1;
			2'b11 : R268_Q <= #2 ~Q;
		endcase*/
		R268_Q <= (~R262_Q) ? ~R268_Q : 1'b0;
	end
	
	// S274A
	assign LSPC_8M = ~|{S276_Q, R262_Q};
	
	wire S219A_nQ;
	FD4 S219A(LSPC_8M, S219A_nQ, 1'b1, 1'b1, LSPC_4M, S219A_nQ);
	
endmodule
