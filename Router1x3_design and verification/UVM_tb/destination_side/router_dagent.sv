//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------************************************* Destination Agent ************************************************----------
	
	//Extend router_source_agent from uvm_component
	class router_destination_agent extends uvm_component;

	//Register this class with factory 
	`uvm_component_utils(router_destination_agent)
 
	//Declare handle for source agent configuration
   destination_config d_cfg;
	//Declare handles for monitor,sequencer and driver
	router_dmonitor monh;
	router_dsequencer seqrh;
	router_ddriver drvh;

	//----------------------------------------------------------------------------------------------------------------
	//METHODS
	//----------------------------------------------------------------------------------------------------------------

	// Standard methods
	extern function new(string name ="router_destination_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
 function void connect_phase(uvm_phase phase);
   drvh.seq_item_port.connect(seqrh.seq_item_export);
 endfunction
	endclass

	//-----------------------------Define constructor new()-------------------------------------------------//
	function router_destination_agent::new(string name = "router_destination_agent",uvm_component parent);
		super.new(name,parent);
	endfunction:new
 
 //-------------------------------build() phase-------------------------------------------------------------//
 function void router_destination_agent::build_phase(uvm_phase phase);
 
     //Call the super.build_phase
     super.build_phase(phase);
     
     //Get the config object uvm_config_db
     if(!uvm_config_db #(destination_config)::get(this,"","destination_config",d_cfg))
       `uvm_fatal("ROUTER DESTINATION AGENT","You are not getting object from config,whether you set it()??")
           
           //Create istance for monitor
           monh = router_dmonitor::type_id::create("monh",this);
           
           
           //If is_active == UVM_ACTIVE create instance for driver and sequencer
           if(d_cfg.is_active == UVM_ACTIVE)
               begin
                 
                 drvh = router_ddriver::type_id::create("drvh",this);
                 seqrh = router_dsequencer::type_id::create("seqrh",this);
                 end
  endfunction:build_phase       
       
       
       

