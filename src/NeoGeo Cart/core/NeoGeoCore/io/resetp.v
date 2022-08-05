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

// Version 0.6.0 Alpha
// Mazamars312 : Added the 6mhz clock to this so we can sync the LSCP to the PLL. 
// Also using the clk_sys to help in this for getting the sync right
// We also need to make sure that the CLK_1HB is Changing to low on the resetP turing high to keep the text 100%
// This should now give us a clock acurate system now

module resetp(
	input CLK_24MB,
	input nRESET,
	output reg nRESETP,
	input CLK_6MB,
	input CLK_1HB,
	input clk_sys
);


	// 24MB    ""__""__""__""__""__
	// nRESET  ____________""""""""
	// nRESETP """"""""""""""____""

	parameter 		startup_reset		=	0,	// this is where the reset line is low we make sure that the reset_p is still high
						wait_for_6_rlow	= 	1, // We watch for a fall on the 6mhz clock 
						delay_reset 		= 	2,	// we wait for one cycle for the 6mhz and then place the reset on high
						running_core		=	3;	// the reset cycle is complete and if we see another reset we go back to the startup
						
	reg [1:0] 		reset_state = 0;
	
	reg prev_CLK_6MB;
	reg prev_nRESET;
	reg [7:0] cnt;
	
	always @(posedge clk_sys) begin
		prev_CLK_6MB <= CLK_6MB;
		prev_nRESET  <= nRESET;
	end
	
	always @(posedge clk_sys) begin
		case (reset_state)
			wait_for_6_rlow : begin
				nRESETP <= 1'b0;
				cnt		<= 'd0;
				if (prev_CLK_6MB && ~CLK_6MB) begin
					reset_state <= delay_reset;
				end
			end
			delay_reset : begin
			// We have to make sure that he 3mhz clock is high as the PLL will make it low once the 6mhz counter starts
			// If this is low it will cause an issue with the SROM access. This will increase compile times but it is worth it
				
				if (cnt == 5'd17) begin
					nRESETP 		<= 1'b1;
					cnt			<= 'd0;
					reset_state <= running_core;
				end
				else begin
					nRESETP 		<= 1'b0;
					cnt			<= cnt + 1;
				end
			end
			running_core : begin
				nRESETP <= 1'b1;
				if (~nRESET &&  prev_nRESET) begin
					reset_state <= startup_reset;
				end
			end
			default : begin	// this is out Startup_reset
				nRESETP <= 1'b1;
				cnt 		<= 'd0;
				if ( nRESET && ~prev_nRESET) begin
					nRESETP <= 1'b0;
					reset_state <= wait_for_6_rlow;
				end
			end
		endcase
	end
	
endmodule
