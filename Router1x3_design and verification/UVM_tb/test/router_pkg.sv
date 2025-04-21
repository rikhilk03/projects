//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Router Packages *************************************************---------

	package router_pkg;
	
	//import uvm_pkg
	import uvm_pkg::*;
	
	//include macros.svh
	`include "uvm_macros.svh"
//`include "tb_defs.sv"
`include "souc_xtn.sv"
`include "source_agt_config.sv"
`include "destination_agt_config.sv"
`include "router_env_config.sv"
`include "router_sdriver.sv"
`include "router_smonitor.sv"
`include "router_ssequencer.sv"
`include "router_sagent.sv"
`include "router_sagent_top.sv"
`include "souc_seqs.sv"

`include "dest_xtn.sv"
`include "router_dmonitor.sv"
`include "router_dsequencer.sv"
`include "router_ddriver.sv"
`include "router_dagent.sv"
`include "router_dagent_top.sv"
`include "dest_seqs.sv"

//`include "ram_virtual_sequencer.sv"
//`include "ram_virtual_seqs.sv"
`include "router_scoreboard.sv"

`include "router_env.sv"


`include "router_base_test.sv"
	
	
	endpackage

