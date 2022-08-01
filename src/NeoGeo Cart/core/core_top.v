//
// User core top-level
//
// Instantiated by the real top-level: apf_top
//

`default_nettype none

module core_top (

//
// physical connections
//

///////////////////////////////////////////////////
// clock inputs 74.25mhz. not phase aligned, so treat these domains as asynchronous

input 	wire 				clk_74a, // mainclk1
input 	wire 				clk_74b, // mainclk1 

input 	wire				reset_l_main,

inout		wire				bridge_spimosi,
inout		wire				bridge_spimiso,
inout		wire				bridge_spiclk,
input		wire				bridge_spiss,
inout		wire				bridge_1wire,

///////////////////////////////////////////////////
// cartridge interface
// switches between 3.3v and 5v mechanically
// output enable for multibit translators controlled by pic32

// GBA AD[15:8]
inout		wire	[7:0]		cart_tran_bank2,
output	wire				cart_tran_bank2_dir,

// GBA AD[7:0]
inout		wire	[7:0]		cart_tran_bank3,
output	wire				cart_tran_bank3_dir,

// GBA A[23:16]
inout		wire	[7:0]		cart_tran_bank1,
output	wire				cart_tran_bank1_dir,

// GBA [7] PHI#
// GBA [6] WR#
// GBA [5] RD#
// GBA [4] CS1#/CS#
//     [3:0] unwired
inout		wire	[7:4]		cart_tran_bank0,
output	wire				cart_tran_bank0_dir,

// GBA CS2#/RES#
inout		wire				cart_tran_pin30,
output	wire				cart_tran_pin30_dir,
// when GBC cart is inserted, this signal when low or weak will pull GBC /RES low with a special circuit
// the goal is that when unconfigured, the FPGA weak pullups won't interfere.
// thus, if GBC cart is inserted, FPGA must drive this high in order to let the level translators
// and general IO drive this pin.
output	wire				cart_pin30_pwroff_reset,

// GBA IRQ/DRQ
inout	wire					cart_tran_pin31,
output	wire				cart_tran_pin31_dir,

// infrared
input		wire				port_ir_rx,
output	wire				port_ir_tx,
output	wire				port_ir_rx_disable, 

// GBA link port
inout		wire				port_tran_si,
output	wire				port_tran_si_dir,
inout		wire				port_tran_so,
output	wire				port_tran_so_dir,
inout		wire				port_tran_sck,
output	wire				port_tran_sck_dir,
inout		wire				port_tran_sd,
output	wire				port_tran_sd_dir,
 
///////////////////////////////////////////////////
// cellular psram 0 and 1, two chips (64mbit x2 dual die per chip)

output	wire	[21:16]	cram0_a,
inout		wire	[15:0]	cram0_dq,
input		wire				cram0_wait,
output	wire				cram0_clk,
output	wire				cram0_adv_n,
output	wire				cram0_cre,
output	wire				cram0_ce0_n,
output	wire				cram0_ce1_n,
output	wire				cram0_oe_n,
output	wire				cram0_we_n,
output	wire				cram0_ub_n,
output	wire				cram0_lb_n,

output	wire	[21:16]	cram1_a,
inout		wire	[15:0]	cram1_dq,
input		wire				cram1_wait,
output	wire				cram1_clk,
output	wire				cram1_adv_n,
output	wire				cram1_cre,
output	wire				cram1_ce0_n,
output	wire				cram1_ce1_n,
output	wire				cram1_oe_n,
output	wire				cram1_we_n,
output	wire				cram1_ub_n,
output	wire				cram1_lb_n,

///////////////////////////////////////////////////
// sdram, 512mbit 16bit

output	wire	[12:0]	dram_a,
output	wire	[1:0]		dram_ba,
inout		wire	[15:0]	dram_dq,
output	wire	[1:0]		dram_dqm,
output	wire				dram_clk,
output	wire				dram_cke,
output	wire				dram_ras_n,
output	wire				dram_cas_n,
output	wire				dram_we_n,

///////////////////////////////////////////////////
// sram, 1mbit 16bit

output	wire	[16:0]	sram_a,
inout		wire	[15:0]	sram_dq,
output	wire				sram_oe_n,
output	wire				sram_we_n,
output	wire				sram_ub_n,
output	wire				sram_lb_n,

///////////////////////////////////////////////////
// vblank driven by dock for sync in a certain mode

input	wire					vblank,

///////////////////////////////////////////////////
// i/o to 6515D breakout usb uart

output	wire				dbg_tx,
input	wire					dbg_rx,

///////////////////////////////////////////////////
// i/o pads near jtag connector user can solder to

output	wire				user1,
input	wire					user2,

///////////////////////////////////////////////////
// RFU internal i2c bus 

inout	wire					aux_sda,
output	wire				aux_scl,

///////////////////////////////////////////////////
// RFU, do not use
output	wire				vpll_feed,

//
// logical connections
//

///////////////////////////////////////////////////
// video, audio output to scaler
output	wire	[23:0]	video_rgb,
output	wire				video_rgb_clock,
output	wire				video_rgb_clock_90,
output	wire				video_de,
output	wire				video_skip,
output	wire				video_vs,
output	wire				video_hs,
	
output	wire				audio_mclk,
input		wire				audio_adc,
output	wire				audio_dac,
output	wire				audio_lrck

);

// not using the IR port, so turn off both the LED, and
// disable the receive circuit to save power
assign port_ir_tx = 0;
assign port_ir_rx_disable = 1;

// cart is unused, so set all level translators accordingly
// directions are 0:IN, 1:OUT
assign cart_tran_bank3 		= 8'hzz;
assign cart_tran_bank3_dir = 1'b0;
assign cart_tran_bank2 		= 8'hzz;
assign cart_tran_bank2_dir = 1'b0;
assign cart_tran_bank1 		= 8'hzz;
assign cart_tran_bank1_dir = 1'b0;
assign cart_tran_bank0 		= 4'hf;
assign cart_tran_bank0_dir = 1'b1;
assign cart_tran_pin30 		= 1'b0;		// reset or cs2, we let the hw control it by itself
assign cart_tran_pin30_dir = 1'bz;
assign cart_pin30_pwroff_reset = 1'b0;	// hardware can control this
assign cart_tran_pin31 		= 1'bz;		// input
assign cart_tran_pin31_dir = 1'b0;	// input

// link port is input only
assign port_tran_so 			= 1'bz;
assign port_tran_so_dir 	= 1'b0;		// SO is output only
assign port_tran_si 			= 1'bz;
assign port_tran_si_dir 	= 1'b0;		// SI is input only
assign port_tran_sck 		= 1'bz;
assign port_tran_sck_dir 	= 1'b0;	// clock direction can change
assign port_tran_sd 			= 1'bz;
assign port_tran_sd_dir 	= 1'b0;		// SD is input and not used

// Audio system

wire clk_audio;
wire [15:0] audio_l;
wire [15:0] audio_r;
wire audio_s;
wire audio_mix;

i2s i2s (
.clk_74a			(clk_74a),
.left_audio		(audio_l),
.right_audio	(audio_r),

.audio_mclk		(audio_mclk),
.audio_dac		(audio_dac),
.audio_lrck		(audio_lrck)

);

wire debug_led, debug_button;

emu Neogeo
(
	.clk_74a					(clk_74a),
	.reset_l_main			(reset_l_main),
	
	.debug_led				(debug_led),
	.debug_button			(debug_button),
	
	.bridge_1wire			( bridge_1wire ),
	
	.bridge_spimosi		( bridge_spimosi ),
	.bridge_spimiso		( bridge_spimiso ),
	.bridge_spiclk			( bridge_spiclk ),
	.bridge_spiss			( bridge_spiss ),

	.VGA_R					(video_rgb[23:16]),
	.VGA_G					(video_rgb[15: 8]),
	.VGA_B					(video_rgb[ 7: 0]),
	.VGA_HS					(video_hs),
	.VGA_VS					(video_vs),
	.VGA_DE					(video_de),
	
	.CLK_VIDEO				(video_rgb_clock),
	.CLK_VIDEO_90			(video_rgb_clock_90),

	.AUDIO_L					( audio_l ),
	.AUDIO_R					( audio_r ),
	.AUDIO_S					( audio_s ),

	.cram0_a					( cram0_a ),
	.cram0_dq				( cram0_dq ),
	.cram0_wait				( cram0_wait ),
	.cram0_clk				( cram0_clk ),
	.cram0_adv_n			( cram0_adv_n ),
	.cram0_cre				( cram0_cre ),
	.cram0_ce0_n			( cram0_ce0_n ),
	.cram0_ce1_n			( cram0_ce1_n ),
	.cram0_oe_n				( cram0_oe_n ),
	.cram0_we_n				( cram0_we_n ),
	.cram0_ub_n				( cram0_ub_n ),
	.cram0_lb_n				( cram0_lb_n ),
	
	.cram1_a					( cram1_a ),
	.cram1_dq				( cram1_dq ),
	.cram1_wait				( cram1_wait ),
	.cram1_clk				( cram1_clk ),
	.cram1_adv_n			( cram1_adv_n ),
	.cram1_cre				( cram1_cre ),
	.cram1_ce0_n			( cram1_ce0_n ),
	.cram1_ce1_n			( cram1_ce1_n ),
	.cram1_oe_n				( cram1_oe_n ),
	.cram1_we_n				( cram1_we_n ),
	.cram1_ub_n				( cram1_ub_n ),
	.cram1_lb_n				( cram1_lb_n ),
	
	.SDRAM_DQ				( dram_dq ),
	.SDRAM_A					( dram_a ),
	.SDRAM_DQML				( dram_dqm[0] ),
	.SDRAM_DQMH				( dram_dqm[1] ),
	.SDRAM_BA				( dram_ba ),
	.SDRAM_nWE				( dram_we_n ),
	.SDRAM_nRAS				( dram_ras_n ),
	.SDRAM_nCAS				( dram_cas_n ),
	.SDRAM_CLK				( dram_clk ),
	.SDRAM_CKE				( dram_cke ),
	
	.sram_a					( sram_a ),
	.sram_dq					( sram_dq ),
	.sram_oe_n				( sram_oe_n ),
	.sram_we_n				( sram_we_n ),
	.sram_ub_n				( sram_ub_n ),
	.sram_lb_n				( sram_lb_n )
);


	
endmodule
