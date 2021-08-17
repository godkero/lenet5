`timescale 1ns / 1ps


module relu_function
#(
    parameter DATA_WIDTH = 16
)(
    input clk,
    input [DATA_WIDTH - 1:0] relu_in,
    output reg [DATA_WIDTH - 1:0] relu_out
    );

    wire [DATA_WIDTH -1:0] relu_func ;

    assign relu_func = relu_in[DATA_WIDTH -1] != 1'b1 ? relu_in : 16'b0;

    always@(posedge clk)begin
        relu_out <= relu_func;
    end


endmodule
