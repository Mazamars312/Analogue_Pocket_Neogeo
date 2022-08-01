/* This file is part of JT12.

 
    JT12 program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    JT12 program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with JT12.  If not, see <http://www.gnu.org/licenses/>.

    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 11-12-2018
    
    Each channel can use the full range of the DAC as they do not
    get summed in the real chip.

    Operator data is summed up without adding extra bits. This is
    the case of real YM3438, which was used on Megadrive 2 models.

*/

/* Mixer for Megadrive/Genesis
   cen_fm  must be 1 over  7  of clk
   psg_cen_240 must be 1 over 15  of clk
   PSG and FM signals are interpolated up to clk sample rate.
*/

module jt12_genmix(
    input               rst,
    input               clk,
    input signed [15:0] fm_left,
    input signed [15:0] fm_right,
    input signed [10:0] psg_snd,
    input fm_en,  // enable FM
    input psg_en, // enable PSG
    // Mixed sound at clk sample rate
    output signed [15:0] snd_left,
    output signed [15:0] snd_right
);

/////////////////////////////////////////////////
// PSG
// x5 -> div 3 -> div 7
// 54MHz count up to:
// orig -> 16*15 = 240
// x5 -> 16*15/5 = 48
// div 3 -> 48*3 = 144
// div 7 -> 144*7 = 1008 <=> fm_sample
// 48 x 5 = 240, 
reg [5:0] psgcnt48;
reg [2:0] psgcnt240, psgcnt1008;
reg [1:0] psgcnt144;

always @(posedge clk)
    if( rst ) begin
        psgcnt48  <= 6'd0;
        psgcnt240 <= 3'd0;
        psgcnt144 <= 2'd0;
        psgcnt1008<= 3'd0;
    end else begin
        psgcnt48  <= psgcnt48 ==6'd47  ? 6'd0 : psgcnt48 +6'd1;
        if( psgcnt48 == 6'd47 ) begin
            psgcnt240 <= psgcnt240==3'd4 ? 3'd0 : psgcnt240+3'd1;
            psgcnt144  <= psgcnt144 ==2'd2 ? 2'd0 : psgcnt144+2'd1;
            if( psgcnt144==2'd0 )
                psgcnt1008 <= psgcnt1008==3'd6 ? 3'd0 : psgcnt1008+3'd1;
        end
    end

reg psg_cen_1008, psg_cen_240, psg_cen_48, psg_cen_144;
always @(negedge clk) begin
    psg_cen_240 <= psgcnt48 ==6'd47 && psgcnt240 == 3'd0;
    psg_cen_48  <= psgcnt48 ==6'd47;
    psg_cen_144 <= psgcnt48 ==6'd47 && psgcnt144==2'd0;
    psg_cen_1008<= psgcnt48 ==6'd47 && psgcnt144==2'd0 && psgcnt1008==3'd0;
end

wire signed [11:0] psg0, psg1, psg2, psg3; 
assign psg0 = psg_en ? { psg_snd[10], psg_snd } : 12'b0;

// 48
jt12_interpol #(.calcw(19),.inw(12),.rate(5),.m(4),.n(2)) 
u_psg1(
    .clk    ( clk      ),
    .rst    ( rst      ),        
    .cen_in ( psg_cen_240  ),
    .cen_out( psg_cen_48   ),
    .snd_in ( psg0     ),
    .snd_out( psg1     )
);

// 144
jt12_decim #(.calcw(19),.inw(12),.rate(3),.m(2),.n(3) ) 
u_psg2(
    .clk    ( clk         ),
    .rst    ( rst         ),        
    .cen_in ( psg_cen_48  ),
    .cen_out( psg_cen_144 ),
    .snd_in ( psg1        ),
    .snd_out( psg2        )
);

// 1008
jt12_decim #(.calcw(15),.inw(12),.rate(7),.m(1),.n(1) ) 
u_psg3(
    .clk    ( clk         ),
    .rst    ( rst         ),        
    .cen_in ( psg_cen_144 ),
    .cen_out( psg_cen_1008),
    .snd_in ( psg2        ),
    .snd_out( psg3        )
);

/////////////////////////////////////////////////
// FM
// x4 -> x4 -> x7 -> x9
// 54MHz count up to:
// 252 -> 63 -> 9 -> 1
reg [1:0] clkcnt252, clkcnt1008;
reg [2:0] clkcnt63;
reg [3:0] clkcnt9;
always @(posedge clk)
    if( rst ) begin
        clkcnt1008<= 2'd0;
        clkcnt252 <= 2'd0;
        clkcnt63  <= 3'd0;
        clkcnt9   <= 4'd0;
    end else begin
        clkcnt9   <= clkcnt9  ==4'd8   ? 4'd0 : clkcnt9  +4'd1;
        if( clkcnt9== 4'd8 ) begin
            clkcnt63  <= clkcnt63 ==3'd6  ? 3'd0 : clkcnt63 +3'd1;
            if( clkcnt63==3'd6 ) begin
                clkcnt252 <= clkcnt252+2'd1;
                if(clkcnt252==2'd3) clkcnt1008<=clkcnt1008+2'd1;
            end
        end
    end 
// evenly spaced clock enable signals
reg cen_1008, cen_252, cen_63, cen_9;
always @(negedge clk) begin
    cen_9    <= clkcnt9  ==4'd8;
    cen_63   <= clkcnt9  ==4'd8 && clkcnt63  ==3'd0;
    cen_252  <= clkcnt9  ==4'd8 && clkcnt63  ==3'd0 && clkcnt252 ==2'd0;
    cen_1008 <= clkcnt9  ==4'd8 && clkcnt63  ==3'd0 && clkcnt252 ==2'd0 && clkcnt1008==2'd0;
end

jt12_fm_uprate u_left(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .fm_snd     ( fm_left   ),
    .psg_snd    ( psg3      ),
    .fm_en      ( fm_en     ),
    .cen_1008   ( cen_1008  ),
    .cen_252    ( cen_252   ),
    .cen_63     ( cen_63    ),
    .cen_9      ( cen_9     ),
    .snd        ( snd_left  )      // Mixed sound at clk sample rate
);

jt12_fm_uprate u_right(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .fm_snd     ( fm_right  ),
    .psg_snd    ( psg3      ),
    .fm_en      ( fm_en     ),
    .cen_1008   ( cen_1008  ),
    .cen_252    ( cen_252   ),
    .cen_63     ( cen_63    ),
    .cen_9      ( cen_9     ),
    .snd        ( snd_right )      // Mixed sound at clk sample rate
);

endmodule // jt12_genmix