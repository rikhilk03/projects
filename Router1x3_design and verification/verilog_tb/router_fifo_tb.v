

	// Test bench code for router fifo
	
	module router_fifo_tb;
		
		reg clock,resetn,write_enb,read_enb,soft_reset,lfd_state;
		reg [7:0] data_in;
		wire empty,full;
		wire [7:0] data_out;
		integer k;

		router_fifo dut(clock,resetn,write_enb,read_enb,soft_reset,lfd_state,data_in,
		           empty,full,data_out);

			initial
				data_in = 0;

			initial
			begin
				clock = 1'b0;
				forever #10 clock = ~clock;
			end

			task reset_in;
				begin
					@(negedge clock)
					resetn = 1'b0;
					@(negedge clock)
					resetn = 1'b1;
				end
			endtask

			task soft_rst;
				begin
					@(negedge clock)
					soft_reset = 1'b1;
					@(negedge clock)
					soft_reset = 1'b0;
				end
			endtask


			task write; // For write operation
			
					reg [7:0] payload_data,parity,header;
					reg [5:0] payload_len;
					reg [1:0] addr;

					begin  // For header
						@(negedge clock)
						payload_len = 6'd14;
						addr = 2'b01;
						header = {payload_len,addr};
						data_in = header;
						lfd_state = 1'b1;
						write_enb = 1'b1;
						// parity = parity ^ header;
						for (k=0;k<payload_len;k=k+1) // For payload
						begin
							@(negedge clock)
							lfd_state = 1'b0;
							payload_data = {$random}%256;
							data_in = payload_data;
				// parity = parity ^ data_in;
						end
						@(negedge clock) // For parity
						parity = {$random} %256;
						data_in = parity;
					end
				endtask 

				task read; // For read operation
					begin
						@(negedge clock)
						write_enb = 1'b0;
						read_enb = 1'b1;
					end
				endtask

				initial
				begin
					reset_in;
					write;
					read;
				end
				endmodule


