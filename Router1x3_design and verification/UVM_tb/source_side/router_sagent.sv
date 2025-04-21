//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Source Agent ************************************************----------
	
	//Extend router_source_agent from uvm_component
	class router_source_agent extends uvm_component;

	//Register this class with factory 
	`uvm_component_utils(router_source_agent)
 
	//Declare handle for source agent configuration
   source_config s_cfg;
   
	//Declare handles for monitor,sequencer and driver
	router_monitor monh;
	router_sequencer seqrh;
	router_driver drvh;

	//----------------------------------------------------------------------------------------------------------------
	//METHODS
	//----------------------------------------------------------------------------------------------------------------

	// Standard methods
	extern function new(string name ="router_source_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
 function void connect_phase(uvm_phase phase);
   drvh.seq_item_port.connect(seqrh.seq_item_export);
 endfunction
	endclass

	//-----------------------------Define constructor new()-------------------------------------------------//
	function router_source_agent::new(string name = "router_source_agent",uvm_component parent);
		super.new(name,parent);
	endfunction:new
 
 //-------------------------------build() phase-------------------------------------------------------------//
 function void router_source_agent::build_phase(uvm_phase phase);
 
     //Call the super.build_phase
     super.build_phase(phase);
     
     //Get the config object uvm_config_db
     if(!uvm_config_db #(source_config)::get(this,"","source_config",s_cfg))
       `uvm_fatal("ROUTER SOURCE AGENT","You are not getting object from config,whether you set it()??")
           
           //Create istance for monitor
           monh = router_monitor::type_id::create("monh",this);
           
           //If is_active == UVM_ACTIVE create instance for driver and sequencer
           if(s_cfg.is_active == UVM_ACTIVE)
               begin
                 
                 drvh = router_driver::type_id::create("drvh",this);
                 seqrh = router_sequencer::type_id::create("seqrh",this);
                 end
  endfunction:build_phase       
       
       
       
/*function void router_env::build_phase(uvm_phase phase);
		
	//get the config object using uvm_config_db
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",r_cfg))
		`uvm_fatal("ROUTER ENV","You did not get the configuration object whether u set it ??")
   
   //assign size to source agt top dynamic handles
   s_agt_top = new[r_cfg.no_of_sagents];
   
   //inside foreach loop set source config to uvm_config_db
   foreach(s_agt_top[i]) begin
       uvm_config_db #(source_config)::set(this,$sformatf("s_agt_top[%0d]*",i),"source_config",r_cfg.s_cfg[i]);
   
   //create instances for s_agt_top
   s_agt_top[i] = source_agt_top::type_id::create($sformatf("s_agt_top[%0d]",i),this); end
   
   //assign size to destination agt top dynamic handles
   d_agt_top = new[r_cfg.no_of_dagents];
   
   //inside foreach loop set source config to uvm_config_db
   foreach(d_agt_top[i]) begin
       uvm_config_db #(destination_config)::set(this,$sformatf("d_agt_top[%0d]*",i),"destination_config",r_cfg.d_cfg[i]);
  

   //create instances for s_agt_top
   d_agt_top[i] = destination_agt_top::type_id::create($sformatf("d_agt_top[%0d]",i),this); end */
	

	//sendfunction:build_phase
