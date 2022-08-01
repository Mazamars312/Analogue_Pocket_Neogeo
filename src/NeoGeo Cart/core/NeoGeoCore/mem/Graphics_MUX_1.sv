//
// CRAM8_ram.v
// Copyright (c) 2022 Mazamars312
//
//
// This source file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version. 
//
// This source file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License 
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ------------------------------------------
//

// 8-bit version

module cram_8bit
(
	output [21:16]		cram_a,
	inout	 [15:0]		cram_dq,
	input					cram_wait,
	input					cram_clk,
	output 				cram_adv_n,
	output 				cram_cre,
	output 				cram_ce0_n,
	output 				cram_ce1_n,
	output 				cram_oe_n,
	output 				cram_we_n,
	output 				cram_ub_n,
	output 				cram_lb_n,

	input  [23:0] 		wraddr,
	input  [31:0] 		din,
	input         		we_req,
	output reg    		we_ack,

	input  	  [23:0] rdaddr1,
	output reg [7:0]  dout1,
	input             rd_req1,
	output reg        rd_ack1,

	input      [23:0] rdaddr2,
	output reg [7:0]  dout2,
	input             rd_req2,
	output reg        rd_ack2, 
);

reg [23:0] ram_address;
reg [15:0] ram_data_out;
reg		  ram_oe_tristate;

assign cram_dq = ram_oe_tristate ? ram_data_out : 16'bz;

reg [6:0]  state  = 7'b00_11111;
reg [1:0]  channel = 0; 

/********************************************************************

	In this core we will run in Bigeden mode for writing and reading

	status for the cram is also used for the signals to help
	keep the reg count down
	
	MSD 	[7:6]	: State change between same signals
			[5]	: Address latch
			[4]	: Chip Enable (You also need to select if this is for the Hi or low chip)
			[3]	: Output Enable
			[2]	: Write enable
			[1]	: Chip Reg enable for chip reg changes
	LSD	[0]	: upper and lower byte (For this core we will only use a 16bit word for read and writes
					  even for the 8bit reads)
			

********************************************************************/

parameter	init_reset		=	'b00_11111;
parameter	init_address	=	'b01_11111;
parameter	idle				=	'b10_11111;
parameter	address_read	=	'b00_00111;
parameter	address_write	=	'b00_00100;
parameter	write_hi			=	'b00_10110;
parameter	write_lo			=	'b01_10110;
parameter	read_single		=	'b00_10010;

assign cram_adv_n = state[5]; 
assign cram_cre	= state[1];
assign cram_ce0_n	= state[4] && ~ram_address[23];
assign cram_ce1_n	= state[4] &&  ram_address[23];
assign cram_oe_n	= state[3];
assign cram_we_n	= state[2];
assign cram_ub_n	= state[0];
assign cram_lb_n	= state[0];
assign cram_a		= ram_address[23:17];
//									 2               1
//                         10 98 76 5 4 321 0 9 8 7 6 54 3 210
wire	cram_ram_reg	= 22'b00_00_00_0_0_011_1_1_0_0_0_01_1_111;

always @(posedge cram_clk) begin
	case(state)
		init_reset : begin
			we_ack  <= 'b0;
			rd_ack1 <= 'b0;
			rd_ack2 <= 'b0;
			channel <=  0;
			ram_address <= 'b0;
			state <= idle;
			ram_oe_tristate <= 1'b1;
		end
		idle : begin
			state <= idle;
			we_ack  <= 'b0;
			rd_ack1 <= 'b0;
			rd_ack2 <= 'b0;
			channel <= 0;
			ram_oe_tristate <= 1'b1;
			if(we_req  != we_ack) begin
				state <= address_write;
				ram_address <= wraddr[23:0];
				ram_data_out <= wraddr[16:1]};
			end
			else if(rd_req1 != rd_ack1) begin
				state <= read_single;
				channel <= 0;
				ram_address <= rdaddr1[23:0];
				ram_data_out <= wraddr[16:0];
			end
			else if(rd_req2 != rd_ack2) begin
				state <= read_single;
				channel <= 1;
				ram_address <= rdaddr2[23:0];
				ram_data_out <= wraddr[16:0];
			end
		end
		address_read : begin
			state <= address_read;
			ram_oe_tristate <= 'b0;
		end
		address_write : begin
			state <= write_hi;
			ram_oe_tristate <= 1'b1;
		end
		read_single : begin
			ram_oe_tristate <= 1'b0;
			if (cram_wait) state <= idle;
			case (channel)
				2'd1 : begin
					dout1 <= ram_address[0] ? cram_dq[ 7:0] : cram_dq[15:8];
					rd_ack1 <= cram_wait;
				end
				default : begin
					dout2 <= ram_address[0] ? cram_dq[ 7:0] : cram_dq[15:8];
					rd_ack2 <= cram_wait;
				end
			endcase
		end
		write_hi : begin
			ram_oe_tristate <= 1'b1;
			if (cram_wait) begin
				state <= address_read;
				ram_data_out <= din[15:0];
			end
			else begin
				ram_data_out <= din[31:16];
			end
		end
		write_lo : begin
			if (cram_wait) begin
				state <= idle;
				ram_data_out <= din[15:0];
				ram_oe_tristate <= 1'b1;
			end
			else begin
				ram_data_out <= din[15:0];
				ram_oe_tristate <= 1'b1;
			end
		end
		default : begin
			state <= init_reset;
		end
	endcase
