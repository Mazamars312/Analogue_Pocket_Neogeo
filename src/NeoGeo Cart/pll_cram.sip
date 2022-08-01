set_global_assignment -entity "pll_cram" -library "lib_pll_cram" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_cram" -library "lib_pll_cram" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "pll_cram" -library "lib_pll_cram" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_cram" -name SPD_FILE [file join $::quartus(sip_path) "pll_cram.spd"]

set_global_assignment -library "lib_pll_cram" -name MISC_FILE [file join $::quartus(sip_path) "pll_cram_sim/pll_cram.vo"]
