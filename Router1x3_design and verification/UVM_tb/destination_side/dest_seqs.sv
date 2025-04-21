//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Destination Sequences *************************************************---------

//------------------------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//------------------------------------------------------------------------------------------------------------------------

//Extend dest_base_seq from uvm_sequence parameterized by dest_xtn
class dest_base_seqs extends uvm_sequence#(dest_xtn);

// Factory registration using `uvm_object_utils
`uvm_object_utils(dest_base_seqs)

//---------------------------------------------------------------------------------------------------------------------------
//METHODS
//--------------------------------------------------------------------------------------------------------------------------
//Standard methods

extern function new(string name ="dest_base_seqs");

endclass:dest_base_seqs

//-------------------------------new() method-------------------------------------------------------------------------------//
function dest_base_seqs::new(string name = "dest_base_seqs");
super.new(name);
endfunction:new

//-------------------------------------------------------------------------------------------------------------------------
//
//SHORT SEQUENCE
//
//-------------------------------------------------------------------------------------------------------------------------
//Extend short_seqs from dest_base_seqs
class short_seqs extends dest_base_seqs;

//Factory registration
`uvm_object_utils(short_seqs)

//----------------------------------------------------------------------------
//UVM METHODS
//----------------------------------------------------------------------------
//standard methods
extern function new(string name = "short_seqs");
extern task body();

endclass:short_seqs

//--------------------------------------new() ----------------------------------------//
function short_seqs::new(string name ="short_seqs");
super.new(name);
endfunction:new

//--------------------------------------- body() -------------------------------------//
task short_seqs::body();
repeat(1) begin
req = dest_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {no_of_cycles < 29;})
finish_item(req); end
endtask:body


//-------------------------------------------------------------------------------------------------------------------------
//
//NORMAL SEQUENCE
//
//-------------------------------------------------------------------------------------------------------------------------
//Extend normal_seqs from dest_base_seqs
class normal_seqs extends dest_base_seqs;

//Factory registration
`uvm_object_utils(normal_seqs)

//-------------------------------------------------------------
//UVM METHODS
//-------------------------------------------------------------
//standard methods
extern function new(string name = "normal_seqs");
extern task body();

endclass:normal_seqs

//--------------------------------------new() ----------------------------------------//
function normal_seqs::new(string name = "normal_seqs");
super.new(name);
endfunction:new

//--------------------------------------- body() -------------------------------------//
task normal_seqs::body();
repeat(1) begin
req = dest_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {no_of_cycles > 30 && no_of_cycles <40;})
finish_item(req); end
endtask:body