end

endmodule


module cram_16bit
(
	output [21:16]		cram_a,
	inout	 [15:0]		cram_dq,
	input					cram_wait,
	input					cram_clk,
	output 				cram_adv_n,
	output 				cram_cre,
	output 				cram_ce0_n,
	output 				cram_ce1_n,
	output 				cram_oe_n,
	output 				cram_we_n,
	output 				cram_ub_n,
	output 				cram_lb_n,

	input  [23:0] 		wraddr,
	input  [31:0] 		din,
	input         		we_req,
	output reg    		we_ack,

	input      [20:1] M68K_ADDR,
	input      [15:0] M68K_DATA,
	input             nAS,
	input             nLDS,
	input             nUDS,
	input             DATA_TYPE,
	input             nROMOE,
	input             nPORTOE,
	input      [26:0] P2ROM_ADDR,
	output reg [15:0] PROM_DATA,
	output reg        PROM_DATA_READY,

	input      [23:0] rdaddr2,
	output reg [7:0]  dout2,
	input             rd_req2,
	output reg        rd_ack2, 
);

reg [23:0] ram_address;
reg [15:0] ram_data_out;
reg		  ram_oe_tristate;

assign cram_dq = ram_oe_tristate ? ram_data_out : 16'bz;

reg [6:0]  state  = 7'b00_11111;
reg [1:0]  channel = 0; 

/********************************************************************

	In this core we will run in Bigeden mode for writing and reading

	status for the cram is also used for the signals to help
	keep the reg count down
	
	MSD 	[7:6]	: State change between same signals
			[5]	: Address latch
			[4]	: Chip Enable (You also need to select if this is for the Hi or low chip)
			[3]	: Output Enable
			[2]	: Write enable
			[1]	: Chip Reg enable for chip reg changes
	LSD	[0]	: upper and lower byte (For this core we will only use a 16bit word for read and writes
					  even for the 8bit reads)
			

********************************************************************/

parameter	init_reset		=	'b00_11111;
parameter	init_address	=	'b01_11111;
parameter	idle				=	'b10_11111;
parameter	address_read	=	'b00_00111;
parameter	address_write	=	'b00_00100;
parameter	write_hi			=	'b00_10110;
parameter	write_lo			=	'b01_10110;
parameter	read_single		=	'b00_10010;

assign cram_adv_n = state[5]; 
assign cram_cre	= state[1];
assign cram_ce0_n	= state[4] && ~ram_address[23];
assign cram_ce1_n	= state[4] &&  ram_address[23];
assign cram_oe_n	= state[3];
assign cram_we_n	= state[2];
assign cram_ub_n	= state[0] && ;
assign cram_lb_n	= state[0];
assign cram_a		= ram_address[23:17];
//									 2               1
//                         10 98 76 5 4 321 0 9 8 7 6 54 3 210
wire	cram_ram_reg	= 22'b00_00_00_0_0_011_1_1_0_0_0_01_1_111;

always @(posedge cram_clk) begin
	case(state)
		init_reset : begin
			we_ack  <= 'b0;
			rd_ack1 <= 'b0;
			rd_ack2 <= 'b0;
			channel <=  0;
			ram_address <= 'b0;
			state <= idle;
			ram_oe_tristate <= 1'b1;
		end
		idle : begin
			state <= idle;
			we_ack  <= 'b0;
			rd_ack1 <= 'b0;
			rd_ack2 <= 'b0;
			channel <= 0;
			ram_oe_tristate <= 1'b1;
			if(we_req  != we_ack) begin
				state <= address_write;
				ram_address <= wraddr[23:0];
				ram_data_out <= wraddr[16:1]};
			end
			else if(rd_req1 != rd_ack1) begin
				state <= read_single;
				channel <= 0;
				ram_address <= rdaddr1[23:0];
				ram_data_out <= wraddr[16:0];
			end
			else if(rd_req2 != rd_ack2) begin
				state <= read_single;
				channel <= 1;
				ram_address <= rdaddr2[23:0];
				ram_data_out <= wraddr[16:0];
			end
		end
		address_read : begin
			state <= address_read;
			ram_oe_tristate <= 'b0;
		end
		address_write : begin
			state <= write_hi;
			ram_oe_tristate <= 1'b1;
		end
		read_single : begin
			ram_oe_tristate <= 1'b0;
			if (cram_wait) state <= idle;
			case (channel)
				2'd1 : begin
					dout1 <= ram_address[0] ? cram_dq[ 7:0] : cram_dq[15:8];
					rd_ack1 <= cram_wait;
				end
				default : begin
					dout2 <= ram_address[0] ? cram_dq[ 7:0] : cram_dq[15:8];
					rd_ack2 <= cram_wait;
				end
			endcase
		end
		write_hi : begin
			ram_oe_tristate <= 1'b1;
			if (cram_wait) begin
				state <= address_read;
				ram_data_out <= din[15:0];
			end
			else begin
				ram_data_out <= din[31:16];
			end
		end
		write_lo : begin
			if (cram_wait) begin
				state <= idle;
				ram_data_out <= din[15:0];
				ram_oe_tristate <= 1'b1;
			end
			else begin
				ram_data_out <= din[15:0];
				ram_oe_tristate <= 1'b1;
			end
		end
		default : begin
			state <= init_reset;
		end
	endcase
end

endmodule
