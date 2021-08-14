`timescale 1ns / 1ps

module top_wrapper#(
  parameter DATA_WIDTH = 12,
            L3_INPUT_CHANNEL = 6,
            L3_INPUT_HEIGHT = 14,
            L3_INPUT_WIDTH = 14,
            L3_FILTER_SIZE = 151,
            INPUT_SIZE = 1176,
            FILTER_BASE_0 = 0,
            FILTER_BASE_1 = 1208
  )
  (
  input clk_in,rst,start,
  output finish,
  output [6:0] out_d
  );
  
  wire clk;
  wire locked;
  clk_wiz_0 pll_clk(.clk_out1(clk),.locked(locked),.clk_in1(clk_in));   


  //front params
  wire L1_w_load_done;
  wire [4:0] front_st; 
  wire [1:0] L1_cal_wait;
  wire L1_done,L1_en,L3_en;
  wire [383:0] L1_in_data; //12*32
  wire [DATA_WIDTH - 1:0]  L1_w_data;  //12
  wire [7:0] L1_w_addr;
  wire [4:0] L1_in_addr;
  wire [5:0] L1_position_col;
  wire L3_done;


  //layer convoultion 3
  wire [3:0] col,row;


  //front layer
  reg [DATA_WIDTH-1:0] inp [0:4][0:31];
  reg [DATA_WIDTH-1:0] weight[0:5][0:24];
  reg [DATA_WIDTH-1:0] bias [0:5];

  //middle layer
  reg [11:0] input_mem [0: L3_INPUT_CHANNEL - 1][0: L3_INPUT_HEIGHT - 1][0: L3_INPUT_WIDTH - 1];
  reg [11:0] weight1_mem [0:L3_FILTER_SIZE -2];
  reg [11:0] weight2_mem [0:L3_FILTER_SIZE -2];
  reg [11:0] bias1_mem;
  reg [11:0] bias2_mem;


  wire [DATA_WIDTH-1:0] con_result [0:11];

  wire [11:0] L3_cur_filter_count;
  wire [1:0] L1_load_wait;
  wire [5:0] weight_index;
  wire [3:0] weight_channel;

  wire L1_w_load_en;
  wire [4:0] L1_row_cnt;

  
  wire [4:0] in_cell_row;
  wire [4:0] in_cell_col;
 


  calculate_wrapper cal_wrapper(
    .clk(clk),
    .L1_en(L1_en),
    .L3_en(L3_en),
    .L1_inp_unit1 (inp[0][0+in_cell_row]    ),
    .L1_inp_unit2 (inp[0][1+in_cell_row]    ),
    .L1_inp_unit3 (inp[0][2+in_cell_row]    ),
    .L1_inp_unit4 (inp[0][3+in_cell_row]    ),
    .L1_inp_unit5 (inp[0][4+in_cell_row]    ),
    .L1_inp_unit6 (inp[1][0+in_cell_row]    ),
    .L1_inp_unit7 (inp[1][1+in_cell_row]    ),
    .L1_inp_unit8 (inp[1][2+in_cell_row]    ),
    .L1_inp_unit9 (inp[1][3+in_cell_row]    ),
    .L1_inp_unit10(inp[1][4+in_cell_row]    ),
    .L1_inp_unit11(inp[2][0+in_cell_row]    ),
    .L1_inp_unit12(inp[2][1+in_cell_row]    ),
    .L1_inp_unit13(inp[2][2+in_cell_row]    ),
    .L1_inp_unit14(inp[2][3+in_cell_row]    ),
    .L1_inp_unit15(inp[2][4+in_cell_row]    ),
    .L1_inp_unit16(inp[3][0+in_cell_row]    ),
    .L1_inp_unit17(inp[3][1+in_cell_row]    ),
    .L1_inp_unit18(inp[3][2+in_cell_row]    ),
    .L1_inp_unit19(inp[3][3+in_cell_row]    ),
    .L1_inp_unit20(inp[3][4+in_cell_row]    ),
    .L1_inp_unit21(inp[4][0+in_cell_row]    ),
    .L1_inp_unit22(inp[4][1+in_cell_row]    ),
    .L1_inp_unit23(inp[4][2+in_cell_row]    ),
    .L1_inp_unit24(inp[4][3+in_cell_row]    ),
    .L1_inp_unit25(inp[4][4+in_cell_row]    ),
    . L1_weight_unit1_channel1(weight[0][0] ),
    . L1_weight_unit2_channel1(weight[0][1] ),
    . L1_weight_unit3_channel1(weight[0][2] ),
    . L1_weight_unit4_channel1(weight[0][3] ),
    . L1_weight_unit5_channel1(weight[0][4] ),
    . L1_weight_unit6_channel1(weight[0][5] ),
    . L1_weight_unit7_channel1(weight[0][6] ),
    . L1_weight_unit8_channel1(weight[0][7] ),
    . L1_weight_unit9_channel1(weight[0][8] ),
    .L1_weight_unit10_channel1(weight[0][9] ),
    .L1_weight_unit11_channel1(weight[0][10]),
    .L1_weight_unit12_channel1(weight[0][11]),
    .L1_weight_unit13_channel1(weight[0][12]),
    .L1_weight_unit14_channel1(weight[0][13]),
    .L1_weight_unit15_channel1(weight[0][14]),
    .L1_weight_unit16_channel1(weight[0][15]),
    .L1_weight_unit17_channel1(weight[0][16]),
    .L1_weight_unit18_channel1(weight[0][17]),
    .L1_weight_unit19_channel1(weight[0][18]),
    .L1_weight_unit20_channel1(weight[0][19]),
    .L1_weight_unit21_channel1(weight[0][20]),
    .L1_weight_unit22_channel1(weight[0][21]),
    .L1_weight_unit23_channel1(weight[0][22]),
    .L1_weight_unit24_channel1(weight[0][23]),
    .L1_weight_unit25_channel1(weight[0][24]),
    . L1_weight_unit1_channel2(weight[1][0] ),
    . L1_weight_unit2_channel2(weight[1][1] ),
    . L1_weight_unit3_channel2(weight[1][2] ),
    . L1_weight_unit4_channel2(weight[1][3] ),
    . L1_weight_unit5_channel2(weight[1][4] ),
    . L1_weight_unit6_channel2(weight[1][5] ),
    . L1_weight_unit7_channel2(weight[1][6] ),
    . L1_weight_unit8_channel2(weight[1][7] ),
    . L1_weight_unit9_channel2(weight[1][8] ),
    .L1_weight_unit10_channel2(weight[1][9] ),
    .L1_weight_unit11_channel2(weight[1][10]),
    .L1_weight_unit12_channel2(weight[1][11]),
    .L1_weight_unit13_channel2(weight[1][12]),
    .L1_weight_unit14_channel2(weight[1][13]),
    .L1_weight_unit15_channel2(weight[1][14]),
    .L1_weight_unit16_channel2(weight[1][15]),
    .L1_weight_unit17_channel2(weight[1][16]),
    .L1_weight_unit18_channel2(weight[1][17]),
    .L1_weight_unit19_channel2(weight[1][18]),
    .L1_weight_unit20_channel2(weight[1][19]),
    .L1_weight_unit21_channel2(weight[1][20]),
    .L1_weight_unit22_channel2(weight[1][21]),
    .L1_weight_unit23_channel2(weight[1][22]),
    .L1_weight_unit24_channel2(weight[1][23]),
    .L1_weight_unit25_channel2(weight[1][24]),
    . L1_weight_unit1_channel3(weight[2][0] ),
    . L1_weight_unit2_channel3(weight[2][1] ),
    . L1_weight_unit3_channel3(weight[2][2] ),
    . L1_weight_unit4_channel3(weight[2][3] ),
    . L1_weight_unit5_channel3(weight[2][4] ),
    . L1_weight_unit6_channel3(weight[2][5] ),
    . L1_weight_unit7_channel3(weight[2][6] ),
    . L1_weight_unit8_channel3(weight[2][7] ),
    . L1_weight_unit9_channel3(weight[2][8] ),
    .L1_weight_unit10_channel3(weight[2][9] ),
    .L1_weight_unit11_channel3(weight[2][10]),
    .L1_weight_unit12_channel3(weight[2][11]),
    .L1_weight_unit13_channel3(weight[2][12]),
    .L1_weight_unit14_channel3(weight[2][13]),
    .L1_weight_unit15_channel3(weight[2][14]),
    .L1_weight_unit16_channel3(weight[2][15]),
    .L1_weight_unit17_channel3(weight[2][16]),
    .L1_weight_unit18_channel3(weight[2][17]),
    .L1_weight_unit19_channel3(weight[2][18]),
    .L1_weight_unit20_channel3(weight[2][19]),
    .L1_weight_unit21_channel3(weight[2][20]),
    .L1_weight_unit22_channel3(weight[2][21]),
    .L1_weight_unit23_channel3(weight[2][22]),
    .L1_weight_unit24_channel3(weight[2][23]),
    .L1_weight_unit25_channel3(weight[2][24]),
    . L1_weight_unit1_channel4(weight[3][0] ),
    . L1_weight_unit2_channel4(weight[3][1] ),
    . L1_weight_unit3_channel4(weight[3][2] ),
    . L1_weight_unit4_channel4(weight[3][3] ),
    . L1_weight_unit5_channel4(weight[3][4] ),
    . L1_weight_unit6_channel4(weight[3][5] ),
    . L1_weight_unit7_channel4(weight[3][6] ),
    . L1_weight_unit8_channel4(weight[3][7] ),
    . L1_weight_unit9_channel4(weight[3][8] ),
    .L1_weight_unit10_channel4(weight[3][9] ),
    .L1_weight_unit11_channel4(weight[3][10]),
    .L1_weight_unit12_channel4(weight[3][11]),
    .L1_weight_unit13_channel4(weight[3][12]),
    .L1_weight_unit14_channel4(weight[3][13]),
    .L1_weight_unit15_channel4(weight[3][14]),
    .L1_weight_unit16_channel4(weight[3][15]),
    .L1_weight_unit17_channel4(weight[3][16]),
    .L1_weight_unit18_channel4(weight[3][17]),
    .L1_weight_unit19_channel4(weight[3][18]),
    .L1_weight_unit20_channel4(weight[3][19]),
    .L1_weight_unit21_channel4(weight[3][20]),
    .L1_weight_unit22_channel4(weight[3][21]),
    .L1_weight_unit23_channel4(weight[3][22]),
    .L1_weight_unit24_channel4(weight[3][23]),
    .L1_weight_unit25_channel4(weight[3][24]),
    . L1_weight_unit1_channel5(weight[4][0] ),
    . L1_weight_unit2_channel5(weight[4][1] ),
    . L1_weight_unit3_channel5(weight[4][2] ),
    . L1_weight_unit4_channel5(weight[4][3] ),
    . L1_weight_unit5_channel5(weight[4][4] ),
    . L1_weight_unit6_channel5(weight[4][5] ),
    . L1_weight_unit7_channel5(weight[4][6] ),
    . L1_weight_unit8_channel5(weight[4][7] ),
    . L1_weight_unit9_channel5(weight[4][8] ),
    .L1_weight_unit10_channel5(weight[4][9] ),
    .L1_weight_unit11_channel5(weight[4][10]),
    .L1_weight_unit12_channel5(weight[4][11]),
    .L1_weight_unit13_channel5(weight[4][12]),
    .L1_weight_unit14_channel5(weight[4][13]),
    .L1_weight_unit15_channel5(weight[4][14]),
    .L1_weight_unit16_channel5(weight[4][15]),
    .L1_weight_unit17_channel5(weight[4][16]),
    .L1_weight_unit18_channel5(weight[4][17]),
    .L1_weight_unit19_channel5(weight[4][18]),
    .L1_weight_unit20_channel5(weight[4][19]),
    .L1_weight_unit21_channel5(weight[4][20]),
    .L1_weight_unit22_channel5(weight[4][21]),
    .L1_weight_unit23_channel5(weight[4][22]),
    .L1_weight_unit24_channel5(weight[4][23]),
    .L1_weight_unit25_channel5(weight[4][24]),
    . L1_weight_unit1_channel6(weight[5][0] ),
    . L1_weight_unit2_channel6(weight[5][1] ),
    . L1_weight_unit3_channel6(weight[5][2] ),
    . L1_weight_unit4_channel6(weight[5][3] ),
    . L1_weight_unit5_channel6(weight[5][4] ),
    . L1_weight_unit6_channel6(weight[5][5] ),
    . L1_weight_unit7_channel6(weight[5][6] ),
    . L1_weight_unit8_channel6(weight[5][7] ),
    . L1_weight_unit9_channel6(weight[5][8] ),
    .L1_weight_unit10_channel6(weight[5][9] ),
    .L1_weight_unit11_channel6(weight[5][10]),
    .L1_weight_unit12_channel6(weight[5][11]),
    .L1_weight_unit13_channel6(weight[5][12]),
    .L1_weight_unit14_channel6(weight[5][13]),
    .L1_weight_unit15_channel6(weight[5][14]),
    .L1_weight_unit16_channel6(weight[5][15]),
    .L1_weight_unit17_channel6(weight[5][16]),
    .L1_weight_unit18_channel6(weight[5][17]),
    .L1_weight_unit19_channel6(weight[5][18]),
    .L1_weight_unit20_channel6(weight[5][19]),
    .L1_weight_unit21_channel6(weight[5][20]),
    .L1_weight_unit22_channel6(weight[5][21]),
    .L1_weight_unit23_channel6(weight[5][22]),
    .L1_weight_unit24_channel6(weight[5][23]),
    .L1_weight_unit25_channel6(weight[5][24]),
    .L1_bias_unit1(bias[0]),
    .L1_bias_unit2(bias[1]),
    .L1_bias_unit3(bias[2]),
    .L1_bias_unit4(bias[3]),
    .L1_bias_unit5(bias[4]),
    .L1_bias_unit6(bias[5]),

    .L3_a_channel1_unit1 (input_mem[0][0+col][0+row]),.L3_a_channel2_unit1 (input_mem[1][0+col][0+row]),.L3_a_channel3_unit1 (input_mem[2][0+col][0+row]),.L3_a_channel4_unit1 (input_mem[3][0+col][0+row]),.L3_a_channel5_unit1 (input_mem[4][0+col][0+row]),.L3_a_channel6_unit1 (input_mem[5][0+col][0+row]),
    .L3_a_channel1_unit2 (input_mem[0][0+col][1+row]),.L3_a_channel2_unit2 (input_mem[1][0+col][1+row]),.L3_a_channel3_unit2 (input_mem[2][0+col][1+row]),.L3_a_channel4_unit2 (input_mem[3][0+col][1+row]),.L3_a_channel5_unit2 (input_mem[4][0+col][1+row]),.L3_a_channel6_unit2 (input_mem[5][0+col][1+row]),
    .L3_a_channel1_unit3 (input_mem[0][0+col][2+row]),.L3_a_channel2_unit3 (input_mem[1][0+col][2+row]),.L3_a_channel3_unit3 (input_mem[2][0+col][2+row]),.L3_a_channel4_unit3 (input_mem[3][0+col][2+row]),.L3_a_channel5_unit3 (input_mem[4][0+col][2+row]),.L3_a_channel6_unit3 (input_mem[5][0+col][2+row]),
    .L3_a_channel1_unit4 (input_mem[0][0+col][3+row]),.L3_a_channel2_unit4 (input_mem[1][0+col][3+row]),.L3_a_channel3_unit4 (input_mem[2][0+col][3+row]),.L3_a_channel4_unit4 (input_mem[3][0+col][3+row]),.L3_a_channel5_unit4 (input_mem[4][0+col][3+row]),.L3_a_channel6_unit4 (input_mem[5][0+col][3+row]),
    .L3_a_channel1_unit5 (input_mem[0][0+col][4+row]),.L3_a_channel2_unit5 (input_mem[1][0+col][4+row]),.L3_a_channel3_unit5 (input_mem[2][0+col][4+row]),.L3_a_channel4_unit5 (input_mem[3][0+col][4+row]),.L3_a_channel5_unit5 (input_mem[4][0+col][4+row]),.L3_a_channel6_unit5 (input_mem[5][0+col][4+row]),
    .L3_a_channel1_unit6 (input_mem[0][1+col][0+row]),.L3_a_channel2_unit6 (input_mem[1][1+col][0+row]),.L3_a_channel3_unit6 (input_mem[2][1+col][0+row]),.L3_a_channel4_unit6 (input_mem[3][1+col][0+row]),.L3_a_channel5_unit6 (input_mem[4][1+col][0+row]),.L3_a_channel6_unit6 (input_mem[5][1+col][0+row]),
    .L3_a_channel1_unit7 (input_mem[0][1+col][1+row]),.L3_a_channel2_unit7 (input_mem[1][1+col][1+row]),.L3_a_channel3_unit7 (input_mem[2][1+col][1+row]),.L3_a_channel4_unit7 (input_mem[3][1+col][1+row]),.L3_a_channel5_unit7 (input_mem[4][1+col][1+row]),.L3_a_channel6_unit7 (input_mem[5][1+col][1+row]),
    .L3_a_channel1_unit8 (input_mem[0][1+col][2+row]),.L3_a_channel2_unit8 (input_mem[1][1+col][2+row]),.L3_a_channel3_unit8 (input_mem[2][1+col][2+row]),.L3_a_channel4_unit8 (input_mem[3][1+col][2+row]),.L3_a_channel5_unit8 (input_mem[4][1+col][2+row]),.L3_a_channel6_unit8 (input_mem[5][1+col][2+row]),
    .L3_a_channel1_unit9 (input_mem[0][1+col][3+row]),.L3_a_channel2_unit9 (input_mem[1][1+col][3+row]),.L3_a_channel3_unit9 (input_mem[2][1+col][3+row]),.L3_a_channel4_unit9 (input_mem[3][1+col][3+row]),.L3_a_channel5_unit9 (input_mem[4][1+col][3+row]),.L3_a_channel6_unit9 (input_mem[5][1+col][3+row]),
    .L3_a_channel1_unit10(input_mem[0][1+col][4+row]),.L3_a_channel2_unit10(input_mem[1][1+col][4+row]),.L3_a_channel3_unit10(input_mem[2][1+col][4+row]),.L3_a_channel4_unit10(input_mem[3][1+col][4+row]),.L3_a_channel5_unit10(input_mem[4][1+col][4+row]),.L3_a_channel6_unit10(input_mem[5][1+col][4+row]),
    .L3_a_channel1_unit11(input_mem[0][2+col][0+row]),.L3_a_channel2_unit11(input_mem[1][2+col][0+row]),.L3_a_channel3_unit11(input_mem[2][2+col][0+row]),.L3_a_channel4_unit11(input_mem[3][2+col][0+row]),.L3_a_channel5_unit11(input_mem[4][2+col][0+row]),.L3_a_channel6_unit11(input_mem[5][2+col][0+row]),
    .L3_a_channel1_unit12(input_mem[0][2+col][1+row]),.L3_a_channel2_unit12(input_mem[1][2+col][1+row]),.L3_a_channel3_unit12(input_mem[2][2+col][1+row]),.L3_a_channel4_unit12(input_mem[3][2+col][1+row]),.L3_a_channel5_unit12(input_mem[4][2+col][1+row]),.L3_a_channel6_unit12(input_mem[5][2+col][1+row]),
    .L3_a_channel1_unit13(input_mem[0][2+col][2+row]),.L3_a_channel2_unit13(input_mem[1][2+col][2+row]),.L3_a_channel3_unit13(input_mem[2][2+col][2+row]),.L3_a_channel4_unit13(input_mem[3][2+col][2+row]),.L3_a_channel5_unit13(input_mem[4][2+col][2+row]),.L3_a_channel6_unit13(input_mem[5][2+col][2+row]),
    .L3_a_channel1_unit14(input_mem[0][2+col][3+row]),.L3_a_channel2_unit14(input_mem[1][2+col][3+row]),.L3_a_channel3_unit14(input_mem[2][2+col][3+row]),.L3_a_channel4_unit14(input_mem[3][2+col][3+row]),.L3_a_channel5_unit14(input_mem[4][2+col][3+row]),.L3_a_channel6_unit14(input_mem[5][2+col][3+row]),
    .L3_a_channel1_unit15(input_mem[0][2+col][4+row]),.L3_a_channel2_unit15(input_mem[1][2+col][4+row]),.L3_a_channel3_unit15(input_mem[2][2+col][4+row]),.L3_a_channel4_unit15(input_mem[3][2+col][4+row]),.L3_a_channel5_unit15(input_mem[4][2+col][4+row]),.L3_a_channel6_unit15(input_mem[5][2+col][4+row]),
    .L3_a_channel1_unit16(input_mem[0][3+col][0+row]),.L3_a_channel2_unit16(input_mem[1][3+col][0+row]),.L3_a_channel3_unit16(input_mem[2][3+col][0+row]),.L3_a_channel4_unit16(input_mem[3][3+col][0+row]),.L3_a_channel5_unit16(input_mem[4][3+col][0+row]),.L3_a_channel6_unit16(input_mem[5][3+col][0+row]),
    .L3_a_channel1_unit17(input_mem[0][3+col][1+row]),.L3_a_channel2_unit17(input_mem[1][3+col][1+row]),.L3_a_channel3_unit17(input_mem[2][3+col][1+row]),.L3_a_channel4_unit17(input_mem[3][3+col][1+row]),.L3_a_channel5_unit17(input_mem[4][3+col][1+row]),.L3_a_channel6_unit17(input_mem[5][3+col][1+row]),
    .L3_a_channel1_unit18(input_mem[0][3+col][2+row]),.L3_a_channel2_unit18(input_mem[1][3+col][2+row]),.L3_a_channel3_unit18(input_mem[2][3+col][2+row]),.L3_a_channel4_unit18(input_mem[3][3+col][2+row]),.L3_a_channel5_unit18(input_mem[4][3+col][2+row]),.L3_a_channel6_unit18(input_mem[5][3+col][2+row]),
    .L3_a_channel1_unit19(input_mem[0][3+col][3+row]),.L3_a_channel2_unit19(input_mem[1][3+col][3+row]),.L3_a_channel3_unit19(input_mem[2][3+col][3+row]),.L3_a_channel4_unit19(input_mem[3][3+col][3+row]),.L3_a_channel5_unit19(input_mem[4][3+col][3+row]),.L3_a_channel6_unit19(input_mem[5][3+col][3+row]),
    .L3_a_channel1_unit20(input_mem[0][3+col][4+row]),.L3_a_channel2_unit20(input_mem[1][3+col][4+row]),.L3_a_channel3_unit20(input_mem[2][3+col][4+row]),.L3_a_channel4_unit20(input_mem[3][3+col][4+row]),.L3_a_channel5_unit20(input_mem[4][3+col][4+row]),.L3_a_channel6_unit20(input_mem[5][3+col][4+row]),
    .L3_a_channel1_unit21(input_mem[0][4+col][0+row]),.L3_a_channel2_unit21(input_mem[1][4+col][0+row]),.L3_a_channel3_unit21(input_mem[2][4+col][0+row]),.L3_a_channel4_unit21(input_mem[3][4+col][0+row]),.L3_a_channel5_unit21(input_mem[4][4+col][0+row]),.L3_a_channel6_unit21(input_mem[5][4+col][0+row]),
    .L3_a_channel1_unit22(input_mem[0][4+col][1+row]),.L3_a_channel2_unit22(input_mem[1][4+col][1+row]),.L3_a_channel3_unit22(input_mem[2][4+col][1+row]),.L3_a_channel4_unit22(input_mem[3][4+col][1+row]),.L3_a_channel5_unit22(input_mem[4][4+col][1+row]),.L3_a_channel6_unit22(input_mem[5][4+col][1+row]),
    .L3_a_channel1_unit23(input_mem[0][4+col][2+row]),.L3_a_channel2_unit23(input_mem[1][4+col][2+row]),.L3_a_channel3_unit23(input_mem[2][4+col][2+row]),.L3_a_channel4_unit23(input_mem[3][4+col][2+row]),.L3_a_channel5_unit23(input_mem[4][4+col][2+row]),.L3_a_channel6_unit23(input_mem[5][4+col][2+row]),
    .L3_a_channel1_unit24(input_mem[0][4+col][3+row]),.L3_a_channel2_unit24(input_mem[1][4+col][3+row]),.L3_a_channel3_unit24(input_mem[2][4+col][3+row]),.L3_a_channel4_unit24(input_mem[3][4+col][3+row]),.L3_a_channel5_unit24(input_mem[4][4+col][3+row]),.L3_a_channel6_unit24(input_mem[5][4+col][3+row]),
    .L3_a_channel1_unit25(input_mem[0][4+col][4+row]),.L3_a_channel2_unit25(input_mem[1][4+col][4+row]),.L3_a_channel3_unit25(input_mem[2][4+col][4+row]),.L3_a_channel4_unit25(input_mem[3][4+col][4+row]),.L3_a_channel5_unit25(input_mem[4][4+col][4+row]),.L3_a_channel6_unit25(input_mem[5][4+col][4+row]),


    .L3_b_channel1_unit1 (weight1_mem[0] ),.L3_b_channel2_unit1 (weight1_mem[25]),.L3_b_channel3_unit1 (weight1_mem[50]),.L3_b_channel4_unit1 (weight1_mem[75]),.L3_b_channel5_unit1 (weight1_mem[100]),.L3_b_channel6_unit1 (weight1_mem[125]),
    .L3_b_channel1_unit2 (weight1_mem[1] ),.L3_b_channel2_unit2 (weight1_mem[26]),.L3_b_channel3_unit2 (weight1_mem[51]),.L3_b_channel4_unit2 (weight1_mem[76]),.L3_b_channel5_unit2 (weight1_mem[101]),.L3_b_channel6_unit2 (weight1_mem[126]),
    .L3_b_channel1_unit3 (weight1_mem[2] ),.L3_b_channel2_unit3 (weight1_mem[27]),.L3_b_channel3_unit3 (weight1_mem[52]),.L3_b_channel4_unit3 (weight1_mem[77]),.L3_b_channel5_unit3 (weight1_mem[102]),.L3_b_channel6_unit3 (weight1_mem[127]),
    .L3_b_channel1_unit4 (weight1_mem[3] ),.L3_b_channel2_unit4 (weight1_mem[28]),.L3_b_channel3_unit4 (weight1_mem[53]),.L3_b_channel4_unit4 (weight1_mem[78]),.L3_b_channel5_unit4 (weight1_mem[103]),.L3_b_channel6_unit4 (weight1_mem[128]),
    .L3_b_channel1_unit5 (weight1_mem[4] ),.L3_b_channel2_unit5 (weight1_mem[29]),.L3_b_channel3_unit5 (weight1_mem[54]),.L3_b_channel4_unit5 (weight1_mem[79]),.L3_b_channel5_unit5 (weight1_mem[104]),.L3_b_channel6_unit5 (weight1_mem[129]),
    .L3_b_channel1_unit6 (weight1_mem[5] ),.L3_b_channel2_unit6 (weight1_mem[30]),.L3_b_channel3_unit6 (weight1_mem[55]),.L3_b_channel4_unit6 (weight1_mem[80]),.L3_b_channel5_unit6 (weight1_mem[105]),.L3_b_channel6_unit6 (weight1_mem[130]),
    .L3_b_channel1_unit7 (weight1_mem[6] ),.L3_b_channel2_unit7 (weight1_mem[31]),.L3_b_channel3_unit7 (weight1_mem[56]),.L3_b_channel4_unit7 (weight1_mem[81]),.L3_b_channel5_unit7 (weight1_mem[106]),.L3_b_channel6_unit7 (weight1_mem[131]),
    .L3_b_channel1_unit8 (weight1_mem[7] ),.L3_b_channel2_unit8 (weight1_mem[32]),.L3_b_channel3_unit8 (weight1_mem[57]),.L3_b_channel4_unit8 (weight1_mem[82]),.L3_b_channel5_unit8 (weight1_mem[107]),.L3_b_channel6_unit8 (weight1_mem[132]),
    .L3_b_channel1_unit9 (weight1_mem[8] ),.L3_b_channel2_unit9 (weight1_mem[33]),.L3_b_channel3_unit9 (weight1_mem[58]),.L3_b_channel4_unit9 (weight1_mem[83]),.L3_b_channel5_unit9 (weight1_mem[108]),.L3_b_channel6_unit9 (weight1_mem[133]),
    .L3_b_channel1_unit10(weight1_mem[9] ),.L3_b_channel2_unit10(weight1_mem[34]),.L3_b_channel3_unit10(weight1_mem[59]),.L3_b_channel4_unit10(weight1_mem[84]),.L3_b_channel5_unit10(weight1_mem[109]),.L3_b_channel6_unit10(weight1_mem[134]),
    .L3_b_channel1_unit11(weight1_mem[10]),.L3_b_channel2_unit11(weight1_mem[35]),.L3_b_channel3_unit11(weight1_mem[60]),.L3_b_channel4_unit11(weight1_mem[85]),.L3_b_channel5_unit11(weight1_mem[110]),.L3_b_channel6_unit11(weight1_mem[135]),
    .L3_b_channel1_unit12(weight1_mem[11]),.L3_b_channel2_unit12(weight1_mem[36]),.L3_b_channel3_unit12(weight1_mem[61]),.L3_b_channel4_unit12(weight1_mem[86]),.L3_b_channel5_unit12(weight1_mem[111]),.L3_b_channel6_unit12(weight1_mem[136]),
    .L3_b_channel1_unit13(weight1_mem[12]),.L3_b_channel2_unit13(weight1_mem[37]),.L3_b_channel3_unit13(weight1_mem[62]),.L3_b_channel4_unit13(weight1_mem[87]),.L3_b_channel5_unit13(weight1_mem[112]),.L3_b_channel6_unit13(weight1_mem[137]),
    .L3_b_channel1_unit14(weight1_mem[13]),.L3_b_channel2_unit14(weight1_mem[38]),.L3_b_channel3_unit14(weight1_mem[63]),.L3_b_channel4_unit14(weight1_mem[88]),.L3_b_channel5_unit14(weight1_mem[113]),.L3_b_channel6_unit14(weight1_mem[138]),
    .L3_b_channel1_unit15(weight1_mem[14]),.L3_b_channel2_unit15(weight1_mem[39]),.L3_b_channel3_unit15(weight1_mem[64]),.L3_b_channel4_unit15(weight1_mem[89]),.L3_b_channel5_unit15(weight1_mem[114]),.L3_b_channel6_unit15(weight1_mem[139]),
    .L3_b_channel1_unit16(weight1_mem[15]),.L3_b_channel2_unit16(weight1_mem[40]),.L3_b_channel3_unit16(weight1_mem[65]),.L3_b_channel4_unit16(weight1_mem[90]),.L3_b_channel5_unit16(weight1_mem[115]),.L3_b_channel6_unit16(weight1_mem[140]),
    .L3_b_channel1_unit17(weight1_mem[16]),.L3_b_channel2_unit17(weight1_mem[41]),.L3_b_channel3_unit17(weight1_mem[66]),.L3_b_channel4_unit17(weight1_mem[91]),.L3_b_channel5_unit17(weight1_mem[116]),.L3_b_channel6_unit17(weight1_mem[141]),
    .L3_b_channel1_unit18(weight1_mem[17]),.L3_b_channel2_unit18(weight1_mem[42]),.L3_b_channel3_unit18(weight1_mem[67]),.L3_b_channel4_unit18(weight1_mem[92]),.L3_b_channel5_unit18(weight1_mem[117]),.L3_b_channel6_unit18(weight1_mem[142]),
    .L3_b_channel1_unit19(weight1_mem[18]),.L3_b_channel2_unit19(weight1_mem[43]),.L3_b_channel3_unit19(weight1_mem[68]),.L3_b_channel4_unit19(weight1_mem[93]),.L3_b_channel5_unit19(weight1_mem[118]),.L3_b_channel6_unit19(weight1_mem[143]),
    .L3_b_channel1_unit20(weight1_mem[19]),.L3_b_channel2_unit20(weight1_mem[44]),.L3_b_channel3_unit20(weight1_mem[69]),.L3_b_channel4_unit20(weight1_mem[94]),.L3_b_channel5_unit20(weight1_mem[119]),.L3_b_channel6_unit20(weight1_mem[144]),
    .L3_b_channel1_unit21(weight1_mem[20]),.L3_b_channel2_unit21(weight1_mem[45]),.L3_b_channel3_unit21(weight1_mem[70]),.L3_b_channel4_unit21(weight1_mem[95]),.L3_b_channel5_unit21(weight1_mem[120]),.L3_b_channel6_unit21(weight1_mem[145]),
    .L3_b_channel1_unit22(weight1_mem[21]),.L3_b_channel2_unit22(weight1_mem[46]),.L3_b_channel3_unit22(weight1_mem[71]),.L3_b_channel4_unit22(weight1_mem[96]),.L3_b_channel5_unit22(weight1_mem[121]),.L3_b_channel6_unit22(weight1_mem[146]),
    .L3_b_channel1_unit23(weight1_mem[22]),.L3_b_channel2_unit23(weight1_mem[47]),.L3_b_channel3_unit23(weight1_mem[72]),.L3_b_channel4_unit23(weight1_mem[97]),.L3_b_channel5_unit23(weight1_mem[122]),.L3_b_channel6_unit23(weight1_mem[147]),
    .L3_b_channel1_unit24(weight1_mem[23]),.L3_b_channel2_unit24(weight1_mem[48]),.L3_b_channel3_unit24(weight1_mem[73]),.L3_b_channel4_unit24(weight1_mem[98]),.L3_b_channel5_unit24(weight1_mem[123]),.L3_b_channel6_unit24(weight1_mem[148]),
    .L3_b_channel1_unit25(weight1_mem[24]),.L3_b_channel2_unit25(weight1_mem[49]),.L3_b_channel3_unit25(weight1_mem[74]),.L3_b_channel4_unit25(weight1_mem[99]),.L3_b_channel5_unit25(weight1_mem[124]),.L3_b_channel6_unit25(weight1_mem[149]),

    .L3_b_2_channel1_unit1 (weight2_mem[0] ),.L3_b_2_channel2_unit1 (weight2_mem[25]),.L3_b_2_channel3_unit1 (weight2_mem[50]),.L3_b_2_channel4_unit1 (weight2_mem[75]),.L3_b_2_channel5_unit1 (weight1_mem[100]),.L3_b_2_channel6_unit1 (weight1_mem[125]),
    .L3_b_2_channel1_unit2 (weight2_mem[1] ),.L3_b_2_channel2_unit2 (weight2_mem[26]),.L3_b_2_channel3_unit2 (weight2_mem[51]),.L3_b_2_channel4_unit2 (weight2_mem[76]),.L3_b_2_channel5_unit2 (weight1_mem[101]),.L3_b_2_channel6_unit2 (weight1_mem[126]),
    .L3_b_2_channel1_unit3 (weight2_mem[2] ),.L3_b_2_channel2_unit3 (weight2_mem[27]),.L3_b_2_channel3_unit3 (weight2_mem[52]),.L3_b_2_channel4_unit3 (weight2_mem[77]),.L3_b_2_channel5_unit3 (weight1_mem[102]),.L3_b_2_channel6_unit3 (weight1_mem[127]),
    .L3_b_2_channel1_unit4 (weight2_mem[3] ),.L3_b_2_channel2_unit4 (weight2_mem[28]),.L3_b_2_channel3_unit4 (weight2_mem[53]),.L3_b_2_channel4_unit4 (weight2_mem[78]),.L3_b_2_channel5_unit4 (weight1_mem[103]),.L3_b_2_channel6_unit4 (weight1_mem[128]),
    .L3_b_2_channel1_unit5 (weight2_mem[4] ),.L3_b_2_channel2_unit5 (weight2_mem[29]),.L3_b_2_channel3_unit5 (weight2_mem[54]),.L3_b_2_channel4_unit5 (weight2_mem[79]),.L3_b_2_channel5_unit5 (weight1_mem[104]),.L3_b_2_channel6_unit5 (weight1_mem[129]),
    .L3_b_2_channel1_unit6 (weight2_mem[5] ),.L3_b_2_channel2_unit6 (weight2_mem[30]),.L3_b_2_channel3_unit6 (weight2_mem[55]),.L3_b_2_channel4_unit6 (weight2_mem[80]),.L3_b_2_channel5_unit6 (weight1_mem[105]),.L3_b_2_channel6_unit6 (weight1_mem[130]),
    .L3_b_2_channel1_unit7 (weight2_mem[6] ),.L3_b_2_channel2_unit7 (weight2_mem[31]),.L3_b_2_channel3_unit7 (weight2_mem[56]),.L3_b_2_channel4_unit7 (weight2_mem[81]),.L3_b_2_channel5_unit7 (weight1_mem[106]),.L3_b_2_channel6_unit7 (weight1_mem[131]),
    .L3_b_2_channel1_unit8 (weight2_mem[7] ),.L3_b_2_channel2_unit8 (weight2_mem[32]),.L3_b_2_channel3_unit8 (weight2_mem[57]),.L3_b_2_channel4_unit8 (weight2_mem[82]),.L3_b_2_channel5_unit8 (weight1_mem[107]),.L3_b_2_channel6_unit8 (weight1_mem[132]),
    .L3_b_2_channel1_unit9 (weight2_mem[8] ),.L3_b_2_channel2_unit9 (weight2_mem[33]),.L3_b_2_channel3_unit9 (weight2_mem[58]),.L3_b_2_channel4_unit9 (weight2_mem[83]),.L3_b_2_channel5_unit9 (weight1_mem[108]),.L3_b_2_channel6_unit9 (weight1_mem[133]),
    .L3_b_2_channel1_unit10(weight2_mem[9] ),.L3_b_2_channel2_unit10(weight2_mem[34]),.L3_b_2_channel3_unit10(weight2_mem[59]),.L3_b_2_channel4_unit10(weight2_mem[84]),.L3_b_2_channel5_unit10(weight1_mem[109]),.L3_b_2_channel6_unit10(weight1_mem[134]),
    .L3_b_2_channel1_unit11(weight2_mem[10]),.L3_b_2_channel2_unit11(weight2_mem[35]),.L3_b_2_channel3_unit11(weight2_mem[60]),.L3_b_2_channel4_unit11(weight2_mem[85]),.L3_b_2_channel5_unit11(weight1_mem[110]),.L3_b_2_channel6_unit11(weight1_mem[135]),
    .L3_b_2_channel1_unit12(weight2_mem[11]),.L3_b_2_channel2_unit12(weight2_mem[36]),.L3_b_2_channel3_unit12(weight2_mem[61]),.L3_b_2_channel4_unit12(weight2_mem[86]),.L3_b_2_channel5_unit12(weight1_mem[111]),.L3_b_2_channel6_unit12(weight1_mem[136]),
    .L3_b_2_channel1_unit13(weight2_mem[12]),.L3_b_2_channel2_unit13(weight2_mem[37]),.L3_b_2_channel3_unit13(weight2_mem[62]),.L3_b_2_channel4_unit13(weight2_mem[87]),.L3_b_2_channel5_unit13(weight1_mem[112]),.L3_b_2_channel6_unit13(weight1_mem[137]),
    .L3_b_2_channel1_unit14(weight2_mem[13]),.L3_b_2_channel2_unit14(weight2_mem[38]),.L3_b_2_channel3_unit14(weight2_mem[63]),.L3_b_2_channel4_unit14(weight2_mem[88]),.L3_b_2_channel5_unit14(weight1_mem[113]),.L3_b_2_channel6_unit14(weight1_mem[138]),
    .L3_b_2_channel1_unit15(weight2_mem[14]),.L3_b_2_channel2_unit15(weight2_mem[39]),.L3_b_2_channel3_unit15(weight2_mem[64]),.L3_b_2_channel4_unit15(weight2_mem[89]),.L3_b_2_channel5_unit15(weight1_mem[114]),.L3_b_2_channel6_unit15(weight1_mem[139]),
    .L3_b_2_channel1_unit16(weight2_mem[15]),.L3_b_2_channel2_unit16(weight2_mem[40]),.L3_b_2_channel3_unit16(weight2_mem[65]),.L3_b_2_channel4_unit16(weight2_mem[90]),.L3_b_2_channel5_unit16(weight1_mem[115]),.L3_b_2_channel6_unit16(weight1_mem[140]),
    .L3_b_2_channel1_unit17(weight2_mem[16]),.L3_b_2_channel2_unit17(weight2_mem[41]),.L3_b_2_channel3_unit17(weight2_mem[66]),.L3_b_2_channel4_unit17(weight2_mem[91]),.L3_b_2_channel5_unit17(weight1_mem[116]),.L3_b_2_channel6_unit17(weight1_mem[141]),
    .L3_b_2_channel1_unit18(weight2_mem[17]),.L3_b_2_channel2_unit18(weight2_mem[42]),.L3_b_2_channel3_unit18(weight2_mem[67]),.L3_b_2_channel4_unit18(weight2_mem[92]),.L3_b_2_channel5_unit18(weight1_mem[117]),.L3_b_2_channel6_unit18(weight1_mem[142]),
    .L3_b_2_channel1_unit19(weight2_mem[18]),.L3_b_2_channel2_unit19(weight2_mem[43]),.L3_b_2_channel3_unit19(weight2_mem[68]),.L3_b_2_channel4_unit19(weight2_mem[93]),.L3_b_2_channel5_unit19(weight1_mem[118]),.L3_b_2_channel6_unit19(weight1_mem[143]),
    .L3_b_2_channel1_unit20(weight2_mem[19]),.L3_b_2_channel2_unit20(weight2_mem[44]),.L3_b_2_channel3_unit20(weight2_mem[69]),.L3_b_2_channel4_unit20(weight2_mem[94]),.L3_b_2_channel5_unit20(weight1_mem[119]),.L3_b_2_channel6_unit20(weight1_mem[144]),
    .L3_b_2_channel1_unit21(weight2_mem[20]),.L3_b_2_channel2_unit21(weight2_mem[45]),.L3_b_2_channel3_unit21(weight2_mem[70]),.L3_b_2_channel4_unit21(weight2_mem[95]),.L3_b_2_channel5_unit21(weight1_mem[120]),.L3_b_2_channel6_unit21(weight1_mem[145]),
    .L3_b_2_channel1_unit22(weight2_mem[21]),.L3_b_2_channel2_unit22(weight2_mem[46]),.L3_b_2_channel3_unit22(weight2_mem[71]),.L3_b_2_channel4_unit22(weight2_mem[96]),.L3_b_2_channel5_unit22(weight1_mem[121]),.L3_b_2_channel6_unit22(weight1_mem[146]),
    .L3_b_2_channel1_unit23(weight2_mem[22]),.L3_b_2_channel2_unit23(weight2_mem[47]),.L3_b_2_channel3_unit23(weight2_mem[72]),.L3_b_2_channel4_unit23(weight2_mem[97]),.L3_b_2_channel5_unit23(weight1_mem[122]),.L3_b_2_channel6_unit23(weight1_mem[147]),
    .L3_b_2_channel1_unit24(weight2_mem[23]),.L3_b_2_channel2_unit24(weight2_mem[48]),.L3_b_2_channel3_unit24(weight2_mem[73]),.L3_b_2_channel4_unit24(weight2_mem[98]),.L3_b_2_channel5_unit24(weight1_mem[123]),.L3_b_2_channel6_unit24(weight1_mem[148]),
    .L3_b_2_channel1_unit25(weight2_mem[24]),.L3_b_2_channel2_unit25(weight2_mem[49]),.L3_b_2_channel3_unit25(weight2_mem[74]),.L3_b_2_channel4_unit25(weight2_mem[99]),.L3_b_2_channel5_unit25(weight1_mem[124]),.L3_b_2_channel6_unit25(weight1_mem[149]),



    .L3_bias_unit1(bias1_mem),
    .L3_bias_unit2(bias2_mem),


    .out_result_a(con_result[0]),
    .out_result_b(con_result[1]),
    .out_result_c(con_result[2]),
    .out_result_d(con_result[3]),
    .out_result_e(con_result[4]),
    .out_result_f(con_result[5]),
    .out_result_g(con_result[6]),
    .out_result_h(con_result[7]),
    .out_result_i(con_result[8]),
    .out_result_j(con_result[9]),
    .out_result_k(con_result[10]),
    .out_result_l(con_result[11])

    );




  integer i,j;

  //weight memory 
  always@(posedge clk)begin
    if(L1_load_wait == 2'b10)begin
        for(i = 0; i< 4'd6 ; i = i + 1)begin
          if(L1_w_load_done == 1'b1)begin
              bias[i] <= bias[i];
          end
          else if(i == weight_channel && weight_index == 25)begin
              bias[i] <= L1_w_data;                        
          end
          else begin
              bias[i] <= bias[i];
          end
      end
    end
    else if(L1_en == 1'b0)begin
      for(i = 0; i< 4'd6 ; i = i + 1)begin    
              bias[i] <= 1'b0;
      end
    end
    else begin
        for(i = 0; i< 6 ; i = i + 1)begin    
              bias[i] <= bias[i];
        end
    end
    

    if(L1_load_wait == 2'b10)begin
        for(i = 0; i <4'd6 ; i = i+1)begin
            for(j = 0; j< 5'd25 ; j = j + 1)begin
                if(i== weight_channel && j == weight_index)begin
                    weight[i][j] <= L1_w_data;        
                end   
                else begin
                    weight[i][j] <= weight[i][j];        
                end
            end    
        end  
    end
    else if(L1_en == 1'b0)begin
        for(i = 0; i <4'd6 ; i = i+1)begin
          for(j = 0; j< 5'd25 ; j = j + 1)begin
                  weight[i][j] <= 1'b0;                        
          end    
      end
    end

    else begin
      for(i = 0; i <4'd6 ; i = i+1)begin
          for(j = 0; j< 5'd25 ; j = j + 1)begin
                  weight[i][j] <= weight[i][j];                        
          end    
      end  
    end
  end

  //input data index
  always@(posedge clk)begin
    //load register 시간에 input memory는 32*5를 채워야하니까
    if(L1_load_wait == 2'b10)begin
          //load 5 col
      if(L1_position_col < 3'd5)begin
        for(i = 0; i < 4'd5 ; i = i + 1)begin
            for(j = 0 ; j < 6'd32 ; j = j + 1)begin
                if(L1_position_col == i) inp[i][j] <= L1_in_data[j*12 +: 12];
                else inp[i][j] <= inp[i][j];
            end
        end
      end
      else begin
        for(i = 0; i < 3'd5 ; i = i + 1)begin
            for(j = 0 ; j < 6'd32 ; j = j + 1)begin
                inp[i][j] <= inp[i][j];
            end
        end
      end
    end
    //end st==load_w


    //st == calculation 
    //shift 0~4 and load 5
    // 1 --> 0
    // 2 --> 1
    // 3 --> 2
    // 4 --> 3
    // new_data --> 4
        
    else if(L1_cal_wait == 2'b11)begin
      if(L1_row_cnt == 5'd27)begin
          for(i = 0; i < 3'd5 ; i = i + 1)begin
            for(j = 0 ; j < 6'd32 ; j = j + 1)begin
                //load new data
                if(4 == i)begin
                    inp[i][j] <= L1_in_data[j*12 +: 12];
                end
                
                //shift col
                else begin
                    inp[i][j] <= inp[i+1][j];
                end
            end
        end
      end
      else begin
          for(i = 0; i < 3'd5 ; i = i + 1)begin
              for(j = 0 ; j < 6'd32 ; j = j + 1)begin
                  inp[i][j] <= inp[i][j];
              end
          end
      end
    end
    //end st == calculation
    
    // other state

    else if( L1_en == 1'b0)begin
      for(i = 0; i < 3'd5 ; i = i + 1)begin
          for(j = 0 ; j < 6'd32 ; j = j + 1)begin
              inp[i][j] <= 1'b0;
          end
        end
    end


    else begin
        for(i = 0; i < 3'd5 ; i = i + 1)begin
          for(j = 0 ; j < 6'd32 ; j = j + 1)begin
              inp[i][j] <= inp[i][j];
          end
      end
    end
  end

  //L1,L2 memory
  //w:12 d:5*5*6 + 6   addra [7:0] dout[11:0]
  con1_w_mem L1_weight_mem (.clka(clk),.addra(L1_w_addr),.douta(L1_w_data)  );
  // command center
  control top_control(.clk(clk),.rst(rst),.start(start),.L1_done(L1_done),.L3_done(L3_done),.L1_en(L1_en),.L3_en(L3_en),.finish(finish));
  // w:12*32 d:32  input addr[9:0] dina[11:0] output addr[4:0] dout[383:0]
  Input_ram input_ram (.clka(clk),.wea(1'b0),.addra(10'b0),.dina(12'b0),.clkb(clk),.addrb(L1_in_addr),.doutb(L1_in_data));

  //layer 2 output block memory params
  wire L2_feature_wea;
  wire [7:0] L2_feature_addr_write;
  wire [7:0] L2_feature_addr_read_s;
  wire [7:0] L2_feature_addr_read_r;
  wire [7:0] L2_mem_addr_read;

  wire [11:0] L2_feature1_dina;
  wire [11:0] L2_feature2_dina;
  wire [11:0] L2_feature3_dina;
  wire [11:0] L2_feature4_dina;
  wire [11:0] L2_feature5_dina;
  wire [11:0] L2_feature6_dina;

  wire [11:0] L2_feature1_dout;
  wire [11:0] L2_feature2_dout;
  wire [11:0] L2_feature3_dout;
  wire [11:0] L2_feature4_dout;
  wire [11:0] L2_feature5_dout;
  wire [11:0] L2_feature6_dout;

//layer front (layer1 & layer2)
  front_layer_wrapper L1_L2_wrapper(
      .clk(clk),.rst(rst),
      //L1 params
      .L1_en(L1_en),
      .L1_in_data(L1_in_data),
      .L1_done(L1_done),
      .L1_w_addr(L1_w_addr),
      .L1_in_addr(L1_in_addr),
      .L1_w_data(L1_w_data),
      //weight load param
      .w_load_done(L1_w_load_done),
      .load_wait(L1_load_wait),
      .weight_index(weight_index),
      .weight_channel(weight_channel),
      .w_load_en(L1_w_load_en),
      //conv result
      .con_result_1(con_result[0]),
      .con_result_2(con_result[1]),
      .con_result_3(con_result[2]),
      .con_result_4(con_result[3]),
      .con_result_5(con_result[4]),
      .con_result_6(con_result[5]),
      //L2 output block memory
      .L2_out1_dout(L2_feature1_dout),
      .L2_out2_dout(L2_feature2_dout),
      .L2_out3_dout(L2_feature3_dout),
      .L2_out4_dout(L2_feature4_dout),
      .L2_out5_dout(L2_feature5_dout),
      .L2_out6_dout(L2_feature6_dout),
      .L2_out1_din(L2_feature1_dina),
      .L2_out2_din(L2_feature2_dina),
      .L2_out3_din(L2_feature3_dina),
      .L2_out4_din(L2_feature4_dina),
      .L2_out5_din(L2_feature5_dina),
      .L2_out6_din(L2_feature6_dina),
      .row_cnt(L1_row_cnt),
      .L2_out_addr_read(L2_feature_addr_read_s),
      .L2_out_addr_write(L2_feature_addr_write),
      .L2_out_wea(L2_feature_wea),
      //other flags
      .cal_wait(L1_cal_wait),
      .position_col(L1_position_col),
      .in_cell_row(in_cell_row),
      .in_cell_col(in_cell_col),
      .st(front_st)
  ); 

  //layer2 output block memory
  layer_2_output feature1 (.clka(clk),.wea(L2_feature_wea),.addra(L2_feature_addr_write),.dina(L2_feature1_dina),.clkb(clk),.addrb(L2_mem_addr_read),.doutb(L2_feature1_dout));
  layer_2_output feature2 (.clka(clk),.wea(L2_feature_wea),.addra(L2_feature_addr_write),.dina(L2_feature2_dina),.clkb(clk),.addrb(L2_mem_addr_read),.doutb(L2_feature2_dout));
  layer_2_output feature3 (.clka(clk),.wea(L2_feature_wea),.addra(L2_feature_addr_write),.dina(L2_feature3_dina),.clkb(clk),.addrb(L2_mem_addr_read),.doutb(L2_feature3_dout));
  layer_2_output feature4 (.clka(clk),.wea(L2_feature_wea),.addra(L2_feature_addr_write),.dina(L2_feature4_dina),.clkb(clk),.addrb(L2_mem_addr_read),.doutb(L2_feature4_dout));
  layer_2_output feature5 (.clka(clk),.wea(L2_feature_wea),.addra(L2_feature_addr_write),.dina(L2_feature5_dina),.clkb(clk),.addrb(L2_mem_addr_read),.doutb(L2_feature5_dout));
  layer_2_output feature6 (.clka(clk),.wea(L2_feature_wea),.addra(L2_feature_addr_write),.dina(L2_feature6_dina),.clkb(clk),.addrb(L2_mem_addr_read),.doutb(L2_feature6_dout));

  assign L2_mem_addr_read = (L1_en == 1'b1) ? L2_feature_addr_read_s:(L3_en == 1'b1) ? L2_feature_addr_read_r : 1'b0;  





/////////////////////////// 
  wire [7:0] L4_output_read_addr;
  wire [11:0] L4_output_read_data1;
  wire [11:0] L4_output_read_data2;

  wire [7:0] L4_output_write_addr;
  wire [11:0] L4_output_write_data1;
  wire [11:0] L4_output_write_data2;

  wire L4_output_wea;


  wire [11:0] L3_weight_douta;
  wire [11:0] L3_weight_doutb;
  wire [11:0] L3_weight_addra;
  wire [11:0] L3_weight_addrb;
  
  
  wire [3:0] L3_input_height_count;
  wire [3:0] L3_input_width_count;
  wire [1:0] L3_input_wait;
  wire [2:0] L3_wait_weight;
  wire L3_inp_load_done;
  wire L3_load_weight_done;

  wire [11:0] cur_filter_count;
 

  middle_layer_wrapper L3_L4_wrapper(
    .clk(clk),
    .rst(rst),
    .L3_en(L3_en),
    //L3 weight blcok memory
    .L3_weight_douta(L3_weight_douta),
    .L3_weight_doutb(L3_weight_doutb),
    .L3_weight_addra(L3_weight_addra),
    .L3_weight_addrb(L3_weight_addrb),
    //L2 output block memory
    // .L2_feature1_douta(L2_feature1_dout),
    // .L2_feature2_douta(L2_feature2_dout),
    // .L2_feature3_douta(L2_feature3_dout),
    // .L2_feature4_douta(L2_feature4_dout),
    // .L2_feature5_douta(L2_feature5_dout),
    // .L2_feature6_douta(L2_feature6_dout),
    .L2_feature_addr_read(L2_feature_addr_read_r),
    //convoultion result
    .con_result_1(con_result[0]),
    .con_result_2(con_result[1]),
    .con_result_3(con_result[2]),
    .con_result_4(con_result[3]),
    .con_result_5(con_result[4]),
    .con_result_6(con_result[5]),
    .con_result_7(con_result[6]),
    .con_result_8(con_result[7]),
    .con_result_9(con_result[8]),
    .con_result_10(con_result[9]),
    .con_result_11(con_result[10]),
    .con_result_12(con_result[11]),
    

    //output block memory
    .L4_output_read_data1(L4_output_read_data1),
    .L4_output_read_data2(L4_output_read_data2),
    .L4_output_read_addr(L4_output_read_addr),
    .L4_output_write_addr(L4_output_write_addr),
    .L4_output_write_data1(L4_output_write_data1),
    .L4_output_write_data2(L4_output_write_data2),
    .L4_output_wea(L4_output_wea),
     //other params
    .cur_input_height_count(L3_input_height_count),
    .cur_input_width_count(L3_input_width_count),
    .inp_wait(L3_input_wait),
    .wait_weight(L3_wait_weight),
    .inp_load_done(L3_inp_load_done),
    .load_weight_done(L3_load_weight_done),
    .cur_filter_count(L3_cur_filter_count),
    .col(col),
    .row(row),
    .L3_done(L3_done)
    
  );


  //L3 input memory load
  always@(posedge clk)begin
    if(L3_input_wait == 2'b10 && L3_inp_load_done == 1'b0)begin
      for(i = 0; i< L3_INPUT_HEIGHT ;i = i + 1)begin
        for(j = 0; j< L3_INPUT_WIDTH ; j = j + 1)begin
            if(L3_input_height_count == i && L3_input_width_count == j )begin
              input_mem [0][i][j] <= L2_feature1_dout;
              input_mem [1][i][j] <= L2_feature2_dout;
              input_mem [2][i][j] <= L2_feature3_dout;
              input_mem [3][i][j] <= L2_feature4_dout;
              input_mem [4][i][j] <= L2_feature5_dout;
              input_mem [5][i][j] <= L2_feature6_dout;
            end
            else begin
              input_mem [0][i][j] <= input_mem[0][i][j];
              input_mem [1][i][j] <= input_mem[1][i][j];
              input_mem [2][i][j] <= input_mem[2][i][j];
              input_mem [3][i][j] <= input_mem[3][i][j];
              input_mem [4][i][j] <= input_mem[4][i][j];
              input_mem [5][i][j] <= input_mem[5][i][j];
            end   
        end
      end
    end
    else begin
      for(i = 0; i < L3_INPUT_HEIGHT ;i = i + 1)begin
        for(j = 0; j < L3_INPUT_WIDTH ; j = j + 1)begin
          input_mem [0][i][j] <= input_mem [0][i][j];
          input_mem [1][i][j] <= input_mem [1][i][j];
          input_mem [2][i][j] <= input_mem [2][i][j];
          input_mem [3][i][j] <= input_mem [3][i][j];
          input_mem [4][i][j] <= input_mem [4][i][j];
          input_mem [5][i][j] <= input_mem [5][i][j];
        end
      end
    end
  end

  //L3 filter load
   always@(posedge clk)begin
        if(L3_wait_weight == 2'b11 && L3_load_weight_done == 1'b0)begin
            for(i = 0; i< 8'd150 ;i = i + 1)begin
                if(L3_cur_filter_count == i )begin
                    weight1_mem [i] <= L3_weight_douta;
                    weight2_mem [i] <= L3_weight_doutb;
                end
                else begin
                    weight1_mem [i] <= weight1_mem [i];
                    weight2_mem [i] <= weight2_mem [i];
                end
            end

            if(L3_cur_filter_count == L3_FILTER_SIZE - 1)begin
                bias1_mem <= L3_weight_douta;
                bias2_mem <= L3_weight_doutb;
            end
            else begin
                bias2_mem <= bias2_mem;
                bias1_mem <= bias1_mem;
            end
        end

        else begin
            for(i = 0; i< 8'd150 ;i = i + 1)begin
                weight1_mem [i] <=  weight1_mem [i];
                weight2_mem [i] <=  weight2_mem [i];
            end
                bias1_mem <= bias1_mem;
                bias2_mem <= bias2_mem;
        end
    end


  //layer3 weight block memory
  con3_w_mem L3_weight_mem (
    .clka(clk),    // input wire clka
    .addra(L3_weight_addra),  // input wire [11 : 0] addra
    .douta(L3_weight_douta),  // output wire [11 : 0] douta
    .clkb(clk),    // input wire clkb
    .addrb(L3_weight_addrb),  // input wire [11 : 0] addrb
    .doutb(L3_weight_doutb)  // output wire [11 : 0] doutb
  );

  //layer 4 output block memory
  layer_4_output L4_feature1 (
    .clka(clk),    // input wire clka
    .wea(L4_output_wea),      // input wire [0 : 0] wea
    .addra(L4_output_write_addr),  // input wire [7 : 0] addra
    .dina(L4_output_write_data1),    // input wire [11 : 0] dina
    .clkb(clk),    // input wire clkb
    .addrb(L4_output_read_addr),  // input wire [7 : 0] addrb
    .doutb(L4_output_read_data1)  // output wire [11 : 0] doutb
  );

  layer_4_output L4_feature2 (
    .clka(clk),    // input wire clka
    .wea(L4_output_wea),      // input wire [0 : 0] wea
    .addra(L4_output_write_addr),  // input wire [7 : 0] addra
    .dina(L4_output_write_data2),    // input wire [11 : 0] dina
    .clkb(clk),    // input wire clkb
    .addrb(L4_output_read_addr),  // input wire [7 : 0] addrb
    .doutb(L4_output_read_data2)  // output wire [11 : 0] doutb
  );


  assign out_d = L4_output_write_data1[6:0];

endmodule
