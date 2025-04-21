//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Destination Monitor ************************************************----------
	
//Extend router_moniotr from uvm_moniotr
class router_dmonitor extends uvm_monitor;

//Factory registration
`uvm_component_utils(router_dmonitor)

//Declare handle for virtual router interface 
virtual router_if.DESTINATION_MON vif;

//Declare handle for source configuration 
destination_config d_cfg;

//Declare handle for uvm_analysis port
uvm_analysis_port #(dest_xtn) mon_dport;

//------------------------------------------------------------------------------------------------------------------------------------
//METHODS
//------------------------------------------------------------------------------------------------------------------------------------
//Standard methods
extern function new(string name = "router_dmonitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass

//-----------------------------------------Define new()----------------------------------------------------------------------//
function router_dmonitor::new(string name = "router_dmonitor",uvm_component parent);
super.new(name,parent);
mon_dport = new("mon_dport",this);
endfunction:new

//------------------------------------------build() phase--------------------------------------------------------------------//
function void router_dmonitor::build_phase(uvm_phase phase);
//Call super.build_phase
super.build_phase(phase);
//get the config object from uvm_config_db
if(!uvm_config_db #(destination_config)::get(this,"","destination_config",d_cfg))
	`uvm_fatal("DESTINATION MONITOR","You are not getting the config object whether you set it ()??")
endfunction:build_phase

//-------------------------------------------connect() phase------------------------------------------------------------------//
function void router_dmonitor::connect_phase(uvm_phase phase);
//Call super.connect_phase
super.connect_phase(phase);
//connect the virtual interface of source configuration to this interface
vif = d_cfg.vif;
endfunction:connect_phase

//--------------------------------------------- run() phase ---------------------------------------------------------------------//
task router_dmonitor::run_phase(uvm_phase phase);

//inside forever loop call the collect_data()
forever
	begin
		collect_data();
	end
endtask:run_phase


//------------------------------------------ collect_data() -----------------------------------------------------------//
task router_dmonitor::collect_data();

//Create handle for destination transcation

 dest_xtn xtn;

//Create instance for destination transcation
xtn = dest_xtn::type_id::create("xtn");

//Check for read enable and if it is one in the next clock cycle we have to sample the header
while(vif.destination_mon.read_enb !== 1)
	@(vif.destination_mon);
@(vif.destination_mon);
xtn.header = vif.destination_mon.data_out;

//Assign size to payload before sampling the payload because payload is a dynamic array
xtn.payload = new[xtn.header[7:2]];
@(vif.destination_mon);

//Sample the payload within the foreach loop
foreach(xtn.payload[i]) begin
xtn.payload[i] = vif.destination_mon.data_out;
@(vif.destination_mon);end

//Parity should be sampled after the one cycle of sampling of payload
xtn.parity = vif.destination_mon.data_out;
while(vif.destination_mon.read_enb !== 0)
	@(vif.destination_mon);

`uvm_info("DESTINATION MONITOR","You are displying the transactions of destination monitor",UVM_LOW)

xtn.print();

 mon_dport.write(xtn);
endtask
