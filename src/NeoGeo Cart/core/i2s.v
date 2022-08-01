//
// audio i2s generator
//
module i2s (
input 			clk_74a,
input [15:0]	left_audio,
input [15:0]	right_audio,

output 			audio_mclk,
output			audio_dac,
output			audio_lrck
);

assign audio_mclk = audgen_mclk;
assign audio_dac  = audgen_dac;
assign audio_lrck = audgen_lrck;

	reg				audgen_nextsamp;

// generate MCLK = 12.288mhz with fractional accumulator
	reg			[21:0]	audgen_accum;
	reg					audgen_mclk;
	parameter	[20:0]	CYCLE_48KHZ = 21'd122880 * 2;//21'd122880 * 2;
always @(posedge clk_74a) begin
	audgen_accum <= audgen_accum + CYCLE_48KHZ;
	if(audgen_accum >= 21'd742500) begin
		audgen_mclk <= ~audgen_mclk;
		audgen_accum <= audgen_accum - 21'd742500 + CYCLE_48KHZ;
	end
end

// generate SCLK = 3.072mhz by dividing MCLK by 4
	reg	[1:0]	aud_mclk_divider;
	wire		audgen_sclk	= aud_mclk_divider[1] /* synthesis keep*/;
	reg			audgen_lrck_1;
always @(posedge audgen_mclk) begin
	aud_mclk_divider <= aud_mclk_divider + 1'b1;
	// rising edge
	if(audgen_lrck & ~audgen_lrck_1) begin
		//aud_mclk_divider <= 1;
	end
end

// shift out audio data as I2S 
// 32 total bits per channel, but only 16 active bits at the start and then 16 dummy bits
//
// synchronize audio samples coming from the ram readout
	wire	[31:0]	audgen_sampdata_s;
synch_3 #(.WIDTH(32)) s5({left_audio, right_audio}, audgen_sampdata_s, audgen_sclk);
	//reg		[31:0]	audgen_sampdata = 32'hF0008000;
	reg		[31:0]	audgen_sampshift;
	reg		[4:0]	audgen_lrck_cnt;	
	reg				audgen_lrck;
	reg				audgen_dac;
always @(negedge audgen_sclk) begin
	audgen_nextsamp <= 0;
	
	// output the next bit
	audgen_dac <= audgen_sampshift[31];
	
	// 48khz * 64
	audgen_lrck_cnt <= audgen_lrck_cnt + 1'b1;
	if(audgen_lrck_cnt == 31) begin
		// switch channels
		audgen_lrck <= ~audgen_lrck;
		
		if(audgen_lrck) begin
			// load new sample
			audgen_nextsamp <= 1;
			// RIFF wave data is stored as 16bit little endian signed, so byteswap 16-bit
			audgen_sampshift <= {audgen_sampdata_s};
		end
	end else begin
		// only shift for 16 clocks per channel
		if(audgen_lrck_cnt < 16) begin
			audgen_sampshift <= {audgen_sampshift[30:0], 1'b0};
		end
	
	end
end

endmodule