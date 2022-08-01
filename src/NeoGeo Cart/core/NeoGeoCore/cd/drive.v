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

// This module handles the CDD 4-bit communication bus, TOC readback and keeps
// track of the current MSF
// The protocol is very similar (if not identical) to the one used by the Mega CD drive

module cd_drive(
	input nRESET,	// System reset OR drive reset
	input CLK_12M,
	
	input HOCK,
	output reg CDCK,
	input [3:0] CDD_DIN,
	output reg [3:0] CDD_DOUT,
	output reg CDD_nIRQ,
	
	input clk_sys,
	output reg [15:0] sd_req_type,
	output reg sd_rd,
	input sd_ack,
	input [15:0] sd_buff_dout,
	input sd_buff_wr,
	
	output reg [7:0] MSF_M,
	output reg [7:0] MSF_S,
	output reg [7:0] MSF_F,
	input MSF_INC,			// Request to increment MSF
	output reg READING	// High when STAT_PLAYING, used to keep sectors flowing in
);

	// Command codes
	parameter CMD_NOP=4'd0, CMD_STOP=4'd1, CMD_TOC=4'd2, CMD_PLAY=4'd3, CMD_SEEK=4'd4, CMD_PAUSE=4'd6, CMD_RESUME=4'd7,
		CMD_FFW=4'd8, CMD_REW=4'd9, CMD_CLOSE=4'd12, CMD_OPEN=4'd13;

	// TOC sub-commands
	parameter TOC_ABSPOS=4'd0, TOC_RELPOS=4'd1, TOC_TRACK=4'd2, TOC_LENGTH=4'd3, TOC_FIRSTLAST=4'd4, TOC_START=4'd5,
		TOC_ERROR=4'd6;
	
	// Status codes
	parameter STAT_STOPPED=4'd0, STAT_PLAYING=4'd1, STAT_READTOC=4'd9;
	
	// Current TOC sub-command implementation:
	// 0: Get position
	//		Unimplemented
	// 1: Get position relative
	//		Unimplemented
	// 2: Get track number
	//		Unimplemented
	// 3: Get CD length: sd_req_type = 16'hD100
	//		0: M
	//		1: S
	//		2: F
	// 4: Get first/last: sd_req_type = 16'hD000
	//		0: First track # BCD
	//		1: Last track # BCD
	// 5: Get track start: sd_req_type = 16'hD2nn
	//		0: M
	//		1: S
	//		2: F
	//		3: Type
	// 6: Get last error
	//		Unimplemented

	reg [8:0] CLK_DIV;		// SLOW THE FUCK DOWN
	reg [11:0] IRQ_TIMER;
	reg [3:0] DOUT_COUNTER;	// 0~10
	reg [3:0] DIN_COUNTER;	// 0~10, 11 is special code for processing
	
	reg [3:0] STATUS_DATA [9];
	reg [3:0] COMMAND_DATA [10];
	
	reg HOCK_PREV;
	reg [1:0] COMM_STATE;	// 0~2
	reg [3:0] CHECKSUM_IN;
	
	reg [7:0] TOC_DATA [4];
	
	reg REQ_STATE, REQ_TRIG, REQ_RUN, REQ_ACK;
	reg MSF_INC_PREV, sd_ack_prev, sd_buff_wr_prev;
	reg [1:0] REQ_TYPE;

	always @(posedge clk_sys or negedge nRESET)
	begin
		if (!nRESET)
		begin
			REQ_STATE <= 0;
			REQ_RUN <= 0;
			REQ_ACK <= 0;
			
			sd_req_type <= 16'h0000;
			sd_ack_prev <= 0;
			sd_buff_wr_prev <= 0;
			
			CLK_DIV <= 9'd0;
			IRQ_TIMER <= 12'd0;
			DOUT_COUNTER <= 4'd10;
			DIN_COUNTER <= 4'd10;
			HOCK_PREV <= 0;
			CDCK <= 1;
			COMM_STATE <= 2'd0;
			CDD_nIRQ <= 1;
			
			STATUS_DATA[0] <= STAT_STOPPED;
			STATUS_DATA[1] <= 4'd0;
			STATUS_DATA[2] <= 4'd0;
			STATUS_DATA[3] <= 4'd0;
			STATUS_DATA[4] <= 4'd0;
			STATUS_DATA[5] <= 4'd0;
			STATUS_DATA[6] <= 4'd0;
			STATUS_DATA[7] <= 4'd0;
			STATUS_DATA[8] <= 4'd0;
			
			REQ_TRIG <= 0;
			REQ_TYPE <= 2'd0;
			
			MSF_INC_PREV <= 0;
			READING <= 0;
		end
		else
		begin
			sd_ack_prev <= sd_ack;
			sd_buff_wr_prev <= sd_buff_wr;
			
			if (REQ_TRIG)
			begin
				// Start TOC read request
				REQ_RUN <= 1;
				REQ_ACK <= 0;
				REQ_STATE <= 0;
				
				case (REQ_TYPE)
					2'd0: sd_req_type <= 16'hD000;	// first-last
					2'd1: sd_req_type <= 16'hD100;	// length
					2'd2: sd_req_type <= {8'hD2, COMMAND_DATA[4], COMMAND_DATA[5]};	// track start
					2'd3: sd_req_type <= 16'h0000;	// default
				endcase
				
				sd_rd <= 1;
				REQ_TRIG <= 0;
			end
			
			// sd_ack rising edge
			if (~sd_ack_prev & sd_ack & REQ_RUN)
				sd_rd <= 0;
			
			// sd_buff_wr rising edge
			if (~sd_buff_wr_prev & sd_buff_wr & REQ_RUN)
			begin
				// Got TOC data
				if (sd_req_type[15:12] == 4'hD)	// Is this check needed ? REQ_RUN is enough ?
				begin
					if (!REQ_STATE)
					begin
						// First two bytes
						{TOC_DATA[1], TOC_DATA[0]} <= sd_buff_dout;
						REQ_STATE <= 1;
					end
					else
					begin
						// Last two bytes
						{TOC_DATA[3], TOC_DATA[2]} <= sd_buff_dout;
						REQ_ACK <= 1;
						REQ_RUN <= 0;
						sd_req_type <= 16'h0000;
					end
				end
			end
			
			MSF_INC_PREV <= MSF_INC;
		
			// Rising edge of MSF_INC: Increment MSF
			if (~MSF_INC_PREV & MSF_INC)
			begin
				// Ugly BCD add :(
				if (MSF_F < 8'h75)
				begin
					// Inc frames
					if (MSF_F[3:0] < 4'h9)
						MSF_F <= MSF_F + 1'b1;
					else
					begin
						MSF_F[3:0] <= 4'h0;
						MSF_F[7:4] <= MSF_F[7:4] + 1'b1;
					end
				end
				else
				begin
					MSF_F <= 8'h00;
					if (MSF_S < 8'h59)
					begin
						// Inc seconds
						if (MSF_S[3:0] < 4'h9)
							MSF_S <= MSF_S + 1'b1;
						else
						begin
							MSF_S[3:0] <= 4'h0;
							MSF_S[7:4] <= MSF_S[7:4] + 1'b1;
						end
					end
					else
					begin
						MSF_S <= 8'h00;
						// Inc minutes
						if (MSF_M[3:0] < 4'h9)
							MSF_M <= MSF_M + 1'b1;
						else
						begin
							MSF_M[3:0] <= 4'h0;
							MSF_M[7:4] <= MSF_M[7:4] + 1'b1;
						end
					end
				end
			end
			
			
			// This simulates the Sony CDD MCU, so it must be quite slow
			// Here it "runs" at clk_sys/480=120M/480=250kHz
			
			if (CLK_DIV == 9'd480-1)
			begin
				CLK_DIV <= 9'd0;
				
				HOCK_PREV <= HOCK;
				
				// Fire CDD comm. IRQ at 64Hz
				// Does it switch to 75Hz when playing ?
				if (IRQ_TIMER == 12'd3906-1)
				begin
					IRQ_TIMER <= 12'd0;
					CDD_nIRQ <= 0;
					COMM_STATE <= 2'd0;
					DOUT_COUNTER <= 4'd0;
					DIN_COUNTER <= 4'd0;
				end
				else
				begin
					// Retry whatever happens
					if (IRQ_TIMER == 12'd1953-1)
						CDD_nIRQ <= 1;
						
					IRQ_TIMER <= IRQ_TIMER + 1'b1;
				end
				
				if (~HOCK & ~CDD_nIRQ)
					CDD_nIRQ <= 1;		// Comm. started ok, ack
				
				if (CDD_nIRQ)
				begin
					if (DOUT_COUNTER != 4'd10)
					begin
						// CDD to HOST
						
						if (COMM_STATE == 2'd0)
						begin
							// Put data on bus
							CDD_DOUT <= (DOUT_COUNTER == 4'd9) ? CHECKSUM_OUT : STATUS_DATA[DOUT_COUNTER];
							CDCK <= 0;
							COMM_STATE <= 2'd1;
						end
						else if (COMM_STATE == 2'd1)
						begin
							// Wait for HOCK high
							if (~HOCK_PREV & HOCK)
							begin
								CDCK <= 1;
								COMM_STATE <= 2'd2;
								// Escape from CDD -> HOST mode at last word
								if (DOUT_COUNTER == 4'd9)
								begin
									DOUT_COUNTER <= 4'd10;
									COMM_STATE <= 2'd1;
									CHECKSUM_IN <= 4'd5;
								end
							end
						end
						else if (COMM_STATE == 2'd2)
						begin
							// Wait for HOCK low
							if (HOCK_PREV & ~HOCK)
							begin
								DOUT_COUNTER <= DOUT_COUNTER + 1'b1;
								COMM_STATE <= 2'd0;
							end
						end
						
					end
					else if (DIN_COUNTER < 4'd10)
					begin
						// HOST to CDD
						
						if (COMM_STATE == 2'd0)
						begin
							// Wait for HOCK rising edge
							if (~HOCK_PREV & HOCK)
							begin
								COMMAND_DATA[DIN_COUNTER] <= CDD_DIN;
								CHECKSUM_IN <= CHECKSUM_IN + CDD_DIN;
								CDCK <= 1;
								DIN_COUNTER <= DIN_COUNTER + 1'b1;
								COMM_STATE <= 2'd1;
							end
						end
						else if (COMM_STATE == 2'd1)
						begin
							// Wait for HOCK falling edge
							if (HOCK_PREV & ~HOCK)
							begin
								CDCK <= 0;
								COMM_STATE <= 2'd0;
							end
						end
						
					end
					else if (DIN_COUNTER == 4'd10)
					begin
						// Comm frame just ended, do this just once
						DIN_COUNTER <= 4'd11;
						
						// Process command if checksum ok
						if (CHECKSUM_IN == 4'd15)
						begin
							if (COMMAND_DATA[0] == CMD_NOP)
							begin
								if (STATUS_DATA[0] == STAT_PLAYING)
								begin
									// Report current MSF during playback
									// Should it always be reported whatever the drive's state ?
									STATUS_DATA[2] <= MSF_M[7:4];
									STATUS_DATA[3] <= MSF_M[3:0];
									STATUS_DATA[4] <= MSF_S[7:4];
									STATUS_DATA[5] <= MSF_S[3:0];
									STATUS_DATA[6] <= MSF_F[7:4];
									STATUS_DATA[7] <= MSF_F[3:0];
									STATUS_DATA[8] <= 4'd0;	// Is this ok ?
								end
							end
							else if (COMMAND_DATA[0] == CMD_STOP)
							begin
								STATUS_DATA[0] <= STAT_STOPPED;
								READING <= 0;
							end
							else if (COMMAND_DATA[0] == CMD_TOC)
							begin
								// Sub-command code is read back in status data
								STATUS_DATA[1] <= COMMAND_DATA[3];
								
								if (COMMAND_DATA[3] == TOC_ABSPOS)
								begin
									// Get absolute position
									// Unused on Neo CD ?
								end
								else if (COMMAND_DATA[3] == TOC_RELPOS)
								begin
									// Get relative position
								end
								else if (COMMAND_DATA[3] == TOC_TRACK)
								begin
									// Get track number
								end
								else if (COMMAND_DATA[3] == TOC_LENGTH)
								begin
									// Get CD length
									if (REQ_ACK & (REQ_TYPE == 2'd1))
									begin
										// Data from HPS is ready
										STATUS_DATA[0] <= STAT_READTOC;
										STATUS_DATA[2] <= TOC_DATA[0][7:4];
										STATUS_DATA[3] <= TOC_DATA[0][3:0];
										STATUS_DATA[4] <= TOC_DATA[1][7:4];
										STATUS_DATA[5] <= TOC_DATA[1][3:0];
										STATUS_DATA[6] <= TOC_DATA[2][7:4];
										STATUS_DATA[7] <= TOC_DATA[2][3:0];
										STATUS_DATA[8] <= 4'd0;
									end
									else
									begin
										// Trigger HPS request
										REQ_TYPE <= 2'd1;
										REQ_TRIG <= 1;
									end
								end
								else if (COMMAND_DATA[3] == TOC_FIRSTLAST)
								begin
									// Get first and last tracks
									if (REQ_ACK & (REQ_TYPE == 2'd0))
									begin
										// Data from HPS is ready
										STATUS_DATA[0] <= STAT_READTOC;
										STATUS_DATA[2] <= TOC_DATA[0][7:4];
										STATUS_DATA[3] <= TOC_DATA[0][3:0];
										STATUS_DATA[4] <= TOC_DATA[1][7:4];
										STATUS_DATA[5] <= TOC_DATA[1][3:0];
										STATUS_DATA[6] <= 4'd0;
										STATUS_DATA[7] <= 4'd0;
										STATUS_DATA[8] <= 4'd0;
									end
									else
									begin
										// Trigger HPS request
										REQ_TYPE <= 2'd0;
										REQ_TRIG <= 1;
									end
								end
								else if (COMMAND_DATA[3] == TOC_START)
								begin
									// Get track start and type
									if (REQ_ACK & (REQ_TYPE == 2'd2))
									begin
										// Data from HPS is ready
										STATUS_DATA[0] <= STAT_READTOC;
										STATUS_DATA[2] <= TOC_DATA[0][7:4];
										STATUS_DATA[3] <= TOC_DATA[0][3:0];
										STATUS_DATA[4] <= TOC_DATA[1][7:4];
										STATUS_DATA[5] <= TOC_DATA[1][3:0];
										STATUS_DATA[6] <= TOC_DATA[2][7:4] | TOC_DATA[3][2];	// OR track type bit, 1:data
										STATUS_DATA[7] <= TOC_DATA[2][3:0];
										STATUS_DATA[8] <= COMMAND_DATA[5];
									end
									else
									begin
										// Trigger HPS request
										REQ_TYPE <= 2'd2;
										REQ_TRIG <= 1;
									end
								end
								else if (COMMAND_DATA[3] == TOC_ERROR)
								begin
									// Get last error
								end
							end
							else if (COMMAND_DATA[0] == CMD_PLAY)
							begin
								STATUS_DATA[0] <= STAT_PLAYING;
								MSF_M[7:4] <= COMMAND_DATA[2];
								MSF_M[3:0] <= COMMAND_DATA[3];
								MSF_S[7:4] <= COMMAND_DATA[4];
								MSF_S[3:0] <= COMMAND_DATA[5];
								MSF_F[7:4] <= COMMAND_DATA[6];
								MSF_F[3:0] <= COMMAND_DATA[7];
								READING <= 1;
							end
						end
							
					end
					
				end
			end
			else
				CLK_DIV <= CLK_DIV + 1'b1;
		end
	end
	
	// Should this be synchronous ? Maybe not required, comm. is relatively slow
	wire [3:0] CHECKSUM_OUT = ~(4'd5 + STATUS_DATA[0] + STATUS_DATA[1] + STATUS_DATA[2] +  STATUS_DATA[3] + 
										STATUS_DATA[4] +  STATUS_DATA[5] +  STATUS_DATA[6] +  STATUS_DATA[7] + 
										STATUS_DATA[8]);
	
endmodule
