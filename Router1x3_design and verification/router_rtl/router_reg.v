/* Loadable register: because in data_out it is load the packets like header, payload annd parity order
the router register uses 4 internal register of 8 bit
1. Header byte
2. Fifo_full_state byte
3. packet parity byte from source
4. calculation internal parity byte
signals generated from router register are parity done, low_pkt_valid, error and d_out signals
parity_done:- indicates the router received the parity packet
err:- it means it calculates internal parity from each packet and compare with the parity
the parity byte register and parity_done conditions are same so we can assign both of them within the same always block */

module router_register(input clk, rst, pkt_valid, input [7:0] data_in, input fifo_full, 
					   rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state,
					   output reg [7:0] data_out, output reg parity_done, err, low_pkt_valid);

reg [7:0] header_byte, fifo_full_state_byte, packet_parity, internal_parity;

//header_byte register logic
always@(posedge clk) begin
if(!rst)
	header_byte <= 8'b0;
else if(detect_add && pkt_valid && data_in != 3)
	header_byte <= data_in;
end

//fifo_full_state_byte register logic
always@(posedge clk) begin
if(!rst)
	fifo_full_state_byte <= 8'b0;
else if(ld_state && fifo_full)
	fifo_full_state_byte <= data_in;
end

//data_out register logic
always@(posedge clk) begin
if(!rst)
	data_out <= 8'b0;
else if(lfd_state)
	data_out <= header_byte;
else if(ld_state && !fifo_full)
	data_out <= data_in;
else if(laf_state)
	data_out <= fifo_full_state_byte;
end

//low_pkt_valid logic which is negation of the pkt_valid
always@(posedge clk) begin
if(!rst)
	low_pkt_valid <= 1'b0;
else if(ld_state && ~pkt_valid)
	low_pkt_valid <= 1'b1;
end

//internal parity logic
always@(posedge clk) begin
if(!rst)
	internal_parity <= 8'b0;
else if(detect_add)
	internal_parity <= 8'b0;
else if(lfd_state)
	internal_parity <= internal_parity^header_byte;
else if(ld_state && pkt_valid && !fifo_full)
	internal_parity <= internal_parity^data_in;
end

//packet_parity logic and parity_done logic with same conditions 
always@(posedge clk) begin
if(!rst) begin
	packet_parity <= 8'b0;
	//parity_done <= 1'b0;
end
else if(detect_add) begin
	packet_parity <= 8'b0;
	//parity_done <= 1'b0;
end
//else if(ld_state && !pkt_valid && !fifo_full) / && laf_state && low_pkt_valid && ~parity_done) begin
else if(ld_state && !pkt_valid) begin
	packet_parity <= data_in;
	//parity_done <= 1'b1;
end
end

//packet_parity logic and parity_done logic with same conditions 
always@(posedge clk) begin
if(!rst) begin
	parity_done <= 1'b0;
end
else if(detect_add) begin
	parity_done <= 1'b0;
end

else if((ld_state && !pkt_valid) || (low_pkt_valid && laf_state)) begin
	parity_done <= 1'b1;
end

end

//Error logic to check parity 
always@(posedge clk) begin
if(!rst)
	err <= 1'b0;
else if(!parity_done)
	err <= 1'b0;
else if(internal_parity != packet_parity)
	err <= 1'b1;
else 
	err <= 1'b0;
end

endmodule

