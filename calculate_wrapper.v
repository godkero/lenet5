`timescale 1ns / 1ps

module calculate_wrapper(
    input clk,
    input L1_en,
    input L3_en,
    input [11:0]  L1_inp_unit1 ,
    input [11:0]  L1_inp_unit2 ,
    input [11:0]  L1_inp_unit3 ,
    input [11:0]  L1_inp_unit4 ,
    input [11:0]  L1_inp_unit5 ,
    input [11:0]  L1_inp_unit6 ,
    input [11:0]  L1_inp_unit7 ,
    input [11:0]  L1_inp_unit8 ,
    input [11:0]  L1_inp_unit9 ,
    input [11:0]  L1_inp_unit10,
    input [11:0]  L1_inp_unit11,
    input [11:0]  L1_inp_unit12,
    input [11:0]  L1_inp_unit13,
    input [11:0]  L1_inp_unit14,
    input [11:0]  L1_inp_unit15,
    input [11:0]  L1_inp_unit16,
    input [11:0]  L1_inp_unit17,
    input [11:0]  L1_inp_unit18,
    input [11:0]  L1_inp_unit19,
    input [11:0]  L1_inp_unit20,
    input [11:0]  L1_inp_unit21,
    input [11:0]  L1_inp_unit22,
    input [11:0]  L1_inp_unit23,
    input [11:0]  L1_inp_unit24,
    input [11:0]  L1_inp_unit25,

    input [11:0]  L1_weight_unit1_channel1,
    input [11:0]  L1_weight_unit2_channel1,
    input [11:0]  L1_weight_unit3_channel1,
    input [11:0]  L1_weight_unit4_channel1,
    input [11:0]  L1_weight_unit5_channel1,
    input [11:0]  L1_weight_unit6_channel1,
    input [11:0]  L1_weight_unit7_channel1,
    input [11:0]  L1_weight_unit8_channel1,
    input [11:0]  L1_weight_unit9_channel1,
    input [11:0] L1_weight_unit10_channel1,
    input [11:0] L1_weight_unit11_channel1,
    input [11:0] L1_weight_unit12_channel1,
    input [11:0] L1_weight_unit13_channel1,
    input [11:0] L1_weight_unit14_channel1,
    input [11:0] L1_weight_unit15_channel1,
    input [11:0] L1_weight_unit16_channel1,
    input [11:0] L1_weight_unit17_channel1,
    input [11:0] L1_weight_unit18_channel1,
    input [11:0] L1_weight_unit19_channel1,
    input [11:0] L1_weight_unit20_channel1,
    input [11:0] L1_weight_unit21_channel1,
    input [11:0] L1_weight_unit22_channel1,
    input [11:0] L1_weight_unit23_channel1,
    input [11:0] L1_weight_unit24_channel1,
    input [11:0] L1_weight_unit25_channel1,
    input [11:0]  L1_weight_unit1_channel2,
    input [11:0]  L1_weight_unit2_channel2,
    input [11:0]  L1_weight_unit3_channel2,
    input [11:0]  L1_weight_unit4_channel2,
    input [11:0]  L1_weight_unit5_channel2,
    input [11:0]  L1_weight_unit6_channel2,
    input [11:0]  L1_weight_unit7_channel2,
    input [11:0]  L1_weight_unit8_channel2,
    input [11:0]  L1_weight_unit9_channel2,
    input [11:0] L1_weight_unit10_channel2,
    input [11:0] L1_weight_unit11_channel2,
    input [11:0] L1_weight_unit12_channel2,
    input [11:0] L1_weight_unit13_channel2,
    input [11:0] L1_weight_unit14_channel2,
    input [11:0] L1_weight_unit15_channel2,
    input [11:0] L1_weight_unit16_channel2,
    input [11:0] L1_weight_unit17_channel2,
    input [11:0] L1_weight_unit18_channel2,
    input [11:0] L1_weight_unit19_channel2,
    input [11:0] L1_weight_unit20_channel2,
    input [11:0] L1_weight_unit21_channel2,
    input [11:0] L1_weight_unit22_channel2,
    input [11:0] L1_weight_unit23_channel2,
    input [11:0] L1_weight_unit24_channel2,
    input [11:0] L1_weight_unit25_channel2,
    input [11:0]  L1_weight_unit1_channel3,
    input [11:0]  L1_weight_unit2_channel3,
    input [11:0]  L1_weight_unit3_channel3,
    input [11:0]  L1_weight_unit4_channel3,
    input [11:0]  L1_weight_unit5_channel3,
    input [11:0]  L1_weight_unit6_channel3,
    input [11:0]  L1_weight_unit7_channel3,
    input [11:0]  L1_weight_unit8_channel3,
    input [11:0]  L1_weight_unit9_channel3,
    input [11:0] L1_weight_unit10_channel3,
    input [11:0] L1_weight_unit11_channel3,
    input [11:0] L1_weight_unit12_channel3,
    input [11:0] L1_weight_unit13_channel3,
    input [11:0] L1_weight_unit14_channel3,
    input [11:0] L1_weight_unit15_channel3,
    input [11:0] L1_weight_unit16_channel3,
    input [11:0] L1_weight_unit17_channel3,
    input [11:0] L1_weight_unit18_channel3,
    input [11:0] L1_weight_unit19_channel3,
    input [11:0] L1_weight_unit20_channel3,
    input [11:0] L1_weight_unit21_channel3,
    input [11:0] L1_weight_unit22_channel3,
    input [11:0] L1_weight_unit23_channel3,
    input [11:0] L1_weight_unit24_channel3,
    input [11:0] L1_weight_unit25_channel3,
    input [11:0]  L1_weight_unit1_channel4,
    input [11:0]  L1_weight_unit2_channel4,
    input [11:0]  L1_weight_unit3_channel4,
    input [11:0]  L1_weight_unit4_channel4,
    input [11:0]  L1_weight_unit5_channel4,
    input [11:0]  L1_weight_unit6_channel4,
    input [11:0]  L1_weight_unit7_channel4,
    input [11:0]  L1_weight_unit8_channel4,
    input [11:0]  L1_weight_unit9_channel4,
    input [11:0] L1_weight_unit10_channel4,
    input [11:0] L1_weight_unit11_channel4,
    input [11:0] L1_weight_unit12_channel4,
    input [11:0] L1_weight_unit13_channel4,
    input [11:0] L1_weight_unit14_channel4,
    input [11:0] L1_weight_unit15_channel4,
    input [11:0] L1_weight_unit16_channel4,
    input [11:0] L1_weight_unit17_channel4,
    input [11:0] L1_weight_unit18_channel4,
    input [11:0] L1_weight_unit19_channel4,
    input [11:0] L1_weight_unit20_channel4,
    input [11:0] L1_weight_unit21_channel4,
    input [11:0] L1_weight_unit22_channel4,
    input [11:0] L1_weight_unit23_channel4,
    input [11:0] L1_weight_unit24_channel4,
    input [11:0] L1_weight_unit25_channel4,
    input [11:0]  L1_weight_unit1_channel5,
    input [11:0]  L1_weight_unit2_channel5,
    input [11:0]  L1_weight_unit3_channel5,
    input [11:0]  L1_weight_unit4_channel5,
    input [11:0]  L1_weight_unit5_channel5,
    input [11:0]  L1_weight_unit6_channel5,
    input [11:0]  L1_weight_unit7_channel5,
    input [11:0]  L1_weight_unit8_channel5,
    input [11:0]  L1_weight_unit9_channel5,
    input [11:0] L1_weight_unit10_channel5,
    input [11:0] L1_weight_unit11_channel5,
    input [11:0] L1_weight_unit12_channel5,
    input [11:0] L1_weight_unit13_channel5,
    input [11:0] L1_weight_unit14_channel5,
    input [11:0] L1_weight_unit15_channel5,
    input [11:0] L1_weight_unit16_channel5,
    input [11:0] L1_weight_unit17_channel5,
    input [11:0] L1_weight_unit18_channel5,
    input [11:0] L1_weight_unit19_channel5,
    input [11:0] L1_weight_unit20_channel5,
    input [11:0] L1_weight_unit21_channel5,
    input [11:0] L1_weight_unit22_channel5,
    input [11:0] L1_weight_unit23_channel5,
    input [11:0] L1_weight_unit24_channel5,
    input [11:0] L1_weight_unit25_channel5,
    input [11:0]  L1_weight_unit1_channel6,
    input [11:0]  L1_weight_unit2_channel6,
    input [11:0]  L1_weight_unit3_channel6,
    input [11:0]  L1_weight_unit4_channel6,
    input [11:0]  L1_weight_unit5_channel6,
    input [11:0]  L1_weight_unit6_channel6,
    input [11:0]  L1_weight_unit7_channel6,
    input [11:0]  L1_weight_unit8_channel6,
    input [11:0]  L1_weight_unit9_channel6,
    input [11:0] L1_weight_unit10_channel6,
    input [11:0] L1_weight_unit11_channel6,
    input [11:0] L1_weight_unit12_channel6,
    input [11:0] L1_weight_unit13_channel6,
    input [11:0] L1_weight_unit14_channel6,
    input [11:0] L1_weight_unit15_channel6,
    input [11:0] L1_weight_unit16_channel6,
    input [11:0] L1_weight_unit17_channel6,
    input [11:0] L1_weight_unit18_channel6,
    input [11:0] L1_weight_unit19_channel6,
    input [11:0] L1_weight_unit20_channel6,
    input [11:0] L1_weight_unit21_channel6,
    input [11:0] L1_weight_unit22_channel6,
    input [11:0] L1_weight_unit23_channel6,
    input [11:0] L1_weight_unit24_channel6,
    input [11:0] L1_weight_unit25_channel6,
    input [11:0] L1_bias_unit1,
    input [11:0] L1_bias_unit2,
    input [11:0] L1_bias_unit3,
    input [11:0] L1_bias_unit4,
    input [11:0] L1_bias_unit5,
    input [11:0] L1_bias_unit6,

    output [11:0] out_result_a,
    output [11:0] out_result_b,
    output [11:0] out_result_c,
    output [11:0] out_result_d,
    output [11:0] out_result_e,
    output [11:0] out_result_f


    // `L1_INSTANCE_PORT
    );


    wire [11:0] in_a [0:5][0:24];
    wire [11:0] in_b [0:5][0:24];
    wire [11:0] L1_bias[0:5];

    wire [11:0] out_temp[0:5];
    
    //input a assign
    assign in_a[0][0 ] = L1_en  ? L1_inp_unit1 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][1 ] = L1_en  ? L1_inp_unit2 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][2 ] = L1_en  ? L1_inp_unit3 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][3 ] = L1_en  ? L1_inp_unit4 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][4 ] = L1_en  ? L1_inp_unit5 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][5 ] = L1_en  ? L1_inp_unit6 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][6 ] = L1_en  ? L1_inp_unit7 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][7 ] = L1_en  ? L1_inp_unit8 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][8 ] = L1_en  ? L1_inp_unit9 : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][9 ] = L1_en ? L1_inp_unit10 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][10] = L1_en ? L1_inp_unit11 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][11] = L1_en ? L1_inp_unit12 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][12] = L1_en ? L1_inp_unit13 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][13] = L1_en ? L1_inp_unit14 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][14] = L1_en ? L1_inp_unit15 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][15] = L1_en ? L1_inp_unit16 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][16] = L1_en ? L1_inp_unit17 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][17] = L1_en ? L1_inp_unit18 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][18] = L1_en ? L1_inp_unit19 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][19] = L1_en ? L1_inp_unit20 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][20] = L1_en ? L1_inp_unit21 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][21] = L1_en ? L1_inp_unit22 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][22] = L1_en ? L1_inp_unit23 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][23] = L1_en ? L1_inp_unit24 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[0][24] = L1_en ? L1_inp_unit25 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_a[1][0 ] = L1_en  ? L1_inp_unit1 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][1 ] = L1_en  ? L1_inp_unit2 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][2 ] = L1_en  ? L1_inp_unit3 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][3 ] = L1_en  ? L1_inp_unit4 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][4 ] = L1_en  ? L1_inp_unit5 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][5 ] = L1_en  ? L1_inp_unit6 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][6 ] = L1_en  ? L1_inp_unit7 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][7 ] = L1_en  ? L1_inp_unit8 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][8 ] = L1_en  ? L1_inp_unit9 : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][9 ] = L1_en ? L1_inp_unit10 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][10] = L1_en ? L1_inp_unit11 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][11] = L1_en ? L1_inp_unit12 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][12] = L1_en ? L1_inp_unit13 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][13] = L1_en ? L1_inp_unit14 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][14] = L1_en ? L1_inp_unit15 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][15] = L1_en ? L1_inp_unit16 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][16] = L1_en ? L1_inp_unit17 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][17] = L1_en ? L1_inp_unit18 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][18] = L1_en ? L1_inp_unit19 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][19] = L1_en ? L1_inp_unit20 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][20] = L1_en ? L1_inp_unit21 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][21] = L1_en ? L1_inp_unit22 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][22] = L1_en ? L1_inp_unit23 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][23] = L1_en ? L1_inp_unit24 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[1][24] = L1_en ? L1_inp_unit25 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_a[2][0 ] = L1_en  ? L1_inp_unit1 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][1 ] = L1_en  ? L1_inp_unit2 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][2 ] = L1_en  ? L1_inp_unit3 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][3 ] = L1_en  ? L1_inp_unit4 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][4 ] = L1_en  ? L1_inp_unit5 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][5 ] = L1_en  ? L1_inp_unit6 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][6 ] = L1_en  ? L1_inp_unit7 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][7 ] = L1_en  ? L1_inp_unit8 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][8 ] = L1_en  ? L1_inp_unit9 : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][9 ] = L1_en ? L1_inp_unit10 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][10] = L1_en ? L1_inp_unit11 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][11] = L1_en ? L1_inp_unit12 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][12] = L1_en ? L1_inp_unit13 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][13] = L1_en ? L1_inp_unit14 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][14] = L1_en ? L1_inp_unit15 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][15] = L1_en ? L1_inp_unit16 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][16] = L1_en ? L1_inp_unit17 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][17] = L1_en ? L1_inp_unit18 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][18] = L1_en ? L1_inp_unit19 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][19] = L1_en ? L1_inp_unit20 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][20] = L1_en ? L1_inp_unit21 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][21] = L1_en ? L1_inp_unit22 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][22] = L1_en ? L1_inp_unit23 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][23] = L1_en ? L1_inp_unit24 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[2][24] = L1_en ? L1_inp_unit25 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_a[3][0 ] = L1_en  ? L1_inp_unit1 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][1 ] = L1_en  ? L1_inp_unit2 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][2 ] = L1_en  ? L1_inp_unit3 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][3 ] = L1_en  ? L1_inp_unit4 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][4 ] = L1_en  ? L1_inp_unit5 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][5 ] = L1_en  ? L1_inp_unit6 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][6 ] = L1_en  ? L1_inp_unit7 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][7 ] = L1_en  ? L1_inp_unit8 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][8 ] = L1_en  ? L1_inp_unit9 : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][9 ] = L1_en ? L1_inp_unit10 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][10] = L1_en ? L1_inp_unit11 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][11] = L1_en ? L1_inp_unit12 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][12] = L1_en ? L1_inp_unit13 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][13] = L1_en ? L1_inp_unit14 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][14] = L1_en ? L1_inp_unit15 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][15] = L1_en ? L1_inp_unit16 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][16] = L1_en ? L1_inp_unit17 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][17] = L1_en ? L1_inp_unit18 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][18] = L1_en ? L1_inp_unit19 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][19] = L1_en ? L1_inp_unit20 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][20] = L1_en ? L1_inp_unit21 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][21] = L1_en ? L1_inp_unit22 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][22] = L1_en ? L1_inp_unit23 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][23] = L1_en ? L1_inp_unit24 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[3][24] = L1_en ? L1_inp_unit25 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_a[4][0 ] = L1_en  ? L1_inp_unit1 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][1 ] = L1_en  ? L1_inp_unit2 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][2 ] = L1_en  ? L1_inp_unit3 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][3 ] = L1_en  ? L1_inp_unit4 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][4 ] = L1_en  ? L1_inp_unit5 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][5 ] = L1_en  ? L1_inp_unit6 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][6 ] = L1_en  ? L1_inp_unit7 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][7 ] = L1_en  ? L1_inp_unit8 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][8 ] = L1_en  ? L1_inp_unit9 : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][9 ] = L1_en ? L1_inp_unit10 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][10] = L1_en ? L1_inp_unit11 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][11] = L1_en ? L1_inp_unit12 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][12] = L1_en ? L1_inp_unit13 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][13] = L1_en ? L1_inp_unit14 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][14] = L1_en ? L1_inp_unit15 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][15] = L1_en ? L1_inp_unit16 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][16] = L1_en ? L1_inp_unit17 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][17] = L1_en ? L1_inp_unit18 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][18] = L1_en ? L1_inp_unit19 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][19] = L1_en ? L1_inp_unit20 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][20] = L1_en ? L1_inp_unit21 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][21] = L1_en ? L1_inp_unit22 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][22] = L1_en ? L1_inp_unit23 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][23] = L1_en ? L1_inp_unit24 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[4][24] = L1_en ? L1_inp_unit25 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_a[5][0 ] = L1_en  ? L1_inp_unit1 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][1 ] = L1_en  ? L1_inp_unit2 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][2 ] = L1_en  ? L1_inp_unit3 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][3 ] = L1_en  ? L1_inp_unit4 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][4 ] = L1_en  ? L1_inp_unit5 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][5 ] = L1_en  ? L1_inp_unit6 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][6 ] = L1_en  ? L1_inp_unit7 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][7 ] = L1_en  ? L1_inp_unit8 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][8 ] = L1_en  ? L1_inp_unit9 : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][9 ] = L1_en ? L1_inp_unit10 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][10] = L1_en ? L1_inp_unit11 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][11] = L1_en ? L1_inp_unit12 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][12] = L1_en ? L1_inp_unit13 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][13] = L1_en ? L1_inp_unit14 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][14] = L1_en ? L1_inp_unit15 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][15] = L1_en ? L1_inp_unit16 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][16] = L1_en ? L1_inp_unit17 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][17] = L1_en ? L1_inp_unit18 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][18] = L1_en ? L1_inp_unit19 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][19] = L1_en ? L1_inp_unit20 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][20] = L1_en ? L1_inp_unit21 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][21] = L1_en ? L1_inp_unit22 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][22] = L1_en ? L1_inp_unit23 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][23] = L1_en ? L1_inp_unit24 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_a[5][24] = L1_en ? L1_inp_unit25 : L3_en ? L1_weight_unit10_channel6 : 1'b0;


    assign in_b[0][0] = L1_en  ? L1_weight_unit1_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][1] = L1_en  ? L1_weight_unit2_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][2] = L1_en  ? L1_weight_unit3_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][3] = L1_en  ? L1_weight_unit4_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][4] = L1_en  ? L1_weight_unit5_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][5] = L1_en  ? L1_weight_unit6_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][6] = L1_en  ? L1_weight_unit7_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][7] = L1_en  ? L1_weight_unit8_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][8] = L1_en  ? L1_weight_unit9_channel1  : L3_en  ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][9] = L1_en  ? L1_weight_unit10_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][10] = L1_en ? L1_weight_unit11_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][11] = L1_en ? L1_weight_unit12_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][12] = L1_en ? L1_weight_unit13_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][13] = L1_en ? L1_weight_unit14_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][14] = L1_en ? L1_weight_unit15_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][15] = L1_en ? L1_weight_unit16_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][16] = L1_en ? L1_weight_unit17_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][17] = L1_en ? L1_weight_unit18_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][18] = L1_en ? L1_weight_unit19_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][19] = L1_en ? L1_weight_unit20_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][20] = L1_en ? L1_weight_unit21_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][21] = L1_en ? L1_weight_unit22_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][22] = L1_en ? L1_weight_unit23_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][23] = L1_en ? L1_weight_unit24_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[0][24] = L1_en ? L1_weight_unit25_channel1 : L3_en ? L1_weight_unit10_channel1 : 1'b0;
    assign in_b[1][0] = L1_en  ? L1_weight_unit1_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][1] = L1_en  ? L1_weight_unit2_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][2] = L1_en  ? L1_weight_unit3_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][3] = L1_en  ? L1_weight_unit4_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][4] = L1_en  ? L1_weight_unit5_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][5] = L1_en  ? L1_weight_unit6_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][6] = L1_en  ? L1_weight_unit7_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][7] = L1_en  ? L1_weight_unit8_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][8] = L1_en  ? L1_weight_unit9_channel2  : L3_en  ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][9] = L1_en  ? L1_weight_unit10_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][10] = L1_en ? L1_weight_unit11_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][11] = L1_en ? L1_weight_unit12_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][12] = L1_en ? L1_weight_unit13_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][13] = L1_en ? L1_weight_unit14_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][14] = L1_en ? L1_weight_unit15_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][15] = L1_en ? L1_weight_unit16_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][16] = L1_en ? L1_weight_unit17_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][17] = L1_en ? L1_weight_unit18_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][18] = L1_en ? L1_weight_unit19_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][19] = L1_en ? L1_weight_unit20_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][20] = L1_en ? L1_weight_unit21_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][21] = L1_en ? L1_weight_unit22_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][22] = L1_en ? L1_weight_unit23_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][23] = L1_en ? L1_weight_unit24_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[1][24] = L1_en ? L1_weight_unit25_channel2 : L3_en ? L1_weight_unit10_channel2 : 1'b0;
    assign in_b[2][0] = L1_en  ? L1_weight_unit1_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][1] = L1_en  ? L1_weight_unit2_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][2] = L1_en  ? L1_weight_unit3_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][3] = L1_en  ? L1_weight_unit4_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][4] = L1_en  ? L1_weight_unit5_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][5] = L1_en  ? L1_weight_unit6_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][6] = L1_en  ? L1_weight_unit7_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][7] = L1_en  ? L1_weight_unit8_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][8] = L1_en  ? L1_weight_unit9_channel3  : L3_en  ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][9] = L1_en  ? L1_weight_unit10_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][10] = L1_en ? L1_weight_unit11_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][11] = L1_en ? L1_weight_unit12_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][12] = L1_en ? L1_weight_unit13_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][13] = L1_en ? L1_weight_unit14_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][14] = L1_en ? L1_weight_unit15_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][15] = L1_en ? L1_weight_unit16_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][16] = L1_en ? L1_weight_unit17_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][17] = L1_en ? L1_weight_unit18_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][18] = L1_en ? L1_weight_unit19_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][19] = L1_en ? L1_weight_unit20_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][20] = L1_en ? L1_weight_unit21_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][21] = L1_en ? L1_weight_unit22_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][22] = L1_en ? L1_weight_unit23_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][23] = L1_en ? L1_weight_unit24_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[2][24] = L1_en ? L1_weight_unit25_channel3 : L3_en ? L1_weight_unit10_channel3 : 1'b0;
    assign in_b[3][0] = L1_en  ? L1_weight_unit1_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][1] = L1_en  ? L1_weight_unit2_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][2] = L1_en  ? L1_weight_unit3_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][3] = L1_en  ? L1_weight_unit4_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][4] = L1_en  ? L1_weight_unit5_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][5] = L1_en  ? L1_weight_unit6_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][6] = L1_en  ? L1_weight_unit7_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][7] = L1_en  ? L1_weight_unit8_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][8] = L1_en  ? L1_weight_unit9_channel4  : L3_en  ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][9] = L1_en  ? L1_weight_unit10_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][10] = L1_en ? L1_weight_unit11_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][11] = L1_en ? L1_weight_unit12_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][12] = L1_en ? L1_weight_unit13_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][13] = L1_en ? L1_weight_unit14_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][14] = L1_en ? L1_weight_unit15_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][15] = L1_en ? L1_weight_unit16_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][16] = L1_en ? L1_weight_unit17_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][17] = L1_en ? L1_weight_unit18_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][18] = L1_en ? L1_weight_unit19_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][19] = L1_en ? L1_weight_unit20_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][20] = L1_en ? L1_weight_unit21_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][21] = L1_en ? L1_weight_unit22_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][22] = L1_en ? L1_weight_unit23_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][23] = L1_en ? L1_weight_unit24_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[3][24] = L1_en ? L1_weight_unit25_channel4 : L3_en ? L1_weight_unit10_channel4 : 1'b0;
    assign in_b[4][0] = L1_en  ? L1_weight_unit1_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][1] = L1_en  ? L1_weight_unit2_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][2] = L1_en  ? L1_weight_unit3_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][3] = L1_en  ? L1_weight_unit4_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][4] = L1_en  ? L1_weight_unit5_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][5] = L1_en  ? L1_weight_unit6_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][6] = L1_en  ? L1_weight_unit7_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][7] = L1_en  ? L1_weight_unit8_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][8] = L1_en  ? L1_weight_unit9_channel5  : L3_en  ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][9] = L1_en  ? L1_weight_unit10_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][10] = L1_en ? L1_weight_unit11_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][11] = L1_en ? L1_weight_unit12_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][12] = L1_en ? L1_weight_unit13_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][13] = L1_en ? L1_weight_unit14_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][14] = L1_en ? L1_weight_unit15_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][15] = L1_en ? L1_weight_unit16_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][16] = L1_en ? L1_weight_unit17_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][17] = L1_en ? L1_weight_unit18_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][18] = L1_en ? L1_weight_unit19_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][19] = L1_en ? L1_weight_unit20_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][20] = L1_en ? L1_weight_unit21_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][21] = L1_en ? L1_weight_unit22_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][22] = L1_en ? L1_weight_unit23_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][23] = L1_en ? L1_weight_unit24_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[4][24] = L1_en ? L1_weight_unit25_channel5 : L3_en ? L1_weight_unit10_channel5 : 1'b0;
    assign in_b[5][0] = L1_en  ? L1_weight_unit1_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][1] = L1_en  ? L1_weight_unit2_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][2] = L1_en  ? L1_weight_unit3_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][3] = L1_en  ? L1_weight_unit4_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][4] = L1_en  ? L1_weight_unit5_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][5] = L1_en  ? L1_weight_unit6_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][6] = L1_en  ? L1_weight_unit7_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][7] = L1_en  ? L1_weight_unit8_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][8] = L1_en  ? L1_weight_unit9_channel6  : L3_en  ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][9] = L1_en  ? L1_weight_unit10_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][10] = L1_en ? L1_weight_unit11_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][11] = L1_en ? L1_weight_unit12_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][12] = L1_en ? L1_weight_unit13_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][13] = L1_en ? L1_weight_unit14_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][14] = L1_en ? L1_weight_unit15_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][15] = L1_en ? L1_weight_unit16_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][16] = L1_en ? L1_weight_unit17_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][17] = L1_en ? L1_weight_unit18_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][18] = L1_en ? L1_weight_unit19_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][19] = L1_en ? L1_weight_unit20_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][20] = L1_en ? L1_weight_unit21_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][21] = L1_en ? L1_weight_unit22_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][22] = L1_en ? L1_weight_unit23_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][23] = L1_en ? L1_weight_unit24_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;
    assign in_b[5][24] = L1_en ? L1_weight_unit25_channel6 : L3_en ? L1_weight_unit10_channel6 : 1'b0;

    assign L1_bias[0] = L1_bias_unit1;
    assign L1_bias[1] = L1_bias_unit2;
    assign L1_bias[2] = L1_bias_unit3;
    assign L1_bias[3] = L1_bias_unit4;
    assign L1_bias[4] = L1_bias_unit5;
    assign L1_bias[5] = L1_bias_unit6;










    localparam IDLE = 4'b0001, FRONT = 4'b0010, MIDDLE = 4'b0100, FC = 4'b1000;
    reg [3:0] st;

    always@(posedge clk)begin
        if     (L1_en == 1'b1) st <= FRONT;
        else if(L3_en == 1'b1) st <= MIDDLE; 
        else st <= IDLE;
    end
    

    calculate_2d cal_instance1(
        .clk(clk),
        //input 25
        .input_unit_1 (in_a[0][0]),.input_unit_2  (in_a[0][1 ]),.input_unit_3 (in_a[0][2 ]),    
        .input_unit_4 (in_a[0][3]),.input_unit_5  (in_a[0][4 ]),.input_unit_6 (in_a[0][5 ]),
        .input_unit_7 (in_a[0][6]),.input_unit_8  (in_a[0][7 ]),.input_unit_9 (in_a[0][8 ]),
        .input_unit_10(in_a[0][9]),.input_unit_11 (in_a[0][10]),.input_unit_12(in_a[0][11]),
        .input_unit_13(in_a[0][12]),.input_unit_14(in_a[0][13]),.input_unit_15(in_a[0][14]),
        .input_unit_16(in_a[0][15]),.input_unit_17(in_a[0][16]),.input_unit_18(in_a[0][17]),
        .input_unit_19(in_a[0][18]),.input_unit_20(in_a[0][19]),.input_unit_21(in_a[0][20]),
        .input_unit_22(in_a[0][21]),.input_unit_23(in_a[0][22]),.input_unit_24(in_a[0][23]),
        .input_unit_25(in_a[0][24]),
        
        //weight 25
        .weight_unit_1 (in_b[0][0]), .weight_unit_2 (in_b[0][1] ),.weight_unit_3 (in_b[0][2] ),
        .weight_unit_4 (in_b[0][3]), .weight_unit_5 (in_b[0][4] ),.weight_unit_6 (in_b[0][5] ),
        .weight_unit_7 (in_b[0][6]), .weight_unit_8 (in_b[0][7] ),.weight_unit_9 (in_b[0][8] ),
        .weight_unit_10(in_b[0][9]), .weight_unit_11(in_b[0][10]),.weight_unit_12(in_b[0][11]),
        .weight_unit_13(in_b[0][12]),.weight_unit_14(in_b[0][13]),.weight_unit_15(in_b[0][14]),
        .weight_unit_16(in_b[0][15]),.weight_unit_17(in_b[0][16]),.weight_unit_18(in_b[0][17]),
        .weight_unit_19(in_b[0][18]),.weight_unit_20(in_b[0][19]),.weight_unit_21(in_b[0][20]),
        .weight_unit_22(in_b[0][21]),.weight_unit_23(in_b[0][22]),.weight_unit_24(in_b[0][23]),
        .weight_unit_25(in_b[0][24]),
        //bias 1
        .bias_unit(L1_bias[0]),
        .output_unit_1(out_temp[0])        //.stage_5_unit(out_temp)
    );

    calculate_2d cal_instance2(
        .clk(clk),
        //input 25
        .input_unit_1 (in_a[0][0]),.input_unit_2  (in_a[0][1 ]),.input_unit_3 (in_a[0][2 ]),    
        .input_unit_4 (in_a[0][3]),.input_unit_5  (in_a[0][4 ]),.input_unit_6 (in_a[0][5 ]),
        .input_unit_7 (in_a[0][6]),.input_unit_8  (in_a[0][7 ]),.input_unit_9 (in_a[0][8 ]),
        .input_unit_10(in_a[0][9]),.input_unit_11 (in_a[0][10]),.input_unit_12(in_a[0][11]),
        .input_unit_13(in_a[0][12]),.input_unit_14(in_a[0][13]),.input_unit_15(in_a[0][14]),
        .input_unit_16(in_a[0][15]),.input_unit_17(in_a[0][16]),.input_unit_18(in_a[0][17]),
        .input_unit_19(in_a[0][18]),.input_unit_20(in_a[0][19]),.input_unit_21(in_a[0][20]),
        .input_unit_22(in_a[0][21]),.input_unit_23(in_a[0][22]),.input_unit_24(in_a[0][23]),
        .input_unit_25(in_a[0][24]),
        
        //weight 25
        .weight_unit_1 (in_b[1][0]), .weight_unit_2 (in_b[1][1] ),.weight_unit_3 (in_b[1][2] ),
        .weight_unit_4 (in_b[1][3]), .weight_unit_5 (in_b[1][4] ),.weight_unit_6 (in_b[1][5] ),
        .weight_unit_7 (in_b[1][6]), .weight_unit_8 (in_b[1][7] ),.weight_unit_9 (in_b[1][8] ),
        .weight_unit_10(in_b[1][9]), .weight_unit_11(in_b[1][10]),.weight_unit_12(in_b[1][11]),
        .weight_unit_13(in_b[1][12]),.weight_unit_14(in_b[1][13]),.weight_unit_15(in_b[1][14]),
        .weight_unit_16(in_b[1][15]),.weight_unit_17(in_b[1][16]),.weight_unit_18(in_b[1][17]),
        .weight_unit_19(in_b[1][18]),.weight_unit_20(in_b[1][19]),.weight_unit_21(in_b[1][20]),
        .weight_unit_22(in_b[1][21]),.weight_unit_23(in_b[1][22]),.weight_unit_24(in_b[1][23]),
        .weight_unit_25(in_b[1][24]),
        //bias 1
        .bias_unit(L1_bias[1]),
        .output_unit_1(out_temp[1])        //.stage_5_unit(out_temp)
    );

    calculate_2d cal_instance3(
        .clk(clk),
        //input 25
        .input_unit_1 (in_a[0][0]),.input_unit_2  (in_a[0][1 ]),.input_unit_3 (in_a[0][2 ]),    
        .input_unit_4 (in_a[0][3]),.input_unit_5  (in_a[0][4 ]),.input_unit_6 (in_a[0][5 ]),
        .input_unit_7 (in_a[0][6]),.input_unit_8  (in_a[0][7 ]),.input_unit_9 (in_a[0][8 ]),
        .input_unit_10(in_a[0][9]),.input_unit_11 (in_a[0][10]),.input_unit_12(in_a[0][11]),
        .input_unit_13(in_a[0][12]),.input_unit_14(in_a[0][13]),.input_unit_15(in_a[0][14]),
        .input_unit_16(in_a[0][15]),.input_unit_17(in_a[0][16]),.input_unit_18(in_a[0][17]),
        .input_unit_19(in_a[0][18]),.input_unit_20(in_a[0][19]),.input_unit_21(in_a[0][20]),
        .input_unit_22(in_a[0][21]),.input_unit_23(in_a[0][22]),.input_unit_24(in_a[0][23]),
        .input_unit_25(in_a[0][24]),
        
        
        //weight 25
        .weight_unit_1 (in_b[2][0]), .weight_unit_2 (in_b[2][1] ),.weight_unit_3 (in_b[2][2] ),
        .weight_unit_4 (in_b[2][3]), .weight_unit_5 (in_b[2][4] ),.weight_unit_6 (in_b[2][5] ),
        .weight_unit_7 (in_b[2][6]), .weight_unit_8 (in_b[2][7] ),.weight_unit_9 (in_b[2][8] ),
        .weight_unit_10(in_b[2][9]), .weight_unit_11(in_b[2][10]),.weight_unit_12(in_b[2][11]),
        .weight_unit_13(in_b[2][12]),.weight_unit_14(in_b[2][13]),.weight_unit_15(in_b[2][14]),
        .weight_unit_16(in_b[2][15]),.weight_unit_17(in_b[2][16]),.weight_unit_18(in_b[2][17]),
        .weight_unit_19(in_b[2][18]),.weight_unit_20(in_b[2][19]),.weight_unit_21(in_b[2][20]),
        .weight_unit_22(in_b[2][21]),.weight_unit_23(in_b[2][22]),.weight_unit_24(in_b[2][23]),
        .weight_unit_25(in_b[2][24]),
        //bias 1
        .bias_unit(L1_bias[2]),
        .output_unit_1(out_temp[2])        //.stage_5_unit(out_temp)
    );

    calculate_2d cal_instance4(
        .clk(clk),
        //input 25
        .input_unit_1 (in_a[0][0]),.input_unit_2  (in_a[0][1 ]),.input_unit_3 (in_a[0][2 ]),    
        .input_unit_4 (in_a[0][3]),.input_unit_5  (in_a[0][4 ]),.input_unit_6 (in_a[0][5 ]),
        .input_unit_7 (in_a[0][6]),.input_unit_8  (in_a[0][7 ]),.input_unit_9 (in_a[0][8 ]),
        .input_unit_10(in_a[0][9]),.input_unit_11 (in_a[0][10]),.input_unit_12(in_a[0][11]),
        .input_unit_13(in_a[0][12]),.input_unit_14(in_a[0][13]),.input_unit_15(in_a[0][14]),
        .input_unit_16(in_a[0][15]),.input_unit_17(in_a[0][16]),.input_unit_18(in_a[0][17]),
        .input_unit_19(in_a[0][18]),.input_unit_20(in_a[0][19]),.input_unit_21(in_a[0][20]),
        .input_unit_22(in_a[0][21]),.input_unit_23(in_a[0][22]),.input_unit_24(in_a[0][23]),
        .input_unit_25(in_a[0][24]),
        
        
        //weight 25
        .weight_unit_1 (in_b[3][0]), .weight_unit_2 (in_b[3][1] ),.weight_unit_3 (in_b[3][2] ),
        .weight_unit_4 (in_b[3][3]), .weight_unit_5 (in_b[3][4] ),.weight_unit_6 (in_b[3][5] ),
        .weight_unit_7 (in_b[3][6]), .weight_unit_8 (in_b[3][7] ),.weight_unit_9 (in_b[3][8] ),
        .weight_unit_10(in_b[3][9]), .weight_unit_11(in_b[3][10]),.weight_unit_12(in_b[3][11]),
        .weight_unit_13(in_b[3][12]),.weight_unit_14(in_b[3][13]),.weight_unit_15(in_b[3][14]),
        .weight_unit_16(in_b[3][15]),.weight_unit_17(in_b[3][16]),.weight_unit_18(in_b[3][17]),
        .weight_unit_19(in_b[3][18]),.weight_unit_20(in_b[3][19]),.weight_unit_21(in_b[3][20]),
        .weight_unit_22(in_b[3][21]),.weight_unit_23(in_b[3][22]),.weight_unit_24(in_b[3][23]),
        .weight_unit_25(in_b[3][24]),
        //bias 1
        .bias_unit(L1_bias[3]),
        .output_unit_1(out_temp[3])        //.stage_5_unit(out_temp)
    );

    calculate_2d cal_instance5(
        .clk(clk),
        //input 25
        .input_unit_1 (in_a[0][0]),.input_unit_2  (in_a[0][1 ]),.input_unit_3 (in_a[0][2 ]),    
        .input_unit_4 (in_a[0][3]),.input_unit_5  (in_a[0][4 ]),.input_unit_6 (in_a[0][5 ]),
        .input_unit_7 (in_a[0][6]),.input_unit_8  (in_a[0][7 ]),.input_unit_9 (in_a[0][8 ]),
        .input_unit_10(in_a[0][9]),.input_unit_11 (in_a[0][10]),.input_unit_12(in_a[0][11]),
        .input_unit_13(in_a[0][12]),.input_unit_14(in_a[0][13]),.input_unit_15(in_a[0][14]),
        .input_unit_16(in_a[0][15]),.input_unit_17(in_a[0][16]),.input_unit_18(in_a[0][17]),
        .input_unit_19(in_a[0][18]),.input_unit_20(in_a[0][19]),.input_unit_21(in_a[0][20]),
        .input_unit_22(in_a[0][21]),.input_unit_23(in_a[0][22]),.input_unit_24(in_a[0][23]),
        .input_unit_25(in_a[0][24]),
        
        
        //weight 25
        .weight_unit_1 (in_b[4][0]), .weight_unit_2 (in_b[4][1] ),.weight_unit_3 (in_b[4][2] ),
        .weight_unit_4 (in_b[4][3]), .weight_unit_5 (in_b[4][4] ),.weight_unit_6 (in_b[4][5] ),
        .weight_unit_7 (in_b[4][6]), .weight_unit_8 (in_b[4][7] ),.weight_unit_9 (in_b[4][8] ),
        .weight_unit_10(in_b[4][9]), .weight_unit_11(in_b[4][10]),.weight_unit_12(in_b[4][11]),
        .weight_unit_13(in_b[4][12]),.weight_unit_14(in_b[4][13]),.weight_unit_15(in_b[4][14]),
        .weight_unit_16(in_b[4][15]),.weight_unit_17(in_b[4][16]),.weight_unit_18(in_b[4][17]),
        .weight_unit_19(in_b[4][18]),.weight_unit_20(in_b[4][19]),.weight_unit_21(in_b[4][20]),
        .weight_unit_22(in_b[4][21]),.weight_unit_23(in_b[4][22]),.weight_unit_24(in_b[4][23]),
        .weight_unit_25(in_b[4][24]),
        //bias 1
        .bias_unit(L1_bias[4]),
        .output_unit_1(out_temp[4])        //.stage_5_unit(out_temp)
    );


    calculate_2d cal_instance6(
        .clk(clk),
        //input 25
        .input_unit_1 (in_a[0][0]),.input_unit_2  (in_a[0][1 ]),.input_unit_3 (in_a[0][2 ]),    
        .input_unit_4 (in_a[0][3]),.input_unit_5  (in_a[0][4 ]),.input_unit_6 (in_a[0][5 ]),
        .input_unit_7 (in_a[0][6]),.input_unit_8  (in_a[0][7 ]),.input_unit_9 (in_a[0][8 ]),
        .input_unit_10(in_a[0][9]),.input_unit_11 (in_a[0][10]),.input_unit_12(in_a[0][11]),
        .input_unit_13(in_a[0][12]),.input_unit_14(in_a[0][13]),.input_unit_15(in_a[0][14]),
        .input_unit_16(in_a[0][15]),.input_unit_17(in_a[0][16]),.input_unit_18(in_a[0][17]),
        .input_unit_19(in_a[0][18]),.input_unit_20(in_a[0][19]),.input_unit_21(in_a[0][20]),
        .input_unit_22(in_a[0][21]),.input_unit_23(in_a[0][22]),.input_unit_24(in_a[0][23]),
        .input_unit_25(in_a[0][24]),
        
        
        //weight 25
        .weight_unit_1 (in_b[5][0]), .weight_unit_2 (in_b[5][1] ),.weight_unit_3 (in_b[5][2] ),
        .weight_unit_4 (in_b[5][3]), .weight_unit_5 (in_b[5][4] ),.weight_unit_6 (in_b[5][5] ),
        .weight_unit_7 (in_b[5][6]), .weight_unit_8 (in_b[5][7] ),.weight_unit_9 (in_b[5][8] ),
        .weight_unit_10(in_b[5][9]), .weight_unit_11(in_b[5][10]),.weight_unit_12(in_b[5][11]),
        .weight_unit_13(in_b[5][12]),.weight_unit_14(in_b[5][13]),.weight_unit_15(in_b[5][14]),
        .weight_unit_16(in_b[5][15]),.weight_unit_17(in_b[5][16]),.weight_unit_18(in_b[5][17]),
        .weight_unit_19(in_b[5][18]),.weight_unit_20(in_b[5][19]),.weight_unit_21(in_b[5][20]),
        .weight_unit_22(in_b[5][21]),.weight_unit_23(in_b[5][22]),.weight_unit_24(in_b[5][23]),
        .weight_unit_25(in_b[5][24]),
        //bias 1
        .bias_unit(L1_bias[5]),
        .output_unit_1(out_temp[5])        //.stage_5_unit(out_temp)
    );

    assign out_result_a = out_temp[0];
    assign out_result_b = out_temp[1];
    assign out_result_c = out_temp[2];
    assign out_result_d = out_temp[3];
    assign out_result_e = out_temp[4];
    assign out_result_f = out_temp[5];

    

endmodule
    //layer1,2 25 * 6
    //layer3,4 25 * 12 