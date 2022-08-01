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
    Date: 14-2-2017 

*/

module jt12_csr( // Circular Shift Register + input mux
    input           rst,
    input           clk,
    input           clk_en /* synthesis direct_enable */,
    input   [ 7:0]  din,
    input   [43:0]  shift_in,
    output  [43:0]  shift_out,

    input           up_tl,     
    input           up_dt1,    
    input           up_ks_ar,  
    input           up_amen_dr,
    input           up_sr,     
    input           up_sl_rr,  
    input           up_ssgeg,  
    input           update_op_I,
    input           update_op_II,
    input           update_op_IV
);

localparam regop_width=44;

reg [regop_width-1:0] regop_in;

jt12_sh_rst #(.width(regop_width),.stages(12)) u_regch(
    .clk    ( clk          ),
    .clk_en ( clk_en       ),
    .rst    ( rst          ),
    .din    ( regop_in     ),
    .drop   ( shift_out    )
);

wire up_tl_op   = up_tl     & update_op_IV;
wire up_dt1_op  = up_dt1    & update_op_I;
wire up_mul_op  = up_dt1    & update_op_II;
wire up_ks_op   = up_ks_ar  & update_op_II;
wire up_ar_op   = up_ks_ar  & update_op_I;
wire up_amen_op = up_amen_dr& update_op_IV;
wire up_dr_op   = up_amen_dr& update_op_I;
wire up_sr_op   = up_sr     & update_op_I;
wire up_sl_op   = up_sl_rr  & update_op_I;
wire up_rr_op   = up_sl_rr  & update_op_I;
wire up_ssg_op  = up_ssgeg  & update_op_I;

always @(*)
    regop_in = {
        up_tl_op    ? din[6:0]    : shift_in[43:37],      // 7 
        up_dt1_op   ? din[6:4]    : shift_in[36:34],      // 3 
        up_mul_op   ? din[3:0]    : shift_in[33:30],      // 4 
        up_ks_op    ? din[7:6]    : shift_in[29:28],      // 2 
        up_ar_op    ? din[4:0]    : shift_in[27:23],      // 5 
        up_amen_op  ? din[7]      : shift_in[   22],      // 1 
        up_dr_op    ? din[4:0]    : shift_in[21:17],      // 5 
        up_sr_op    ? din[4:0]    : shift_in[16:12],      // 5 
        up_sl_op    ? din[7:4]    : shift_in[11: 8],      // 4 
        up_rr_op    ? din[3:0]    : shift_in[ 7: 4],      // 4 
        up_ssg_op   ? din[3:0]    : shift_in[ 3: 0]       // 4 
    };

endmodule // jt12_reg