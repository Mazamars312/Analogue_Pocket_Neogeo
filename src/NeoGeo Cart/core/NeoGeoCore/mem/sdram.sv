//
// io_sdram
//
// 2019-2022 analogue-marshall
//

module sdram (

input		wire				controller_clk,
input		wire				chip_clk,
input		wire				clk_90,
input		wire				reset_n,

output	reg				phy_cke,
output	wire				phy_clk,
output	wire				phy_cas,
output	wire				phy_ras,
output	wire				phy_we,
output	reg	[1:0]		phy_ba,
output	reg	[12:0]	phy_a,
inout	wire	[15:0]		phy_dq,
output	reg	[1:0]		phy_dqm,

input	wire					burst_rd, // must be synchronous to clk_ram
input	wire	[24:0]		burst_addr,
input	wire	[10:0]		burst_len,
input	wire					burst_32bit,
output	reg	[31:0]	burst_data,
output	reg				burst_data_valid,
output	reg				burst_data_done,

input		wire				burstwr,
input		wire	[24:0]	burstwr_addr,
output	reg				burstwr_ready,
input		wire				burstwr_strobe,
input		wire	[15:0]	burstwr_data,
input		wire				burstwr_done,

input		wire				word_rd, // can be from other clock domain. we synchronize these
input		wire				word_wr,
input		wire	[23:0]	word_addr,
input		wire	[31:0]	word_data,
output	reg	[31:0]	word_q,
output	reg				word_busy
);

	// tristate for DQ
	reg				phy_dq_oe;		
	assign			phy_dq = phy_dq_oe ? phy_dq_out : 16'bZZZZZZZZZZZZZZZZ;
	reg	[15:0]	phy_dq_out;

	reg	[2:0]		cmd;
	assign {phy_ras, phy_cas, phy_we} = cmd;

	localparam		CMD_NOP				= 3'b111;
	localparam		CMD_ACT				= 3'b011;
	localparam		CMD_READ			= 3'b101;
	localparam		CMD_WRITE			= 3'b100;
	localparam		CMD_PRECHG			= 3'b010;
	localparam		CMD_AUTOREF			= 3'b001;
	localparam		CMD_LMR				= 3'b000;
	localparam		CMD_SELFENTER		= 3'b001;
	localparam		CMD_SELFEXIT		= 3'b111;

	localparam		CAS					= 	4'd3;	// timings are for 166mhz
	localparam		TIMING_LMR			= 	4'd2;	// tLMR = 2ck
	localparam		TIMING_AUTOREFRESH	=	4'd12;	// tRFC = 80
	localparam		TIMING_PRECHARGE	=	4'd3;	// tRP = 18
	localparam		TIMING_ACT_ACT		=	4'd9;	// tRC = 60
	localparam		TIMING_ACT_RW		=	4'd3;	// tRCD = 18
	localparam		TIMING_ACT_PRECHG	=	4'd7;	// tRAS = 42
	localparam		TIMING_WRITE		=	4'd3;	// tWR = 2ck

	reg		[5:0]	state;
	
	localparam		ST_RESET			= 'd0;
	localparam		ST_BOOT_0			= 'd1;
	localparam		ST_BOOT_1			= 'd2;
	localparam		ST_BOOT_2			= 'd3;
	localparam		ST_BOOT_3			= 'd4;
	localparam		ST_BOOT_4			= 'd5;
	localparam		ST_BOOT_5			= 'd6;
	localparam		ST_IDLE				= 'd7;
	
	localparam		ST_WRITE_0			= 'd20;
	localparam		ST_WRITE_1			= 'd21;
	localparam		ST_WRITE_2			= 'd22;
	localparam		ST_WRITE_3			= 'd23;
	localparam		ST_WRITE_4			= 'd24;
	localparam		ST_WRITE_5			= 'd25;
	localparam		ST_WRITE_6			= 'd26;
	
	localparam		ST_READ_0			= 'd30;
	localparam		ST_READ_1			= 'd31;
	localparam		ST_READ_2			= 'd32;
	localparam		ST_READ_3			= 'd33;
	localparam		ST_READ_4			= 'd34;
	localparam		ST_READ_5			= 'd35;
	localparam		ST_READ_6			= 'd36;
	localparam		ST_READ_7			= 'd37;
	localparam		ST_READ_8			= 'd38;
	localparam		ST_READ_9			= 'd39;
	
	localparam		ST_BURSTWR_0		= 'd46;
	localparam		ST_BURSTWR_1		= 'd47;
	localparam		ST_BURSTWR_2		= 'd48;
	localparam		ST_BURSTWR_3		= 'd49;
	localparam		ST_BURSTWR_4		= 'd50;
	localparam		ST_BURSTWR_5		= 'd51;
	localparam		ST_BURSTWR_6		= 'd52;
	localparam		ST_BURSTWR_7		= 'd53;
	
	localparam		ST_REFRESH_0		= 'd60;
	localparam		ST_REFRESH_1		= 'd61;
	
	
	reg		[23:0]	delay_boot;
	reg		[15:0]	dc;
	reg		[9:0]	refresh_count;
	reg				issue_autorefresh;
	
	wire reset_n_s;
