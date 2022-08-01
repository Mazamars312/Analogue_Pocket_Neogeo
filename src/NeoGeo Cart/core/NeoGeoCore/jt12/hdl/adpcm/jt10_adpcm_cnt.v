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
    Date: 21-03-2019
*/

module jt10_adpcm_cnt(
    input             rst_n,
    input             clk,        // CPU clock
    input             cen,        // 666 kHz
    // pipeline channel
    input      [ 5:0] cur_ch,
    input      [ 5:0] en_ch,
    // Address writes from CPU
    input      [15:0] addr_in,
    input      [ 2:0] addr_ch,
    input             up_start,
    input             up_end,
    // Counter control
    input             aon,
    input             aoff,
    // ROM driver
    output     [19:0] addr_out,
    output     [ 3:0] bank,
    output            sel,
    output            roe_n,
    output            decon,
    output            clr,      // inform the decoder that a new section begins
    // Flags
    output reg [ 5:0] flags,
    input      [ 5:0] clr_flags,
    //
    output [15:0] start_top,
    output [15:0]   end_top
);

reg [20:0] addr1, addr2, addr3, addr4, addr5, addr6;
reg [3:0] bank1, bank2, bank3, bank4, bank5, bank6;
reg [11:0] start1, start2, start3, start4, start5, start6,
           end1,   end2,   end3,   end4,   end5,   end6;
reg on1, on2, on3, on4, on5, on6;
reg done5, done6, done1;
reg [5:0] done_sr, zero;

reg roe_n1, decon1;

reg clr1, clr2, clr3, clr4, clr5, clr6;
reg skip1, skip2, skip3, skip4, skip5, skip6;

// All outputs from stage 1
assign addr_out = addr1[20:1];
assign sel      = addr1[0];
assign bank     = bank1;
assign roe_n    = roe_n1;
assign clr      = clr1;
assign decon    = decon1;

// Two cycles early:  0            0             1            1             2            2             3            3             4            4             5            5
wire active5 = (en_ch[1] && cur_ch[4]) || (en_ch[2] && cur_ch[5]) || (en_ch[2] && cur_ch[0]) || (en_ch[3] && cur_ch[1]) || (en_ch[4] && cur_ch[2]) || (en_ch[5] && cur_ch[3]);//{ cur_ch[3:0], cur_ch[5:4] } == en_ch;
wire sumup5  = on5 && !done5 && active5;
reg  sumup6;

reg [5:0] last_done, set_flags;

always @(posedge clk or negedge rst_n) 
    if( !rst_n ) begin
        zero      <= 6'd1;
        done_sr   <= ~6'd0;
        last_done <= ~6'd0;
    end else if(cen) begin
        zero    <= { zero[0], zero[5:1] };
        done_sr <= { done1, done_sr[5:1]};
        if( zero[0] ) begin
            last_done <= done_sr;
            set_flags <= ~last_done & done_sr;
        end
    end

always @(posedge clk or negedge rst_n) 
    if( !rst_n ) begin
        flags <= 6'd0;
    end else begin
        flags <= ~clr_flags & (set_flags | flags);
    end

`ifdef SIMULATION
wire [11:0] addr1_cmp = addr1[20:9];
`endif

assign start_top = {bank1, start1};
assign   end_top =   {bank1, end1};

reg [5:0] addr_ch_dec;

always @(*)
    case(addr_ch)
        3'd0: addr_ch_dec = 6'b000_001;
        3'd1: addr_ch_dec = 6'b000_010;
        3'd2: addr_ch_dec = 6'b000_100;
        3'd3: addr_ch_dec = 6'b001_000;
        3'd4: addr_ch_dec = 6'b010_000;
        3'd5: addr_ch_dec = 6'b100_000;
        default: addr_ch_dec = 6'd0;
    endcase // up_addr

wire up1 = cur_ch == addr_ch_dec;

always @(posedge clk or negedge rst_n) 
    if( !rst_n ) begin
        addr1  <= 'd0;    addr2 <= 'd0;    addr3 <= 'd0;
        addr4  <= 'd0;    addr5 <= 'd0;    addr6 <= 'd0;
        done1  <= 'd1;    done5 <= 'd1;    done6 <= 'd1;
        start1 <= 'd0;   start2 <= 'd0;   start3 <= 'd0;
        start4 <= 'd0;   start5 <= 'd0;   start6 <= 'd0;
        end1   <= 'd0;     end2 <= 'd0;     end3 <= 'd0;
        end4   <= 'd0;     end5 <= 'd0;     end6 <= 'd0;
        skip1  <= 'd0;    skip2 <= 'd0;    skip3 <= 'd0;
        skip4  <= 'd0;    skip5 <= 'd0;    skip6 <= 'd0;
    end else if( cen ) begin
        addr2  <= addr1;
        on2    <= aoff ? 1'b0 : (aon | (on1 && ~done1));
        clr2   <= aoff || aon || done1; // Each time a A-ON is sent the address counter restarts
        start2 <=  (up_start && up1) ? addr_in[11:0] : start1;
        end2   <=  (up_end   && up1) ? addr_in[11:0] : end1;
        bank2  <=  (up_start && up1) ? addr_in[15:12] : bank1;
        skip2  <= skip1;

        addr3  <= addr2; // clr2 ? {start2,9'd0} : addr2;
        on3    <= on2;
        clr3   <= clr2;
        start3 <= start2;
        end3   <= end2;
        bank3  <= bank2;
        skip3  <= skip2;

        addr4  <= addr3;
        on4    <= on3;
        clr4   <= clr3;
        start4 <= start3;
        end4   <= end3;
        bank4  <= bank3;
        skip4  <= skip3;

        addr5  <= addr4;
        on5    <= on4;
        clr5   <= clr4;
        done5  <= addr4[20:9] == end4 && addr4[8:0]==~9'b0 && ~(clr4 && on4);
        start5 <= start4;
        end5   <= end4;
        bank5  <= bank4;
        skip5  <= skip4;
        // V
        addr6  <= addr5;
        on6    <= on5;
        clr6   <= clr5;
        done6  <= done5;
        start6 <= start5;
        end6   <= end5;
        bank6  <= bank5;
        sumup6 <= sumup5;
        skip6  <= skip5;

        addr1  <= (clr6 && on6) ? {start6,9'd0} : (sumup6 && ~skip6 ? addr6+21'd1 :addr6);
        on1    <= on6;
        done1  <= done6;
        start1 <= start6;
        end1   <= end6;
        roe_n1 <= ~sumup6;
        decon1 <= sumup6;
        bank1  <= bank6;
        clr1   <= clr6;
        skip1  <= (clr6 && on6) ? 1'b1 : sumup6 ? 1'b0 : skip6;
    end

endmodule // jt10_adpcm_cnt
