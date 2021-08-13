`timescale 1ns / 1ps

module top_wrapper#(
  parameter DATA_WIDTH = 12,
            L3_INPUT_CHANNEL = 6,
            L3_INPUT_HEIGHT = 14,
            L3_INPUT_WIDTH = 14,
            L3_FITER_SIZE = 151,
            INPUT_SIZE = 1176,
            FILTER_BASE_0 = 0,
            FILTER_BASE_1 = 1208,
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


  //front layer
  reg [DATA_WIDTH-1:0] inp [0:4][0:31];
  reg [DATA_WIDTH-1:0] weight[0:5][0:24];
  reg [DATA_WIDTH-1:0] bias [0:5];

  //middle layer
  reg [11:0] input_mem [0: L3_INPUT_CHANNEL - 1][0: L3_INPUT_HEIGHT - 1][0: L3_INPUT_WIDTH - 1];
  reg [11:0] weight1_mem [0:L3_FITER_SIZE -2];
  reg [11:0] weight2_mem [0:L3_FITER_SIZE -2];
  reg [11:0] bias1_mem;
  reg [11:0] bias2_mem;


  wire [DATA_WIDTH-1:0] con_result [0:5];


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

    .out_result_a(con_result[0]),
    .out_result_b(con_result[1]),
    .out_result_c(con_result[2]),
    .out_result_d(con_result[3]),
    .out_result_e(con_result[4]),
    .out_result_f(con_result[5])

    );




  integer i,j;

  //weight memory 
  always@(posedge clk)begin
    if(L1_load_wait == 2'b10)begin
        for(i = 0; i< 6 ; i = i + 1)begin
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
      for(i = 0; i< 6 ; i = i + 1)begin    
              bias[i] <= 1'b0;
      end
    end
    else begin
        for(i = 0; i< 6 ; i = i + 1)begin    
              bias[i] <= bias[i];
        end
    end
    

    if(L1_load_wait == 2'b10)begin
        for(i = 0; i <6 ; i = i+1)begin
            for(j = 0; j< 25 ; j = j + 1)begin
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
        for(i = 0; i <6 ; i = i+1)begin
          for(j = 0; j< 25 ; j = j + 1)begin
                  weight[i][j] <= 1'b0;                        
          end    
      end
    end

    else begin
      for(i = 0; i <6 ; i = i+1)begin
          for(j = 0; j< 25 ; j = j + 1)begin
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
        for(i = 0; i < 5 ; i = i + 1)begin
            for(j = 0 ; j < 32 ; j = j + 1)begin
                if(L1_position_col == i) inp[i][j] <= L1_in_data[j*12 +: 12];
                else inp[i][j] <= inp[i][j];
            end
        end
      end
      else begin
        for(i = 0; i < 5 ; i = i + 1)begin
            for(j = 0 ; j < 32 ; j = j + 1)begin
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
          for(i = 0; i < 5 ; i = i + 1)begin
            for(j = 0 ; j < 32 ; j = j + 1)begin
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
          for(i = 0; i < 5 ; i = i + 1)begin
              for(j = 0 ; j < 32 ; j = j + 1)begin
                  inp[i][j] <= inp[i][j];
              end
          end
      end
    end
    //end st == calculation
    
    // other state

    else if( L1_en == 1'b0)begin
      for(i = 0; i < 5 ; i = i + 1)begin
          for(j = 0 ; j < 32 ; j = j + 1)begin
              inp[i][j] <= 1'b0;
          end
        end
    end


    else begin
          for(i = 0; i < 5 ; i = i + 1)begin
                    for(j = 0 ; j < 32 ; j = j + 1)begin
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
  wire [7:0] L4_output_read_addr1;
  wire [7:0] L4_output_read_addr2;
  wire [11:0] L4_output_read_data1;
  wire [11:0] L4_output_read_data2;

  wire [7:0] L4_output_write_addr1;
  wire [7:0] L4_output_write_addr2;

  wire [11:0] L4_output_write_data1;
  wire [11:0] L4_output_write_data2;

  wire L4_output_wea1;
  wire L4_output_wea2;


  wire [11:0] L3_weigth_douta;
  wire [11:0] L3_weigth_doutb;
  wire [11:0] L3_weight_addra;
  wire [11:0] L3_weight_addrb;


  middle_layer_wrapper L3_L4_wrapper(
    .clk(clk),
    .rst(rst),
    .L3_en(L3_en),
    .L3_weigth_douta(L3_weigth_douta),
    .L3_weigth_doutb(L3_weigth_doutb),
    .L2_feature1_douta(L2_feature1_dout),
    .L2_feature2_douta(L2_feature2_dout),
    .L2_feature3_douta(L2_feature3_dout),
    .L2_feature4_douta(L2_feature4_dout),
    .L2_feature5_douta(L2_feature5_dout),
    .L2_feature6_douta(L2_feature6_dout),

    .L4_output_read_data1(L4_output_read_data1),
    .L4_output_read_data2(L4_output_read_data2),
    .L4_output_read_addr1(L4_output_read_addr1),
    .L4_output_read_addr2(L4_output_read_addr2),
    .L4_output_write_addr1(L4_output_write_addr1),
    .L4_output_write_addr2(L4_output_write_addr2),
    .L4_output_write_data1(L4_output_write_data1),
    .L4_output_write_data2(L4_output_write_data2),
    .L4_output_wea1(L4_output_wea1),
    .L4_output_wea2(L4_output_wea2),

    .L3_weight_addra(L3_weight_addra),
    .L3_weight_addrb(L3_weight_addrb),
    .L2_feature1_addr_read(L2_feature1_addr_read_m),
    .L2_feature2_addr_read(L2_feature2_addr_read_m),
    .L2_feature3_addr_read(L2_feature3_addr_read_m),
    .L2_feature4_addr_read(L2_feature4_addr_read_m),
    .L2_feature5_addr_read(L2_feature5_addr_read_m),
    .L2_feature6_addr_read(L2_feature6_addr_read_m),
    .L3_done(L3_done)
  );




  con3_w_mem L3_weight_mem (
    .clka(clk),    // input wire clka
    .addra(L3_weight_addra),  // input wire [11 : 0] addra
    .douta(L3_weigth_douta),  // output wire [11 : 0] douta
    .clkb(clk),    // input wire clkb
    .addrb(L3_weight_addrb),  // input wire [11 : 0] addrb
    .doutb(L3_weigth_doutb)  // output wire [11 : 0] doutb
  );


  layer_4_output L4_feature1 (
    .clka(clk),    // input wire clka
    .wea(L4_output_wea1),      // input wire [0 : 0] wea
    .addra(L4_output_write_addr1),  // input wire [7 : 0] addra
    .dina(L4_output_write_data1),    // input wire [11 : 0] dina
    .clkb(clk),    // input wire clkb
    .addrb(L4_output_read_addr1),  // input wire [7 : 0] addrb
    .doutb(L4_output_read_data1)  // output wire [11 : 0] doutb
  );

  layer_4_output L4_feature2 (
    .clka(clk),    // input wire clka
    .wea(L4_output_wea2),      // input wire [0 : 0] wea
    .addra(L4_output_write_addr2),  // input wire [7 : 0] addra
    .dina(L4_output_write_data2),    // input wire [11 : 0] dina
    .clkb(clk),    // input wire clkb
    .addrb(L4_output_read_addr2),  // input wire [7 : 0] addrb
    .doutb(L4_output_read_data2)  // output wire [11 : 0] doutb
  );


  assign out_d = L4_output_write_data1[6:0];

endmodule
