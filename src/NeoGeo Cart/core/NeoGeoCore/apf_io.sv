/****************************************************************************************
	
	Pocket APF I/O Handoff
	
	Created by: Mazamars312
	
	Free of use - please feel free to use at your own and create :-)
	
	This controls the following:
	
	-APF to each Ram controller access using a 32/16/8bit pathway to each core
	-Helps with the clock domain change over using syncs
	-Core control for game options like special chips in the core
	-Controller access to the core.
	-Core managerment for things like reset and core monitoring
	
	ToDo: 
	-Tidy up some of the core for reading to the APF Managerment - (This will help with save states and save games) 
	-move the SDRAM controller to a 133mhz clock with a fifo to help with transfers (Some times it goes too fast that data is missed)
	-RTC for the core

*****************************************************************************************/

//// Version 0.6.0 Alpha
//
// Addeda new controller layout for the json setup. This will be later handled by the APF framework once the interact.json happens


module apf_io
(
	input					clk_74a, 
	input          	clk_sys,
	
	input					debug_button,
	output				debug_led,			// these are used with the debuging cart
	
	inout	  				bridge_spimosi,
	inout	 				bridge_spimiso,
	inout	 				bridge_spiclk,
	input	 				bridge_spiss,
	inout	 				bridge_1wire,
	
	input 				reset_l_main,
	
	input					locked_1,
	input					locked_2,

	// buttons up to 32
	output reg [31:0] 		joystick_0,
	output reg [31:0] 		joystick_1,
	output reg [31:0] 		joystick_2,
	output reg [31:0] 		joystick_3,
	output reg [31:0] 		joystick_4,
	output reg [31:0] 		joystick_5,
	
	// analog -127..+127, Y: [15:8], X: [7:0]
	output [15:0] 		joystick_l_analog_0,
	output [15:0] 		joystick_l_analog_1,
	output [15:0] 		joystick_l_analog_2,
	output [15:0] 		joystick_l_analog_3,
	output [15:0] 		joystick_l_analog_4,
	output [15:0] 		joystick_l_analog_5,

	output [15:0] 		joystick_r_analog_0,
	output [15:0] 		joystick_r_analog_1,
	output [15:0] 		joystick_r_analog_2,
	output [15:0] 		joystick_r_analog_3,
	output [15:0] 		joystick_r_analog_4,
	output [15:0] 		joystick_r_analog_5,

	input  [15:0] 		joystick_0_rumble, // 15:8 - 'large' rumble motor magnitude, 7:0 'small' rumble motor magnitude  - Not Done yet
	input  [15:0] 		joystick_1_rumble,
	input  [15:0] 		joystick_2_rumble,
	input  [15:0] 		joystick_3_rumble,
	input  [15:0] 		joystick_4_rumble,
	input  [15:0] 		joystick_5_rumble,

	// paddle 0..255
	output  [7:0] 		paddle_0,
	output  [7:0] 		paddle_1,
	output  [7:0] 		paddle_2,
	output  [7:0] 		paddle_3,
	output  [7:0] 		paddle_4,
	output  [7:0] 		paddle_5,

	// spinner [7:0] -128..+127, [8] - toggle with every update  - Not Done yet
	output  [8:0] 		spinner_0,
	output  [8:0] 		spinner_1,
	output  [8:0] 		spinner_2,
	output  [8:0] 		spinner_3,
	output  [8:0] 		spinner_4,
	output  [8:0] 		spinner_5,

	// ps2 keyboard emulation - Not Done yet
	output        		ps2_kbd_clk_out,
	output        		ps2_kbd_data_out,
	input         		ps2_kbd_clk_in,
	input         		ps2_kbd_data_in,

	input   [2:0] 		ps2_kbd_led_status,
	input   [2:0] 		ps2_kbd_led_use,

	output        		ps2_mouse_clk_out,
	output        		ps2_mouse_data_out,
	input         		ps2_mouse_clk_in,
	input         		ps2_mouse_data_in,

	// ps2 alternative interface.

	// [8] - extended, [9] - pressed, [10] - toggles with every press/release
	output [10:0] 		ps2_key,

	// [24] - toggles with every event
	output [24:0] 		ps2_mouse,
	output [15:0] 		ps2_mouse_ext, // 15:8 - reserved(additional buttons), 7:0 - wheel movements

	
	output 				sdram_word_rd,
	output  				sdram_word_wr,
	output  	[25:0]	sdram_word_addr,
	output  	[15:0]	sdram_word_data,
	input 	  [15:0]	sdram_word_q,
	input					sdram_word_busy,
	
	output 				sram_word_rd,
	output  				sram_word_wr,
	output  	  [24:0]	sram_word_addr,
	output  	  [31:0]	sram_word_data,
	input 	  [31:0]	sram_word_q,
	input					sram_word_busy,
	
	output 				cram0_word_rd,
	output  				cram0_word_wr,
	output  	[23:0]	cram0_word_addr,
	output  	[31:0]	cram0_word_data,
	input 	  [31:0]	cram0_word_q,
	input					cram0_word_busy,
	
	output 				cram1_word_rd,
	output 				cram1_word_wr,
	output 	[23:0]	cram1_word_addr,
	output 	[31:0]	cram1_word_data,
	input 	  [31:0]	cram1_word_q,
	input					cram1_word_busy,
	
	output  				LO_RAM_word_wr,
	output  	[16:0]	LO_RAM_word_addr,
	output  	[7:0]		LO_RAM_word_data,
	input 	[7:0]		LO_RAM_word_q,



	// System Configuration
	output reg			start_system,
	output reg [64:0] RTC,
	output reg [7:0]	DIPSW,
	output reg [1:0]	SYSTEM_TYPE,
	output reg [1:0]	memory_card_enable,
	output reg [1:0]	use_mouse_reg,
	output reg			video_mode,
	output reg [3:0]	snd_enable,
	output reg [5:0]	ch_enable,
	output reg [15:0]	pixel_mux_change,
	
	output reg [3:0] 	cart_pchip,
	output reg       	use_pcm,
	output reg [1:0] 	cart_chip,
	output reg [1:0] 	cmc_chip,

	
	output reg [23:0] P2ROM_MASK, 
	output reg [25:0] CROM_MASK, 
	output reg [23:0] V1ROM_MASK, 
	output reg [23:0] V2ROM_MASK, 
	output reg [18:0] MROM_MASK,
	

	// Seconds since 1970-01-01 00:00:00
	output reg [32:0] TIMESTAMP,	
	
	output [11:0]		neogeo_memcard_addr,
	output 				neogeo_memcard_wr,
	output [15:0]		neogeo_memcard_dout,
	input  [15:0]		neogeo_memcard_din
);

