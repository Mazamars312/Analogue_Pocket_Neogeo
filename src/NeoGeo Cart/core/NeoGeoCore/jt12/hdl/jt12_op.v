`timescale 1ns / 1ps


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

    Based on Sauraen VHDL version of OPN/OPN2, which is based on die shots.

    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 27-1-2017 

*/


module jt12_op(
    input           rst,
    input           clk,
    input           clk_en /* synthesis direct_enable */,
    input   [9:0]   pg_phase_VIII,
    input   [9:0]   eg_atten_IX,        // output from envelope generator
    input   [2:0]   fb_II,      // voice feedback
    input           xuse_prevprev1,
    input           xuse_prev2,
    input           xuse_internal,
    input           yuse_prev1,
    input           yuse_prev2,
    input           yuse_internal, 
    input           test_214,
    
    input           s1_enters,
    input           s2_enters,
    input           s3_enters,
    input           s4_enters,
    input           zero,
    
    output  signed [ 8:0]   op_result,
    output  signed [13:0]   full_result
);

parameter num_ch = 6;

/*  enters  exits
    S1      S2
    S3      S4
    S2      S1
    S4      S3
*/

reg [13:0]  op_result_internal, op_XII;
reg [11:0]  atten_internal_IX;

assign op_result   = op_result_internal[13:5];
assign full_result = op_result_internal;

reg         signbit_IX, signbit_X, signbit_XI;
reg [11:0]  totalatten_X;

wire [13:0] prev1, prevprev1, prev2;

reg [13:0] prev1_din, prevprev1_din, prev2_din;

always @(*)
    if( num_ch==3 ) begin
        prev1_din     = s1_enters ? op_result_internal : prev1;
        prevprev1_din = s3_enters ? op_result_internal : prevprev1;
        prev2_din     = s2_enters ? op_result_internal : prev2;
    end else begin // 6 channels
        prev1_din     = s2_enters ? op_result_internal : prev1;
        prevprev1_din = s2_enters ? prev1 : prevprev1;
        prev2_din     = s1_enters ? op_result_internal : prev2;
    end

jt12_sh #( .width(14), .stages(num_ch)) prev1_buffer(
//  .rst    ( rst       ),
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .din    ( prev1_din ),
    .drop   ( prev1     )
);

jt12_sh #( .width(14), .stages(num_ch)) prevprev1_buffer(
//  .rst    ( rst           ),
    .clk    ( clk           ),
    .clk_en ( clk_en        ),
    .din    ( prevprev1_din ),
    .drop   ( prevprev1     )
);

jt12_sh #( .width(14), .stages(num_ch)) prev2_buffer(
//  .rst    ( rst       ),
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .din    ( prev2_din ),
    .drop   ( prev2     )
);


reg [10:0]  subtresult;

reg [12:0]  shifter, shifter_2, shifter_3;

// REGISTER/CYCLE 1
// Creation of phase modulation (FM) feedback signal, before shifting
reg [13:0]  x,  y;
reg [14:0]  xs, ys, pm_preshift_II;
reg         s1_II;

always @(*) begin
    casez( {xuse_prevprev1, xuse_prev2, xuse_internal })
        3'b1??: x = prevprev1;
        3'b01?: x = prev2;
        3'b001: x = op_result_internal;
        default: x = 14'd0;
    endcase
    casez( {yuse_prev1, yuse_prev2, yuse_internal })
        3'b1??: y = prev1;
        3'b01?: y = prev2;
        3'b001: y = op_result_internal;
        default: y = 14'd0;
    endcase    
    xs = { x[13], x }; // sign-extend
    ys = { y[13], y }; // sign-extend
end

always @(posedge clk) if( clk_en ) begin
    pm_preshift_II <= xs + ys; // carry is discarded
    s1_II <= s1_enters;
end

/* REGISTER/CYCLE 2-7 (also YM2612 extra cycles 1-6)
   Shifting of FM feedback signal, adding phase from PG to FM phase
   In YM2203, phasemod_II is not registered at all, it is latched on the first edge 
   in add_pg_phase and the second edge is the output of add_pg_phase. In the YM2612, there
   are 6 cycles worth of registers between the generated (non-registered) phasemod_II signal
   and the input to add_pg_phase.     */

reg  [9:0]  phasemod_II;
wire [9:0]  phasemod_VIII;

always @(*) begin
    // Shift FM feedback signal
    if (!s1_II ) // Not S1
        phasemod_II = pm_preshift_II[10:1]; // Bit 0 of pm_preshift_II is never used
    else // S1
        case( fb_II )
            3'd0: phasemod_II = 10'd0;      
            3'd1: phasemod_II = { {4{pm_preshift_II[14]}}, pm_preshift_II[14:9] };
            3'd2: phasemod_II = { {3{pm_preshift_II[14]}}, pm_preshift_II[14:8] };
            3'd3: phasemod_II = { {2{pm_preshift_II[14]}}, pm_preshift_II[14:7] };
            3'd4: phasemod_II = {    pm_preshift_II[14],   pm_preshift_II[14:6] };
            3'd5: phasemod_II = pm_preshift_II[14:5];
            3'd6: phasemod_II = pm_preshift_II[13:4];
            3'd7: phasemod_II = pm_preshift_II[12:3];
        endcase
end

// REGISTER/CYCLE 2-7
//generate
//    if( num_ch==6 )
        jt12_sh #( .width(10), .stages(6)) phasemod_sh(
            .clk    ( clk   ),
            .clk_en ( clk_en),
            .din    ( phasemod_II ),
            .drop   ( phasemod_VIII )
        );
//     else begin
//         assign phasemod_VIII = phasemod_II;
//     end
// endgenerate

// REGISTER/CYCLE 8
reg [ 9:0]  phase;
// Sets the maximum number of fanouts for a register or combinational
// cell.  The Quartus II software will replicate the cell and split
// the fanouts among the duplicates until the fanout of each cell
// is below the maximum.

reg [ 7:0]  aux_VIII;

always @(*) begin
    phase   = phasemod_VIII + pg_phase_VIII;
    aux_VIII= phase[7:0] ^ {8{~phase[8]}};
end

always @(posedge clk) if( clk_en ) begin    
    signbit_IX <= phase[9];     
end

wire [11:0]  logsin_IX;

jt12_logsin u_logsin (
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .addr   ( aux_VIII[7:0] ),
    .logsin ( logsin_IX )
);  


// REGISTER/CYCLE 9
// Sine table    
// Main sine table body

always @(*) begin
    subtresult = eg_atten_IX + logsin_IX[11:2];
    atten_internal_IX = { subtresult[9:0], logsin_IX[1:0] } | {12{subtresult[10]}};
end

wire [9:0] mantissa_X;
reg  [9:0] mantissa_XI;
reg  [3:0] exponent_X, exponent_XI;

jt12_exprom u_exprom(
    .clk    ( clk       ),
    .clk_en ( clk_en    ),
    .addr   ( atten_internal_IX[7:0] ),
    .exp    ( mantissa_X )
);

always @(posedge clk) if( clk_en ) begin
    exponent_X <= atten_internal_IX[11:8];    
    signbit_X  <= signbit_IX;    
end

always @(posedge clk) if( clk_en ) begin
    mantissa_XI <= mantissa_X;
    exponent_XI <= exponent_X;
    signbit_XI  <= signbit_X;     
end

// REGISTER/CYCLE 11
// Introduce test bit as MSB, 2's complement & Carry-out discarded

always @(*) begin    
    // Floating-point to integer, and incorporating sign bit
    // Two-stage shifting of mantissa_XI by exponent_XI
    shifter = { 3'b001, mantissa_XI };
    case( ~exponent_XI[1:0] )
        2'b00: shifter_2 = { 1'b0, shifter[12:1] }; // LSB discarded
        2'b01: shifter_2 = shifter;
        2'b10: shifter_2 = { shifter[11:0], 1'b0 };
        2'b11: shifter_2 = { shifter[10:0], 2'b0 };
    endcase
    case( ~exponent_XI[3:2] )
        2'b00: shifter_3 = {12'b0, shifter_2[12]   };
        2'b01: shifter_3 = { 8'b0, shifter_2[12:8] };
        2'b10: shifter_3 = { 4'b0, shifter_2[12:4] };
        2'b11: shifter_3 = shifter_2;
    endcase
end

always @(posedge clk) if( clk_en ) begin
    // REGISTER CYCLE 11
    op_XII <= ({ test_214, shifter_3 } ^ {14{signbit_XI}}) + {13'd0,signbit_XI};               
    // REGISTER CYCLE 12
    // Extra register, take output after here
    op_result_internal <= op_XII;   
end

endmodule
