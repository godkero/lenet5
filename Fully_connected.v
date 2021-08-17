`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/14 00:16:05
// Design Name: 
// Module Name: Fully_connected
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


module Fully_connected
#(
    parameter DATA_WIDTH = 16,
              INPUT_SIZE = 400,
              OUTPUT_SIZE = 120
)
(
    input [DATA_WIDTH - 1: 0] a,b,
    output FC_done
);

assign FC_done = 1'b0;



endmodule
