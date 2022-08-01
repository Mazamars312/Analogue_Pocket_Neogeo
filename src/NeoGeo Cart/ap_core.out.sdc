## Generated SDC file "ap_core.out.sdc"

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

## DATE    "Mon Aug 01 05:13:53 2022"

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

create_clock -name {altera_reserved_tck} -period 33.333 -waveform { 0.000 16.666 } [get_ports {altera_reserved_tck}]
create_clock -name {clk_74a} -period 13.468 -waveform { 0.000 6.734 } [get_ports {clk_74a}]
create_clock -name {clk_74b} -period 13.468 -waveform { 0.000 6.734 } [get_ports {clk_74b}]
create_clock -name {bridge_spiclk} -period 13.468 -waveform { 0.000 6.734 } [get_ports {bridge_spiclk}]
create_clock -name {scal_clk} -period 166.660 -waveform { 0.000 83.330 } [get_ports {scal_clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk} -source [get_pins {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 7 -master_clock {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|vcoph[0]} [get_pins {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] 
create_generated_clock -name {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|vcoph[0]} -source [get_pins {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|refclkin}] -duty_cycle 50/1 -multiply_by 1163 -divide_by 128 -master_clock {clk_74a} [get_pins {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|fpll_0|fpll|vcoph[0]}] 
create_generated_clock -name {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 1143 -divide_by 128 -master_clock {clk_74a} [get_pins {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 5 -master_clock {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.120  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.120  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.120  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.120  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -setup 0.120  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -setup 0.120  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {clk_74a}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {clk_74a}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -setup 0.120  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -setup 0.120  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -rise_to [get_clocks {clk_74a}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}] -fall_to [get_clocks {clk_74a}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -rise_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -fall_to [get_clocks {ic|Neogeo|pll_sdram|pll_sdram_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -rise_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -fall_to [get_clocks {ic|Neogeo|pll_sys|pll_inst|altera_pll_i|cyclonev_pll|counter[0].output_counter|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks { bridge_spiclk }] -group [get_clocks { clk_74a }] -group [get_clocks { clk_74b }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk }] 
set_clock_groups -asynchronous -group [get_clocks { bridge_spiclk }] -group [get_clocks { clk_74a }] -group [get_clocks { clk_74b }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk }] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -start -from [get_keepers {*fx68k:*|Ir[*]}] -to [get_keepers {*fx68k:*|microAddr[*]}] 2
set_multicycle_path -hold -start -from [get_keepers {*fx68k:*|Ir[*]}] -to [get_keepers {*fx68k:*|microAddr[*]}] 1
set_multicycle_path -setup -start -from [get_keepers {*fx68k:*|Ir[*]}] -to [get_keepers {*fx68k:*|nanoAddr[*]}] 2
set_multicycle_path -hold -start -from [get_keepers {*fx68k:*|Ir[*]}] -to [get_keepers {*fx68k:*|nanoAddr[*]}] 1
set_multicycle_path -setup -start -from [get_keepers {*|nanoLatch[*]}] -to [get_keepers {*|excUnit|alu|pswCcr[*]}] 2
set_multicycle_path -hold -start -from [get_keepers {*|nanoLatch[*]}] -to [get_keepers {*|excUnit|alu|pswCcr[*]}] 1
set_multicycle_path -setup -start -from [get_keepers {*|excUnit|alu|oper[*]}] -to [get_keepers {*|excUnit|alu|pswCcr[*]}] 2
set_multicycle_path -hold -start -from [get_keepers {*|excUnit|alu|oper[*]}] -to [get_keepers {*|excUnit|alu|pswCcr[*]}] 1


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