synch_3 s1(reset_n, reset_n_s, controller_clk);	

	reg word_rd_queue;
	reg word_wr_queue;
	wire word_rd_s, word_rd_r;
	wire word_wr_s, word_wr_r;
synch_3 s2(word_rd, word_rd_s, controller_clk, word_rd_r);	
synch_3 s3(word_wr, word_wr_s, controller_clk, word_wr_r);	

	wire	[23:0]	word_addr_s;
synch_3 #(.WIDTH(24)) s4(word_addr, word_addr_s, controller_clk);

	wire	[31:0]	word_data_s;
synch_3 #(.WIDTH(32)) s5(word_data, word_data_s, controller_clk);
	
	reg burst_rd_queue;
	reg	burstwr_queue;
	
	reg				word_op;
	reg				bram_op;
	reg		[24:0]	addr;
	wire	[9:0]	addr_col9_next_1 = addr[9:0] + 'h1;
	
	reg		[10:0]	length;
	wire	[10:0]	length_next = length - 'h1;
	reg				enable_dq_read, enable_dq_read_1, enable_dq_read_2, enable_dq_read_3, enable_dq_read_4, enable_dq_read_5;
	reg				enable_dq_read_toggle;
	
	reg				enable_data_done, enable_data_done_1, enable_data_done_2, enable_data_done_3, enable_data_done_4;

	reg				read_newrow;
	reg				burstwr_newrow;
	
	
	// the phase delay on the reads are calibrated at runtime
	reg		[15:0]	phy_dq_latched;
always @(posedge controller_clk) begin//chip_clk) begin
	phy_dq_latched <= phy_dq;
end

	
always @(*) begin
	burst_data_done <= enable_data_done_4;
end
initial begin
	state <= ST_RESET;
	phy_cke <= 0;
