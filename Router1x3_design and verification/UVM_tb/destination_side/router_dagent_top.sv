//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Router Destination Agent Top *************************************---------
//------------- CLASS DESCRIPTION--------------------------

// Extend Source Agent Top class from UVM Environment Class
      class destination_agt_top extends uvm_env;
      
      //Factory registration using component
      `uvm_component_utils(destination_agt_top)
      
      //Declare handle for Source agent
      router_destination_agent d_agt;
      
      //----------------------------------------------------
      //Methods
      //-----------------------------------------------------
      
// Standard UVM Methds
      extern function new(string name = "destination_agt_top",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void end_of_elaboration_phase(uvm_phase phase);
      
      endclass
      
//--------------------------------------function new() constructor------------------------------------//
      function destination_agt_top::new(string name ="destination_agt_top",uvm_component parent);
          super.new(name,parent);
      endfunction:new
      
//-------------------------------------------build() phase---------------------------------------------//
      function void destination_agt_top::build_phase(uvm_phase phase);
          //call super.build 
          super.build_phase(phase);
          
          //create instance for source agent 
          d_agt = router_destination_agent::type_id::create("d_agt",this);
          
      endfunction:build_phase
      
//------------------------------------------end_of_elaboration() phase-------------------------------------//
      function void destination_agt_top::end_of_elaboration_phase(uvm_phase phase);
          //call super.end_of_elaboration
          super.end_of_elaboration_phase(phase);
          
          //Print the topology
          uvm_top.print_topology;
      endfunction:end_of_elaboration_phase
