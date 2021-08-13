`timescale 1ns / 1ps


module relu_function(
    input clk,
    input [11:0] relu_in,
    output reg [11:0] relu_out
    );

    wire [11:0] relu_func ;

    assign relu_func = relu_in[11] != 1'b1 ? relu_in : 12'b0;

    always@(posedge clk)begin
        relu_out <= relu_func;
    end


endmodule
