/****************************************************************************************
	
	Ram arbertor for Writing 32bit streams
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following:
	
	This will stream the 32bit data through a 32bit bus.
	Does both big and little eiden accesses
	
	ToDo:
		work on the read process

*****************************************************************************************/

// Version 0.6.0 Alpha
// Added the read side to follow the Big and little enden coding.
// Made the core read on the fall of the read and writes.


module ram_32_bit_sfix_state_controller (
	input 					clk_74a,
	input 					clk_sys,
	input 					reset_l,
	
	input 					bigendin,
	
	// Ram Controller
	output reg				word_rd,
	output reg 				word_wr,
	output reg 				word_32bit,
	output reg 	[25:0]	word_addr,
	output reg 	[31:0]	word_data,
	input 	  	[31:0]	word_q,
	input						word_busy,
	
	// SPI interface
	input			[31:0]	bridge_addr,
	input						bridge_rd,
	output reg	[31:0]	bridge_rd_data,
	input						bridge_wr,
	input			[31:0]	bridge_wr_data,
	output reg				bridge_processing,
	output reg 				bridge_completed
);



/*************************************************************

	interface controller to Memory cores once the dataslot
	is confirmed.

*************************************************************/

reg [3:0] 	RAM_STATE;

reg 			requested_read;

reg [31:0]  bridge_wr_data_reg;

parameter	idle					=	'd0;
parameter	request				=	'd1;
parameter	write_low_wait_24 =  'd2;
parameter	write_low_24		=  'd3;
parameter	write_low_wait_16 =  'd4;
parameter	write_low_16		=  'd5;
parameter	write_low_wait_8 	=  'd6;
parameter	write_low_8			=  'd7;
parameter 	wait_read			= 	'd8;

	
	wire 		bridge_rd_s, bridge_rd_r, bridge_rd_f;
synch_3 s00(bridge_rd, bridge_rd_s, clk_sys, bridge_rd_r, bridge_rd_f);

	wire 		bridge_wr_s, bridge_wr_r, bridge_wr_f;
synch_3 s01(bridge_wr, bridge_wr_s, clk_sys, bridge_wr_r, bridge_wr_f);

	wire [31:0]	bridge_wr_data_s;
synch_3 #(.WIDTH(32)) s02(bridge_wr_data, bridge_wr_data_s, clk_sys);

	wire [31:0]	bridge_addr_s;
synch_3 #(.WIDTH(32)) s03(bridge_addr, bridge_addr_s, clk_sys);

always @(posedge clk_sys or negedge reset_l) begin
	if (~reset_l) begin
		RAM_STATE 								<= 'd0;
		requested_read 						<= 'd0;
		word_rd									<= 'd0;
		word_wr									<= 'd0;
		word_addr								<= 'd0;
		word_data								<= 'd0;
		bridge_rd_data							<= 'd0;
		bridge_completed						<= 'b0;
		bridge_processing						<= 'b0;
		word_32bit								<= 'b1;
	end
	else begin
		word_rd									<= 'd0;
		word_wr									<= 'd0;
		bridge_completed						<= 'b0;
		case (RAM_STATE)
			request : begin
				case (word_32bit)
					1'b1 : begin
						bridge_processing		<= 'b1;
						if (~word_busy) begin // we need to wait for access
							word_addr 					<= bridge_addr_s[25:0]; // We have to make sure that we are doing a 32bit word process here
							if (requested_read) 	begin
								RAM_STATE 				<= wait_read;
								word_rd 					<= 'b1;
							end
							else begin
								RAM_STATE 				<= idle;
								word_wr 					<= 'b1;
								bridge_processing		<= 'b0;
								word_data 					<= bigendin ? bridge_wr_data_s : 
																{bridge_wr_data_s[23:16], bridge_wr_data_s[31:24], bridge_wr_data_s[7:0], bridge_wr_data_s[15:8]};
							end
						end
					end
					default : begin
						if (~word_busy) begin // we need to wait for access
																// Location ram					 , 	Bank				  , Tiles
							word_addr 				<= {2'd0, bridge_addr_s[23:19], bridge_addr_s[18:17], bridge_addr_s[16:5], bridge_addr_s[2:0], bridge_addr_s[4:3]}; // We have to make sure that we are doing a 32bit word process here
							RAM_STATE 				<= write_low_wait_24;
							word_wr 					<= 'b1;
							bridge_processing		<= 'b1;
							word_data 				<= {4{~bigendin ? bridge_wr_data_reg[31:24] : bridge_wr_data_reg[23:16]}};
						end
					end
				endcase
			end
			write_low_wait_24 : begin
				if (word_busy) begin
					RAM_STATE 				<= write_low_24;
				end
			end
			write_low_24 : begin
				word_wr 					<= 'b0;
				if (~word_busy) begin // we need to wait for access
					word_addr 				<= word_addr + 'b100; // We have to make sure that we are doing a 32bit word process here
					RAM_STATE 				<= write_low_wait_16;
					word_wr 					<= 'b1;
					bridge_processing		<= 'b0;
					word_data 				<= {4{bigendin ? bridge_wr_data_reg[31:24] : bridge_wr_data_reg[23:16]}};
				end
			end
			write_low_wait_16 : begin
				if (word_busy) begin
					RAM_STATE 				<= write_low_16;
				end
			end
			write_low_16 : begin
				word_wr 					<= 'b0;
				if (~word_busy) begin // we need to wait for access
					word_addr 				<= word_addr + 'b100; // We have to make sure that we are doing a 32bit word process here
					RAM_STATE 				<= write_low_wait_8;
					word_wr 					<= 'b1;
					bridge_processing		<= 'b0;
					word_data 				<= {4{~bigendin ? bridge_wr_data_reg[15:8] : bridge_wr_data_reg[7:0]}};
				end
			end
			write_low_wait_8 : begin
				if (word_busy) begin
					RAM_STATE 				<= write_low_8;
				end
			end
			write_low_8 : begin
				word_wr 					<= 'b0;
				if (~word_busy) begin // we need to wait for access
					word_addr 				<= word_addr + 'b100; // We have to make sure that we are doing a 32bit word process here
					RAM_STATE 				<= idle;
					word_wr 					<= 'b1;
					bridge_processing		<= 'b0;
					word_data 				<= {4{bigendin ? bridge_wr_data_reg[15:8] : bridge_wr_data_reg[7:0]}};
				end
			end
			
			
			wait_read : begin
				if (~word_busy) begin
					RAM_STATE 					<= idle;
					bridge_completed 			<= 'b1;
					case (bigendin)
						1'b1 		: bridge_rd_data	<= word_q;
						default 	: bridge_rd_data	<= {word_q[23:16], word_q[31:24], word_q[7:0], word_q[15:8]};
					endcase
					bridge_processing			<= 'b0;
				end
			end
			default : begin
				if (bridge_rd_f || bridge_wr_f) begin
					RAM_STATE 					<= request;
				   requested_read 			<= bridge_rd_f;
					bridge_wr_data_reg		<= bridge_wr_data_s;
					bridge_processing			<= 'b1;
					case (bridge_addr_s[23:20])
						4'hc,
						4'hd		: word_32bit <= 1'b0;
						default 	: word_32bit <= 1'b1;
					endcase
				end
				else begin
					RAM_STATE 					<= 'd0;
					requested_read 			<= 'd0;
					word_rd						<= 'd0;
					word_wr						<= 'd0;
				end
			end		
		endcase	
	end
end


endmodule