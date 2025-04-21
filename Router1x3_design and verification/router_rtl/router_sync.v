//check empty condition in soft_reset logic (confirm with circuit diagram of soft_reset circuit)
module router_synchronizer(input clk, rst, detect_add, write_enb_reg, read_enb_0, read_enb_1, read_enb_2, empty_0, empty_1, empty_2, full_0, full_1, full_2,
 input [1:0] data_in, output reg fifo_full, output valid_out_0, valid_out_1, valid_out_2, output reg soft_reset_0, soft_reset_1, soft_reset_2, output reg [2:0] write_enb);
 
reg [1:0] fifo_addr;
reg [4:0] count_0_sft_rst, count_1_sft_rst, count_2_sft_rst;

//capturing address to know which destination it has to write data
always@(posedge clk)
begin
if(!rst)
	fifo_addr <= 2'b0;
else if(detect_add)
	fifo_addr <= data_in;
//	

end

always@(empty_0,empty_1,empty_2) begin
	$display(valid_out_0,valid_out_1, valid_out_2);
	$display("fifo_addr=%0d",fifo_addr); end
//write enable logic for destination
always@(*)
begin
if(write_enb_reg)
	begin
		case(fifo_addr)
			2'b00: write_enb = 3'b001;
			2'b01: write_enb = 3'b010;
			2'b10: write_enb = 3'b100;
			default: write_enb = 3'b0;
		endcase
	end
else
	write_enb = 3'b0;
end

//FIFO_FULL Logic to known the status of the fifo 
always@(*)
begin
	case(fifo_addr)
		2'b00: fifo_full = full_0;
		2'b01: fifo_full = full_1;
		2'b10: fifo_full = full_2;
		default: fifo_full = 1'b0;
	endcase
end

//Soft reset logic :- (time out) count 30 cycles if more than that soft reset becomes high
always@(posedge clk)
begin
if(!rst)
	begin
		soft_reset_0 <= 0;
		count_0_sft_rst <= 5'd1;
	end
else if(!valid_out_0 || empty_0)
	begin
		soft_reset_0 <= 0;
		count_0_sft_rst <= 5'd1;
	end
else if(read_enb_0 && ~empty_0)
	begin
		soft_reset_0 <= 0;
		count_0_sft_rst <= 5'd1;
	end
else if(count_0_sft_rst == 5'd30)
	begin
		soft_reset_0 <= 1'b1;
		count_0_sft_rst <= 5'd1;
	end
else 
	begin
		soft_reset_0 <= 1'b0;
		count_0_sft_rst <= count_0_sft_rst + 5'd1;
	end
end

//
//
always@(posedge clk)
begin
if(!rst)
	begin
		soft_reset_1 <= 0;
		count_1_sft_rst <= 5'd1;
	end
else if(!valid_out_1 || empty_1)
	begin
		soft_reset_1 <= 0;
		count_1_sft_rst <= 5'd1;
	end
else if(read_enb_1 && ~empty_1)
	begin
		soft_reset_1 <= 0;
		count_1_sft_rst <= 5'd1;
	end
else if(count_1_sft_rst == 5'd30)
	begin
		soft_reset_1 <= 1'b1;
		count_1_sft_rst <= 5'd1;
	end
else 
	begin
		soft_reset_1 <= 1'b0;
		count_1_sft_rst <= count_1_sft_rst + 5'd1;
	end
end

always@(posedge clk)
begin
if(!rst)
	begin
		soft_reset_2 <= 0;
		count_2_sft_rst <= 5'd1;
	end
else if(!valid_out_2 || empty_2)
	begin
		soft_reset_2 <= 0;
		count_2_sft_rst <= 5'd1;
	end
else if(read_enb_2 && ~empty_2)
	begin
		soft_reset_2 <= 0;
		count_2_sft_rst <= 5'd1;
	end
else if(count_2_sft_rst == 5'd30)
	begin
		soft_reset_2 <= 1'b1;
		count_2_sft_rst <= 5'd1;
	end
else 
	begin
		soft_reset_2 <= 1'b0;
		count_2_sft_rst <= count_2_sft_rst + 5'd1;
	end
end

assign valid_out_0 = ~empty_0;
assign valid_out_1 = ~empty_1;
assign valid_out_2 = ~empty_2;

//
endmodule

