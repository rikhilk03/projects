//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Router Source Agent Top ******************************************---------
//------------------------------------------ CLASS DESCRIPTION-------------------------------------------------------------

// Extend Source Agent Top class from UVM Environment Class
      class source_agt_top extends uvm_env;
      
      //Factory registration using component
      `uvm_component_utils(source_agt_top)
      
      //Declare handle for Source agent
      router_source_agent s_agt;
      
      //----------------------------------------------------
      //Methods
      //-----------------------------------------------------
      
      // Standard UVM Methds
      extern function new(string name = "source_agt_top",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
    //  extern function void end_of_elaboration_phase(uvm_phase phase);
      
      endclass:source_agt_top
      
//-------------------function new() constructor------------------------------------------//
      function source_agt_top::new(string name ="source_agt_top",uvm_component parent);
          super.new(name,parent);
      endfunction:new
      
//-------------------------------build() phase------------------------------------------------//
      function void source_agt_top::build_phase(uvm_phase phase);
          //call super.build 
          super.build_phase(phase);
          
          //create instance for source agent 
          s_agt = router_source_agent::type_id::create("s_agt",this);
          
      endfunction:build_phase
      
//-------------------------------end_of_elaboration() phase---------------------------------------------//
  /*    function void source_agt_top::end_of_elaboration_phase(uvm_phase phase);
          //call super.end_of_elaboration
          super.end_of_elaboration_phase(phase);
          
          //Print the topology
          uvm_top.print_topology;
      endfunction:end_of_elaboration_phase*/
