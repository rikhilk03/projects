//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Router Base test *************************************************---------
//----------------------------------------------------------
//CLASS DESCRIPTION
//----------------------------------------------------------

      class router_base_test extends uvm_test;
        
        // Factory registration using uvm component
        `uvm_component_utils(router_base_test)
        
        // Declare handles for environment configuration and environment class
        router_env_config r_tb_cfg;
        router_env router_envh;
        
        // Declare handles for source configuration and destination configuration classes
        source_config s_cfg[];
        destination_config d_cfg[];
        
        // Declare local variables for no.of sagents and dagents of type int
        int no_of_sagents = 1;
        int no_of_dagents = 3;

//--------------------------------------------------
//METHODS
//--------------------------------------------------
//Standard methods    
        
        
        extern function new(string name = "router_base_test",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        
      endclass:router_base_test
 
 //-------------------Constructor new()----------------------------------------------------     
      // Define function new() constructor method
      function router_base_test::new(string name = "router_base_test",uvm_component parent);
          super.new(name,parent);
      endfunction:new
      
 //-------------------build() phase method ---------------------------------------------------
       function void router_base_test::build_phase(uvm_phase phase);
            begin///////////////////////////////////////////////////////
           // Creating object for environment configuration 
           r_tb_cfg = router_env_config::type_id::create("r_tb_cfg"); 
           
           // Assigning no of sagents to source configuration
           s_cfg = new[no_of_sagents];
           r_tb_cfg.s_cfg = new[no_of_sagents];/////////////////////////////////////////////////////////////////////////////// ERROR WAS HERE ( U FORGOT THIS)<---
           foreach(s_cfg[i]) begin///////////////////////////////////////////////////////////////////////////////
               //creating object for every source configuration class
               s_cfg[i] = source_config::type_id::create($sformatf("s_cfg[%0d]",i));
              // $display("yes rou are getting",s_cfg[0]);
              
               //getting from configuration from virtual router interface to source configuration and writing fatal for that
               if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("s_if%0d",i),s_cfg[i].vif))
                   `uvm_fatal("ROUTER BASE TEST","You are not getting source configuration in ram base test class,whether u set?")
                   
                         // Assigning UVM_ACTIVE to is_active which is in source configuration
                         s_cfg[i].is_active = UVM_ACTIVE;
                         
                         // Assigning local source configuration handle to environment configuration handle
                         r_tb_cfg.s_cfg[i] = s_cfg[i]; end///////////////////////////////////////////////////////////
                         
                         // Assigning local variables to configuration handles
                         r_tb_cfg.no_of_sagents = no_of_sagents; 
                         
                         // Assigning no of dagents to destination configuration
           d_cfg = new[no_of_dagents];
           r_tb_cfg.d_cfg=new[no_of_dagents];/////////////////////////////////////////////////////////////////////////////// ERROR WAS HERE ( U FORGOT THIS)<---
           foreach(d_cfg[i]) begin///////////////////////////////////////////////////////////////////
               //creating object for every source configuration class
               d_cfg[i] = destination_config::type_id::create($sformatf("d_cfg[%0d]",i));
               
               //getting from configuration from virtual router interface to source configuration and writing fatal for that
               if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("d_if%0d",i),d_cfg[i].vif))
                   `uvm_fatal("ROUTER BASE TEST","You are not getting  destination configuration in ram base test class,whether u set?")
                   
                         // Assigning UVM_ACTIVE to is_active which is in source configuration
                         d_cfg[i].is_active = UVM_ACTIVE;
                         
                         // Assigning local source configuration handle to environment configuration handle
                         r_tb_cfg.d_cfg[i] = d_cfg[i]; end////////////////////////////////////////////////////////////
                         
                         // Assigning local variables to configuration handles
                         r_tb_cfg.no_of_dagents = no_of_dagents;
                         
                         //Setting configuration object into uvm config 
                         uvm_config_db #(router_env_config)::set(this,"*","router_env_config",r_tb_cfg);
                         
                         // Call super.build_phase
                         super.build_phase(phase);


                         // Create instance for router environment 
                         router_envh =  router_env::type_id::create("router_envh",this); end///////////////////////
                         
           endfunction:build_phase
           
           
//-----------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------

//Extend small_packet_test from router_base_test
class small_packet_test extends router_base_test;

//Factory registration using uvm_component_utils
`uvm_component_utils(small_packet_test)

//Create handle for small_packet_seqs as spacket_seqs
small_packet_seqs spacket_seqs;

//Declare a addr variable of type bit[1:0]
bit [1:0]addr;

//-------------------------------------------------
//METHODS
//-------------------------------------------------
//Standard methods

