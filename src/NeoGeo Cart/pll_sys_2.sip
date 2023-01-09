set_global_assignment -entity "pll_sys_2" -library "lib_pll_sys_2" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_sys_2" -library "lib_pll_sys_2" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "pll_sys_2" -library "lib_pll_sys_2" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_sys_2" -name SPD_FILE [file join $::quartus(sip_path) "pll_sys_2.spd"]

set_global_assignment -library "lib_pll_sys_2" -name MISC_FILE [file join $::quartus(sip_path) "pll_sys_2_sim/pll_sys_2.vo"]
