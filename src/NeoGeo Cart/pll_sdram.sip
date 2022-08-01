set_global_assignment -entity "pll_sdram" -library "lib_pll_sdram" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_sdram" -library "lib_pll_sdram" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "pll_sdram" -library "lib_pll_sdram" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_sdram" -name SPD_FILE [file join $::quartus(sip_path) "pll_sdram.spd"]

set_global_assignment -library "lib_pll_sdram" -name MISC_FILE [file join $::quartus(sip_path) "pll_sdram_sim/pll_sdram.vo"]
