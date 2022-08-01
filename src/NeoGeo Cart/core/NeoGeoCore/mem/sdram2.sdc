derive_pll_clocks

set clk_sdram_sys  {*|pll|pll_inst|altera_pll_i|*[0].*|divclk}
set clk_sdram_chip {*|pll|pll_inst|altera_pll_i|*[2].*|divclk}

create_generated_clock -name SDRAM2_CLK -source [get_pins -compatibility_mode $clk_sdram_chip] [get_ports {SDRAM2_CLK}]

derive_clock_uncertainty

# Set acceptable delays for SDRAM2 chip (See correspondent chip datasheet) 
set_input_delay -max -clock $clk_sdram_sys 8.7ns [get_ports SDRAM2_DQ[*]]
set_input_delay -min -clock $clk_sdram_sys 6.0ns [get_ports SDRAM2_DQ[*]]

set_output_delay -max -clock SDRAM2_CLK  1.6ns [get_ports {SDRAM2_D* SDRAM2_A* SDRAM2_BA* SDRAM2_n*}]
set_output_delay -min -clock SDRAM2_CLK -0.9ns [get_ports {SDRAM2_D* SDRAM2_A* SDRAM2_BA* SDRAM2_n*}]
