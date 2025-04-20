`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2024 11:38:06 AM
// Design Name: 
// Module Name: gray2bin
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gray2bin #(parameter
    depth = 1024
)(
    input  [$clog2(depth):0] gray,
    output [$clog2(depth):0] bin);

    genvar i;
    generate 
        for(i=0;i<=$clog2(depth);i=i+1) begin
            assign bin[i] = ^(gray >> i);
        end
    endgenerate
endmodule

    