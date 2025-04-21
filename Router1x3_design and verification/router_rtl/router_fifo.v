module router_fifo(input clk, rst, write_enb, soft_reset, read_enb, lfd_state_in, input [7:0] data_in, output empty, full, output reg [7:0] data_out);
reg [8:0] mem [15:0];
reg [4:0] wr_ptr, rd_ptr;
reg [6:0] count;
reg lfd_state_out;

//lfd state 
always@(posedge clk)
begin
if(!rst)
	lfd_state_out <= 0;
else 
	lfd_state_out <= lfd_state_in;
end 

//internal counter for fifo
always@(posedge clk)
begin
if(!rst)
	count <= 7'b0;
else if(soft_reset)
	count <= 7'b0;
else if(read_enb && ~empty)
begin
	if(mem[rd_ptr [3:0]] [8] == 1'b1)
		count <= mem[rd_ptr [3:0]] [7:2] + 1'b1;
	else if(count != 0)
		count <= count - 7'b1;
end
end

//read logic 
always@(posedge clk)
begin
if(!rst)
	data_out <= 8'b0;
else if(soft_reset)
	data_out <= 8'bz;
else if(count == 0 && data_out !=0)
	data_out <= 8'bz;
else if(read_enb && ~empty)
	data_out <= mem[rd_ptr [3:0]];
end

//write logic
always@(posedge clk)
begin
if(!rst)
	mem[wr_ptr[3:0]] <= 8'b0;
else if(soft_reset)
	mem[wr_ptr[3:0]] <= 8'b0;
else if(write_enb && ~full)
	mem[wr_ptr [3:0]] <= {lfd_state_out, data_in};
end

//read pointer and write pointer incrementing logic
//write pointer
always@(posedge clk)
begin
if(!rst)
	wr_ptr <= 5'b0;
else if(soft_reset)
	wr_ptr <= 5'b0;
else if(write_enb && ~full)
	wr_ptr <= wr_ptr + 1'b1;
end

//read pointer
always@(posedge clk)
begin
if(!rst)
	rd_ptr <= 5'b0;
else if(soft_reset)
	rd_ptr <= 5'b0;
else if(read_enb && !empty)
	rd_ptr <= rd_ptr + 1'b1;
end

assign full = (wr_ptr=={~rd_ptr[4], rd_ptr[3:0]})?1'b1:1'b0;
assign empty = (wr_ptr==rd_ptr)?1'b1:1'b0;


endmodule

