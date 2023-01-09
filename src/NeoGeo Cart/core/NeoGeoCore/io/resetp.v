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
	output reg nRESETP
);
	reg O49_nQ;
	// 24MB    ""__""__""__""__""__
	// nRESET  ____________""""""""
	// nRESETP """"""""""""""____""
	always @(posedge CLK_24MB)
	begin
		O49_nQ <= ~nRESET;
		nRESETP <= ~&{O49_nQ, nRESET};
	end
	
endmodule
