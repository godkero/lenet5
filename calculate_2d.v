`timescale 1ns / 1ps


module calculate_2d
#(parameter 
    DATA_WIDTH = 12, 
    FILTER_WIDTH = 5, 
    FILTER_WEIGHT = 5,
    INPUT_WIDTH = 32, 
    INPUT_HEIGTH = 32,
    OUTPUT_WIDTH = 28,
    OUTPUT_HEIGTH = 28,
    OUTPUT_FEATURE_MAP = 6,
    W_DEPTH = 26,
    IN_DEPTH = 1024,
    WEIGHT_BIT =  FILTER_WEIGHT * FILTER_WIDTH * DATA_WIDTH,
    W_READ_SIZE = OUTPUT_FEATURE_MAP * DATA_WIDTH,
    //parent
    PARENT_IDLE = 4'b0001,
    PARENT_LOAD_W = 4'b0010,
    PARENT_CALCULATION = 4'b0100,
    PARENT_DONE = 4'b1000
    // //child
    // IDLE = 7'b0000001,
    // WAIT_1 = 7'b0000010,
    // LOAD = 7'b0000100,
    // LOAD_DONE = 7'b0001000,
    // WAIT_2 = 7'b0010000,
    // WORK =  7'b0100000,
    // WORK_DONE = 7'b1000000
)
(
input  clk,
input  signed [DATA_WIDTH-1 : 0] input_unit_1,
input  signed [DATA_WIDTH-1 : 0] input_unit_2,
input  signed [DATA_WIDTH-1 : 0] input_unit_3,
input  signed [DATA_WIDTH-1 : 0] input_unit_4,
input  signed [DATA_WIDTH-1 : 0] input_unit_5,
input  signed [DATA_WIDTH-1 : 0] input_unit_6,
input  signed [DATA_WIDTH-1 : 0] input_unit_7,
input  signed [DATA_WIDTH-1 : 0] input_unit_8,
input  signed [DATA_WIDTH-1 : 0] input_unit_9,
input  signed [DATA_WIDTH-1 : 0] input_unit_10,
input  signed [DATA_WIDTH-1 : 0] input_unit_11,
input  signed [DATA_WIDTH-1 : 0] input_unit_12,
input  signed [DATA_WIDTH-1 : 0] input_unit_13,
input  signed [DATA_WIDTH-1 : 0] input_unit_14,
input  signed [DATA_WIDTH-1 : 0] input_unit_15,
input  signed [DATA_WIDTH-1 : 0] input_unit_16,
input  signed [DATA_WIDTH-1 : 0] input_unit_17,
input  signed [DATA_WIDTH-1 : 0] input_unit_18,
input  signed [DATA_WIDTH-1 : 0] input_unit_19,
input  signed [DATA_WIDTH-1 : 0] input_unit_20,
input  signed [DATA_WIDTH-1 : 0] input_unit_21,
input  signed [DATA_WIDTH-1 : 0] input_unit_22,
input  signed [DATA_WIDTH-1 : 0] input_unit_23,
input  signed [DATA_WIDTH-1 : 0] input_unit_24,
input  signed [DATA_WIDTH-1 : 0] input_unit_25,
input  signed [DATA_WIDTH-1 : 0] weight_unit_1,
input  signed [DATA_WIDTH-1 : 0] weight_unit_2,
input  signed [DATA_WIDTH-1 : 0] weight_unit_3,
input  signed [DATA_WIDTH-1 : 0] weight_unit_4,
input  signed [DATA_WIDTH-1 : 0] weight_unit_5,
input  signed [DATA_WIDTH-1 : 0] weight_unit_6,
input  signed [DATA_WIDTH-1 : 0] weight_unit_7,
input  signed [DATA_WIDTH-1 : 0] weight_unit_8,
input  signed [DATA_WIDTH-1 : 0] weight_unit_9,
input  signed [DATA_WIDTH-1 : 0] weight_unit_10,
input  signed [DATA_WIDTH-1 : 0] weight_unit_11,
input  signed [DATA_WIDTH-1 : 0] weight_unit_12,
input  signed [DATA_WIDTH-1 : 0] weight_unit_13,
input  signed [DATA_WIDTH-1 : 0] weight_unit_14,
input  signed [DATA_WIDTH-1 : 0] weight_unit_15,
input  signed [DATA_WIDTH-1 : 0] weight_unit_16,
input  signed [DATA_WIDTH-1 : 0] weight_unit_17,
input  signed [DATA_WIDTH-1 : 0] weight_unit_18,
input  signed [DATA_WIDTH-1 : 0] weight_unit_19,
input  signed [DATA_WIDTH-1 : 0] weight_unit_20,
input  signed [DATA_WIDTH-1 : 0] weight_unit_21,
input  signed [DATA_WIDTH-1 : 0] weight_unit_22,
input  signed [DATA_WIDTH-1 : 0] weight_unit_23,
input  signed [DATA_WIDTH-1 : 0] weight_unit_24,
input  signed [DATA_WIDTH-1 : 0] weight_unit_25,
input  signed [DATA_WIDTH-1 : 0] bias_unit,

output signed [DATA_WIDTH-1 : 0] output_unit_1

);




wire signed [DATA_WIDTH-1 : 0] mult_unit_1;
wire signed [DATA_WIDTH-1 : 0] mult_unit_2;
wire signed [DATA_WIDTH-1 : 0] mult_unit_3;
wire signed [DATA_WIDTH-1 : 0] mult_unit_4;
wire signed [DATA_WIDTH-1 : 0] mult_unit_5;
wire signed [DATA_WIDTH-1 : 0] mult_unit_6;
wire signed [DATA_WIDTH-1 : 0] mult_unit_7;
wire signed [DATA_WIDTH-1 : 0] mult_unit_8;
wire signed [DATA_WIDTH-1 : 0] mult_unit_9;
wire signed [DATA_WIDTH-1 : 0] mult_unit_10;
wire signed[DATA_WIDTH-1 : 0] mult_unit_11;
wire signed[DATA_WIDTH-1 : 0] mult_unit_12;
wire signed[DATA_WIDTH-1 : 0] mult_unit_13;
wire signed[DATA_WIDTH-1 : 0] mult_unit_14;
wire signed[DATA_WIDTH-1 : 0] mult_unit_15;
wire signed[DATA_WIDTH-1 : 0] mult_unit_16;
wire signed[DATA_WIDTH-1 : 0] mult_unit_17;
wire signed[DATA_WIDTH-1 : 0] mult_unit_18;
wire signed[DATA_WIDTH-1 : 0] mult_unit_19;
wire signed[DATA_WIDTH-1 : 0] mult_unit_20;
wire signed[DATA_WIDTH-1 : 0] mult_unit_21;
wire signed[DATA_WIDTH-1 : 0] mult_unit_22;
wire signed[DATA_WIDTH-1 : 0] mult_unit_23;
wire signed[DATA_WIDTH-1 : 0] mult_unit_24;
wire signed[DATA_WIDTH-1 : 0] mult_unit_25;

reg signed [11:0] stage_1_unit [0:12];
reg signed [11:0] stage_2_unit [0:6];
reg signed [11:0] stage_3_unit [0:3];
reg signed [11:0] stage_4_unit [0:1];
reg signed [DATA_WIDTH-1:0]  stage_5_unit;


    mult_cell mul1(clk,input_unit_1,weight_unit_1,mult_unit_1);
    mult_cell mul2(clk,input_unit_2,weight_unit_2,mult_unit_2);
    mult_cell mul3(clk,input_unit_3,weight_unit_3,mult_unit_3);
    mult_cell mul4(clk,input_unit_4,weight_unit_4,mult_unit_4);
    mult_cell mul5(clk,input_unit_5,weight_unit_5,mult_unit_5);
    mult_cell mul6(clk,input_unit_6,weight_unit_6,mult_unit_6);
    mult_cell mul7(clk,input_unit_7,weight_unit_7,mult_unit_7);
    mult_cell mul8(clk,input_unit_8,weight_unit_8,mult_unit_8);
    mult_cell mul9(clk,input_unit_9,weight_unit_9,mult_unit_9);
    mult_cell mul10(clk,input_unit_10,weight_unit_10,mult_unit_10);
    mult_cell mul11(clk,input_unit_11,weight_unit_11,mult_unit_11);
    mult_cell mul12(clk,input_unit_12,weight_unit_12,mult_unit_12);
    mult_cell mul13(clk,input_unit_13,weight_unit_13,mult_unit_13);
    mult_cell mul14(clk,input_unit_14,weight_unit_14,mult_unit_14);
    mult_cell mul15(clk,input_unit_15,weight_unit_15,mult_unit_15);
    mult_cell mul16(clk,input_unit_16,weight_unit_16,mult_unit_16);
    mult_cell mul17(clk,input_unit_17,weight_unit_17,mult_unit_17);
    mult_cell mul18(clk,input_unit_18,weight_unit_18,mult_unit_18);
    mult_cell mul19(clk,input_unit_19,weight_unit_19,mult_unit_19);
    mult_cell mul20(clk,input_unit_20,weight_unit_20,mult_unit_20);
    mult_cell mul21(clk,input_unit_21,weight_unit_21,mult_unit_21);
    mult_cell mul22(clk,input_unit_22,weight_unit_22,mult_unit_22);
    mult_cell mul23(clk,input_unit_23,weight_unit_23,mult_unit_23);
    mult_cell mul24(clk,input_unit_24,weight_unit_24,mult_unit_24);
    mult_cell mul25(clk,input_unit_25,weight_unit_25,mult_unit_25);
    

    // reg [11:0] stage_5_unit;
    
    
    //add tree
    always@(posedge clk)begin
        stage_1_unit[0] <= mult_unit_1 + mult_unit_2;
        stage_1_unit[1] <= mult_unit_3 + mult_unit_4;
        stage_1_unit[2] <= mult_unit_5 + mult_unit_6;
        stage_1_unit[3] <= mult_unit_7 + mult_unit_8;
        stage_1_unit[4] <= mult_unit_9 + mult_unit_10;
        stage_1_unit[5] <= mult_unit_11 + mult_unit_12;
        stage_1_unit[6] <= mult_unit_13 + mult_unit_14;
        stage_1_unit[7] <= mult_unit_15 + mult_unit_16;
        stage_1_unit[8] <= mult_unit_17 + mult_unit_18;
        stage_1_unit[9] <= mult_unit_19 + mult_unit_20;
        stage_1_unit[10] <= mult_unit_21 + mult_unit_22;
        stage_1_unit[11] <= mult_unit_23 + mult_unit_24;
        stage_1_unit[12] <= mult_unit_25 + bias_unit; //bias

        stage_2_unit[0] <= stage_1_unit[0] + stage_1_unit[1];
        stage_2_unit[1] <= stage_1_unit[2] + stage_1_unit[3];
        stage_2_unit[2] <= stage_1_unit[4] + stage_1_unit[5];
        stage_2_unit[3] <= stage_1_unit[6] + stage_1_unit[7];
        stage_2_unit[4] <= stage_1_unit[8] + stage_1_unit[9];
        stage_2_unit[5] <= stage_1_unit[10] + stage_1_unit[11];
        stage_2_unit[6] <= stage_1_unit[12];

        stage_3_unit[0] <= stage_2_unit[0] + stage_2_unit[1];
        stage_3_unit[1] <= stage_2_unit[2] + stage_2_unit[3];
        stage_3_unit[2] <= stage_2_unit[4] + stage_2_unit[5];
        stage_3_unit[3] <= stage_2_unit[6];

        stage_4_unit[0] <= stage_3_unit[0] + stage_3_unit[1];
        stage_4_unit[1] <= stage_3_unit[2] + stage_3_unit[3];

        stage_5_unit <= stage_4_unit[0] + stage_4_unit[1]; 
    end

    relu_function relu(
        clk,
        stage_5_unit,
        output_unit_1
    );



endmodule