wire reset_n;

// controller data (pad) master
	wire	[15:0]	cont1_key;
	wire	[15:0]	cont2_key;
	wire	[15:0]	cont3_key;
	wire	[15:0]	cont4_key;
	wire	[31:0]	cont1_joy;
	wire	[31:0]	cont2_joy;
	wire	[31:0]	cont3_joy;
	wire	[31:0]	cont4_joy;
	wire	[15:0]	cont1_trig;
	wire	[15:0]	cont2_trig;
	wire	[15:0]	cont3_trig;
	wire	[15:0]	cont4_trig;
	wire	[15:0]	buttons_legacy;
	
	wire				scaler_slot_strobe;
	wire	[2:0]		scaler_slot;
	
	
wire [31:0]	ram_CRAM0_controller_rd_data;
wire [31:0]	ram_CRAM1_controller_rd_data;
wire [31:0]	ram_SDRAM_controller_rd_data;
wire [31:0]	ram_SROM_controller_rd_data;
wire [31:0]	ram_lo_rom_controller_rd_data;
wire [31:0]	neogeo_sram_controller_rd_data;
wire [31:0]	neogeo_memorycard_controller_rd_data;
	
	
io_pad_controller ipm (
	.clk						( clk_74a ),
	.reset_n 				( reset_l_main ),

	.pad_1wire				( bridge_1wire ),
		
	.cont1_key				( cont1_key ),
	.cont2_key				( cont2_key ),
	.cont3_key				( cont3_key ),
	.cont4_key				( cont4_key ),
	.cont1_joy				( cont1_joy ),
	.cont2_joy				( cont2_joy ),
	.cont3_joy				( cont3_joy ),
	.cont4_joy				( cont4_joy ),
	.cont1_trig				( cont1_trig ),
	.cont2_trig				( cont2_trig ),
	.cont3_trig				( cont3_trig ),
	.cont4_trig				( cont4_trig )
);
	///////////////////////////////////////////////////
