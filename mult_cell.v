`timescale 1ns / 1ps


module mult_cell
#(
    parameter 
    DATA_WIDTH = 16, 
    EXPANDED_WIDTH = 32,
    FRACTIONAL_BITS = 12,
    IDLE = 4'b0001,
    LOAD_W = 4'b0010,
    CALCULATION = 4'b0100,
    DONE = 4'b1000
)
(
    input  clk,
    input  signed [DATA_WIDTH-1 : 0] input_unit,
    input  signed [DATA_WIDTH-1 : 0] weight_unit,
    output reg signed  [DATA_WIDTH-1 :0] output_unit
);
    wire signed [EXPANDED_WIDTH -1:0] temp;
    wire signed [EXPANDED_WIDTH -1 :0] shift_temp;
    
    assign temp = input_unit*weight_unit;
    assign shift_temp = temp>>FRACTIONAL_BITS;

    always@(posedge clk)begin
        output_unit <= shift_temp[DATA_WIDTH - 1:0];
    end

endmodule
