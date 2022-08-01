set_global_assignment -entity "pll_cfg" -library "lib_pll_cfg" -name IP_TOOL_NAME "altera_pll_reconfig"
set_global_assignment -entity "pll_cfg" -library "lib_pll_cfg" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "pll_cfg" -library "lib_pll_cfg" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_cfg" -name SPD_FILE [file join $::quartus(sip_path) "pll_cfg.spd"]

set_global_assignment -library "lib_pll_cfg" -name MISC_FILE [file join $::quartus(sip_path) "pll_cfg_sim/pll_cfg.v"]
set_global_assignment -library "lib_pll_cfg" -name MISC_FILE [file join $::quartus(sip_path) "pll_cfg_sim/altera_pll_reconfig/altera_pll_reconfig_top.v"]
set_global_assignment -library "lib_pll_cfg" -name MISC_FILE [file join $::quartus(sip_path) "pll_cfg_sim/altera_pll_reconfig/altera_pll_reconfig_core.v"]
set_global_assignment -library "lib_pll_cfg" -name MISC_FILE [file join $::quartus(sip_path) "pll_cfg_sim/altera_pll_reconfig/altera_std_synchronizer.v"]
