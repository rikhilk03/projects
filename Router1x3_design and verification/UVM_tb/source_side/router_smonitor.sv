//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Source Agent ************************************************----------
	
//Extend router_moniotr from uvm_moniotr
class router_monitor extends uvm_monitor;

//Factory registration
`uvm_component_utils(router_monitor)

//Declare handle for virtual router interface 
virtual router_if.SOURCE_MON vif;

//Declare handle for source configuration 
source_config s_cfg;

//Declare handle for uvm_analysis port
uvm_analysis_port #(souc_xtn) mon_sport;

//------------------------------------------------------------------------------------------------------------------------------------
//METHODS
//------------------------------------------------------------------------------------------------------------------------------------
//Standard methods
extern function new(string name = "router_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass

//-----------------------------------------Define new()----------------------------------------------------------------------//
function router_monitor::new(string name = "router_monitor",uvm_component parent);
super.new(name,parent);
endfunction:new

//------------------------------------------build() phase--------------------------------------------------------------------//
function void router_monitor::build_phase(uvm_phase phase);
//Call super.build_phase
super.build_phase(phase);
//get the config object from uvm_config_db
if(!uvm_config_db #(source_config)::get(this,"","source_config",s_cfg))
	`uvm_fatal("SOURCE MONITOR","You are not getting the config object whether you set it ()??")
mon_sport = new("mon_sport",this);
endfunction:build_phase

//-------------------------------------------connect() phase------------------------------------------------------------------//
function void router_monitor::connect_phase(uvm_phase phase);
//Call super.connect_phase
super.connect_phase(phase);
//connect the virtual interface of source configuration to this interface
vif = s_cfg.vif;
endfunction:connect_phase

//---------------------------------------------- run() phase ------------------------------------------------------------------------//
task router_monitor::run_phase(uvm_phase phase);
//In forever loop call the collect_data
	forever
		collect_data();
endtask:run_phase

//---------------------------------------------- collect_data() ----------------------------------------------------------------------//
task router_monitor::collect_data();
//Create handle for source transaction and create instance for that transaction

souc_xtn xtn;
xtn = souc_xtn::type_id::create("xtn");

//Check for pkt_valid and busy using while loop
//Here pkt_valid should be high and busy should be low,then only it will sample the data,that too in the next cycle
while(vif.source_mon.pkt_valid !== 1)
	@(vif.source_mon);

while(vif.source_mon.busy !== 0)
	@(vif.source_mon);
//assign data_in to transaction header
xtn.header = vif.source_mon.data_in;

//assign data_in to payload using foreach loop or for loop
//Before assigning give size to dynamic array because it is dynamic array
xtn.payload = new[xtn.header[7:2]];
	@(vif.source_mon);

foreach(xtn.payload[i]) 
	begin

//Check for busy signal using while and assign it
	while(vif.source_mon.busy !== 0)
	@(vif.source_mon);

	xtn.payload[i] = vif.source_mon.data_in; 
	@(vif.source_mon);
	end
$display("===================================================================================");

//Check for pkt_valid for sampling the parity
while(vif.source_mon.pkt_valid !== 0)
	@(vif.source_mon);
xtn.parity = vif.source_mon.data_in;
//Give two cycles delay to sample the error as per protocol
@(vif.source_mon);
@(vif.source_mon);
xtn.err = vif.source_mon.err;

//Display the all source transactions
`uvm_info("SOURCE MONITOR","Displaying the trNsactions of source",UVM_LOW)
xtn.print();

//Call the write() method using analysis port handle
mon_sport.write(xtn);
endtask