// controller data - No Mouse or keyboard yet
// 
// key bitmap:
//   [0]	dpad_up
//   [1]	dpad_down
//   [2]	dpad_left
//   [3]	dpad_right
//   [4]	face_a
//   [5]	face_b
//   [6]	face_x
//   [7]	face_y
//   [8]	trig_l1
//   [9]	trig_r1
//   [10]	trig_l2
//   [11]	trig_r2
//   [12]	trig_l3
//   [13]	trig_r3
//   [14]	face_select
//   [15]	face_start
// joy values - unsigned
//   [ 7: 0] lstick_x
//   [15: 8] lstick_y
//   [23:16] rstick_x
//   [31:24] rstick_y
// trigger values - unsigned
//   [ 7: 0] ltrig
//   [15: 8] rtrig
//

reg [3:0] controller_map_1, controller_map_2;

always @(posedge clk_sys) begin
	case (controller_map_1)												//		D					C				B					A
		4'h1	  : joystick_0 <= {cont1_key[14], cont1_key[15], cont1_key[4], cont1_key[6], cont1_key[5], cont1_key[7], cont1_key[0], cont1_key[1], cont1_key[2], cont1_key[3]}; // Neogeo outlay
		4'h2	  : joystick_0 <= {cont1_key[14], cont1_key[15], cont1_key[6], cont1_key[7], cont1_key[4], cont1_key[5], cont1_key[0], cont1_key[1], cont1_key[2], cont1_key[3]}; // Neogeo CD outlay
		default : joystick_0 <= {cont1_key[14], cont1_key[15], cont1_key[7:4], cont1_key[0], cont1_key[1], cont1_key[2], cont1_key[3]}; // Xbox Controller/Snes controller
	endcase
	case (controller_map_2)												//		D					C				B					A
		4'h1	  : joystick_1 <= {cont2_key[14], cont2_key[15], cont2_key[4], cont2_key[6], cont2_key[5], cont2_key[7], cont2_key[0], cont2_key[1], cont2_key[2], cont2_key[3]}; // Neogeo outlay
		4'h2	  : joystick_1 <= {cont2_key[14], cont2_key[15], cont2_key[6], cont2_key[7], cont2_key[4], cont2_key[5], cont2_key[0], cont2_key[1], cont2_key[2], cont2_key[3]}; // Neogeo CD outlay
		default : joystick_1 <= {cont2_key[14], cont2_key[15], cont2_key[7:4], cont2_key[0], cont2_key[1], cont2_key[2], cont2_key[3]}; // Xbox Controller/Snes controller
	endcase
end

//	assign joystick_0 = {cont1_key[14], cont1_key[15], cont1_key[7:4], cont1_key[0], cont1_key[1], cont1_key[2], cont1_key[3]};
//	assign joystick_1 = {cont2_key[14], cont2_key[15], cont2_key[7:4], cont2_key[0], cont2_key[1], cont2_key[2], cont2_key[3]};
	
// virtual pmp bridge
	wire				bridge_endian_little = 0; //
	wire	[31:0]	bridge_addr;
	wire				bridge_rd;
	reg	[31:0]	bridge_rd_data;
	wire				bridge_wr;
	wire	[31:0]	bridge_wr_data;
	wire 	[31:0]	cmd_bridge_rd_data;
	
io_bridge_peripheral ibs (
	.clk						( clk_74a ),
	.reset_n					( reset_l_main ),
	.endian_little			( bridge_endian_little ),
	.pmp_addr				( bridge_addr ),
	.pmp_addr_valid		( bridge_address_valid ),
	.pmp_rd					( bridge_rd ),
	.pmp_rd_data			( bridge_rd_data ),
	.pmp_wr					( bridge_wr ),
	.pmp_wr_data			( bridge_wr_data ),
	.phy_spimosi			( bridge_spimosi ),
	.phy_spimiso			( bridge_spimiso ),
	.phy_spiclk				( bridge_spiclk ),
	.phy_spiss				( bridge_spiss )
);


