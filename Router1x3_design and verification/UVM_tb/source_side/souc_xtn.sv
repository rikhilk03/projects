//--------********************************************************************************************************---------
//--------********************************************************************************************************---------
//--------************************************* Source Transaction ***********************************************---------

//------------------------------------------------------------------------------------------------------
//CLASS DESCRIPTION
//------------------------------------------------------------------------------------------------------

//Extend source transaction from uvm sequence item
class souc_xtn extends uvm_sequence_item;

//Register this class to uvm_factory
`uvm_object_utils(souc_xtn)
//----------------------------------------------------------
//Declare inputs as rand and outputs as non-rand
//-----------------------------------------------------------

//Declare header[7:0] of bit type as rand
rand bit[7:0] header;

//Declare payload[] of bit type as rand
rand bit[7:0] payload[];

//Declare parity[7:0] of bit type and error of bit type
bit [7:0] parity;
bit err;

//--------------------------------------------------------------
//Constraints
//--------------------------------------------------------------

constraint c1{header[1:0] != 2'b11;}
constraint c2{header[7:2] != 0;}
constraint c3{payload.size == header[7:2];}
            
//---------------------------------------------------------------
//UVM METHODS
//---------------------------------------------------------------
//Standard methods

extern function new(string name = "souc_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();

endclass

//-------------------new() constructor-------------------------------//
function souc_xtn::new(string name = "souc_xtn");
super.new(name);
endfunction

//-----------------------do_print()------------------------------------//
function void souc_xtn::do_print(uvm_printer printer);
//Call super.do_print
super.do_print(printer);

//print each field (string name, value, size, radix)
printer.print_field("header",this.header,8,UVM_DEC);
foreach(payload[i])
    printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
printer.print_field("parity",this.parity,8,UVM_DEC);
printer.print_field("err",this.err,2,UVM_DEC);

endfunction:do_print

//----------------------------post_randomize()----------------------------//
function void souc_xtn::post_randomize();

//super.post_randomize()
super.post_randomize();
//assign header to parity
parity = header;

//Within foreach loop of payload assign the value of xor operation b/w parity and payload to parity
foreach(payload[i])
parity = parity^payload[i];

endfunction:post_randomize
