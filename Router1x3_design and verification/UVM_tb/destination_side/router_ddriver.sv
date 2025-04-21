//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Destination Driver ************************************************----------

//Extend router_driver from uvm_driver
class router_ddriver extends uvm_driver #(dest_xtn);

//Factory registration using uvm_component
`uvm_component_utils(router_ddriver)

//Declare virtual interface handle with source_drv as modport
virtual router_if.DESTINATION_DRV vif;

//Declare handle for source_config as s_cfg
destination_config d_cfg;

//----------------------------------------------------------------------------------
//METHODS
//----------------------------------------------------------------------------------
//Standard UVM Methods

extern function new(string name = "router_ddriver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(dest_xtn xtn);
//extern function void report_phase(uvm_phase phase);

endclass:router_ddriver

//-------------------------------------Define new()---------------------------------------------------//
function router_ddriver::new(string name = "router_ddriver",uvm_component parent);
super.new(name,parent);
endfunction:new

//--------------------------------------build() phase---------------------------------------------------//
function void router_ddriver::build_phase(uvm_phase phase);
//Call super.build_phase
super.build_phase(phase);

//get the config object from uvm_config_db
if(!uvm_config_db #(destination_config)::get(this,"","destination_config",d_cfg))
	`uvm_fatal("DESTINATION DRIVER","You are not getting the configuration whether you set it ()??")

endfunction:build_phase

//-----------------------------------------connect() phase-------------------------------------------------------//
function void router_ddriver::connect_phase(uvm_phase phase);
//Call super.connect_phase
super.connect_phase(phase);

vif = d_cfg.vif;

endfunction:connect_phase

//------------------------------------------run() phase-------------------------------------------------------------------//
task router_ddriver::run_phase(uvm_phase phase);
//Inside forever loop
//Call get next item and send to dut and item done

forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
   //req.print();
		seq_item_port.item_done();
	end
endtask:run_phase

//-------------------------------------- send_to_dut() ---------------------------------------------------------------//
task router_ddriver::send_to_dut(dest_xtn xtn);
$display("****************************************8");
//Check for valid_out using while loop if it is 1, go to next cycle and assert the read enable
while(vif.destination_drv.valid_out !== 1)
	@(vif.destination_drv);
@(vif.destination_drv);
vif.destination_drv.read_enb <= 1'b1;

//give one clock cycle delay
@(vif.destination_drv);

//Again check for valid_out and if it is 0,go to next cycle and deassert the read enable
while(vif.destination_drv.valid_out !== 0)
	@(vif.destination_drv);
@(vif.destination_drv);
vif.destination_drv.read_enb <= 1'b0;
`uvm_info("DESTINATION DRIVER","You are displaying the transaction of destination driver",UVM_LOW)
xtn.print();
endtask




