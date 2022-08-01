/*  This file is part of JT12.

	JT12 is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	JT12 is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with JT12.  If not, see <http://www.gnu.org/licenses/>.

	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 29-10-2018

	*/

module jt12_eg_ctrl(
	input				keyon_now,
	input				keyoff_now,
	input		[2:0]	state_in,
	input		[9:0]	eg,
	// envelope configuration	
	input		[4:0]	arate, // attack  rate
	input		[4:0]	rate1, // decay   rate
	input		[4:0]	rate2, // sustain rate
	input		[3:0]	rrate,
	input		[3:0]	sl,   // sustain level
	// SSG operation
	input				ssg_en,
	input		[2:0]	ssg_eg,
	// SSG output inversion
	input				ssg_inv_in,
	output reg			ssg_inv_out,

	output reg	[4:0]	base_rate,
	output reg	[2:0]	state_next,
	output reg			pg_rst
);

localparam 	ATTACK = 3'b001, 
			DECAY  = 3'b010, 
			HOLD   = 3'b100,
			RELEASE= 3'b000; // default state is release 

// wire is_decaying = state_in[1] | state_in[2];

reg		[4:0]	sustain;

always @(*) 
	if( sl == 4'd15 )
		sustain = 5'h1f; // 93dB
	else
		sustain = {1'b0, sl};

wire	ssg_en_out;
reg		ssg_en_in, ssg_pg_rst;

// aliases
wire ssg_att  = ssg_eg[2];
wire ssg_alt  = ssg_eg[1];
wire ssg_hold = ssg_eg[0] & ssg_en;

reg ssg_over;


always @(*) begin
	ssg_over = ssg_en && eg[9]; // eg >=10'h200
	ssg_pg_rst = ssg_over && !( ssg_alt || ssg_hold );
	pg_rst = keyon_now | ssg_pg_rst;
end

always @(*) 
	casez ( { keyoff_now, keyon_now, state_in} )
		5'b01_???: begin // key on
			base_rate	= arate;
			state_next	= ATTACK;
			ssg_inv_out	= ssg_att & ssg_en;
		end
		{2'b00, ATTACK}: 
			if( eg==10'd0 ) begin
				base_rate	= rate1;
				state_next	= DECAY;
				ssg_inv_out	= ssg_inv_in;
			end
			else begin
				base_rate	= arate;
				state_next	= ATTACK;
				ssg_inv_out	= ssg_inv_in;
			end
		{2'b00, DECAY}: begin
			if( ssg_over ) begin
				base_rate	= ssg_hold ? 5'd0 : arate;
				state_next	= ssg_hold ? HOLD : ATTACK;
				ssg_inv_out	= ssg_en & (ssg_alt ^ ssg_inv_in);
			end
			else begin
				base_rate	=  eg[9:5] >= sustain ? rate2 : rate1;
				state_next	= DECAY;
				ssg_inv_out = ssg_inv_in;
			end
		end
		{2'b00, HOLD}: begin
			base_rate	= 5'd0;
			state_next	= HOLD;
			ssg_inv_out	= ssg_inv_in;
		end
		default: begin // RELEASE, note that keyoff_now==1 will enter this state too
			base_rate	= { rrate, 1'b1 };
			state_next	= RELEASE;	// release
			ssg_inv_out	= 1'b0; // this can produce a glitch in the output
				// But to release from SSG cannot be done nicely while
				// inverting the ouput
		end
	endcase


endmodule // jt12_eg_ctrl