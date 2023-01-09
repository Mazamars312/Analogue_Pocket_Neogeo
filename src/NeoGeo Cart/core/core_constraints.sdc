## Generated SDC file "F:/Analogue/NeoGeo/src/NeoGeo Cart/core/core_constraints.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Standard Edition"

## DATE    "Mon Aug 01 05:13:08 2022"

##
## DEVICE  "5CEBA4F23C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock
#**************************************************************


#**************************************************************
# Create Generated Clock
#**************************************************************

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************


#**************************************************************
# Set Input Delay
#**************************************************************


set dram_chip_clk "ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk"

set_input_delay -clock $dram_chip_clk -reference_pin [get_ports {dram_clk}] -max 5.9 [get_ports dram_dq[*]]
set_input_delay -clock $dram_chip_clk -reference_pin [get_ports {dram_clk}] -min 0.9 [get_ports dram_dq[*]] 

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock $dram_chip_clk -reference_pin [get_ports {dram_clk}] -max 2.0 [get_ports {dram_cke dram_a* dram_ba* dram_cas_n dram_ras_n dram_we_n}]
set_output_delay -clock $dram_chip_clk -reference_pin [get_ports {dram_clk}] -min -1.0 [get_ports {dram_cke dram_a* dram_ba* dram_cas_n dram_ras_n dram_we_n}]

#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous \
 -group { bridge_spiclk } \
 -group { clk_74a } \
 -group { clk_74b } \
 -group { ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk } \
 -group { ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[1].output_counter|divclk } \
 -group { ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[2].output_counter|divclk } \
 -group { ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[3].output_counter|divclk } \
 -group { ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[4].output_counter|divclk }     

#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from {core_top:ic|emu:Neogeo|apf_io:apf_io|RTC[*]} -to {core_top:ic|emu:Neogeo|uPD4990:RTC|SHIFT_REG[*]}


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

