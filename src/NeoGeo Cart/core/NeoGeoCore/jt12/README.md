# JT12 FPGA Clone of Yamaha OPN hardware by Jose Tejada (@topapate)
===================================================================

You can show your appreciation through
* [Patreon](https://patreon.com/topapate), by supporting releases
* [Paypal](https://paypal.me/topapate), with a donation


JT12 is an FM sound source written in Verilog, fully compatible with YM2612/YM3438 (Megadrive), YM2610 (NeoGeo) and YM2203 (PC88, arcades).

The implementation tries to be as close to original hardware as possible. Low usage of FPGA resources has also been a design goal. Except in the operator section (jt12_op) where an exact replica of the original circuit is done. This could be done in less space with a different style but because this piece of the circuit was reversed engineered by Sauraen, I decided to use that knowledge.

Directories:

hdl -> all relevant RTL files, written in verilog
ver -> test benches
ver/verilator -> test bench that can play vgm files

Usage:

YM2610: top level file hdl/jt10.v. Use jt10.qip to automatically get all relevant files in Quartus.
YM2612: top level file hdl/jt12.v. Use jt12.qip to automatically get all relevant files in Quartus.
YM2203: top level file hdl/jt03.v. Use jt03.qip to automatically get all relevant files in Quartus.

## Simulation
=============

There are several simulation test benches in the **ver** folder. The most important one is in the **ver/verilator** folder. The simulation script is called with the shell script **go** in the same folder. The script will compile the file **test.cpp** together with other files and the design and will simulate the tune specificied with the -f command. It can read **vgm** tunes and generate .wav output of them.