extern function new(string name = "small_packet_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass:small_packet_test

//---------------------------------- new() method -----------------------------//
function small_packet_test::new(string name = "small_packet_test",uvm_component parent);
super.new(name,parent);
endfunction:new

//---------------------------------- build() phase ------------------------------//
function void small_packet_test::build_phase(uvm_phase phase);
//Call super.build
super.build_phase(phase);
endfunction:build_phase

//----------------------------------- run() phase---------------------------------//
task small_packet_test::run_phase(uvm_phase phase);

//create handles for short and normal sequences for destination side
short_seqs short_seqh;
normal_seqs normal_seqh;

//Create memories for above sequences and small packet
spacket_seqs = small_packet_seqs::type_id::create("spacket_seqs");
short_seqh = short_seqs::type_id::create("short_seqh");
normal_seqh = normal_seqs::type_id::create("normal_seqh");

//Generate random address using $urandom_range
addr = $urandom_range(0,2);
//set address to uvm_config_db
uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

//raise objection
phase.raise_objection(this);
fork
//start the sequencer
spacket_seqs.start(router_envh.s_agt_top[0].s_agt.seqrh);
short_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
//normal_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
join
#100;
//phase.drop_objection(this);
phase.drop_objection(this);
endtask:run_phase



           
      
//-----------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------

//Extend medium_packet_test from router_base_test
class medium_packet_test extends router_base_test;

//Factory registration using uvm_component_utils
`uvm_component_utils(medium_packet_test)

//Create handle for medium_packet_seqs as mpacket_seqs
medium_packet_seqs mpacket_seqs;

//Declare a addr variable of type bit[1:0]
bit [1:0]addr;

//-------------------------------------------------
//METHODS
//-------------------------------------------------
//Standard methods

extern function new(string name = "medium_packet_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass:medium_packet_test

//---------------------------------- new() method -----------------------------//
function medium_packet_test::new(string name = "medium_packet_test",uvm_component parent);
super.new(name,parent);
endfunction:new

//---------------------------------- build() phase ------------------------------//
function void medium_packet_test::build_phase(uvm_phase phase);
//Call super.build
super.build_phase(phase);
endfunction:build_phase

//----------------------------------- run() phase---------------------------------//
task medium_packet_test::run_phase(uvm_phase phase);

//create handles for short and normal sequences for destination side
short_seqs short_seqh;
normal_seqs normal_seqh;

//Create memory for sequence
mpacket_seqs = medium_packet_seqs::type_id::create("mpacket_seqs");
//short_seqh = short_seqs::type_id::create("short_seqh");
normal_seqh = normal_seqs::type_id::create("normal_seqh");


//Generate random address using $urandom_range
addr = $urandom_range(0,2);
//set address to uvm_config_db
uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

//raise objection
phase.raise_objection(this);

//start the sequencer
fork
mpacket_seqs.start(router_envh.s_agt_top[0].s_agt.seqrh);
//short_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
normal_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
join
#100;

//phase.drop_objection(this);
phase.drop_objection(this);
endtask:run_phase



//-----------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------

//Extend large_packet_test from router_base_test
class large_packet_test extends router_base_test;

//Factory registration using uvm_component_utils
`uvm_component_utils(large_packet_test)

//Create handle for medium_packet_seqs as mpacket_seqs
large_packet_seqs lpacket_seqs;

//Declare a addr variable of type bit[1:0]
bit [1:0]addr;

//-------------------------------------------------
//METHODS
//-------------------------------------------------
//Standard methods

extern function new(string name = "large_packet_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass:large_packet_test

//---------------------------------- new() method -----------------------------//
function large_packet_test::new(string name = "large_packet_test",uvm_component parent);
super.new(name,parent);
endfunction:new

//---------------------------------- build() phase ------------------------------//
function void large_packet_test::build_phase(uvm_phase phase);
//Call super.build
super.build_phase(phase);
endfunction:build_phase

//----------------------------------- run() phase---------------------------------//
task large_packet_test::run_phase(uvm_phase phase);

//create handles for short and normal sequences for destination side
short_seqs short_seqh;
normal_seqs normal_seqh;

//Create memory for sequence
lpacket_seqs = large_packet_seqs::type_id::create("lpacket_seqs");
short_seqh = short_seqs::type_id::create("short_seqh");
//normal_seqh = normal_seqs::type_id::create("normal_seqh");


//Generate random address using $urandom_range
addr = $urandom_range(0,2);
//set address to uvm_config_db
uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);

//raise objection
phase.raise_objection(this);
fork 
//start the sequencer
lpacket_seqs.start(router_envh.s_agt_top[0].s_agt.seqrh);
short_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
//normal_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
#1000;
join
//phase.drop_objection(this);
phase.drop_objection(this);
endtask:run_phase
 



//-----------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------

//Extend correct_packet_test from router_base_test
class correct_packet_test extends router_base_test;

//Factory registration using uvm_component_utils
`uvm_component_utils(correct_packet_test)

//Create handle for correct_packet_seqs as cpacket_seqs
correct_packet_seqs cpacket_seqs;

//Declare a addr variable of type bit[1:0]
bit [1:0]addr;

//-------------------------------------------------
//METHODS
//-------------------------------------------------
//Standard methods

extern function new(string name = "correct_packet_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass:correct_packet_test

//---------------------------------- new() method -----------------------------//
function correct_packet_test::new(string name = "correct_packet_test",uvm_component parent);
super.new(name,parent);
endfunction:new

//---------------------------------- build() phase ------------------------------//
function void correct_packet_test::build_phase(uvm_phase phase);
//Call super.build
super.build_phase(phase);
endfunction:build_phase

//----------------------------------- run() phase---------------------------------//
task correct_packet_test::run_phase(uvm_phase phase);

//create handles for short and normal sequences for destination side
short_seqs short_seqh;
normal_seqs normal_seqh;

//Create memory for sequence
cpacket_seqs = correct_packet_seqs::type_id::create("cpacket_seqs");
//short_seqh = short_seqs::type_id::create("short_seqh");
normal_seqh = normal_seqs::type_id::create("normal_seqh");
//$display("======================11111111111==00000000000000000000000======================================================");

//Generate random address using $urandom_range
addr = $urandom_range(0,2);
//set address to uvm_config_db
uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
//$display("======================11111111111========================================================");

//raise objection
phase.raise_objection(this);

//start the sequencer
//$display("==============================================================================");
cpacket_seqs.start(router_envh.s_agt_top[0].s_agt.seqrh);
short_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
//normal_seqh.start(router_envh.d_agt_top[addr].d_agt.seqrh);
#100;

//phase.drop_objection(this);
phase.drop_objection(this);
endtask:run_phase
       
