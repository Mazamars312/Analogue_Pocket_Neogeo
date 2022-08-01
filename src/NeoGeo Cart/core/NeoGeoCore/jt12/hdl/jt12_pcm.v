module jt12_pcm(
    input               rst,
    input               clk,
    input               clk_en /* synthesis direct_enable */,
    input               zero,
    input   signed [8:0] pcm,
    input               pcm_wr, 
    output reg signed [8:0] pcm_resampled
);

// reg [2:0] ratesel;
// reg [3:0] cnt8;
// reg wrcnt, wrclr;
reg last_zero;
wire zero_edge = !last_zero && zero;
/*
always @(posedge clk)
    if(rst) begin
        cnt8    <= 4'd0;
        wrclr   <= 1'd0;
        ratesel <= 3'd1;
        wrcnt   <= 1'b0;
    end else if(clk_en) begin 
        if( pcm_wr ) begin
            if( wrcnt ) begin
                // case( cnt8[3:2] )
                //     2'd3: ratesel <= 3'b111; // x8
                //     2'd2: ratesel <= 3'b011; // x4
                //     2'd1: ratesel <= 3'b001; // x2
                //     2'd0: ratesel <= 3'b000; // x1
                // endcase 
                cnt8 <= 4'd0;
                wrcnt <= 1'b0;
            end
            else wrcnt <= 1'b1;
        end else 
            if( cnt8!=4'hf && zero ) cnt8 <= cnt8 + 4'd1;
    end
*/
// up-rate PCM samples
reg rate1, rate2; //, rate4, rate8;
reg cen1, cen2; //, cen4, cen8;

always @(posedge clk) 
    if(rst)
        rate2 <= 1'b0;
    else begin
        last_zero <= zero;
        rate1 <= zero_edge;
        if(zero_edge) begin
            rate2 <= ~rate2;
//            if(rate2) begin
//                rate4 <= ~rate4;
//                if(rate4) rate8<=~rate8;
//            end
        end
    end

always @(negedge clk) begin
    cen1 <= rate1;
    cen2 <= rate1 && rate2;
//    cen4 <= rate1 && rate2 && rate4;
//    cen8 <= rate1 && rate2 && rate4 && rate8;
end

wire signed [8:0] pcm3; //,pcm2, pcm1;

//always @(posedge clk) if( clk_en )
//    pcm_resampled <= ratesel[0] ? pcm3 : pcm;
always @(*)
    pcm_resampled = pcm3;

// rate x2
//wire signed [8:0] pcm_in2 = ratesel[1] ? pcm2 : pcm;
jt12_interpol #(.calcw(10),.inw(9),.rate(2),.m(1),.n(2)) 
u_uprate_3(
    .clk    ( clk         ),
    .rst    ( rst         ),        
    .cen_in ( cen2        ),
    .cen_out( cen1        ),
    // .snd_in ( pcm_in2     ),
    .snd_in ( pcm         ),
    .snd_out( pcm3        )
);
/*
// rate x2
wire signed [8:0] pcm_in1 = ratesel[2] ? pcm1 : pcm;
jt12_interpol #(.calcw(10),.inw(9),.rate(2),.m(1),.n(2)) 
u_uprate_2(
    .clk    ( clk         ),
    .rst    ( rst         ),        
    .cen_in ( cen4        ),
    .cen_out( cen2        ),
    .snd_in ( pcm_in1     ),
    .snd_out( pcm2        )
);

// rate x2
jt12_interpol #(.calcw(10),.inw(9),.rate(2),.m(1),.n(2)) 
u_uprate_1(
    .clk    ( clk         ),
    .rst    ( rst         ),        
    .cen_in ( cen8        ),
    .cen_out( cen4        ),
    .snd_in ( pcm         ),
    .snd_out( pcm1        )
);
*/
endmodule // jt12_pcm