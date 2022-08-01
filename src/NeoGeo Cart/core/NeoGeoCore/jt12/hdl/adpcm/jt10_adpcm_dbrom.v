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

// dB to linear

module jt10_adpcm_dbrom(
    input           clk,        // CPU clock
    input   [5:0]   db,
    output reg [8:0]   lin
);

reg [8:0] mem[0:63];

initial begin // generated with file gen_lingain.py
   mem[000] = 9'd511;   mem[001] = 9'd468;   mem[002] = 9'd429;   mem[003] = 9'd394;
   mem[004] = 9'd361;   mem[005] = 9'd331;   mem[006] = 9'd304;   mem[007] = 9'd279;
   mem[008] = 9'd256;   mem[009] = 9'd234;   mem[010] = 9'd215;   mem[011] = 9'd197;
   mem[012] = 9'd181;   mem[013] = 9'd166;   mem[014] = 9'd152;   mem[015] = 9'd139;
   mem[016] = 9'd128;   mem[017] = 9'd117;   mem[018] = 9'd107;   mem[019] = 9'd099;
   mem[020] = 9'd090;   mem[021] = 9'd083;   mem[022] = 9'd076;   mem[023] = 9'd070;
   mem[024] = 9'd064;   mem[025] = 9'd059;   mem[026] = 9'd054;   mem[027] = 9'd049;
   mem[028] = 9'd045;   mem[029] = 9'd041;   mem[030] = 9'd038;   mem[031] = 9'd035;
   mem[032] = 9'd032;   mem[033] = 9'd029;   mem[034] = 9'd027;   mem[035] = 9'd024;
   mem[036] = 9'd022;   mem[037] = 9'd020;   mem[038] = 9'd019;   mem[039] = 9'd017;
   mem[040] = 9'd016;   mem[041] = 9'd014;   mem[042] = 9'd013;   mem[043] = 9'd012;
   mem[044] = 9'd011;   mem[045] = 9'd010;   mem[046] = 9'd009;   mem[047] = 9'd008;
   mem[048] = 9'd008;   mem[049] = 9'd007;   mem[050] = 9'd006;   mem[051] = 9'd006;
   mem[052] = 9'd005;   mem[053] = 9'd005;   mem[054] = 9'd004;   mem[055] = 9'd004;
   mem[056] = 9'd004;   mem[057] = 9'd003;   mem[058] = 9'd003;   mem[059] = 9'd003;
   mem[060] = 9'd002;   mem[061] = 9'd002;   mem[062] = 9'd002;   mem[063] = 9'd002;
end

always @(posedge clk)
    lin <= mem[db];

endmodule // jt10_adpcm_dbrom