end
always @(posedge controller_clk) begin
	phy_dq_oe <= 0;
	cmd <= CMD_NOP;
	dc <= dc + 1'b1;
	
	burst_data_valid <= 0;
	burstwr_ready <= 0;
	
	enable_dq_read_5 <= enable_dq_read_4;
	enable_dq_read_4 <= enable_dq_read_3;
	enable_dq_read_3 <= enable_dq_read_2;
	enable_dq_read_2 <= enable_dq_read_1;
	enable_dq_read_1 <= enable_dq_read;
	enable_dq_read <= 0;
	
	enable_data_done_4 <= enable_data_done_3;
	enable_data_done_3 <= enable_data_done_2;
	enable_data_done_2 <= enable_data_done_1;
	enable_data_done_1 <= enable_data_done;
	enable_data_done <= 0;
	
	// delayed by CAS latency for reads
	// this is triggered by the read FSM but delayed by 3 clocks
	// this makes the FSM simple and everybody happy
	if(enable_dq_read_4) begin
		enable_dq_read_toggle <= ~enable_dq_read_toggle;
		
		if(word_op) begin
			if(~enable_dq_read_toggle) begin
				// even cycles 
				word_q[31:16] <= phy_dq;
			end else begin
				// odd cycles
				word_q[15:0] <= phy_dq;
				//word_q_valid <= 1;
			end
		
		end else begin
			if(burst_32bit) begin
				// accumulate high/low word
				if(~enable_dq_read_toggle) begin
					// even cycles 
					burst_data[31:16] <= phy_dq;
				end else begin
					// odd cycles
					burst_data[15:0] <= phy_dq;
					burst_data_valid <= 1;
				end
			end else begin
				// 16-bit
				burst_data[15:0] <= phy_dq;
				burst_data_valid <= 1;
			end
		end
	end
	
	
	case(state)
	ST_RESET: begin
		phy_cke <= 0;
		cmd <= CMD_NOP;
		delay_boot <= 0;
		issue_autorefresh <= 0;
		phy_dqm <= 2'b00;
		
		state <= ST_BOOT_0;
	end
	ST_BOOT_0: begin
		delay_boot <= delay_boot + 1'b1;

		if(delay_boot == 30000-16) phy_cke <= 1;
		if(delay_boot == 30000) begin
			// 200uS @ 166mhz
			dc <= 0;
			
			// precharge all
			cmd <= CMD_PRECHG;
			phy_a[10] = 1'b1;
	
			state <= ST_BOOT_1;
		end
	end
	ST_BOOT_1: begin
		if(dc == TIMING_PRECHARGE-1) begin
			dc <= 0;
			cmd <= CMD_AUTOREF;
			
			state <= ST_BOOT_2;
		end
	end
	ST_BOOT_2: begin
		if(dc == TIMING_AUTOREFRESH-1) begin
			dc <= 0;
			cmd <= CMD_AUTOREF;
	
			state <= ST_BOOT_3;
		end
	end
	ST_BOOT_3: begin
		if(dc == TIMING_AUTOREFRESH-1) begin
			dc <= 0;
			cmd <= CMD_LMR;
			phy_ba <= 'b00;
			phy_a <= 13'b000000_011_0_000; // CAS 3, burst length 1, sequential
	
			state <= ST_BOOT_4;
		end
	end
	ST_BOOT_4: begin
		if(dc == TIMING_LMR-1) begin
			dc <= 0;
			cmd <= CMD_LMR;
			phy_ba <= 'b10; // Extended mode register
			phy_a <= 13'b00000_010_00_000; // Self refresh coverage: All banks, 
			// drive strength = 3'b010 (alliance, 50%) 
			state <= ST_BOOT_5;
		end
	end
	ST_BOOT_5: begin
		if(dc == TIMING_LMR-1) begin
			phy_dqm <= 2'b00;
			
			state <= ST_IDLE;
		end
	end

	
	ST_IDLE: begin
	
		read_newrow <= 0;
		word_busy <= 0;
		word_op <= 0;
		
		if(issue_autorefresh) begin
			state <= ST_REFRESH_0;
		end else
		if(word_rd_queue) begin
			word_rd_queue <= 0;
			word_op <= 1;
			addr <= word_addr << 1;
			
			length <= 2;
			state <= ST_READ_0;
		end else 
		if(word_wr_queue) begin
			word_wr_queue <= 0;
			word_op <= 1;
			addr <= word_addr << 1;
			
			state <= ST_WRITE_0;
		end else 
		if(burst_rd_queue) begin
			burst_rd_queue <= 0;
			addr <= burst_addr;
			length <= burst_len;
			state <= ST_READ_0;
		end else
		if(burstwr_queue) begin
			burstwr_queue <= 0;
			addr <= burstwr_addr;
			state <= ST_BURSTWR_0;
		end 
		
	
	end
	
	
	
	ST_WRITE_0: begin
		dc <= 0;
		
		phy_ba <= addr[24:23];
		phy_a <= addr[22:10]; // A0-A12 column address
		cmd <= CMD_ACT;
		
		state <= ST_WRITE_1;
	end
	ST_WRITE_1: begin
		phy_a[10] <= 1'b0; // no auto precharge
		if(dc == TIMING_ACT_RW-1) begin
			dc <= 0;
			phy_dq_oe <= 1;
			state <= ST_WRITE_2;
		end	
	end
	ST_WRITE_2: begin
		dc <= 0;	
		
		phy_a <= addr[9:0]; // A0-A9 row address
		cmd <= CMD_WRITE;
		phy_dq_oe <= 1;
		phy_dq_out <= word_data[31:16];//addr[15:0];//
		addr <= addr + 1'b1;
		
		state <= ST_WRITE_3;	
	end
	ST_WRITE_3: begin
		dc <= 0;	
		
		phy_a <= addr[9:0]; // A0-A9 row address
		cmd <= CMD_WRITE;
		phy_dq_oe <= 1;
		phy_dq_out <= word_data[15:0];//16'hABCD; //
		addr <= addr + 1'b1;
		
		state <= ST_WRITE_4;	
	end
	ST_WRITE_4: begin
		if(dc == TIMING_WRITE-1+1) begin
			dc <= 0;
			cmd <= CMD_PRECHG;
			phy_a[10] <= 0; // only precharge current bank 
			state <= ST_WRITE_5;	
		end
	end
	ST_WRITE_5: begin
		if(dc == TIMING_PRECHARGE-1) begin // was -3
			state <= ST_IDLE;
		end	
	end
	
	
	ST_READ_0: begin
		dc <= 0;
		
		phy_ba <= addr[24:23];
		phy_a <= addr[22:10]; // A0-A12 column address
		cmd <= CMD_ACT;
		
		state <= ST_READ_1;
	end
	ST_READ_1: begin
		phy_a[10] <= 1'b0; // no auto precharge
		enable_dq_read_toggle <= 0;
		if(dc == TIMING_ACT_RW-1) begin
			dc <= 0;
			state <= ST_READ_2;
		end	
	end
	ST_READ_2: begin
		phy_a <= addr[9:0]; // A0-A9 row address
		cmd <= CMD_READ;
			
		enable_dq_read <= 1;
		
		length <= length - 1'b1;
		addr <= addr + 1'b1;
		
		if(length == 1) begin
			// we just read the last word, bail
			read_newrow <= 0;
			state <= ST_READ_5;
		end else
		if(addr[9:0] == 10'd1023) begin
			// at the end of the row, we must activate next row to continue a read
			read_newrow <= 1;
			state <= ST_READ_5;
		end
	end
	ST_READ_5: begin
		state <= ST_READ_8;
	end
	ST_READ_8: begin
		state <= ST_READ_9;
	end
	ST_READ_9: begin
		state <= ST_READ_6;// hmm do we need this
	end
	ST_READ_6: begin
		if(!read_newrow && !word_op) enable_data_done <= 1;
		dc <= 0;
		cmd <= CMD_PRECHG;
		phy_a[10] <= 0; // only precharge current bank
		state <= ST_READ_7;	
	end
	ST_READ_7: begin
		if(dc == TIMING_PRECHARGE-1) begin
			if(read_newrow) 
				state <= ST_READ_0;
			else
				state <= ST_IDLE;
		end	
	end
	
	ST_BURSTWR_0: begin
		phy_ba <= addr[24:23];
		phy_a <= addr[22:10]; // A0-A12 column address
		cmd <= CMD_ACT;
		state <= ST_BURSTWR_1;
	end
	ST_BURSTWR_1: begin
		cmd <= CMD_NOP;
		state <= ST_BURSTWR_2;
	end
	ST_BURSTWR_2: begin
		cmd <= CMD_NOP;
		state <= ST_BURSTWR_3;
	end
	ST_BURSTWR_3: begin
		burstwr_ready <= 1;
		burstwr_newrow <= 0;
		
		if(burstwr_strobe) begin
		
			phy_a <= addr[9:0]; // A0-A9 row address
			cmd <= CMD_WRITE;
			phy_dq_oe <= 1;
			phy_dq_out <= burstwr_data;
			
			addr <= addr + 1'b1;
			/*if(addr_col9_next_1 == 9'h0) begin
				burstwr_ready <= 0;
				burstwr_newrow <= 1;
				state <= ST_BURSTWR_4;
			end */
		end
		if(burstwr_strobe | burstwr_done) begin
			burstwr_newrow <= 0;
			state <= ST_BURSTWR_4;
		end
	end
	ST_BURSTWR_4: begin
		cmd <= CMD_NOP;
		state <= ST_BURSTWR_5;
	end
	ST_BURSTWR_5: begin
		cmd <= CMD_PRECHG;
		phy_a[10] <= 0; // only precharge current bank 
		state <= ST_BURSTWR_6;
	end
	ST_BURSTWR_6: begin
		cmd <= CMD_NOP;
		state <= ST_BURSTWR_7;	
	end
	ST_BURSTWR_7: begin
		cmd <= CMD_NOP;
		state <= ST_IDLE;	
		if(burstwr_newrow) begin
			state <= ST_BURSTWR_0;
			if(issue_autorefresh) begin
				state <= ST_REFRESH_0;
			end
		end
	end
	
	
	ST_REFRESH_0: begin
		// autorefresh 
		issue_autorefresh <= 0;
		
		cmd <= CMD_AUTOREF;
		dc <= 0;
		state <= ST_REFRESH_1;
	end
	ST_REFRESH_1: begin
		if(dc == TIMING_AUTOREFRESH-1)  begin
			state <= ST_IDLE;
			if(burstwr_newrow) begin
				state <= ST_BURSTWR_0;
			end
		end
	end
	
	endcase
	
	
	// catch incoming events if fsm is busy
	if(word_rd_r) begin
		word_rd_queue <= 1;
	end
	if(word_wr_r) begin
		word_wr_queue <= 1;
	end
	if(burst_rd) begin
		burst_rd_queue <= 1;
	end
	if(burstwr) begin
		burstwr_queue <= 1;
	end
	
	// autorefresh generator
	refresh_count <= refresh_count + 1'b1;
	if(&refresh_count) begin 
		// every 6.144 uS @ 166mhz
		// note that the number of rows affects how often you must issue a refresh command
		// and this particular sdram has more than usual
		refresh_count <= 0;
		issue_autorefresh <= 1;
	
	end
	
	if(~reset_n_s) begin	
		// reset
		state <= ST_RESET;
		refresh_count <= 0;
	end
end
/*
pin_ddio_clk	isdrck (
	.datain_h 	( 1'b1 ),
	.datain_l 	( 1'b0 ),
	.outclock 	( clk_90 ),
	.dataout 	( phy_clk )
);
*/

/*
altddio_out
#(
	.extend_oe_disable("OFF"),
	.intended_device_family("Cyclone V"),
	.invert_output("OFF"),
	.lpm_hint("UNUSED"),
	.lpm_type("altddio_out"),
	.oe_reg("UNREGISTERED"),
	.power_up_high("OFF"),
	.width(1)
)
sdramclk_ddr
(
	.datain_h(1'b0),
	.datain_l(1'b1),
	.outclock(chip_clk),
	.dataout(phy_clk),
	.aclr(1'b0),
	.aset(1'b0),
	.oe(1'b1),
	.outclocken(1'b1),
	.sclr(1'b0),
	.sset(1'b0)
);
*/

assign phy_clk = chip_clk;

endmodule


