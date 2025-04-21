//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Destination Transaction ***********************************************---------

//------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//------------------------------------------------------------------------------------------------------

//Extend destination transaction from uvm sequence item
class dest_xtn extends uvm_sequence_item;

//Factory registration
`uvm_object_utils(dest_xtn)

// Declare header,payload,parity variables of type bit and payload should be dynamic
bit[7:0] header;
bit [7:0] payload[];
bit [7:0] parity;

//Declare no_of_cycles[5:0] of type bit and declare it as a rand
rand bit[5:0] no_of_cycles;

//------------------------------------------------------------------------------
//UVM METHODS
//------------------------------------------------------------------------------
//Standard methods

extern function new(string name = "dest_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();

endclass:dest_xtn

//--------------------------------------- new()------------------------------------------------//
function dest_xtn::new(string name = "dest_xtn");
super.new(name);
endfunction:new


//------------------------------------ do_print() ----------------------------------------------//
function void dest_xtn::do_print(uvm_printer printer);
//Call super.do_printer
super.do_print(printer);

//print each field(string name,value,size,radix)
printer.print_field("header",this.header,8,UVM_DEC);
foreach(payload[i])
    printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
printer.print_field("parity",this.parity,8,UVM_DEC);
//printer.print_field("error",this.error,2,UVM_DEC);

endfunction:do_print

//----------------------------post_randomize()----------------------------//
function void dest_xtn::post_randomize();

//super.post_randomize()
super.post_randomize();
//assign header to parity
parity = header;

//Within foreach loop of payload assign the value of xor operation b/w parity and payload to parity
foreach(payload[i])
parity = parity^payload[i];

endfunction:post_randomize
