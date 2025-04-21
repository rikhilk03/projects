//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Router Scoreboard ************************************************----------
//-----------------------------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------------------------
//Extend router_scoreboard from uvm_scoreboard
class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)

//Declare handles for tlm_analysis_fifo for both source and destination transaction
uvm_tlm_analysis_fifo #(souc_xtn) router_souch;
uvm_tlm_analysis_fifo #(dest_xtn) router_desth[];

//Create handles for source transaction and destination transaction
souc_xtn sxtnh;
dest_xtn dxtnh;

//Create handle for environment configuration
router_env_config env_cfg;

//---------------------------------------------------------------
//COVER GROUPS
//---------------------------------------------------------------

covergroup souc_coverage;

      ADDR: coverpoint sxtnh.header[1:0]{
                            bins addr1 = {2'b00};
                            bins addr2 = {2'b01};
                            bins addr3 = {2'b10};}
                            
      PAYLOAD: coverpoint sxtnh.header[7:2]{
                            bins small_packet = {[1:15]};
                            bins medium_packet = {[15:40]};
                            bins large_packet = {[41:63]};}
                            
      ERROR: coverpoint sxtnh.err {
                           // bins no_error = {0};
                            bins error = {1,0};}
                            
                            
      PAYLOADxERROR: cross PAYLOAD,ERROR;
      
endgroup:souc_coverage

covergroup dest_coverage;

	ADDR: coverpoint dxtnh.header[1:0]{
                            bins addr1 = {2'b00};
                            bins addr2 = {2'b01};
                            bins addr3 = {2'b10};}
                            
      PAYLOAD: coverpoint dxtnh.header[7:2]{
                            bins small_packet = {[1:15]};
                            bins medium_packet = {[15:40]};
                            bins large_packet = {[41:63]};}
endgroup:dest_coverage


//Factory registration using uvm_component

//-------------------------------------------------------
//UVM METHODS
//-------------------------------------------------------
//Standard methods

extern function new(string name = "router_scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task compare_data(souc_xtn sxtnh,dest_xtn dxtn);
extern function void report_phase(uvm_phase phase);

endclass:router_scoreboard

//--------------------------------------------------- new() method ------------------------------------//
function router_scoreboard::new(string name = "router_scoreboard",uvm_component parent);
super.new(name,parent);
//Create instance for covergrop
souc_coverage = new();
dest_coverage = new();

endfunction


//------------------------------------------------ build() phase ---------------------------------------//
function void router_scoreboard::build_phase(uvm_phase phase);
//Call super.build_phase
super.build_phase(phase);
$display("scoreboardddddddddddddddd");
//create instance for tlm analysis fifo handles
router_souch = new("router_souch",this);

//Get the environment configuration from uvm_config_db
if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
	`uvm_fatal("ROUTER ENV","You did not get the configuration object whether u set it ??")

//Give  size to dynamic array
router_desth = new[env_cfg.no_of_dagents];

//Create instances for those dynamic destination fifo handles
foreach(router_desth[i])
	router_desth[i] = new($sformatf("router_desth[%0d]",i),this);
//Create instance for covergrop
//souc_coverage = new();
//dest_coverage = new();
endfunction

//------------------------------------------------- run() phase -----------------------------------------//
task router_scoreboard::run_phase(uvm_phase phase);
forever
    begin
        fork
            begin
              router_souch.get(sxtnh);
              sxtnh.print();
              souc_coverage.sample();
            end
      
        begin
        fork
            begin
		$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

                router_desth[0].get(dxtnh);
	//	compare_data(dxtnh);
		                dxtnh.print();
                dest_coverage.sample();
		
            end
            
            begin
                router_desth[1].get(dxtnh);
		//compare_data(dxtnh);

                dxtnh.print();
                dest_coverage.sample();
            end
            
            begin
                router_desth[2].get(dxtnh);
	//	compare_data(dxtnh);
                dxtnh.print();
               dest_coverage.sample();
            end
        join_any
        disable fork;
	end

join


compare_data(sxtnh,dxtnh);

    end


    
endtask

//---------------------------------------------------- compare() method ----------------------------//
task router_scoreboard::compare_data(souc_xtn sxtnh,dest_xtn dxtn);
$display("fffffffffffffffffffffffffffff");
if(sxtnh.header == dxtn.header)
  $display("SUCCESSFULLY YOU GOT THE HEADER");
else
  $display("YOU ARE NOT GETTING THE HEADER SUCCESSFULLY");
  
if(sxtnh.payload == dxtn.payload)
  $display("SUCCESSFULLY YOU GOT THE PAYLOAD");
else
  $display("YOU ARE NOT GETTING THE PAYLOAD SUCCESSFULLY");
  
if(sxtnh.parity == dxtn.parity)
  $display("SUCCESSFULLY YOU GOT THE PARITY");
else
  $display("YOU ARE NOT GETTING THE PARITY SUCCESSFULLY");
  
endtask:compare_data

//-------------------------------------------------- report() phase -------------------------------------------//
function void router_scoreboard::report_phase(uvm_phase phase);
`uvm_info("ROUTER SCOREBOARD","Report file is generating",UVM_LOW)
endfunction:report_phase

