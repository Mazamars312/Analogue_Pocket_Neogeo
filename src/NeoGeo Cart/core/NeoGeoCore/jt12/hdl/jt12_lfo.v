/*  This file is part of jt12.

    jt12 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    jt12 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with jt12.  If not, see <http://www.gnu.org/licenses/>.
	
	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 25-2-2017
	*/

`timescale 1ns / 1ps

/*

	Does the LFO frequency depend on the pre-scaler for YM2608 ?

	From spritesmind.net:
	"That would be 7-bit LFO step counter (which is incremented on each LFO clock and reset when LFO enable bit is cleared). 
	LFO AM value indeed corresponds to LFO step counter bits 0:5 shifted left by one 
	and XORed with inversion of bit 6 (to generate an inverted triangle waveform)
	
	LFO AM sensitivity (2 bits) indicates to EG how much LFO AM value is shifted before adding to EG output
	[...] 
	LFO PM step (0-31), which takes bits 2:6 of LFO step counter (0-127) and goes to LFO PM calcuation unit
	"

	From Sauraen:

The LFO seems to have 3 sections:

	[*] 7-bit linear prescaler. The test bit 0x21:1 goes into what looks like the carry-in or something similar; 
	it could go into the reset, I can't quite tell with more detailed analysis. The 7-bit output (plus maybe carry-out) 
	gets logiced together into 8 lines (evidently perform "== N" with N hardcoded for each line), and these go into a 
	little selector unit which is also fed by the LFO Speed and LFO Enable bits. I can't quite see the output of this, 
	but I do see there's some sort of feedback to the prescaler's reset. So this clearly seems like a divide-by-N prescaler. 
	I can try to read the eight N's for you if you want, but you should be able to reverse engineer them from knowing what the LFO speeds are.

	[*] 7-bit linear counter, with an 8-bit unit after the output (possibly inverts the output after each cycle to make a triangle wave?). 
	Bits 1:6 of the output of this go to the EG, and stick into its pipeline at the same place where the LFO->Amplitude two bits go. 
	(Elsewhere the operator LFO enable flag simply forces these two bits to zero for operators not affected by the LFO.) 
	Some modified version of the 8-bit signal between the counter and the inverter unit thing goes to the third unit of the LFO.

	[*] Highly complex unit which modifies the frequency data as it goes from the channel registers to the PG. The block bits bypass this, 
	but all the frequency bits get modified by it. There's a bitslice portion corresponding to bits 0:6, and then what appears to be 
	the same logic folded over to process bits 7:A. But the interesting part is that bits 4:A of the frequency data go into the 
	bitslices 0:6. That is, the bitslice unit for bit 0 has bit 0 enter at the middle and leave (to the PG) at the bottom. But it also has bit 4 enter at the top. 
	And so on through bit 6 having bit A enter at the top. It looks like the top portion is some sort of shifter for bits 4:A--the wires go diagonally 
	so that bit 4 only gets used once, bit 5 gets used in bitslice 1 and 0, bit 6 gets used in bitslices 2:0, and so on so that bit A gets used in all of them. 
	I'm guessing this whole unit is basically a multiplier, multiplying bits 4:A of the frequency value by bits 0:7 of the LFO state, and then adding the result 
	to bits 0:6 of the frequency value (with carry up to the higher bits). It looks like, between the multiplied output and the adder, there's another shifter 
	whose value is based on the the LFO->Frequency bits. But it looks like it's a bit more complex than I'm describing.

*/

module jt12_lfo(
	input			 	rst,
	input			 	clk,
	input				clk_en,
	input				zero,
	input				lfo_rst,
	input				lfo_en,
	input		[2:0]	lfo_freq,
	output	reg	[6:0]	lfo_mod		// 7-bit width according to spritesmind.net
);

reg [6:0] cnt, limit;

always @(*)
	case( lfo_freq )	// same values as in MAME
		3'd0: limit = 7'd108;
		3'd1: limit = 7'd77;
		3'd2: limit = 7'd71;
		3'd3: limit = 7'd67;
		3'd4: limit = 7'd62;
		3'd5: limit = 7'd44;
		3'd6: limit = 7'd8;
		3'd7: limit = 7'd5;
	endcase

always @(posedge clk) 
	if( rst || !lfo_en )
		{ lfo_mod, cnt } <= 14'd0;
	else if( clk_en && zero) begin
		if( cnt == limit ) begin
			cnt <= 7'd0;
			lfo_mod <= lfo_mod + 1'b1;
		end
		else begin
			cnt <= cnt + 1'b1;
		end
	end
	
endmodule
