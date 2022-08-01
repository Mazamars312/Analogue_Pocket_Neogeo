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
    Date: 27-12-2018

*/

// Wrapper to output only combined channels. Defaults to YM2612 mode.

module jt12 (
    input           rst,        // rst should be at least 6 clk&cen cycles long
    input           clk,        // CPU clock
    input           cen,        // optional clock enable, if not needed leave as 1'b1
    input   [7:0]   din,
    input   [1:0]   addr,
    input           cs_n,
    input           wr_n,
    
    output  [7:0]   dout,
    output          irq_n,
    // configuration
    input           en_hifi_pcm,
    // combined output
    output  signed  [15:0]  snd_right,
    output  signed  [15:0]  snd_left,
    output          snd_sample
);

// Default parameters for JT12 select a YM2610
jt12_top u_jt12(
    .rst    ( rst   ),        // rst should be at least 6 clk&cen cycles long
    .clk    ( clk   ),        // CPU clock
    .cen    ( cen   ),        // optional clock enable, it not needed leave as 1'b1
    .din    ( din   ),
    .addr   ( addr  ),
    .cs_n   ( cs_n  ),
    .wr_n   ( wr_n  ),
    
    .dout   ( dout  ),  
    .irq_n  ( irq_n ),
    // configuration
    .en_hifi_pcm    ( en_hifi_pcm ),
    // Unused ADPCM pins
    .adpcma_addr    (      ), // real hardware has 10 pins multiplexed through RMPX pin
    .adpcma_bank    (      ),
    .adpcma_roe_n   (      ), // ADPCM-A ROM output enable
    .adpcma_data    ( 8'd0 ), // Data from RAM
    .adpcmb_addr    (      ), // real hardware has 12 pins multiplexed through PMPX pin
    .adpcmb_roe_n   (      ), // ADPCM-B ROM output enable
    // Separated output
    .psg_A          (),
    .psg_B          (),
    .psg_C          (),
    .fm_snd_left    (),
    .fm_snd_right   (),
    // combined output
    .psg_snd        (),
    .snd_right      ( snd_right     ), // FM+PSG
    .snd_left       ( snd_left      ),  // FM+PSG
    .snd_sample     ( snd_sample    )
);
endmodule // jt03