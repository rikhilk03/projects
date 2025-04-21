//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Source Sequencer ************************************************----------

//Extend router_sequencer from uvm_sequencer
class router_sequencer extends uvm_sequencer #(souc_xtn);

//Factory registration using uvm_component
`uvm_component_utils(router_sequencer)

//-----------------------------------------------------------------------------------
//METHODS
//-----------------------------------------------------------------------------------
//Standard UVM Methods

extern function new(string name = "router_sequencer",uvm_component parent);

endclass:router_sequencer

//--------------------------------Define new()--------------------------------------------------//
function router_sequencer::new(string name = "router_sequencer",uvm_component parent);
super.new(name,parent);
endfunction:new
