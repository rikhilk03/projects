

	// Test bench code for router top module
   
   module router_top_tb;

   reg  clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
   reg   [7:0] data_in;
   wire [7:0] data_out_0,data_out_1,data_out_2;
   wire vld_out_0,vld_out_1,vld_out_2,err,busy;
	integer i;

   router_top dut  (clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_2,
		    vld_out_0,vld_out_1,vld_out_2,err,busy);
   event e1,e2;

   
   task initialize;
	begin
	{read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in} = 0;
	end
	endtask 
	
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
   
   
   /*task pkt_gen_14_1; // packet generation for payload length 14
   reg [7:0] payload_data,parity,header;
   reg [5:0] payload_len;
   reg [1:0] addr;
   begin
   @(negedge clock)
   wait(!busy)
   @(negedge clock)
   payload_len = 6'd14;
   addr = 2'b00; // valid packet
   header = {payload_len,addr};
   parity = 1'b0;
   data_in = header;
   pkt_valid = 1'b1;
   parity = parity^header;
   @(negedge clock)
   wait(!busy)
   for (i=0;i<payload_len;i=i+1)
   begin
   @(negedge clock)
   wait(!busy)
   payload_data = {$random} %256;
   data_in = payload_data;
   parity = parity ^ payload_data;
   end
   @(negedge clock)
   wait(!busy)
   pkt_valid = 1'b0;
   data_in = parity;
   end
   endtask
   
  task pkt_gen_17; // packet generation for payload length 17
   reg [7:0] payload_data,parity,header;
   reg [5:0] payload_len;
   reg [1:0] addr;
   begin
   @(negedge clock)
   wait(!busy)
   @(negedge clock)
   payload_len = 6'd17;
   addr = 2'b10; // valid packet
   header = {payload_len,addr};
   parity = 1'b0;
   data_in = header;
   pkt_valid = 1'b1;
   parity = parity^header;
   @(negedge clock)
   wait(!busy)
   for (i=0;i<payload_len;i=i+1)
   begin
   @(negedge clock)
   wait(!busy)
   payload_data = {$random} %256;
   data_in = payload_data;
   parity = parity ^ payload_data;
   end
   ->e1;
   @(negedge clock)
   wait(!busy)
   pkt_valid = 1'b0;
   data_in = parity;
   end
   endtask */

   task pkt_gen_14; // packet generation for payload length 14
   reg [7:0] payload_data,parity,header;
   reg [5:0] payload_len;
   reg [1:0] addr;
   begin
	   parity = 0;
   //@(negedge clock)
   wait(!busy)
   begin
	 @(negedge clock);
   payload_len = 6'd14;
	   pkt_valid = 1'b1;

   addr = 2'b01; // valid packet
   header = {payload_len,addr};

   data_in = header;
   parity = parity ^ data_in;
	end
   @(negedge clock);
   for (i=0;i<payload_len;i=i+1)
   begin
  
   wait(!busy)
	 @(negedge clock);
   payload_data = {$random} %256;
   data_in = payload_data;
   parity = parity ^ data_in;
   end
   
   wait(!busy)
	@(negedge clock);
   pkt_valid = 1'b0;
   data_in = parity;

	
	
   end
   endtask

  
  /* task pkt_gen_14_l; // packet generation for random payload length
   reg [7:0] payload_data,parity,header;
   reg [5:0] payload_len;
   reg [1:0] addr;
   begin
	   ->e2;
   @(negedge clock)
   wait(!busy)
   @(negedge clock)
   payload_len = {$random} %63+1;
   addr = 2'b10; // valid packet
   header = {payload_len,addr};
   parity = 1'b0;
   data_in = header;
   pkt_valid = 1'b1;
   parity = parity^header;
   @(negedge clock)
   wait(!busy)
   for (i=0;i<payload_len;i=i+1)
   begin
   @(negedge clock)
   wait(!busy)
   payload_data = {$random} %256;
   data_in = payload_data;
   parity = parity ^ payload_data;
   end
   -> e1;
   @(negedge clock)
   wait(!busy)
   pkt_valid = 1'b0;
   data_in = parity;
   end
   endtask*/
  
    initial  // for enabling read
    begin
	 initialize;
    rst;
    //repeat(3)
   // @(negedge clock);
    pkt_gen_14;
	 
	 @(negedge clock);
	read_enb_1=1'b1;
		repeat(30)
    /*@(negedge clock)
    read_enb_1 = 1'b1;*/
    wait(!vld_out_1)
    @(negedge clock)
    read_enb_1 = 1'b0;
	 #1000 $finish;
    end
    
    /*initial
    begin
    @(e1)
    @(negedge clock)
    read_enb_2 = 1;
    @(negedge clock)
    wait(!vld_out_2)
    @(negedge clock)
    read_enb_2 = 0;
    end*/
    
    endmodule
    
    
    
   
