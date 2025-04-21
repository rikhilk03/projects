//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Router environment ******************************************----------

	//Extend router_env class from uvm_env
class router_env extends uvm_env;

	//register this class using uvm_component
	`uvm_component_utils(router_env)
	
	//Declare dynamic handles for router source agent top and router destination agent top
	source_agt_top s_agt_top[];
	destination_agt_top d_agt_top[];

	//Declare handle for scoreboard
	router_scoreboard r_sb;
	//Declare handle for router environment configuration
	router_env_config r_cfg;
	
	//----------------------------------------------------
	//Methods
	//----------------------------------------------------

	//Standard methods
	
	extern function new(string name = "router_env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass:router_env

// Define new() constructor method

	function router_env::new(string name ="router_env",uvm_component parent);
		super.new(name,parent);
	endfunction:new	

//-----------------------build_phase-------------------------------------------------

	function void router_env::build_phase(uvm_phase phase);
		
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
  

   //create instances for d_agt_top
   d_agt_top[i] = destination_agt_top::type_id::create($sformatf("d_agt_top[%0d]",i),this); end
	r_sb = router_scoreboard::type_id::create("r_sb",this);

	endfunction:build_phase

//-----------------------connect_phase-------------------------------------------------------

function void router_env::connect_phase(uvm_phase phase);
foreach(s_agt_top[i])
	s_agt_top[i].s_agt.monh.mon_sport.connect(r_sb.router_souch.analysis_export);

foreach(d_agt_top[i])
	d_agt_top[i].d_agt.monh.mon_dport.connect(r_sb.router_desth[i].analysis_export);


endfunction
