

	// Test bench code for router register
	
	module router_reg_tb;

		reg clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
	   reg [7:0] data_in;
      wire parity_done,low_pkt_valid,err;
      wire [7:0] dout;
	   integer i;

		router_reg dut (clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in,parity_done,low_pkt_valid,err,dout);

		initial
		begin
			clock = 1'b0;
			forever #10 clock = ~clock;
		end

		task initialize;
			begin
				{clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in} = 0;
			end
		endtask

		task rst;
			begin
				@(negedge clock)
				resetn = 1'b0;
				@(negedge clock)
				resetn = 1'b1;
			end
		endtask

		task packet_generation;
			reg [7:0] payload_data,parity,header;
			reg [5:0] payload_len;
			reg [1:0] addr;
			begin
				@(negedge clock)
				payload_len = 6'd5;
				addr = 2'b10; // valid packet
				pkt_valid = 1'b1;
				detect_add = 1'b1;
				header = {payload_len,addr};
				data_in=header;
				parity = 8'h00 ^ header;
				@(negedge clock)
				detect_add = 1'b0;
				full_state = 1'b0;
				fifo_full = 1'b0;
				laf_state = 1'b0;
			  // @(negedge clock)
				//@(negedge clock)
				//@(negedge clock)
												
				lfd_state = 1'b1;
				
				for(i=0;i<payload_len;i=i+1)
				begin
					@(negedge clock)
					lfd_state = 1'b0;
					ld_state = 1'b1;
					payload_data = {$random}%256;
					data_in = payload_data;
					parity = parity ^ data_in;
				end
				@(negedge clock)
				pkt_valid = 1'b0;
				data_in = parity;
				@(negedge clock)
				ld_state = 1'b0;
			end
		endtask


		initial
		begin
			initialize;
			rst;
			packet_generation;
		end
		endmodule


          
