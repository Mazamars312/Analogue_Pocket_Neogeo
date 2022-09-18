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
	input clk_sys,
	input CLK_6MB,
	input CLK_1HB,
	input nRESET,
	output reg nRESETP

);


	// 24MB    ""__""__""__""__""__
	// nRESET  ____________""""""""
	// nRESETP """"""""""""""____""

	parameter 		startup_reset		=	0,	// this is where the reset line is low we make sure that the reset_p is still high
						wait_for_6_rlow	= 	1, // We watch for a fall on the 6mhz clock 
						delay_reset 		= 	2,	// we wait for one cycle for the 6mhz and then place the reset on high
						running_core		=	3;	// the reset cycle is complete and if we see another reset we go back to the startup
						
	reg [1:0] 		reset_state = 0;
	reg [1:0]		reset_state_c;
	reg prev_CLK_6MB;
	reg CLK_6MB_reg;
	reg prev_nRESET;
	reg [31:0] cnt, cnt_c;
	wire [31:0] cnt_test;// = 32'd33;
	
	
	
	always @(posedge clk_sys) begin
		CLK_6MB_reg 	<= CLK_6MB;
		prev_CLK_6MB 	<= CLK_6MB_reg;
		prev_nRESET   	<= nRESET;
		reset_state		<= reset_state_c;
		cnt				<= cnt_c;
	end
	
	Video_change u0 (
		.probe		(cnt_test),
		.source_clk (clk_sys), // source_clk.clk
		.source     (cnt_test)      //    sources.source
	);
	
	wire fall_6mhz = &{~CLK_6MB, prev_CLK_6MB, ~CLK_1HB};
	
	// States
	always @* begin
		case (reset_state)
			wait_for_6_rlow : begin
				if (fall_6mhz) reset_state_c <= delay_reset;
				else reset_state_c <= wait_for_6_rlow;
			end
			delay_reset : begin
			// We have to make sure that he 3mhz clock is high as the PLL will make it low once the 6mhz counter starts
			// If this is low it will cause an issue with the SROM access. This will increase compile times but it is worth it
				if (cnt >= cnt_test) reset_state_c <= running_core;
				else reset_state_c <= delay_reset;
			end
			running_core : begin
				if (~nRESET &&  prev_nRESET) reset_state_c <= startup_reset;
				else reset_state_c <= running_core;
			end
			default : begin	// this is out Startup_reset
				if ( nRESET && ~prev_nRESET) reset_state_c <= wait_for_6_rlow;
				else reset_state_c <= reset_state;
			end
		endcase
	end
	
	// reset core
	
	always @* begin
		case (reset_state)
			wait_for_6_rlow : begin
				nRESETP <= 1'b0;
			end
			delay_reset : begin
			// We have to make sure that he 3mhz clock is high as the PLL will make it low once the 6mhz counter starts
			// If this is low it will cause an issue with the SROM access. This will increase compile times but it is worth it
				if (cnt >= cnt_test) nRESETP <= 1'b1;
				else nRESETP <= 1'b0;
			end
			running_core : begin
				nRESETP <= 1'b1;
			end
			default : begin	// this is out Startup_reset
				if ( nRESET && ~prev_nRESET) nRESETP <= 1'b0;
				else nRESETP <= 1'b1;
			end
		endcase
	end
	
	// Counter 
	
	always @* begin
		case (reset_state)
			wait_for_6_rlow : begin
				cnt_c		<= 'd0;
			end
			delay_reset : begin
			// We have to make sure that he 3mhz clock is high as the PLL will make it low once the 6mhz counter starts
			// If this is low it will cause an issue with the SROM access. This will increase compile times but it is worth it
				cnt_c <= cnt + 1;
			end
			running_core : begin
				cnt_c		<= 'd0;
			end
			default : begin	// this is out Startup_reset
				cnt_c		<= 'd0;
			end
		endcase
	end
	
endmodule
