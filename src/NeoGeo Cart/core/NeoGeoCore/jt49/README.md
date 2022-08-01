# JT49 FPGA Clone of YM2149 hardware by Jose Tejada (@topapate)

You can show your appreciation through
* [Patreon](https://patreon.com/topapate), by supporting releases
* [Paypal](https://paypal.me/topapate), with a donation


YM2149 compatible Verilog core, with emphasis on FPGA implementation as part of JT12 in order to recreate the YM2203 part.

## Usage

There are two top level files you can use:
 - **jt49_bus**: presents the expected AY-3-8910 interface
 - **jt49**: presents a simplified interface, ideal to embed. This is the one used by jt12

clk_en cannot be set to 1 for correct operation. The design assumes that there will be at least one empty clock cycle between every two clk_en high clock cycles.
 
## Port Description jt49

Name     | Direction | Width | Purpose
---------|-----------|-------|-------------------------------------
rst_n    | input     |       | active-low asynchronous reset signal
clk      | input     |       | clock
clk_en   | input     |       | clock enable. It cannot be a permanent 1
addr     | input     | 4     | selects the register to access to
cs_n     | input     |       | chip-select, active low
wr_n     | input     |       | active-low write signal
din      | input     | 8     | data to write to registers
sel      | input     |       | input clock is further divided by 2 when low
dout     | output    | 8     | data read from registers. Updated when cs_n is low
sound    | output    | 10    | Unsigned combined output of the three channels    
A        | output    | 8     | Unsigned output of channel A
B        | output    | 8     | Unsigned output of channel B
C        | output    | 8     | Unsigned output of channel C 

The module is not designed to be used at full clk speed. The clock enable input signal should divide the clock at least by two. This is needed because the volume LUT is shared for all three channels and the pipeline does not include wait states for the LUT as wait states happen naturally when clk_en is used.

The ports of **jt49_bus** replace the CPU interface with that of the original AY-3-8910.

Name     | Direction | Width | Purpose
---------|-----------|-------|-------------------------------------
rst_n    | input     |       | active-low asynchronous reset signal
clk      | input     |       | clock
clk_en   | input     |       | clock enable. It cannot be a permanent 1
bdir     | input     |       | bdir pin of AY-3-8910            
bc1      | input     |       | bc1  pin of AY-3-8910
din      | input     | 8     | data to write to registers
sel      | input     |       | input clock is further divided by 2 when low
dout     | output    | 8     | data read from registers. Updated when cs_n is low
sound    | output    | 10    | Unsigned combined output of the three channels    
A        | output    | 8     | Unsigned output of channel A
B        | output    | 8     | Unsigned output of channel B
C        | output    | 8     | Unsigned output of channel C
IOA_in   | input     | 8     | I/O port A, input side
IOA_in   | output    | 8     | I/O port A, output side
IOB_in   | input     | 8     | I/O port B, input side
IOB_in   | output    | 8     | I/O port B, output side

## Comparison with AY-3-8910 Verilog Model

A simulation test bench of jt49 vs the AY-3-8910 model (available in the doc folder via a git submodule) is available in folder ver/comp. The simulation uses a simple text file to enter arbitrary commands (test_cmd). The command file is converted to hexadecimal by parser.awk and used in simulation. The following parameters were tested:

Item                 |  Compliance      | Remarks
---------------------|------------------|-------------------------------
channel period       |  Yes             | Tested: 0, 1 and FFFF values
noise period         |  Yes             | Tested: 0, 7 and 1F values
envelope shape       |  Yes             | Tested all 16 shapes
envelope period      |  Yes             | Tested 0 and FFF values

## Resistor Load Modelling

The resistor load had an effect of gain compression on the chip. There is a parameter called **COMP** which can be used to model this effect. You can assign a value from 0 to 3.

Value | Dynamic Range | Equivalent resistor  
------|---------------|--------------------
 0    |  43.6 dB      | <1000 Ohm  
 1    |  29.1 dB      | ~8000 Ohm  
 2    |  21.8 dB      | ~40  kOhm (?)  
 3    |  13.4 dB      | ~99  kOhm  

## Non Linear Effects

- Saturation effects are not modelled
- Channel mixing effects by short circuiting the outputs are not modelled
