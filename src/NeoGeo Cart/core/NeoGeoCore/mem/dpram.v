module dpram #(parameter ADDRWIDTH=8, DATAWIDTH=8, NUMWORDS=1<<ADDRWIDTH, MEM_INIT_FILE="")
(
	input	                 clock_a,
	input	 [ADDRWIDTH-1:0] address_a,
	input	 [DATAWIDTH-1:0] data_a,
	input	                 wren_a,
	output [DATAWIDTH-1:0] q_a,

	input	                 clock_b,
	input	 [ADDRWIDTH-1:0] address_b,
	input 					  ce_b,
	input	 [DATAWIDTH-1:0] data_b,
	input	                 wren_b,
	output [DATAWIDTH-1:0] q_b
);

altsyncram altsyncram_component (
			.address_a (address_a),
			.address_b (address_b),
			.clock0 (clock_a),
			.clock1 (clock_b),
			.data_a (data_a),
			.data_b (data_b),
			.wren_a (wren_a),
			.wren_b (wren_b),
			.q_a (q_a),
			.q_b (q_b),
			.aclr0 (1'b0),
			.aclr1 (1'b0),
			.addressstall_a (1'b0),
			.addressstall_b (1'b0),
			.byteena_a (1'b1),
			.byteena_b (1'b1),
			.clocken0 (1'b1),
			.clocken1 (1'b1),
			.clocken2 (1'b1),
			.clocken3 (1'b1),
			.eccstatus (),
			.rden_a (1'b1),
			.rden_b (ce_b));
defparam
	altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK1",
	altsyncram_component.address_reg_b = "CLOCK1",
	altsyncram_component.indata_reg_b = "CLOCK1",
	altsyncram_component.numwords_a = NUMWORDS,
	altsyncram_component.numwords_b = NUMWORDS,
	altsyncram_component.widthad_a = ADDRWIDTH,
	altsyncram_component.widthad_b = ADDRWIDTH,
	altsyncram_component.width_a = DATAWIDTH,
	altsyncram_component.width_b = DATAWIDTH,
	altsyncram_component.width_byteena_a = 1,
	altsyncram_component.width_byteena_b = 1,

	altsyncram_component.init_file = MEM_INIT_FILE, 
	altsyncram_component.clock_enable_input_a = "NORMAL",
	altsyncram_component.clock_enable_input_b = "NORMAL",
	altsyncram_component.clock_enable_output_a = "BYPASS",
	altsyncram_component.clock_enable_output_b = "BYPASS",
	altsyncram_component.intended_device_family = "Cyclone V",
	altsyncram_component.lpm_type = "altsyncram",
	altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
	altsyncram_component.outdata_aclr_a = "NONE",
	altsyncram_component.outdata_aclr_b = "NONE",
	altsyncram_component.outdata_reg_a = "UNREGISTERED",
	altsyncram_component.outdata_reg_b = "UNREGISTERED",
	altsyncram_component.power_up_uninitialized = "FALSE",
	altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
	altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
	altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ";

endmodule

module spram #(parameter ADDRWIDTH=8, DATAWIDTH=8, NUMWORDS=1<<ADDRWIDTH)
(
	input	                 clock,
	input	 [ADDRWIDTH-1:0] address,
	input	 [DATAWIDTH-1:0] data,
	input	                 wren,
	output reg [DATAWIDTH-1:0] q
);

reg [DATAWIDTH-1:0] memory [(2**ADDRWIDTH)-1:0];

always @(posedge clock) begin
	if (wren) memory[address] <= data;
	q <= memory[address];
end

//	altsyncram	altsyncram_component (
//				.address_a (address),
//				.clock0 (clock),
//				.data_a (data),
//				.wren_a (wren),
//				.q_a (q),
//				.aclr0 (1'b0),
//				.aclr1 (1'b0),
//				.address_b (1'b1),
//				.addressstall_a (1'b0),
//				.addressstall_b (1'b0),
//				.byteena_a (1'b1),
//				.byteena_b (1'b1),
//				.clock1 (1'b1),
//				.clocken0 (1'b1),
//				.clocken1 (1'b1),
//				.clocken2 (1'b1),
//				.clocken3 (1'b1),
//				.data_b (1'b1),
//				.eccstatus (),
//				.q_b (),
//				.rden_a (1'b1),
//				.rden_b (1'b1),
//				.wren_b (1'b0));
//	defparam
//		altsyncram_component.numwords_a = NUMWORDS,
//		altsyncram_component.widthad_a = ADDRWIDTH,
//		altsyncram_component.width_a = DATAWIDTH,
//		altsyncram_component.width_byteena_a = 1,
//		altsyncram_component.clock_enable_input_a = "BYPASS",
//		altsyncram_component.clock_enable_output_a = "BYPASS",
//		altsyncram_component.intended_device_family = "Cyclone V",
//		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
//		altsyncram_component.lpm_type = "altsyncram",
//		altsyncram_component.operation_mode = "SINGLE_PORT",
//		altsyncram_component.outdata_aclr_a = "NONE",
//		altsyncram_component.outdata_reg_a = "UNREGISTERED",
//		altsyncram_component.power_up_uninitialized = "FALSE",
//		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ";

endmodule


module cpram
(
	input         clock,
	input         reset,

	input         wr,
	input  [15:0] data,

	input         rd,
	output [15:0] q
);

reg [8:0] rdaddress;
reg [8:0] wraddress;

always @(posedge clock) begin
	if(wr) wraddress <= wraddress + 1'd1;
	if(rd) rdaddress <= rdaddress + 1'd1;

	if(wr) rdaddress <= 0;
	if(rd) wraddress <= 0;

	if(reset) begin
		wraddress <= 0;
		rdaddress <= 0;
	end
end

altsyncram	altsyncram_component (
			.address_a (wraddress),
			.address_b (rdaddress),
			.clock0 (clock),
			.data_a (data),
			.wren_a (wr),
			.q_b (q),
			.aclr0 (1'b0),
			.aclr1 (1'b0),
			.addressstall_a (1'b0),
			.addressstall_b (1'b0),
			.byteena_a (1'b1),
			.byteena_b (1'b1),
			.clock1 (1'b1),
			.clocken0 (1'b1),
			.clocken1 (1'b1),
			.clocken2 (1'b1),
			.clocken3 (1'b1),
			.data_b ({16{1'b1}}),
			.eccstatus (),
			.q_a (),
			.rden_a (1'b1),
			.rden_b (1'b1),
			.wren_b (1'b0));
defparam
	altsyncram_component.address_aclr_b = "NONE",
	altsyncram_component.address_reg_b = "CLOCK0",
	altsyncram_component.clock_enable_input_a = "BYPASS",
	altsyncram_component.clock_enable_input_b = "BYPASS",
	altsyncram_component.clock_enable_output_b = "BYPASS",
	altsyncram_component.intended_device_family = "Cyclone V",
	altsyncram_component.lpm_type = "altsyncram",
	altsyncram_component.numwords_a = 512,
	altsyncram_component.numwords_b = 512,
	altsyncram_component.operation_mode = "DUAL_PORT",
	altsyncram_component.outdata_aclr_b = "NONE",
	altsyncram_component.outdata_reg_b = "UNREGISTERED",
	altsyncram_component.power_up_uninitialized = "FALSE",
	altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
	altsyncram_component.widthad_a = 9,
	altsyncram_component.widthad_b = 9,
	altsyncram_component.width_a = 16,
	altsyncram_component.width_b = 16,
	altsyncram_component.width_byteena_a = 1;

endmodule

module dpram_lo
(
	input	                 clock_a,
	input	 [13:0] address_a,
	input	 [31:0] data_a,
	input	                 wren_a,
	output [31:0] q_a,

	input	                 clock_b,
	input	 [14:0] address_b,
	input	 [16:0] data_b,
	input	                 wren_b,
	output [16:0] q_b
);

altsyncram altsyncram_component (
			.address_a (address_a),
			.address_b (address_b),
			.clock0 (clock_a),
			.clock1 (clock_b),
			.data_a (data_a),
			.data_b (data_b),
			.wren_a (wren_a),
			.wren_b (wren_b),
			.q_a (q_a),
			.q_b (q_b),
			.aclr0 (1'b0),
			.aclr1 (1'b0),
			.addressstall_a (1'b0),
			.addressstall_b (1'b0),
			.byteena_a (1'b1),
			.byteena_b (1'b1),
			.clocken0 (1'b1),
			.clocken1 (1'b1),
			.clocken2 (1'b1),
			.clocken3 (1'b1),
			.eccstatus (),
			.rden_a (1'b1),
			.rden_b (1'b1));
defparam
	altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK1",
	altsyncram_component.address_reg_b = "CLOCK1",
	altsyncram_component.indata_reg_b = "CLOCK1",
	altsyncram_component.numwords_a = 16384,
	altsyncram_component.numwords_b = 32768,
	altsyncram_component.widthad_a = 14,
	altsyncram_component.widthad_b = 15,
	altsyncram_component.width_a = 32,
	altsyncram_component.width_b = 16,
	altsyncram_component.width_byteena_a = 1,
	altsyncram_component.width_byteena_b = 1,
//
//	altsyncram_component.init_file = MEM_INIT_FILE, 
	altsyncram_component.clock_enable_input_a = "NORMAL",
	altsyncram_component.clock_enable_input_b = "NORMAL",
	altsyncram_component.clock_enable_output_a = "BYPASS",
	altsyncram_component.clock_enable_output_b = "BYPASS",
	altsyncram_component.intended_device_family = "Cyclone V",
	altsyncram_component.lpm_type = "altsyncram",
	altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
	altsyncram_component.outdata_aclr_a = "NONE",
	altsyncram_component.outdata_aclr_b = "NONE",
	altsyncram_component.outdata_reg_a = "UNREGISTERED",
	altsyncram_component.outdata_reg_b = "UNREGISTERED",
	altsyncram_component.power_up_uninitialized = "FALSE",
	altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
	altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
	altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ";

endmodule