// bridge host commands
// synchronous to clk_74a
	wire				status_boot_done = locked_1 && locked_2;	
	wire				status_setup_done = locked_1 && locked_2; // For this core we want the 68K ram cleared
	wire				status_running = reset_n; // we are running as soon as reset_n goes high This will be handled by a internal CPU later on

	wire				dataslot_requestread;
	wire	[15:0]	dataslot_requestread_id;
	wire				dataslot_requestread_ack;
	wire				dataslot_requestread_ok;

	wire				dataslot_requestwrite;
	wire	[15:0]	dataslot_requestwrite_id;
	wire				dataslot_requestwrite_ack;
	wire				dataslot_requestwrite_ok;

	wire				dataslot_allcomplete; // this tells the core that everything is loaded and we can now run

	wire				savestate_supported;
	wire	[31:0]	savestate_addr;
	wire	[31:0]	savestate_size;
	wire	[31:0]	savestate_maxloadsize;

	wire				savestate_start;
	wire				savestate_start_ack;
	wire				savestate_start_busy;
	wire				savestate_start_ok;
	wire				savestate_start_err;

	wire				savestate_load;
	wire				savestate_load_ack;
	wire				savestate_load_busy;
	wire				savestate_load_ok;
	wire				savestate_load_err;

// bridge target commands
// synchronous to clk_74a
// bridge data slot access

	wire	[9:0]		datatable_addr;
	wire				datatable_wren;
	wire	[31:0]	datatable_data;
	wire	[31:0]	datatable_q;

assign debug_led = dataslot_requestwrite;
				
