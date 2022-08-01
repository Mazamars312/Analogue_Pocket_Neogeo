// NeoGeo logic definition
// Copyright (C) 2018 Sean Gonsalves
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Z80 CPU plug into TV80 core

module cpu_z80(
	input CLK_4M,
	input nRESET,
	input [7:0] SDD_IN,
	output [7:0] SDD_OUT,
	output [15:0] SDA,
	output reg nIORQ,
	output nMREQ,
	output reg nRD, nWR,
	input nINT, nNMI, nWAIT
);

	wire RFSH_n, MREQ_n;
	assign nMREQ = MREQ_n | ~RFSH_n;

	T80s cpu(
		.RESET_n(nRESET),
		.CLK(CLK_4M),
		.CEN(1),
		.WAIT_n(nWAIT),
		.INT_n(nINT),
		.NMI_n(nNMI),
		.MREQ_n(MREQ_n),
		.IORQ_n(nIORQ),
		.RD_n(nRD),
		.WR_n(nWR),
		.RFSH_n(RFSH_n),
		.A(SDA),
		.DI(SDD_IN),
		.DO(SDD_OUT)
	);

endmodule
