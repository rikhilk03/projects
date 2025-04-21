//--------********************************************************************************************************----------
//--------********************************************************************************************************----------
//--------****************************************** Module top *******************************************************-----

      module top;
      
        import router_pkg::*;
        import uvm_pkg::*;
        
        // Generation of clk
        bit clk;
        always
        #5 clk = ~clk;
        
        //Instantiate 4 router interfaces, 1 for source and 3 for destination and giving clk as input to it
        
        router_if s_if0(clk);
        router_if d_if0(clk);
        router_if d_if1(clk);
        router_if d_if2(clk);
        
        //
        router_top DUV(.clk(clk), .pkt_valid(s_if0.pkt_valid), .err(s_if0.err), .busy(s_if0.busy), 
        .rst(s_if0.rst), .data_in(s_if0.data_in),
        
                        .valid_out_0(d_if0.valid_out), .read_enb_0(d_if0.read_enb), .data_out_0(d_if0.data_out),
                        .valid_out_1(d_if1.valid_out), .read_enb_1(d_if1.read_enb), .data_out_1(d_if1.data_out),
                        .valid_out_2(d_if2.valid_out), .read_enb_2(d_if2.read_enb), .data_out_2(d_if2.data_out));
                        
                       
                        
/*                        
//--------------------assertions----------------------------


property stable;
@(posedge clock) s_if0.busy |=>$stable(s_if0.data_in);
endproperty

property busy_check;
@(posedge clock)$rose(s_if0.pkt_valid)|=>s_if0.busy;
endproperty

property valid_signal;
@(posedge clock)$rose(s_if0.pkt_valid)|->##3(d_if0.valid_out|d_if1.valid_out|d_if2.valid_out);
endproperty

property read_enb0;
@(posedge clock)$rose(d_if0.valid_out)|-> ##[1:29]$rose(d_if0.read_enb);
endproperty

property read_enb1;
@(posedge clock)$rose(d_if1.valid_out)|-> ##[1:29]$rose(d_if1.read_enb);
endproperty

property read_enb2;
@(posedge clock)$rose(d_if2.valid_out)|-> ##[1:29]$rose(d_if2.read_enb);
endproperty

property read_enb_0_low;
@(posedge clock)$fell(d_if0.valid_out)|=>$fell(d_if0.read_enb);
endproperty

property read_enb_1_low;
@(posedge clock)$fell(d_if1.valid_out)|=>$fell(d_if1.read_enb);
endproperty

property read_enb_2_low;
@(posedge clock)$fell(d_if2.valid_out)|=>$fell(d_if2.read_enb);
endproperty

A:assert property(stable)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ stable is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ stable is unsuccessful ");

B:assert property(busy_check)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ busy_chceck is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ busy_check  is unsuccessful");

C:assert property(valid_signal)
$display("valid_signal is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ valid_signal is unsuccessful");

D:assert property(read_enb0)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb0 is  is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb0 is unsuccessful");

E:assert property(read_enb1)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb1 is  is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb1 is unsuccessful");

F:assert property(read_enb2)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb2 is  is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb2 is unsuccessful");

G:assert property(read_enb_0_low)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb0 low is  is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb0_low is unsuccessful");

H:assert property(read_enb_1_low)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb1 low is  is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb1_low is unsuccessful");

I:assert property(read_enb_2_low)
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb2 low is  is successfull");
else
$display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ read_enb2_low is unsuccessful");

A_C: cover property(stable);
B_C: cover property(busy_check);
C_C: cover property(valid_signal);
D_C: cover property(read_enb0);
E_C: cover property(read_enb1);
F_C: cover property(read_enb2);
G_C: cover property(read_enb_0_low);
H_C: cover property(read_enb_1_low);
I_C: cover property(read_enb_2_low);

*/
            
                        
                        
        // set configuration to 1 source and 3 destinations using uvm_config_db with in Initial begin block
        
        initial
           begin


			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

           
           uvm_config_db #(virtual router_if)::set(null,"*","s_if0",s_if0);
           
           uvm_config_db #(virtual router_if)::set(null,"*","d_if0",d_if0);
           uvm_config_db #(virtual router_if)::set(null,"*","d_if1",d_if1);
           uvm_config_db #(virtual router_if)::set(null,"*","d_if2",d_if2);
           
           // call the run test
           run_test();
           end
        endmodule
        
        
        