core_bridge_cmd icb (

	.clk								( clk_74a ),
	.reset_l_main					(reset_l_main),
	// 
	.bridge_addr					( bridge_addr ),
	.bridge_rd						( bridge_rd ),
	.bridge_rd_data				( cmd_bridge_rd_data ),
	.bridge_wr						( bridge_wr ),
	.bridge_wr_data				( bridge_wr_data ),
	
	.status_boot_done				( status_boot_done ),
	.status_setup_done			( status_setup_done ),
	.reset_n							( reset_n ), // Need to change this name to say somethign more like Start the core up
	.status_running				( status_running ),

	.dataslot_requestread		( dataslot_requestread ),
	.dataslot_requestread_id	( dataslot_requestread_id ),
	.dataslot_requestread_ack	( 1'b1 ),
	.dataslot_requestread_ok	( 1'b1 ),

	.dataslot_requestwrite		( dataslot_requestwrite ),
	.dataslot_requestwrite_id	( dataslot_requestwrite_id ),
	.dataslot_requestwrite_ack	( 1'b1 ),
	.dataslot_requestwrite_ok	( 1'b1 ),

	.dataslot_allcomplete		( dataslot_allcomplete ),

	.savestate_supported			( savestate_supported ),
	.savestate_addr				( savestate_addr ),
	.savestate_size				( savestate_size ),
	.savestate_maxloadsize		( savestate_maxloadsize ),

	.savestate_start				( savestate_start ),
	.savestate_start_ack			( savestate_start_ack ),
	.savestate_start_busy		( savestate_start_busy ),
	.savestate_start_ok			( savestate_start_ok ),
	.savestate_start_err			( savestate_start_err ),

	.savestate_load				( savestate_load ),
	.savestate_load_ack			( savestate_load_ack ),
	.savestate_load_busy			( savestate_load_busy ),
	.savestate_load_ok			( savestate_load_ok ),
	.savestate_load_err			( savestate_load_err ),

	.datatable_addr				( datatable_addr ),
	.datatable_wren				( datatable_wren ),
	.datatable_data				( datatable_data ),
	.datatable_q					( datatable_q ),

);


/*********************************************************

	Here is the addressing core for external stuff
	
**********************************************************/

initial begin
	P2ROM_MASK		<= 32'h00000000;
	CROM_MASK		<= 32'h00000000;
	V1ROM_MASK		<= 32'h00000000;
	V2ROM_MASK		<= 32'h00000000;
	MROM_MASK		<= 32'h00000000;
	pixel_mux_change <= 16'h0000;
end

reg [31:0] bridge_addr_reg;

// this writes the masking directly to the regs while watching the writes to the ram locations

wire [18:0] test_19_bits = {bridge_addr_reg[18],
									|bridge_addr_reg[18:17],
									|bridge_addr_reg[18:16],
									|bridge_addr_reg[18:15],
									|bridge_addr_reg[18:14],
									|bridge_addr_reg[18:13],
									|bridge_addr_reg[18:12],
									|bridge_addr_reg[18:11],
									|bridge_addr_reg[18:10],
									|bridge_addr_reg[18:9],
									|bridge_addr_reg[18:8],
									|bridge_addr_reg[18:7],
									|bridge_addr_reg[18:6],
									|bridge_addr_reg[18:5],
									|bridge_addr_reg[18:4],
									|bridge_addr_reg[18:3],
									|bridge_addr_reg[18:2],
									|bridge_addr_reg[18:1],
									|bridge_addr_reg[18:0]};

wire [22:0] test_23_bits = {bridge_addr_reg[22],
									|bridge_addr_reg[22:21],
									|bridge_addr_reg[22:20],
									|bridge_addr_reg[22:19],
									|bridge_addr_reg[22:18],
									|bridge_addr_reg[22:17],
									|bridge_addr_reg[22:16],
									|bridge_addr_reg[22:15],
									|bridge_addr_reg[22:14],
									|bridge_addr_reg[22:13],
									|bridge_addr_reg[22:12],
									|bridge_addr_reg[22:11],
									|bridge_addr_reg[22:10],
									|bridge_addr_reg[22:9],
									|bridge_addr_reg[22:8],
									|bridge_addr_reg[22:7],
									|bridge_addr_reg[22:6],
									|bridge_addr_reg[22:5],
									|bridge_addr_reg[22:4],
									|bridge_addr_reg[22:3],
									|bridge_addr_reg[22:2],
									|bridge_addr_reg[22:1],
									|bridge_addr_reg[22:0]};
									
wire [23:0] test_24_bits = {bridge_addr_reg[23],
									|bridge_addr_reg[23:22],
									|bridge_addr_reg[23:21],
									|bridge_addr_reg[23:20],
									|bridge_addr_reg[23:19],
									|bridge_addr_reg[23:18],
									|bridge_addr_reg[23:17],
									|bridge_addr_reg[23:16],
									|bridge_addr_reg[23:15],
									|bridge_addr_reg[23:14],
									|bridge_addr_reg[23:13],
									|bridge_addr_reg[23:12],
									|bridge_addr_reg[23:11],
									|bridge_addr_reg[23:10],
									|bridge_addr_reg[23:9],
									|bridge_addr_reg[23:8],
									|bridge_addr_reg[23:7],
									|bridge_addr_reg[23:6],
									|bridge_addr_reg[23:5],
									|bridge_addr_reg[23:4],
									|bridge_addr_reg[23:3],
									|bridge_addr_reg[23:2],
									|bridge_addr_reg[23:1],
									|bridge_addr_reg[23:0]};

									
// APF write access over the 32bit address system and setup of the core
always @(posedge clk_sys) begin
	bridge_addr_reg <= bridge_addr;
	if (bridge_wr) begin
		casex(bridge_addr)
			32'h40xxxxxx: begin
				CROM_MASK 	<= test_24_bits;
			end
			// these will monitor the masking side of the roms
			32'b0001_0000_0xxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin
				P2ROM_MASK 	<= {1'b0,test_23_bits[22:1]};
			end
			32'b0001_0000_1111_1xxx_xxxx_xxxx_xxxx_xxxx: begin
				MROM_MASK 	<= test_19_bits;
			end
			32'b0010_0000_0xxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin
				V1ROM_MASK 	<= test_23_bits;
			end
			32'b0010_0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx: begin
				V2ROM_MASK 	<= test_23_bits;
			end
			// here is the config sid of things of the core. Moved the RTC so that this can be configured by the APF directly
			32'hF0000000 : controller_map_1		<= bridge_wr_data[3:0];
			32'hF0000004 : controller_map_2		<= bridge_wr_data[3:0];
			32'hF0000008 : DIPSW 					<= bridge_wr_data;
			32'hF000000c : SYSTEM_TYPE 			<= bridge_wr_data;
			32'hF0000010 : memory_card_enable 	<= bridge_wr_data;
			32'hF0000014 : use_mouse_reg 			<= bridge_wr_data;
			32'hF0000018 : video_mode 				<= bridge_wr_data;
			32'hF000001c : ch_enable				<= bridge_wr_data;
			32'hF0000020 : snd_enable				<= bridge_wr_data;
			32'hF0000024 : cart_pchip				<= bridge_wr_data;
			32'hF0000028 : use_pcm					<= bridge_wr_data;
			32'hF000002C : cart_chip				<= bridge_wr_data;
			32'hF0000030 : cmc_chip					<= bridge_wr_data;
			32'hF1000000 : RTC[63:32]				<= bridge_wr_data;
			32'hF1000004 : RTC[31: 0]				<= bridge_wr_data;

		endcase
	
	end
	start_system <= (&{dataslot_allcomplete, reset_n, ~cont1_key[8]}); // I just made a reset system.... with a button.. Should I debounce this......... 
end

// APF Read loactions will add a delay for the cores when reading data.	

always @(*) begin
	
	casex(bridge_addr)
	32'h0xxxxxxx: begin
		bridge_rd_data <= ram_lo_rom_controller_rd_data;
	end
	32'h1xxxxxxx: begin
		bridge_rd_data <= ram_CRAM0_controller_rd_data;
	end
	32'h2xxxxxxx: begin
		bridge_rd_data <= ram_CRAM1_controller_rd_data;
	end
	32'h3xxxxxxx: begin
		bridge_rd_data <= ram_SROM_controller_rd_data;
	end
	32'h4xxxxxxx: begin
		bridge_rd_data <= ram_SDRAM_controller_rd_data;
	end
	32'h5xxxxxxx: begin
		bridge_rd_data <= neogeo_sram_controller_rd_data;
	end
	32'h6xxxxxxx: begin
		bridge_rd_data <= neogeo_memorycard_controller_rd_data;
	end
	32'hF8xxxxxx: begin
		bridge_rd_data 	<= cmd_bridge_rd_data;
	end
	default: begin
		bridge_rd_data 	<= cmd_bridge_rd_data;
	end
	endcase
end

/*********************************************************

	lo-rom controller

*********************************************************/

ram_8_bit_state_controller ram_lo_rom_controller(
	.clk_74a							(clk_74a),
	.clk_sys							(clk_sys),
	.reset_l							(reset_l_main),
	.bigendin						(~bridge_endian_little),
	
	// Ram Controller
	.word_rd							(),
	.word_wr							(LO_RAM_word_wr),
	.word_addr						(LO_RAM_word_addr),
	.word_data						(LO_RAM_word_data),
	.word_q							(LO_RAM_word_q),
	.word_busy						(1'b0),
	
	// SPI interface
	.bridge_addr					(bridge_addr),
	.bridge_rd						(bridge_rd && (bridge_addr[31:28] == 4'h5)), //APF address 0x5XXX_XXXX
	.bridge_rd_data				(ram_lo_rom_controller_rd_data),
	.bridge_wr						(bridge_wr && (bridge_addr[31:28] == 4'h5)),
	.bridge_wr_data				(bridge_wr_data),
	.bridge_processing			(),
	.bridge_completed				()
);

/*********************************************************

	cram0 controller

*********************************************************/

ram_32_bit_state_controller ram_CRAM0_controller(
	.clk_74a							(clk_74a),
	.clk_sys							(clk_sys),
	.reset_l							(reset_l_main),
	.bigendin						(bridge_endian_little),
	
	
	// Ram Controller
	.word_rd							(cram0_word_rd),
	.word_wr							(cram0_word_wr),
	.word_addr						(cram0_word_addr),
	.word_data						(cram0_word_data),
	.word_q							(cram0_word_q),
	.word_busy						(cram0_word_busy),
	
	// SPI interface
	.bridge_addr					(bridge_addr),
	.bridge_rd						(bridge_rd && (bridge_addr[31:28] == 4'h1)), //APF address 0x1XXX_XXXX
	.bridge_rd_data				(ram_CRAM0_controller_rd_data),
	.bridge_wr						(bridge_wr && (bridge_addr[31:28] == 4'h1)),
	.bridge_wr_data				(bridge_wr_data),
	.bridge_processing			(),
	.bridge_completed				()
);

/*********************************************************

	cram1 controller

*********************************************************/

ram_32_bit_state_controller ram_CRAM1_controller(
	.clk_74a							(clk_74a),
	.clk_sys							(clk_sys),
	.reset_l							(reset_l_main),
	.bigendin						(bridge_endian_little),

	
	// Ram Controller
	.word_rd							(cram1_word_rd),
	.word_wr							(cram1_word_wr),
	.word_addr						(cram1_word_addr),
	.word_data						(cram1_word_data),
	.word_q							(cram1_word_q),
	.word_busy						(cram1_word_busy),
	
	// SPI interface
	.bridge_addr					(bridge_addr),
	.bridge_rd						(bridge_rd && (bridge_addr[31:28] == 4'h2)), //APF address 0x2XXX_XXXX
	.bridge_rd_data				(ram_CRAM1_controller_rd_data),
	.bridge_wr						(bridge_wr && (bridge_addr[31:28] == 4'h2)),
	.bridge_wr_data				(bridge_wr_data),
	.bridge_processing			(),
	.bridge_completed				()
);
	
/*********************************************************

	srom controller

*********************************************************/


ram_32_bit_state_controller ram_SROM_controller(
	.clk_74a							(clk_74a),
	.clk_sys							(clk_sys),
	.reset_l							(reset_l_main),
	.bigendin						(bridge_endian_little),
	// Ram Controller
	.word_rd							(sram_word_rd),
	.word_wr							(sram_word_wr),
	.word_addr						(sram_word_addr),
	.word_data						(sram_word_data),
	.word_q							(sram_word_q),
	.word_busy						(sram_word_busy),
	
	// SPI interface
	.bridge_addr					(bridge_addr),
	.bridge_rd						(bridge_rd && (bridge_addr[31:28] == 4'h3)), //APF address 0x3XXX_XXXX
	.bridge_rd_data				(ram_SROM_controller_rd_data),
	.bridge_wr						(bridge_wr && (bridge_addr[31:28] == 4'h3)),
	.bridge_wr_data				(bridge_wr_data),
	.bridge_processing			(),
	.bridge_completed				()
);
	
/*********************************************************

	sdram controller

*********************************************************/

ram_16_bit_wait_state_controller ram_SDRAM_controller(
	.clk_74a							(clk_74a),
	.clk_sys							(clk_sys),
	.reset_l							(reset_l_main),
	.bigendin						(bridge_endian_little),

	
	// Ram Controller
	.word_rd							(sdram_word_rd),
	.word_wr							(sdram_word_wr),
	.word_addr						(sdram_word_addr),
	.word_data						(sdram_word_data),
	.word_q							(sdram_word_q),
	.word_busy						(sdram_word_busy),
	
	// SPI interface
	.bridge_addr					(bridge_addr),
	.bridge_rd						(bridge_rd && (bridge_addr[31:28] == 4'h4)), //APF address 0x4XXX_XXXX
	.bridge_rd_data				(ram_SDRAM_controller_rd_data),
	.bridge_wr						(bridge_wr && (bridge_addr[31:28] == 4'h4)),
	.bridge_wr_data				(bridge_wr_data),
	.bridge_processing			(),
	.bridge_completed				()
);


/*********************************************************

	memory card controller

*********************************************************/


ram_16_bit_state_controller neogeo_memorycard_controller(
	.clk_74a							(clk_74a),
	.clk_sys							(clk_sys),
	.reset_l							(reset_l_main),
	.bigendin						(bridge_endian_little),
	
	// Ram Controller
	.word_rd							(),
	.word_wr							(neogeo_memcard_wr),
	.word_addr						(neogeo_memcard_addr),
	.word_data						(neogeo_memcard_dout),
	.word_q							(neogeo_memcard_din),
	.word_busy						(1'b0),
	
	// SPI interface
	.bridge_addr					(bridge_addr),
	.bridge_rd						(bridge_rd && (bridge_addr[31:28] == 4'h6)), //APF address 0x6XXX_XXXX
	.bridge_rd_data				(neogeo_memorycard_controller_rd_data),
	.bridge_wr						(bridge_wr && (bridge_addr[31:28] == 4'h6)),
	.bridge_wr_data				(bridge_wr_data),
	.bridge_processing			(),
	.bridge_completed				()
);

endmodule



