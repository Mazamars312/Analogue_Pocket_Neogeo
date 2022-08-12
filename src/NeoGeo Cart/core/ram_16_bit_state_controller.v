/****************************************************************************************
	
	Ram arbertor for Writing 16bit streams
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following:
	
	This will stream the 32bit data through a 16bit bus.
	Does both big and little eiden accesses
	
	ToDo:
		work on the read process

*****************************************************************************************/

// Version 0.6.0 Alpha
// Added the read side to follow the Big and little enden coding.

module ram_16_bit_state_controller (
	input 						clk_74a,
	input 						clk_sys,
	input 						reset_l,
	
	input							bigendin,
	
	// Ram Controller
	output reg					word_rd,
	output reg 					word_wr,
	output reg 	[25:0]		word_addr,
	output reg 	[15:0]		word_data,
	input 	  	[15:0]		word_q,
	input							word_busy,
	
	// SPI interface
	input			[31:0]		bridge_addr,
	input							bridge_rd,
	output reg	[31:0]		bridge_rd_data,
	input							bridge_wr,
	input			[31:0]		bridge_wr_data,
	output reg					bridge_processing,
	output reg 					bridge_completed
);



/*************************************************************

	interface controller to Memory cores once the dataslot
	is confirmed.

*************************************************************/

wire read_active_bridge = bridge_rd;

	wire 		bridge_rd_s, bridge_rd_r, bridge_rd_f;
synch_3 s00(read_active_bridge, bridge_rd_s, clk_sys, bridge_rd_r, bridge_rd_f);

wire write_active_bridge = bridge_wr;

	wire 		bridge_wr_s, bridge_wr_r, bridge_wr_f;
synch_3 s01(write_active_bridge, bridge_wr_s, clk_sys, bridge_wr_r, bridge_wr_f);

	wire [31:0]	bridge_wr_data_s;
synch_3 #(.WIDTH(32)) s02(bridge_wr_data, bridge_wr_data_s, clk_sys);

	wire [31:0]	bridge_addr_s;
synch_3 #(.WIDTH(32)) s03(bridge_addr, bridge_addr_s, clk_sys);


reg [2:0] 	RAM_STATE;

reg 			requested_read;
reg [31:0]	word_data_reg;

reg [31:0]	bridge_rd_data_reg;

parameter	idle				=	'd0;
parameter	request			=	'd1;
parameter	wait_read_1 	=	'd2;
parameter	wait_read_2		=	'd3;
parameter	wait_read_3		=	'd4;
parameter	wait_write_2	=	'd5; // We have already does the first write

always @(posedge clk_sys or negedge reset_l) begin
	if (~reset_l) begin
		RAM_STATE 								<= 'd0;
		requested_read 						<= 'd0;
		word_rd									<= 'd0;
		word_wr									<= 'd0;
		word_addr								<= 'd0;
		word_data								<= 'd0;
		bridge_rd_data_reg					<= 'd0;
		bridge_completed						<= 'b0;
		bridge_processing						<= 'b0;
	end
	else begin
		word_rd									<= 'd0;
		word_wr									<= 'd0;
		bridge_completed						<= 'b0;
		case (RAM_STATE)
			request : begin
				bridge_processing				<= 'b1;
				if (~word_busy) begin // we need to wait for access
					if (requested_read) 	begin
						RAM_STATE 				<= wait_read_1;
						word_rd 					<= 'b1;
					end
					else begin
						RAM_STATE 				<= wait_write_2;
						word_wr 					<= 'b1;
						bridge_processing		<= 'b1;
						word_data 				<= word_data_reg[31:16];
						
					end
				end
			end
			wait_read_1 : begin
				if (~word_busy) begin
					word_addr 					<= word_addr + 2;
					RAM_STATE 					<= wait_read_2;
					word_rd 						<= 'b1;
					bridge_completed 			<= 'b0;
					case (bigendin)
						1'b1 		: bridge_rd_data_reg[31:16]	<= word_q;
						default 	: bridge_rd_data_reg[31:16]	<= {word_q[7:0], word_q[15:8]};
					endcase
					bridge_processing			<= 'b1;
				end
			end
			wait_read_2 : begin
				if (~word_busy) begin
					RAM_STATE 					<= wait_read_3;
					bridge_completed 			<= 'b0;
					bridge_processing			<= 'b1;
				end
			end
			wait_read_3 : begin
				RAM_STATE 					<= idle;
				bridge_completed 			<= 'b1;
				case (bigendin)
					1'b1 		: bridge_rd_data_reg[15: 0]	<= word_q;
					default 	: bridge_rd_data_reg[15: 0]	<= {word_q[7:0], word_q[15:8]};
				endcase
				bridge_processing			<= 'b0;
			end
			wait_write_2 : begin
				if (~word_busy) begin
					RAM_STATE 				<= idle;
					word_wr 					<= 'b1;
					bridge_processing		<= 'b0;
					word_data 				<= word_data_reg[15: 0];
					word_addr 				<= word_addr + 2;
				end
			end
			default : begin
				if (bridge_rd_f || bridge_wr_f) begin
					RAM_STATE 					<= request;
					word_addr 					<= bridge_addr_s[31:0]; // We have to make sure that we are doing a 32bit word process here to a 16bit word
					word_data 					<= bigendin ? bridge_wr_data_s : 
														{bridge_wr_data_s[23:16], bridge_wr_data_s[31:24], bridge_wr_data_s[7:0], bridge_wr_data_s[15:8]};
				   requested_read 			<= bridge_rd_f;
					word_data_reg				<= bigendin ? bridge_wr_data_s : 
														{bridge_wr_data_s[23:16], bridge_wr_data_s[31:24], bridge_wr_data_s[7:0], bridge_wr_data_s[15:8]};
					bridge_processing			<= 'b1;
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

always @(posedge clk_74a or negedge reset_l) begin
	if (~reset_l) bridge_rd_data <= 'b0;
	else bridge_rd_data <= bridge_rd_data_reg;
end

endmodule