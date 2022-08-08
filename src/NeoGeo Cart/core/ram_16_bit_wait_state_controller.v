/****************************************************************************************
	
	Ram arbertor for Writing 32bit streams made for the Neogeo roms
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following:
	
	This will stream the 32bit data through a 32bit bus.
	Does sort the data partly for roms, need to look more in to this
	
	ToDo:
		work on the read process

*****************************************************************************************/


module ram_16_bit_wait_state_controller (
	input 						clk_74a,
	input 						clk_sys,
	input 						reset_l,
	
	input							bigendin,
	
	// Ram Controller
	output reg					word_rd,
	output reg 					word_wr,
	output reg 	[25:0]		word_addr,
	output reg 	[15:0]		word_data,
	input 	  	[31:0]		word_q,
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


reg [1:0] 	RAM_STATE;

reg 			requested_read;
reg [31:0]	word_data_reg;

reg [31:0]	counter;
reg			word_busy_reg;

parameter	idle				=	'd0;
parameter	request_1		=	'd1;
parameter	wait_write_1 	=	'd2;
parameter	wait_write_2	=	'd3; // We have already does the first write

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
		counter									<= 'b0;
	end
	else begin
		word_rd									<= 'd0;
		word_wr									<= 'd0;
		bridge_completed						<= 'b0;
		word_busy_reg							<= word_busy;
		case (RAM_STATE)
			request_1 : begin
				bridge_processing				<= 'b1;
				RAM_STATE 				<= wait_write_1;
				word_wr 					<= 'b1;
				word_data 				<= word_data_reg[31:16];
				counter					<= 'b0;
			end
			wait_write_1 : begin
				RAM_STATE 				<= wait_write_2;
				word_wr 					<= 'b0;
				bridge_processing		<= 'b1;
			end
			wait_write_2 : begin
				word_addr 				<= word_addr + 2;
				RAM_STATE 				<= idle;
				word_wr 					<= 'b1;
				bridge_processing		<= 'b0;
				word_data 				<= word_data_reg[15:0];
			end
			default : begin
				if (bridge_wr_f) begin
					RAM_STATE 					<= request_1;
					word_addr 					<= bridge_addr_s[31:0]; // We have to make sure that we are doing a 32bit word process here to a 16bit word
					word_data_reg				<=  {bridge_wr_data[31:24], 
														  bridge_wr_data[15:8], 
														  bridge_wr_data[23:16], 
														  bridge_wr_data[7:0]};
					bridge_processing			<= 'b1;
				end
				else begin
					RAM_STATE 					<= 'd0;
					requested_read 			<= 'd0;
					word_rd						<= 'd0;
					word_wr						<= 'd0;
					counter						<= 'b0;
				end
			end		
		endcase	
	end
end


endmodule