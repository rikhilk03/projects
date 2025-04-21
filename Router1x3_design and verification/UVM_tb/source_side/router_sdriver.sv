//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Source Driver ************************************************----------

//Extend router_driver from uvm_driver
class router_driver extends uvm_driver #(souc_xtn);

//Factory registration using uvm_component
`uvm_component_utils(router_driver)

//Declare virtual interface handle with source_drv as modport
virtual router_if.SOURCE_DRV vif;

//Declare handle for source_config as s_cfg
source_config s_cfg;

//----------------------------------------------------------------------------------
//METHODS
//----------------------------------------------------------------------------------
//Standard UVM Methods

extern function new(string name = "router_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(souc_xtn xtn);
//extern function void report_phase(uvm_phase phase);

endclass:router_driver

//-------------------------------------Define new()---------------------------------------------------//
function  router_driver::new(string name = "router_driver",uvm_component parent);
super.new(name,parent);
endfunction:new

//--------------------------------------build() phase---------------------------------------------------//
function void router_driver::build_phase(uvm_phase phase);
//Call super.build_phase
super.build_phase(phase);

//get the config object from uvm_config_db
if(!uvm_config_db #(source_config)::get(this,"","source_config",s_cfg))
	`uvm_fatal("SOURCE DRIVER","You are not getting the configuration whether you set it ()??")

endfunction:build_phase

//-----------------------------------------connect() phase-------------------------------------------------------//
function void router_driver::connect_phase(uvm_phase phase);
//Call super.connect_phase
super.connect_phase(phase);

vif = s_cfg.vif;

endfunction:connect_phase

//------------------------------------------run() phase-------------------------------------------------------------------//
task router_driver::run_phase(uvm_phase phase);
@(vif.source_drv);
vif.source_drv.rst <= 1'b0;
@(vif.source_drv);
vif.source_drv.rst <= 1'b1;
forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		//req.print();
		seq_item_port.item_done();
	end
endtask:run_phase

//---------------------------------------- send_to_dut() -----------------------------------------------------------------//
task router_driver::send_to_dut(souc_xtn xtn);
$display("hlooooooooo");
//Checking for busy signal and if it is zero, assert the pkt_valid
while(vif.source_drv.busy !== 0)
  @(vif.source_drv);
$display("hloooo1");
vif.source_drv.pkt_valid <= 1'b1;

//assign header to the source driver 
//and assign the payload to data_in within the foreach loop that is after the one clock cycle
vif.source_drv.data_in <= req.header;
  @(vif.source_drv);
foreach(req.payload[i]) begin
while(vif.source_drv.busy !== 0)
  @(vif.source_drv);
vif.source_drv.data_in <= req.payload[i];
  @(vif.source_drv);
 end
  
//Deassert the packet valid
vif.source_drv.pkt_valid <= 1'b0;

//assign parity to the data_in
vif.source_drv.data_in <= req.parity;

`uvm_info("SOURCE DRIVER","You are printing the transactions of source driver",UVM_LOW)
xtn.print();
endtask
  
