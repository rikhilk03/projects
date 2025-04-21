

	// Test bench code for synchronizer of router
	
	module router_sync_tb;
		
		reg detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
		reg [1:0] data_in;
		wire vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
	   wire [2:0] write_enb;

		router_sync dut(detect_add,write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,
		           data_in,vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,write_enb);

		  initial
		  begin
			  clock = 1'b0;
			  forever #10 clock = ~clock;
		  end

		  task rst;
			  begin
				  @(negedge clock)
				  resetn = 1'b0;
				  @(negedge clock)
				  resetn = 1'b1;
			  end
		  endtask
        
     task data(input [1:0] a);
     begin
     data_in = a;
     end
     endtask
     
     task write(input b);
     begin
     @(negedge clock)
     write_enb_reg = b;
     end
     endtask


		  initial
		  begin
			  rst;
			  @(negedge clock)
			  detect_add = 1'b1;
			  data(2'b01);
			  @(negedge clock)
			  detect_add = 1'b0;
			  write(1'b1);
			  @(negedge clock)
			  {full_0,full_1,full_2} = 3'b010;
			  @(negedge clock)
			  {empty_0,empty_1,empty_2}=3'b101;
			  @(negedge clock)
        {read_enb_0,read_enb_1,read_enb_2} = 3'b010;
		  repeat(30)
		  #1000 $finish;
   		  end
		  endmodule
/*module router_sync_tb(); 
 wire [2:0]write_enb; 
 wire fifo_full; 
 wire vld_out_0,vld_out_1,vld_out_2; 
 wire soft_reset_0,soft_reset_1,soft_reset_2; 
 reg  clock,resetn,detect_add; 
 reg  [1:0]data_in; 
 reg  full_0,full_1,full_2; 
 reg  empty_0,empty_1,empty_2; 
        reg write_enb_reg; 
        reg read_enb_0,read_enb_1,read_enb_2; 
        parameter CYCLE=10; 
     
router_sync 
DUT(clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty
 _1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,write_e
 nb,fifo_full,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft
 _reset_2); 
  
          initial  
            begin 
              clock=1'b0; 
              forever #(CYCLE/2) clock=~clock; 
            end       
//task initialize  
           task initialize; 
          begin 
       {detect_add,data_in,full_0,full_1,full_2}=0; 
       
{write_enb_reg,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,
 empty_2}=0; 
 
         end 
        endtask 
//task reset 
       task reset_dut(); 
                  begin 
                    @(negedge clock) 
                      resetn=1'b0;  
              @(negedge clock) 
                      resetn=1'b1;  
                  end 
              endtask 
//task readenb 
                task readenb(input r1,r2,r3); 
                   begin 
                        {read_enb_0,read_enb_1,read_enb_2}={r1,r2,r3}; 
              end  
               endtask 
//task input and detect addresee 
                 task detect_ad(input [1:0]d1,input detect_ad1); 
                    begin 
                      data_in=d1; 
                detect_add=detect_ad1; 
                    end 
        endtask 
//task fifo_full      
  task fifo_ful(input f1,f2,f3); 
                    begin 
                      full_0=f1; 
                      full_1=f2; 
                      full_2=f3; 
                     end 
                endtask 
//task empty 
               task empty_dut(input e1,e2,e3); 
                  begin 
              empty_0=e1; 
              empty_1=e2; 
                    empty_2=e3; 
        end 
       endtask  
   
  //task write enb reg 
                task write_reg(input l1); 
                    begin 
                    write_enb_reg=l1; 
 
                    end 
               endtask 
       initial 
         begin 
  initialize; 
  reset_dut(); 
                @(negedge clock) 
  readenb(1,1,0); 
        detect_ad(2'b10,1); 
           fifo_ful(0,0,0); 
        write_reg(1); 
           empty_dut(0,0,0); 
                #1000; 
           $finish; 
         end 
endmodule*/



