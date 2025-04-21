//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Source Sequences *************************************************---------

//------------------------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//------------------------------------------------------------------------------------------------------------------------

//Extend souc_base_seq from uvm_sequence parameterized by souc_xtn
class souc_base_seqs extends uvm_sequence #(souc_xtn);

// Factory registration using `uvm_object_utils
`uvm_object_utils(souc_base_seqs)

//---------------------------------------------------------------------------------------------------------------------------
//METHODS
//--------------------------------------------------------------------------------------------------------------------------
//Standard methods

extern function new(string name = "souc_base_seqs");

endclass:souc_base_seqs

//-------------------------------new() method-------------------------------------------------------------------------------//
function souc_base_seqs::new(string name = "souc_base_seqs");
super.new(name);
endfunction:new

//----------------------------------------------------------------------------------------------------------------------------
//
//SMALL PACKET
//
//-----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------------------------------------------------------------------------------------

//Extend small packet from souc_base_seq
class small_packet_seqs extends souc_base_seqs;

//Declare addr[1:0] of type bit
bit [1:0] addr;

//Factory registration using uvm_object_utils
`uvm_object_utils(small_packet_seqs)

//---------------------------------------------------------------
//METHODS
//---------------------------------------------------------------

//Standard methods
extern function new(string name = "small_packet_seqs");
extern task body();

endclass:small_packet_seqs

//--------------------------------new() method-------------------------//
function small_packet_seqs::new(string name = "small_packet_seqs");
super.new(name);
endfunction:new

//---------------------------------body()---------------------------------//
task small_packet_seqs::body();
//Within repeat loop create instance for req
repeat(10)
begin
req = souc_xtn::type_id::create("req");

//get the address from uvm_config_db
if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
	`uvm_fatal("SMALL PACKET","You are not getting the address whether you set() it??")
 
 //Start the item 
 start_item(req);
 
 //assert the randomization with header less than 14 and assign header[1:0] to address
 assert(req.randomize() with {header[7:2]<14;
                       header[1:0]==addr;})
                       
//Finish the item 
 finish_item(req);
 end
 endtask:body
 
 
 //----------------------------------------------------------------------------------------------------------------------------
//
//MEDIUM PACKET
//
//-----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------------------------------------------------------------------------------------

//Extend medium packet from souc_base_seq
class medium_packet_seqs extends souc_base_seqs;

//Declare addr[1:0] of type bit
bit [1:0] addr;

//Factory registration using uvm_object_utils
`uvm_object_utils(medium_packet_seqs)

//---------------------------------------------------------------
//METHODS
//---------------------------------------------------------------

//Standard methods
extern function new(string name = "medium_packet_seqs");
extern task body();

endclass:medium_packet_seqs

//--------------------------------new() method-------------------------//
function medium_packet_seqs::new(string name = "medium_packet_seqs");
super.new(name);
endfunction:new

//---------------------------------body()---------------------------------//
task medium_packet_seqs::body();
//Within repeat loop create instance for req
repeat(1)
begin
req = souc_xtn::type_id::create("req");

//get the address from uvm_config_db
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"addr",addr))
	`uvm_fatal("MEDIUM PACKET","You are not getting the address whether you set() it??")
 
 //Start the item 
 start_item(req);
 
 //assert the randomization with header equal to 14 and assign header[1:0] to address
 assert(req.randomize() with {header[7:2]==40;
                       header[1:0]==addr;})
                       
//Finish the item 
 finish_item(req);
 end
 endtask:body
 

//----------------------------------------------------------------------------------------------------------------------------
//
//LARGE PACKET
//
//-----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------------------------------------------------------------------------------------

//Extend large packet from souc_base_seq
class large_packet_seqs extends souc_base_seqs;

//Declare addr[1:0] of type bit
bit [1:0] addr;

//Factory registration using uvm_object_utils
`uvm_object_utils(large_packet_seqs)

//---------------------------------------------------------------
//METHODS
//---------------------------------------------------------------

//Standard methods
extern function new(string name = "large_packet_seqs");
extern task body();

endclass:large_packet_seqs

//--------------------------------new() method-------------------------//
function large_packet_seqs::new(string name = "large_packet_seqs");
super.new(name);
endfunction:new

//---------------------------------body()---------------------------------//
task large_packet_seqs::body();
//Within repeat loop create instance for req
repeat(1)
begin
req = souc_xtn::type_id::create("req");

//get the address from uvm_config_db
if(!uvm_config_db #(bit[1:0] )::get(null,get_full_name,"addr",addr))
	`uvm_fatal("LARGE PACKET","You are not getting the address whether you set() it??")
 
 //Start the item 
 start_item(req);
 
 //assert the randomization with header greater than 14 and assign header[1:0] to address
 assert(req.randomize() with {header[7:2] inside {[41:63]};
                       header[1:0]==addr;})
                       
//Finish the item 
 finish_item(req);
 end
 endtask:body
 
 
 
 //----------------------------------------------------------------------------------------------------------------------------
//
//CORRECT PACKET
//
//-----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//-----------------------------------------------------------------------------------------------------------------------------

//Extend correct packet from souc_base_seq
class correct_packet_seqs extends souc_base_seqs;

//Declare addr[1:0] of type bit
bit [1:0] addr;

//Factory registration using uvm_object_utils
`uvm_object_utils(correct_packet_seqs)

//---------------------------------------------------------------
//METHODS
//---------------------------------------------------------------

//Standard methods
extern function new(string name = "correct_packet_seqs");
extern task body();

endclass:correct_packet_seqs

//-------------------------------- new() method -------------------------//
function correct_packet_seqs::new(string name = "correct_packet_seqs");
super.new(name);
endfunction:new

//--------------------------------- body() method ---------------------------------//
task correct_packet_seqs::body();
//Within repeat loop create instance for req
repeat(1)
begin
req = souc_xtn::type_id::create("req");

//get the address from uvm_config_db
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name,"addr",addr))
	`uvm_fatal("CORRECT PACKET","You are not getting the address whether you set() it??")
 
 //Start the item 
 start_item(req);
 
 //assert the randomization with header greater than 14 and assign header[1:0] to address
 assert(req.randomize() with {header[7:2]>63;
                       header[1:0]==addr;})
                       
//Finish the item 
 finish_item(req);
 end
 endtask:body
