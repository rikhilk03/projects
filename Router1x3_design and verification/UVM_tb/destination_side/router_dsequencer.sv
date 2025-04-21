//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Destination Sequencer ************************************************----------

//Extend router_sequencer from uvm_sequencer
class router_dsequencer extends uvm_sequencer #(dest_xtn);

//Factory registration using uvm_component
`uvm_component_utils(router_dsequencer)

//-----------------------------------------------------------------------------------
//METHODS
//-----------------------------------------------------------------------------------
//Standard UVM Methods

extern function new(string name = "router_dsequencer",uvm_component parent);

endclass:router_dsequencer

//--------------------------------Define new()--------------------------------------------------//
function router_dsequencer::new(string name = "router_dsequencer",uvm_component parent);
super.new(name,parent);
endfunction:new
