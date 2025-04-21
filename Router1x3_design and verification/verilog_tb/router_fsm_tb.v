

	// test bench code for router fsm
	
	module router_fsm_tb;

	reg clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
	reg [1:0] data_in;
   wire busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;

	router_fsm dut(clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,data_in,
	       	       busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
	initial
	begin
	{pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
	fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,data_in} = 0;
	end
	
	initial
	begin
		clock = 1'b0;
		forever #10 clock = ~clock;
	end

	task reset;
		begin
			@(negedge clock)
			resetn = 1'b0;
			@(negedge clock)
			resetn = 1'b1;
		end
	endtask


	task t1;
		begin
			@(negedge clock)
			pkt_valid = 1'b1;
      data_in = 2'b01;
      fifo_empty_1 = 1'b1;
      @(negedge clock)
      @(negedge clock)
      fifo_full = 1'b0;
      pkt_valid = 1'b0;
      @(negedge clock)
      @(negedge clock)
      fifo_full = 1'b0;
      end
      endtask
      
   task t2;
   begin
       @(negedge clock)
       pkt_valid = 1'b1;
       data_in = 2'b10;
       fifo_empty_2 = 1'b1;
       @(negedge clock)
       @(negedge clock)
       fifo_full = 1'b1;
       @(negedge clock)
       fifo_full = 1'b0;
       @(negedge clock)
       parity_done = 1'b0;
       low_pkt_valid = 1'b1;
       @(negedge clock)
       @(negedge clock)
       fifo_full = 1'b0;
       end
       endtask
       
   task t3;
   begin
       @(negedge clock)
       pkt_valid = 1'b1;
       data_in = 2'b10;
       fifo_empty_2 = 1'b1;
       @(negedge clock)
       @(negedge clock)
       fifo_full = 1'b1;
       @(negedge clock)
       fifo_full = 1'b0;
       @(negedge clock)
       parity_done = 1'b0;
       low_pkt_valid = 1'b0;
       @(negedge clock)
       fifo_full = 1'b0;
       pkt_valid = 1'b0;
       @(negedge clock)
       fifo_full = 1'b0;
       pkt_valid = 1'b0;
       @(negedge clock)
       @(negedge clock)
       fifo_full = 1'b0;
       end
       endtask
       
     task t4;
     begin
         @(negedge clock)
         pkt_valid = 1'b1;
         data_in = 2'b10;
         fifo_empty_2 = 1'b1;
         @(negedge clock)
         @(negedge clock)
         fifo_full = 1'b0;
         pkt_valid = 1'b0;
         @(negedge clock)
         @(negedge clock)
         fifo_full = 1'b1;
         @(negedge clock)
         fifo_full = 1'b0;
         @(negedge clock)
         parity_done = 1'b1;
         end
         endtask
         
         initial
         begin
         reset;
         #500 t1;
         #500 t2;
         #500 t3;
         #500 t4;
			#10000 $stop;
         end
         endmodule 
