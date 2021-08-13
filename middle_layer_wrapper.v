`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/08 02:28:30
// Design Name: 
// Module Name: middle_layer_wrapper
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


module middle_layer_wrapper
#(
parameter  TOTAL_SIZE = 151,
           KERNEL_SIZE = 25,
           CAHNNEL_SIZE = 196,
           INPUT_SIZE = 1176,
           INPUT_WIDTH = 14,
           INPUT_HEIGHT = 14,
           INPUT_CHANNEL = 6,
           FILTER_BASE_0 = 0,
           FILTER_BASE_1 = 1208,
           IDLE = 4'b0001,
           LOAD_INP = 4'b0010,
           CALCULATE = 4'b0100,
           DONE = 4'b1000,
           INP_BASE_1 = 0,
           INP_BASE_2 = 196,
           INP_BASE_3 = 392,
           INP_BASE_4 = 588,
           INP_BASE_5 = 784,
           INP_BASE_6 = 980
)
(
    input clk,rst,
    input L3_en,
    input [11:0] L3_weigth_douta,
    input [11:0] L3_weigth_doutb,
    input [11:0] L2_feature1_douta,
    input [11:0] L2_feature2_douta,
    input [11:0] L2_feature3_douta,
    input [11:0] L2_feature4_douta,
    input [11:0] L2_feature5_douta,
    input [11:0] L2_feature6_douta,

    input [11:0] L4_output_read_data1,
    input [11:0] L4_output_read_data2,
    output [7:0] L4_output_read_addr1,
    output [7:0] L4_output_read_addr2,
    output [7:0] L4_output_write_addr1,
    output [7:0] L4_output_write_addr2,
    output [11:0] L4_output_write_data1,
    output [11:0] L4_output_write_data2,
    output L4_output_wea1,
    output L4_output_wea2,

    output reg [11:0] L3_weight_addra,
    output reg [11:0] L3_weight_addrb,
    output [7:0] L2_feature1_addr_read,
    output [7:0] L2_feature2_addr_read,
    output [7:0] L2_feature3_addr_read,
    output [7:0] L2_feature4_addr_read,
    output [7:0] L2_feature5_addr_read,
    output [7:0] L2_feature6_addr_read,
    output reg L3_done




);


    // register
    reg [11:0] input_mem [0: INPUT_CHANNEL - 1][0: INPUT_HEIGHT - 1][0: INPUT_WIDTH - 1];
    // reg [11:0] input_mem [0:1175];
    reg [11:0] weight1_mem [0:TOTAL_SIZE -2];
    reg [11:0] weight2_mem [0:TOTAL_SIZE -2];
    reg [11:0] bias1_mem;
    reg [11:0] bias2_mem;

    reg inp_load_en;
    reg [1:0] inp_wait;
    reg inp_load_done;
    reg [1:0] after_load_inp;
    reg [3:0] st,nst;
    // assign L3_done = 1'b0;
    wire cal_done;
 
    reg [11:0] filter_count;
    wire [11:0] conv_res [0:5];


    

    //// middle FSM

    always@(posedge clk)begin
        if(rst)begin
            st <= IDLE;
        end
        else begin
            st <= nst;
        end
    end




    always@(st,nst,L3_en,L3_done,inp_load_done,cal_done)begin
        case(st)
        IDLE : begin
           nst = (L3_en  == 1'b1) ? LOAD_INP : IDLE; 
        end
        LOAD_INP : begin
            nst = (L3_en == 1'b1 && inp_load_done == 1'b1) ? CALCULATE : LOAD_INP;
        end
        CALCULATE :begin
            nst = (L3_en == 1'b1 && cal_done == 1'b1) ? DONE : CALCULATE;
        end
        DONE: begin
            nst = DONE;
        end
        default : begin
            nst = IDLE;
        end
        endcase
    end


    //////////////////////////////////////////////
    
    // state load input
    // 읽어오는 대기 시간
    always@(posedge clk)begin
        if(rst)begin
            inp_wait <= 1'b0;
        end
        else if(st == LOAD_INP)begin
            if(inp_wait == 2'b10)begin
                inp_wait <= inp_wait;
            end
            else begin
                inp_wait <= inp_wait + 1'b1;
            end
        end
        else begin
            inp_wait <= 1'b0;
        end
    end


    reg [3:0] cur_input_width_count;
    reg [3:0] cur_input_height_count;


    always@(posedge clk)begin
        //input load done
        if(cur_input_width_count == INPUT_WIDTH - 1 && cur_input_height_count == INPUT_HEIGHT - 1 )begin
            inp_load_done <= 1'b1;
        end
        else begin
            inp_load_done <= 1'b0;
        end
    end

   

    // reg [11:0] input_count;
    reg [3:0] input_width_count;
    reg [3:0] input_height_count;

    always@(posedge clk)begin
        
        
        //읽어오는 시간
        if(rst)begin
            input_width_count <= 1'b0;
            input_height_count <= 1'b0;
        end
        else if(st == LOAD_INP)begin
            if(input_height_count == INPUT_HEIGHT - 1 && input_width_count == INPUT_WIDTH)begin
                input_width_count <= input_width_count;
                input_height_count <= input_height_count;
            end
            else if(input_width_count == INPUT_WIDTH - 1)begin
                input_width_count <= 1'b0;
                input_height_count <= input_height_count + 1'b1;
            end
            else begin
                input_width_count <= input_width_count;
                input_height_count <= input_height_count + 1'b1;
            end
        end
        else begin
            input_width_count <= input_width_count;
            input_height_count <= input_height_count;
        end

        // 쓰는 시간
        if(rst)begin
            cur_input_height_count <= 1'b0;
            cur_input_width_count <= 1'b0;
        end
        else if(inp_wait == 2'b10)begin
            if(cur_input_height_count == INPUT_HEIGHT - 1 && cur_input_width_count == INPUT_WIDTH - 1)begin
                cur_input_height_count <= cur_input_height_count;
                cur_input_width_count <= cur_input_width_count;
            end
            else if(cur_input_width_count == INPUT_WIDTH- 1) begin
                cur_input_height_count <= cur_input_height_count + 1'b1;
                cur_input_width_count <= 1'b0;
            end
            else begin
                cur_input_height_count <= cur_input_height_count;
                cur_input_width_count <= cur_input_width_count + 1'b1;                
            end
        end
        else begin
                cur_input_height_count <= 1'b0;
                cur_input_width_count <= 1'b0;
        end
    end

    assign L2_feature1_addr_read = input_width_count + input_height_count * INPUT_WIDTH + INP_BASE_1;
    assign L2_feature2_addr_read = input_width_count + input_height_count * INPUT_WIDTH + INP_BASE_2;
    assign L2_feature3_addr_read = input_width_count + input_height_count * INPUT_WIDTH + INP_BASE_3;
    assign L2_feature4_addr_read = input_width_count + input_height_count * INPUT_WIDTH + INP_BASE_4;
    assign L2_feature5_addr_read = input_width_count + input_height_count * INPUT_WIDTH + INP_BASE_5;
    assign L2_feature6_addr_read = input_width_count + input_height_count * INPUT_WIDTH + INP_BASE_6;

    integer i,j;
    always@(posedge clk)begin
        if(inp_wait == 2'b10)begin
            for(i = 0; i< 14 ;i = i + 1)begin
                for(j = 0; j< 14 ; j = j + 1)begin
                    if(cur_input_height_count == i && cur_input_width_count == j )begin
                    input_mem [0][i][j] <= L2_feature1_douta;
                    input_mem [1][i][j] <= L2_feature2_douta;
                    input_mem [2][i][j] <= L2_feature3_douta;
                    input_mem [3][i][j] <= L2_feature4_douta;
                    input_mem [4][i][j] <= L2_feature5_douta;
                    input_mem [5][i][j] <= L2_feature6_douta;
                    end
                    else begin
                    input_mem [0][i][j] <= input_mem input_mem [0][i][j];
                    input_mem [1][i][j] <= input_mem input_mem [1][i][j];
                    input_mem [2][i][j] <= input_mem input_mem [2][i][j];
                    input_mem [3][i][j] <= input_mem input_mem [3][i][j];
                    input_mem [4][i][j] <= input_mem input_mem [4][i][j];
                    input_mem [5][i][j] <= input_mem input_mem [5][i][j];
                    end   
                end
                
            end
        end
        else begin
            for(i = 0; i< 196 ;i = i + 1)begin
                input_mem [0][i][j] <= input_mem input_mem [0][i][j];
                input_mem [1][i][j] <= input_mem input_mem [1][i][j];
                input_mem [2][i][j] <= input_mem input_mem [2][i][j];
                input_mem [3][i][j] <= input_mem input_mem [3][i][j];
                input_mem [4][i][j] <= input_mem input_mem [4][i][j];
                input_mem [5][i][j] <= input_mem input_mem [5][i][j];
            end
        end
    end





    //state calculation
    //filter in
    //input data

    parameter CAL_IDLE = 4'b0001, WEIGHT_LOAD = 4'b0010, CONVOLUTION = 4'b0100, DONE_CALCULATION = 4'b1000;

    
    reg [2:0] wait_weight;

    reg [11:0] cur_filter_count;

    reg [4:0]  kernel_count;


    reg [3:0] cal_st,nst_cal_st;

    reg load_weight_done;
    reg conv_done;
    
    reg [11:0] weight_base1;
    reg [11:0] weight_base2;

    reg change_flag;
    always@(posedge clk)begin
        if(rst)begin
            kernel_count <= 1'b0;
            change_flag <= 1'b0;
        end
        else if(cal_st == CONVOLUTION && nst_cal_st == WEIGHT_LOAD)begin
            if(change_flag == 1'b1)begin
                kernel_count <= kernel_count;
                change_flag <= change_flag;            
            end
            else begin
                kernel_count <= kernel_count + 1'b1;
                change_flag <= 1'b1;
            end
        end
        else begin
            kernel_count <= kernel_count;
            change_flag <= 1'b0;
        end


        weight_base1 <= FILTER_BASE_0 + (kernel_count * 151);
        weight_base2 <= FILTER_BASE_1 + (kernel_count * 151); 

    end
    
    //내부에서 커널 개수만큼 컨볼루션 반복해야하므로
    always@(st,cal_st,nst_cal_st,kernel_count,load_weight_done,conv_done)begin
        case(cal_st)
            CAL_IDLE   :nst_cal_st = (st==CALCULATE) ? WEIGHT_LOAD : CAL_IDLE;
            WEIGHT_LOAD:nst_cal_st = (st==CALCULATE && load_weight_done == 1'b1 ) ? CONVOLUTION : 
                                     (st==CALCULATE && kernel_count < 8) ? WEIGHT_LOAD : 
                                     (st==CALCULATE ) ?DONE_CALCULATION : CAL_IDLE;
            CONVOLUTION:nst_cal_st = (st==CALCULATE && conv_done == 1'b1) ? WEIGHT_LOAD :
                                     (st==CALCULATE) ? CONVOLUTION:CAL_IDLE;
            DONE_CALCULATION:nst_cal_st =(st ==CALCULATE) ? DONE_CALCULATION :CAL_IDLE; 
            default:nst_cal_st = CAL_IDLE;
        endcase
    end

    assign cal_done = (cal_st == CALCULATE);


    always@(posedge clk)begin
        if(rst)begin
            cal_st <=WEIGHT_LOAD;
        end        
        else begin
            cal_st <= nst_cal_st;
        end
    end


    // output reg [11:0] L3_weight_addra,
    // output reg [11:0] L3_weight_addrb,
    always@(posedge clk)begin
        if(rst)begin
            filter_count<=1'b0;
        end
        else if(cal_st == WEIGHT_LOAD)begin
            if(filter_count == 12'd150)begin
                filter_count<=filter_count;
            end
            else begin
                filter_count<=filter_count + 1'b1;
            end
        end
        else begin
            filter_count <= 1'b0;
        end

        L3_weight_addra <= weight_base1 + filter_count;
        L3_weight_addrb <=  weight_base2 + filter_count;

    end
//L3_done

    always@(posedge clk)begin
        if(cal_st == WEIGHT_LOAD)begin
            if(wait_weight == 2'b11)begin
                wait_weight <= wait_weight;
            end
            else begin
                wait_weight <= wait_weight + 1'b1;
            end
        end
        else begin
            wait_weight <= 1'b0;
        end

        if(wait_weight == 2'b11)begin
            if(cur_filter_count == 151)begin
                cur_filter_count <= cur_filter_count;
                load_weight_done <= 1'b1;
            end
            else begin
                cur_filter_count <= cur_filter_count + 1'b1;
                load_weight_done <= 1'b0;
            end
        end
        else begin
            cur_filter_count <= 1'b0;
            load_weight_done <= 1'b0;
        end
    end


     always@(posedge clk)begin
        if(wait_weight == 2'b11)begin
            for(i = 0; i< 150 ;i = i + 1)begin
                if(cur_filter_count == i )begin
                    weight1_mem [i] <= L3_weigth_douta;
                    weight2_mem [i] <= L3_weigth_doutb;
                    
                end
                else begin
                    weight1_mem [i] <= weight1_mem [i];
                    weight2_mem [i] <= weight2_mem [i];
                end
            end

            if(cur_filter_count == TOTAL_SIZE -1)begin
                bias1_mem <= L3_weigth_douta;
                bias2_mem <= L3_weigth_doutb;
            end
            else begin
                bias2_mem <= bias2_mem;
                bias1_mem <= bias1_mem;
            end
        end

        else begin
            for(i = 0; i< 150 ;i = i + 1)begin
                weight1_mem [i] <=  weight1_mem [i];
                weight2_mem [i] <=  weight2_mem [i];
            end
                bias1_mem <= bias1_mem;
                bias2_mem <= bias2_mem;
        end
    end


    reg [3:0] col;
    reg [3:0] row;
    reg [3:0] wait_done;

    always@(posedge clk)begin
        if(col == 4'd11)begin
            if(wait_done == 4'd10)begin
                conv_done <= 1'b1;
                wait_done <= wait_done;
            end
            else begin
                conv_done <= 1'b0;
                wait_done <= wait_done + 1'b1;
            end
        end
        else begin
            conv_done<=1'b0;
            wait_done <= 1'b0;
        end

        if(wait_done == 4'd10) L3_done <= 1'b1;
        else;
    end


    always@(posedge clk)begin
        if(cal_st == CONVOLUTION)begin
            if(col == 4'd11)begin
                row <= row;
                col <= col;
            end
            else if(row == 5'd10)begin
                row <= 1'b0;
                col <= col + 1'b1;
            end
            else begin
                row <= row + 1'b1;
                col <= col;
            end
        end
        else begin
            row <= 1'b0;
            col <= 1'b0;
        end
    end



    calculate_2d cal_instance1(
        .clk(clk),
        .input_unit_1(input_mem[0][cur_input_height_count + 0][cur_input_height_count + 0]),
        .input_unit_2(input_mem[0][cur_input_height_count + 0][cur_input_height_count + 1]),
        .input_unit_3(input_mem[0][cur_input_height_count + 0][cur_input_height_count + 2]),
        .input_unit_4(input_mem[0][cur_input_height_count + 0][cur_input_height_count + 3]),
        .input_unit_5(input_mem[0][cur_input_height_count + 0][cur_input_height_count + 4]),
        .input_unit_6(input_mem[0][cur_input_height_count + 1][cur_input_height_count + 0]),
        .input_unit_7(input_mem[0][cur_input_height_count + 1][cur_input_height_count + 1]),
        .input_unit_8(input_mem[0][cur_input_height_count + 1][cur_input_height_count + 2]),
        .input_unit_9(input_mem[0][cur_input_height_count + 1][cur_input_height_count + 3]),
        .input_unit_10(input_mem[0][cur_input_height_count + 1][cur_input_height_count + 4]),
        .input_unit_11(input_mem[0][cur_input_height_count + 2][cur_input_height_count + 0]),
        .input_unit_12(input_mem[0][cur_input_height_count + 2][cur_input_height_count + 1]),
        .input_unit_13(input_mem[0][cur_input_height_count + 2][cur_input_height_count + 2]),
        .input_unit_14(input_mem[0][cur_input_height_count + 2][cur_input_height_count + 3]),
        .input_unit_15(input_mem[0][cur_input_height_count + 2][cur_input_height_count + 4]),
        .input_unit_16(input_mem[0][cur_input_height_count + 3][cur_input_height_count + 0]),
        .input_unit_17(input_mem[0][cur_input_height_count + 3][cur_input_height_count + 1]),
        .input_unit_18(input_mem[0][cur_input_height_count + 3][cur_input_height_count + 2]),
        .input_unit_19(input_mem[0][cur_input_height_count + 3][cur_input_height_count + 3]),
        .input_unit_20(input_mem[0][cur_input_height_count + 3][cur_input_height_count + 4]),
        .input_unit_21(input_mem[0][cur_input_height_count + 4][cur_input_height_count + 0]),
        .input_unit_22(input_mem[0][cur_input_height_count + 4][cur_input_height_count + 1]),
        .input_unit_23(input_mem[0][cur_input_height_count + 4][cur_input_height_count + 2]),
        .input_unit_24(input_mem[0][cur_input_height_count + 4][cur_input_height_count + 3]),
        .input_unit_25(input_mem[0][cur_input_height_count + 4][cur_input_height_count + 4]),
        .weight_unit_1(weight1_mem[0]),
        .weight_unit_2(weight1_mem[1]),
        .weight_unit_3(weight1_mem[2]),
        .weight_unit_4(weight1_mem[3]),
        .weight_unit_5(weight1_mem[4]),
        .weight_unit_6(weight1_mem[5]),
        .weight_unit_7(weight1_mem[6]),
        .weight_unit_8(weight1_mem[7]),
        .weight_unit_9(weight1_mem[8]),
        .weight_unit_10(weight1_mem[9]),
        .weight_unit_11(weight1_mem[10]),
        .weight_unit_12(weight1_mem[11]),
        .weight_unit_13(weight1_mem[12]),
        .weight_unit_14(weight1_mem[13]),
        .weight_unit_15(weight1_mem[14]),
        .weight_unit_16(weight1_mem[15]),
        .weight_unit_17(weight1_mem[16]),
        .weight_unit_18(weight1_mem[17]),
        .weight_unit_19(weight1_mem[18]),
        .weight_unit_20(weight1_mem[19]),
        .weight_unit_21(weight1_mem[20]),
        .weight_unit_22(weight1_mem[21]),
        .weight_unit_23(weight1_mem[22]),
        .weight_unit_24(weight1_mem[23]),
        .weight_unit_25(weight1_mem[24]),
        .bias_unit(bias1_mem),
        .output_unit_1(conv_res[0])
      );


    calculate_2d cal_instance2(
        .clk(clk),
        .input_unit_1(input_mem[1][cur_input_height_count + 0][cur_input_height_count + 0]),
        .input_unit_2(input_mem[1][cur_input_height_count + 0][cur_input_height_count + 1]),
        .input_unit_3(input_mem[1][cur_input_height_count + 0][cur_input_height_count + 2]),
        .input_unit_4(input_mem[1][cur_input_height_count + 0][cur_input_height_count + 3]),
        .input_unit_5(input_mem[1][cur_input_height_count + 0][cur_input_height_count + 4]),
        .input_unit_6(input_mem[1][cur_input_height_count + 1][cur_input_height_count + 0]),
        .input_unit_7(input_mem[1][cur_input_height_count + 1][cur_input_height_count + 1]),
        .input_unit_8(input_mem[1][cur_input_height_count + 1][cur_input_height_count + 2]),
        .input_unit_9(input_mem[1][cur_input_height_count + 1][cur_input_height_count + 3]),
        .input_unit_10(input_mem[1][cur_input_height_count + 1][cur_input_height_count + 4]),
        .input_unit_11(input_mem[1][cur_input_height_count + 2][cur_input_height_count + 0]),
        .input_unit_12(input_mem[1][cur_input_height_count + 2][cur_input_height_count + 1]),
        .input_unit_13(input_mem[1][cur_input_height_count + 2][cur_input_height_count + 2]),
        .input_unit_14(input_mem[1][cur_input_height_count + 2][cur_input_height_count + 3]),
        .input_unit_15(input_mem[1][cur_input_height_count + 2][cur_input_height_count + 4]),
        .input_unit_16(input_mem[1][cur_input_height_count + 3][cur_input_height_count + 0]),
        .input_unit_17(input_mem[1][cur_input_height_count + 3][cur_input_height_count + 1]),
        .input_unit_18(input_mem[1][cur_input_height_count + 3][cur_input_height_count + 2]),
        .input_unit_19(input_mem[1][cur_input_height_count + 3][cur_input_height_count + 3]),
        .input_unit_20(input_mem[1][cur_input_height_count + 3][cur_input_height_count + 4]),
        .input_unit_21(input_mem[1][cur_input_height_count + 4][cur_input_height_count + 0]),
        .input_unit_22(input_mem[1][cur_input_height_count + 4][cur_input_height_count + 1]),
        .input_unit_23(input_mem[1][cur_input_height_count + 4][cur_input_height_count + 2]),
        .input_unit_24(input_mem[1][cur_input_height_count + 4][cur_input_height_count + 3]),
        .input_unit_25(input_mem[1][cur_input_height_count + 4][cur_input_height_count + 4]),
        .weight_unit_1(weight1_mem[25]),
        .weight_unit_2(weight1_mem[26]),
        .weight_unit_3(weight1_mem[27]),
        .weight_unit_4(weight1_mem[28]),
        .weight_unit_5(weight1_mem[29]),
        .weight_unit_6(weight1_mem[30]),
        .weight_unit_7(weight1_mem[31]),
        .weight_unit_8(weight1_mem[32]),
        .weight_unit_9(weight1_mem[33]),
        .weight_unit_10(weight1_mem[34]),
        .weight_unit_11(weight1_mem[35]),
        .weight_unit_12(weight1_mem[36]),
        .weight_unit_13(weight1_mem[37]),
        .weight_unit_14(weight1_mem[38]),
        .weight_unit_15(weight1_mem[39]),
        .weight_unit_16(weight1_mem[40]),
        .weight_unit_17(weight1_mem[41]),
        .weight_unit_18(weight1_mem[42]),
        .weight_unit_19(weight1_mem[43]),
        .weight_unit_20(weight1_mem[44]),
        .weight_unit_21(weight1_mem[45]),
        .weight_unit_22(weight1_mem[46]),
        .weight_unit_23(weight1_mem[47]),
        .weight_unit_24(weight1_mem[48]),
        .weight_unit_25(weight1_mem[49]),
        .bias_unit(12'b0),
        .output_unit_1(conv_res[1])
    );
    calculate_2d cal_instance3(
        .clk(clk),
        .input_unit_1(input_mem[2][cur_input_height_count + 0][cur_input_height_count + 0]),
        .input_unit_2(input_mem[2][cur_input_height_count + 0][cur_input_height_count + 1]),
        .input_unit_3(input_mem[2][cur_input_height_count + 0][cur_input_height_count + 2]),
        .input_unit_4(input_mem[2][cur_input_height_count + 0][cur_input_height_count + 3]),
        .input_unit_5(input_mem[2][cur_input_height_count + 0][cur_input_height_count + 4]),
        .input_unit_6(input_mem[2][cur_input_height_count + 1][cur_input_height_count + 0]),
        .input_unit_7(input_mem[2][cur_input_height_count + 1][cur_input_height_count + 1]),
        .input_unit_8(input_mem[2][cur_input_height_count + 1][cur_input_height_count + 2]),
        .input_unit_9(input_mem[2][cur_input_height_count + 1][cur_input_height_count + 3]),
        .input_unit_10(input_mem[2][cur_input_height_count + 1][cur_input_height_count + 4]),
        .input_unit_11(input_mem[2][cur_input_height_count + 2][cur_input_height_count + 0]),
        .input_unit_12(input_mem[2][cur_input_height_count + 2][cur_input_height_count + 1]),
        .input_unit_13(input_mem[2][cur_input_height_count + 2][cur_input_height_count + 2]),
        .input_unit_14(input_mem[2][cur_input_height_count + 2][cur_input_height_count + 3]),
        .input_unit_15(input_mem[2][cur_input_height_count + 2][cur_input_height_count + 4]),
        .input_unit_16(input_mem[2][cur_input_height_count + 3][cur_input_height_count + 0]),
        .input_unit_17(input_mem[2][cur_input_height_count + 3][cur_input_height_count + 1]),
        .input_unit_18(input_mem[2][cur_input_height_count + 3][cur_input_height_count + 2]),
        .input_unit_19(input_mem[2][cur_input_height_count + 3][cur_input_height_count + 3]),
        .input_unit_20(input_mem[2][cur_input_height_count + 3][cur_input_height_count + 4]),
        .input_unit_21(input_mem[2][cur_input_height_count + 4][cur_input_height_count + 0]),
        .input_unit_22(input_mem[2][cur_input_height_count + 4][cur_input_height_count + 1]),
        .input_unit_23(input_mem[2][cur_input_height_count + 4][cur_input_height_count + 2]),
        .input_unit_24(input_mem[2][cur_input_height_count + 4][cur_input_height_count + 3]),
        .input_unit_25(input_mem[2][cur_input_height_count + 4][cur_input_height_count + 4]),
        .weight_unit_1(weight1_mem[50]),
        .weight_unit_2(weight1_mem[51]),
        .weight_unit_3(weight1_mem[52]),
        .weight_unit_4(weight1_mem[53]),
        .weight_unit_5(weight1_mem[54]),
        .weight_unit_6(weight1_mem[55]),
        .weight_unit_7(weight1_mem[56]),
        .weight_unit_8(weight1_mem[57]),
        .weight_unit_9(weight1_mem[58]),
        .weight_unit_10(weight1_mem[59]),
        .weight_unit_11(weight1_mem[60]),
        .weight_unit_12(weight1_mem[61]),
        .weight_unit_13(weight1_mem[62]),
        .weight_unit_14(weight1_mem[63]),
        .weight_unit_15(weight1_mem[64]),
        .weight_unit_16(weight1_mem[65]),
        .weight_unit_17(weight1_mem[66]),
        .weight_unit_18(weight1_mem[67]),
        .weight_unit_19(weight1_mem[68]),
        .weight_unit_20(weight1_mem[69]),
        .weight_unit_21(weight1_mem[70]),
        .weight_unit_22(weight1_mem[71]),
        .weight_unit_23(weight1_mem[72]),
        .weight_unit_24(weight1_mem[73]),
        .weight_unit_25(weight1_mem[74]),
        .bias_unit(12'b0),
        .output_unit_1(conv_res[2])
    );
    calculate_2d cal_instance4(
        .clk(clk),
        .input_unit_1(input_mem[3][cur_input_height_count + 0][cur_input_height_count + 0]),
        .input_unit_2(input_mem[3][cur_input_height_count + 0][cur_input_height_count + 1]),
        .input_unit_3(input_mem[3][cur_input_height_count + 0][cur_input_height_count + 2]),
        .input_unit_4(input_mem[3][cur_input_height_count + 0][cur_input_height_count + 3]),
        .input_unit_5(input_mem[3][cur_input_height_count + 0][cur_input_height_count + 4]),
        .input_unit_6(input_mem[3][cur_input_height_count + 1][cur_input_height_count + 0]),
        .input_unit_7(input_mem[3][cur_input_height_count + 1][cur_input_height_count + 1]),
        .input_unit_8(input_mem[3][cur_input_height_count + 1][cur_input_height_count + 2]),
        .input_unit_9(input_mem[3][cur_input_height_count + 1][cur_input_height_count + 3]),
        .input_unit_10(input_mem[3][cur_input_height_count + 1][cur_input_height_count + 4]),
        .input_unit_11(input_mem[3][cur_input_height_count + 2][cur_input_height_count + 0]),
        .input_unit_12(input_mem[3][cur_input_height_count + 2][cur_input_height_count + 1]),
        .input_unit_13(input_mem[3][cur_input_height_count + 2][cur_input_height_count + 2]),
        .input_unit_14(input_mem[3][cur_input_height_count + 2][cur_input_height_count + 3]),
        .input_unit_15(input_mem[3][cur_input_height_count + 2][cur_input_height_count + 4]),
        .input_unit_16(input_mem[3][cur_input_height_count + 3][cur_input_height_count + 0]),
        .input_unit_17(input_mem[3][cur_input_height_count + 3][cur_input_height_count + 1]),
        .input_unit_18(input_mem[3][cur_input_height_count + 3][cur_input_height_count + 2]),
        .input_unit_19(input_mem[3][cur_input_height_count + 3][cur_input_height_count + 3]),
        .input_unit_20(input_mem[3][cur_input_height_count + 3][cur_input_height_count + 4]),
        .input_unit_21(input_mem[3][cur_input_height_count + 4][cur_input_height_count + 0]),
        .input_unit_22(input_mem[3][cur_input_height_count + 4][cur_input_height_count + 1]),
        .input_unit_23(input_mem[3][cur_input_height_count + 4][cur_input_height_count + 2]),
        .input_unit_24(input_mem[3][cur_input_height_count + 4][cur_input_height_count + 3]),
        .input_unit_25(input_mem[3][cur_input_height_count + 4][cur_input_height_count + 4]),
        .weight_unit_1(weight1_mem[75]),
        .weight_unit_2(weight1_mem[76]),
        .weight_unit_3(weight1_mem[77]),
        .weight_unit_4(weight1_mem[78]),
        .weight_unit_5(weight1_mem[79]),
        .weight_unit_6(weight1_mem[80]),
        .weight_unit_7(weight1_mem[81]),
        .weight_unit_8(weight1_mem[82]),
        .weight_unit_9(weight1_mem[83]),
        .weight_unit_10(weight1_mem[84]),
        .weight_unit_11(weight1_mem[85]),
        .weight_unit_12(weight1_mem[86]),
        .weight_unit_13(weight1_mem[87]),
        .weight_unit_14(weight1_mem[88]),
        .weight_unit_15(weight1_mem[89]),
        .weight_unit_16(weight1_mem[90]),
        .weight_unit_17(weight1_mem[91]),
        .weight_unit_18(weight1_mem[92]),
        .weight_unit_19(weight1_mem[93]),
        .weight_unit_20(weight1_mem[94]),
        .weight_unit_21(weight1_mem[95]),
        .weight_unit_22(weight1_mem[96]),
        .weight_unit_23(weight1_mem[97]),
        .weight_unit_24(weight1_mem[98]),
        .weight_unit_25(weight1_mem[99]),
        .bias_unit(12'b0),
        .output_unit_1(conv_res[3])
    );
    calculate_2d cal_instance5(
        .clk(clk),
        .input_unit_1(input_mem[4][cur_input_height_count + 0][cur_input_height_count + 0]),
        .input_unit_2(input_mem[4][cur_input_height_count + 0][cur_input_height_count + 1]),
        .input_unit_3(input_mem[4][cur_input_height_count + 0][cur_input_height_count + 2]),
        .input_unit_4(input_mem[4][cur_input_height_count + 0][cur_input_height_count + 3]),
        .input_unit_5(input_mem[4][cur_input_height_count + 0][cur_input_height_count + 4]),
        .input_unit_6(input_mem[4][cur_input_height_count + 1][cur_input_height_count + 0]),
        .input_unit_7(input_mem[4][cur_input_height_count + 1][cur_input_height_count + 1]),
        .input_unit_8(input_mem[4][cur_input_height_count + 1][cur_input_height_count + 2]),
        .input_unit_9(input_mem[4][cur_input_height_count + 1][cur_input_height_count + 3]),
        .input_unit_10(input_mem[4][cur_input_height_count + 1][cur_input_height_count + 4]),
        .input_unit_11(input_mem[4][cur_input_height_count + 2][cur_input_height_count + 0]),
        .input_unit_12(input_mem[4][cur_input_height_count + 2][cur_input_height_count + 1]),
        .input_unit_13(input_mem[4][cur_input_height_count + 2][cur_input_height_count + 2]),
        .input_unit_14(input_mem[4][cur_input_height_count + 2][cur_input_height_count + 3]),
        .input_unit_15(input_mem[4][cur_input_height_count + 2][cur_input_height_count + 4]),
        .input_unit_16(input_mem[4][cur_input_height_count + 3][cur_input_height_count + 0]),
        .input_unit_17(input_mem[4][cur_input_height_count + 3][cur_input_height_count + 1]),
        .input_unit_18(input_mem[4][cur_input_height_count + 3][cur_input_height_count + 2]),
        .input_unit_19(input_mem[4][cur_input_height_count + 3][cur_input_height_count + 3]),
        .input_unit_20(input_mem[4][cur_input_height_count + 3][cur_input_height_count + 4]),
        .input_unit_21(input_mem[4][cur_input_height_count + 4][cur_input_height_count + 0]),
        .input_unit_22(input_mem[4][cur_input_height_count + 4][cur_input_height_count + 1]),
        .input_unit_23(input_mem[4][cur_input_height_count + 4][cur_input_height_count + 2]),
        .input_unit_24(input_mem[4][cur_input_height_count + 4][cur_input_height_count + 3]),
        .input_unit_25(input_mem[4][cur_input_height_count + 4][cur_input_height_count + 4]),
        .weight_unit_1(weight1_mem[100]),
        .weight_unit_2(weight1_mem[101]),
        .weight_unit_3(weight1_mem[102]),
        .weight_unit_4(weight1_mem[103]),
        .weight_unit_5(weight1_mem[104]),
        .weight_unit_6(weight1_mem[105]),
        .weight_unit_7(weight1_mem[106]),
        .weight_unit_8(weight1_mem[107]),
        .weight_unit_9(weight1_mem[108]),
        .weight_unit_10(weight1_mem[109]),
        .weight_unit_11(weight1_mem[110]),
        .weight_unit_12(weight1_mem[111]),
        .weight_unit_13(weight1_mem[112]),
        .weight_unit_14(weight1_mem[113]),
        .weight_unit_15(weight1_mem[114]),
        .weight_unit_16(weight1_mem[115]),
        .weight_unit_17(weight1_mem[116]),
        .weight_unit_18(weight1_mem[117]),
        .weight_unit_19(weight1_mem[118]),
        .weight_unit_20(weight1_mem[119]),
        .weight_unit_21(weight1_mem[120]),
        .weight_unit_22(weight1_mem[121]),
        .weight_unit_23(weight1_mem[122]),
        .weight_unit_24(weight1_mem[123]),
        .weight_unit_25(weight1_mem[124]),
        .bias_unit(12'b0),
        .output_unit_1(conv_res[4])
    );
    calculate_2d cal_instance6(
        .clk(clk),
        .input_unit_1(input_mem[5][cur_input_height_count + 0][cur_input_height_count + 0]),
        .input_unit_2(input_mem[5][cur_input_height_count + 0][cur_input_height_count + 1]),
        .input_unit_3(input_mem[5][cur_input_height_count + 0][cur_input_height_count + 2]),
        .input_unit_4(input_mem[5][cur_input_height_count + 0][cur_input_height_count + 3]),
        .input_unit_5(input_mem[5][cur_input_height_count + 0][cur_input_height_count + 4]),
        .input_unit_6(input_mem[5][cur_input_height_count + 1][cur_input_height_count + 0]),
        .input_unit_7(input_mem[5][cur_input_height_count + 1][cur_input_height_count + 1]),
        .input_unit_8(input_mem[5][cur_input_height_count + 1][cur_input_height_count + 2]),
        .input_unit_9(input_mem[5][cur_input_height_count + 1][cur_input_height_count + 3]),
        .input_unit_10(input_mem[5][cur_input_height_count + 1][cur_input_height_count + 4]),
        .input_unit_11(input_mem[5][cur_input_height_count + 2][cur_input_height_count + 0]),
        .input_unit_12(input_mem[5][cur_input_height_count + 2][cur_input_height_count + 1]),
        .input_unit_13(input_mem[5][cur_input_height_count + 2][cur_input_height_count + 2]),
        .input_unit_14(input_mem[5][cur_input_height_count + 2][cur_input_height_count + 3]),
        .input_unit_15(input_mem[5][cur_input_height_count + 2][cur_input_height_count + 4]),
        .input_unit_16(input_mem[5][cur_input_height_count + 3][cur_input_height_count + 0]),
        .input_unit_17(input_mem[5][cur_input_height_count + 3][cur_input_height_count + 1]),
        .input_unit_18(input_mem[5][cur_input_height_count + 3][cur_input_height_count + 2]),
        .input_unit_19(input_mem[5][cur_input_height_count + 3][cur_input_height_count + 3]),
        .input_unit_20(input_mem[5][cur_input_height_count + 3][cur_input_height_count + 4]),
        .input_unit_21(input_mem[5][cur_input_height_count + 4][cur_input_height_count + 0]),
        .input_unit_22(input_mem[5][cur_input_height_count + 4][cur_input_height_count + 1]),
        .input_unit_23(input_mem[5][cur_input_height_count + 4][cur_input_height_count + 2]),
        .input_unit_24(input_mem[5][cur_input_height_count + 4][cur_input_height_count + 3]),
        .input_unit_25(input_mem[5][cur_input_height_count + 4][cur_input_height_count + 4]),
        .weight_unit_1(weight1_mem[125]),
        .weight_unit_2(weight1_mem[126]),
        .weight_unit_3(weight1_mem[127]),
        .weight_unit_4(weight1_mem[128]),
        .weight_unit_5(weight1_mem[129]),
        .weight_unit_6(weight1_mem[130]),
        .weight_unit_7(weight1_mem[131]),
        .weight_unit_8(weight1_mem[132]),
        .weight_unit_9(weight1_mem[133]),
        .weight_unit_10(weight1_mem[134]),
        .weight_unit_11(weight1_mem[135]),
        .weight_unit_12(weight1_mem[136]),
        .weight_unit_13(weight1_mem[137]),
        .weight_unit_14(weight1_mem[138]),
        .weight_unit_15(weight1_mem[139]),
        .weight_unit_16(weight1_mem[140]),
        .weight_unit_17(weight1_mem[141]),
        .weight_unit_18(weight1_mem[142]),
        .weight_unit_19(weight1_mem[143]),
        .weight_unit_20(weight1_mem[144]),
        .weight_unit_21(weight1_mem[145]),
        .weight_unit_22(weight1_mem[146]),
        .weight_unit_23(weight1_mem[147]),
        .weight_unit_24(weight1_mem[148]),
        .weight_unit_25(weight1_mem[149]),
        .bias_unit(12'b0),
        .output_unit_1(conv_res[5])
    );

    wire [11:0] res_stage2;
    wire pool_done_ins1;
    wire stage2_en;
    assign stage2_en = (cal_st == CONVOLUTION);

    stage2_add stage2(
    .clk(clk),
    .en(stage2_en),
    .datain_a(conv_res[0]),
    .datain_b(conv_res[1]),
    .datain_c(conv_res[2]),
    .datain_d(conv_res[3]),
    .datain_e(conv_res[4]),
    .datain_f(conv_res[5]),
    .dataout(res_stage2)
    );


    wire pool_en = cal_st==CONVOLUTION;

    pooling_layer3 L4_pool_instance1(
        clk,
        pool_en,
        L4_output_read_data1,
        res_stage2,
        L4_output_read_addr1,
        L4_output_write_addr1,
        L4_output_wea1,
        L4_output_write_data1,
        pool_done_ins1
    );
    

    // wire [11:0] conv_res2 [0:5];

    //  calculate_2d cal_instance7(
    //     .clk(clk),
    //     .input_unit_1(input_mem[0+col*14+row+INP_BASE_1]),
    //     .input_unit_2(input_mem[1+col*14+row+INP_BASE_1]),
    //     .input_unit_3(input_mem[2+col*14+row+INP_BASE_1]),
    //     .input_unit_4(input_mem[3+col*14+row+INP_BASE_1]),
    //     .input_unit_5(input_mem[4+col*14+row+INP_BASE_1]),
    //     .input_unit_6(input_mem[14+col*14+row+INP_BASE_1]),
    //     .input_unit_7(input_mem[15+col*14+row+INP_BASE_1]),
    //     .input_unit_8(input_mem[16+col*14+row+INP_BASE_1]),
    //     .input_unit_9(input_mem[17+col*14+row+INP_BASE_1]),
    //     .input_unit_10(input_mem[18+col*14+row+INP_BASE_1]),
    //     .input_unit_11(input_mem[28+col*14+row+INP_BASE_1]),
    //     .input_unit_12(input_mem[29+col*14+row+INP_BASE_1]),
    //     .input_unit_13(input_mem[30+col*14+row+INP_BASE_1]),
    //     .input_unit_14(input_mem[31+col*14+row+INP_BASE_1]),
    //     .input_unit_15(input_mem[32+col*14+row+INP_BASE_1]),
    //     .input_unit_16(input_mem[42+col*14+row+INP_BASE_1]),
    //     .input_unit_17(input_mem[43+col*14+row+INP_BASE_1]),
    //     .input_unit_18(input_mem[44+col*14+row+INP_BASE_1]),
    //     .input_unit_19(input_mem[45+col*14+row+INP_BASE_1]),
    //     .input_unit_20(input_mem[46+col*14+row+INP_BASE_1]),
    //     .input_unit_21(input_mem[56+col*14+row+INP_BASE_1]),
    //     .input_unit_22(input_mem[57+col*14+row+INP_BASE_1]),
    //     .input_unit_23(input_mem[58+col*14+row+INP_BASE_1]),
    //     .input_unit_24(input_mem[59+col*14+row+INP_BASE_1]),
    //     .input_unit_25(input_mem[60+col*14+row+INP_BASE_1]),
    //     .weight_unit_1(weight2_mem[0]),
    //     .weight_unit_2(weight2_mem[1]),
    //     .weight_unit_3(weight2_mem[2]),
    //     .weight_unit_4(weight2_mem[3]),
    //     .weight_unit_5(weight2_mem[4]),
    //     .weight_unit_6(weight2_mem[5]),
    //     .weight_unit_7(weight2_mem[6]),
    //     .weight_unit_8(weight2_mem[7]),
    //     .weight_unit_9(weight2_mem[8]),
    //     .weight_unit_10(weight2_mem[9]),
    //     .weight_unit_11(weight2_mem[10]),
    //     .weight_unit_12(weight2_mem[11]),
    //     .weight_unit_13(weight2_mem[12]),
    //     .weight_unit_14(weight2_mem[13]),
    //     .weight_unit_15(weight2_mem[14]),
    //     .weight_unit_16(weight2_mem[15]),
    //     .weight_unit_17(weight2_mem[16]),
    //     .weight_unit_18(weight2_mem[17]),
    //     .weight_unit_19(weight2_mem[18]),
    //     .weight_unit_20(weight2_mem[19]),
    //     .weight_unit_21(weight2_mem[20]),
    //     .weight_unit_22(weight2_mem[21]),
    //     .weight_unit_23(weight2_mem[22]),
    //     .weight_unit_24(weight2_mem[23]),
    //     .weight_unit_25(weight2_mem[24]),
    //     .bias_unit(bias2_mem),
    //     .output_unit_1(conv_res2[0])
    //   );


    // calculate_2d cal_instance8(
    //     .clk(clk),
    //     .input_unit_1(input_mem[0+col*14+row+INP_BASE_2]),
    //     .input_unit_2(input_mem[1+col*14+row+INP_BASE_2]),
    //     .input_unit_3(input_mem[2+col*14+row+INP_BASE_2]),
    //     .input_unit_4(input_mem[3+col*14+row+INP_BASE_2]),
    //     .input_unit_5(input_mem[4+col*14+row+INP_BASE_2]),
    //     .input_unit_6(input_mem[14+col*14+row+INP_BASE_2]),
    //     .input_unit_7(input_mem[15+col*14+row+INP_BASE_2]),
    //     .input_unit_8(input_mem[16+col*14+row+INP_BASE_2]),
    //     .input_unit_9(input_mem[17+col*14+row+INP_BASE_2]),
    //     .input_unit_10(input_mem[18+col*14+row+INP_BASE_2]),
    //     .input_unit_11(input_mem[28+col*14+row+INP_BASE_2]),
    //     .input_unit_12(input_mem[29+col*14+row+INP_BASE_2]),
    //     .input_unit_13(input_mem[30+col*14+row+INP_BASE_2]),
    //     .input_unit_14(input_mem[31+col*14+row+INP_BASE_2]),
    //     .input_unit_15(input_mem[32+col*14+row+INP_BASE_2]),
    //     .input_unit_16(input_mem[42+col*14+row+INP_BASE_2]),
    //     .input_unit_17(input_mem[43+col*14+row+INP_BASE_2]),
    //     .input_unit_18(input_mem[44+col*14+row+INP_BASE_2]),
    //     .input_unit_19(input_mem[45+col*14+row+INP_BASE_2]),
    //     .input_unit_20(input_mem[46+col*14+row+INP_BASE_2]),
    //     .input_unit_21(input_mem[56+col*14+row+INP_BASE_2]),
    //     .input_unit_22(input_mem[57+col*14+row+INP_BASE_2]),
    //     .input_unit_23(input_mem[58+col*14+row+INP_BASE_2]),
    //     .input_unit_24(input_mem[59+col*14+row+INP_BASE_2]),
    //     .input_unit_25(input_mem[60+col*14+row+INP_BASE_2]),
    //     .weight_unit_1(weight2_mem[25]),
    //     .weight_unit_2(weight2_mem[26]),
    //     .weight_unit_3(weight2_mem[27]),
    //     .weight_unit_4(weight2_mem[28]),
    //     .weight_unit_5(weight2_mem[29]),
    //     .weight_unit_6(weight2_mem[30]),
    //     .weight_unit_7(weight2_mem[31]),
    //     .weight_unit_8(weight2_mem[32]),
    //     .weight_unit_9(weight2_mem[33]),
    //     .weight_unit_10(weight2_mem[34]),
    //     .weight_unit_11(weight2_mem[35]),
    //     .weight_unit_12(weight2_mem[36]),
    //     .weight_unit_13(weight2_mem[37]),
    //     .weight_unit_14(weight2_mem[38]),
    //     .weight_unit_15(weight2_mem[39]),
    //     .weight_unit_16(weight2_mem[40]),
    //     .weight_unit_17(weight2_mem[41]),
    //     .weight_unit_18(weight2_mem[42]),
    //     .weight_unit_19(weight2_mem[43]),
    //     .weight_unit_20(weight2_mem[44]),
    //     .weight_unit_21(weight2_mem[45]),
    //     .weight_unit_22(weight2_mem[46]),
    //     .weight_unit_23(weight2_mem[47]),
    //     .weight_unit_24(weight2_mem[48]),
    //     .weight_unit_25(weight2_mem[49]),
    //     .bias_unit(12'b0),
    //     .output_unit_1(conv_res2[1])
    // );
    // calculate_2d cal_instance9(
    //     .clk(clk),
    //     .input_unit_1(input_mem[0+col*14+row+INP_BASE_3]),
    //     .input_unit_2(input_mem[1+col*14+row+INP_BASE_3]),
    //     .input_unit_3(input_mem[2+col*14+row+INP_BASE_3]),
    //     .input_unit_4(input_mem[3+col*14+row+INP_BASE_3]),
    //     .input_unit_5(input_mem[4+col*14+row+INP_BASE_3]),
    //     .input_unit_6(input_mem[14+col*14+row+INP_BASE_3]),
    //     .input_unit_7(input_mem[15+col*14+row+INP_BASE_3]),
    //     .input_unit_8(input_mem[16+col*14+row+INP_BASE_3]),
    //     .input_unit_9(input_mem[17+col*14+row+INP_BASE_3]),
    //     .input_unit_10(input_mem[18+col*14+row+INP_BASE_3]),
    //     .input_unit_11(input_mem[28+col*14+row+INP_BASE_3]),
    //     .input_unit_12(input_mem[29+col*14+row+INP_BASE_3]),
    //     .input_unit_13(input_mem[30+col*14+row+INP_BASE_3]),
    //     .input_unit_14(input_mem[31+col*14+row+INP_BASE_3]),
    //     .input_unit_15(input_mem[32+col*14+row+INP_BASE_3]),
    //     .input_unit_16(input_mem[42+col*14+row+INP_BASE_3]),
    //     .input_unit_17(input_mem[43+col*14+row+INP_BASE_3]),
    //     .input_unit_18(input_mem[44+col*14+row+INP_BASE_3]),
    //     .input_unit_19(input_mem[45+col*14+row+INP_BASE_3]),
    //     .input_unit_20(input_mem[46+col*14+row+INP_BASE_3]),
    //     .input_unit_21(input_mem[56+col*14+row+INP_BASE_3]),
    //     .input_unit_22(input_mem[57+col*14+row+INP_BASE_3]),
    //     .input_unit_23(input_mem[58+col*14+row+INP_BASE_3]),
    //     .input_unit_24(input_mem[59+col*14+row+INP_BASE_3]),
    //     .input_unit_25(input_mem[60+col*14+row+INP_BASE_3]),
    //     .weight_unit_1(weight2_mem[50]),
    //     .weight_unit_2(weight2_mem[51]),
    //     .weight_unit_3(weight2_mem[52]),
    //     .weight_unit_4(weight2_mem[53]),
    //     .weight_unit_5(weight2_mem[54]),
    //     .weight_unit_6(weight2_mem[55]),
    //     .weight_unit_7(weight2_mem[56]),
    //     .weight_unit_8(weight2_mem[57]),
    //     .weight_unit_9(weight2_mem[58]),
    //     .weight_unit_10(weight2_mem[59]),
    //     .weight_unit_11(weight2_mem[60]),
    //     .weight_unit_12(weight2_mem[61]),
    //     .weight_unit_13(weight2_mem[62]),
    //     .weight_unit_14(weight2_mem[63]),
    //     .weight_unit_15(weight2_mem[64]),
    //     .weight_unit_16(weight2_mem[65]),
    //     .weight_unit_17(weight2_mem[66]),
    //     .weight_unit_18(weight2_mem[67]),
    //     .weight_unit_19(weight2_mem[68]),
    //     .weight_unit_20(weight2_mem[69]),
    //     .weight_unit_21(weight2_mem[70]),
    //     .weight_unit_22(weight2_mem[71]),
    //     .weight_unit_23(weight2_mem[72]),
    //     .weight_unit_24(weight2_mem[73]),
    //     .weight_unit_25(weight2_mem[74]),
    //     .bias_unit(12'b0),
    //     .output_unit_1(conv_res2[2])
    // );
    // calculate_2d cal_instance10(
    //     .clk(clk),
    //     .input_unit_1(input_mem[0+col*14+row+INP_BASE_4]),
    //     .input_unit_2(input_mem[1+col*14+row+INP_BASE_4]),
    //     .input_unit_3(input_mem[2+col*14+row+INP_BASE_4]),
    //     .input_unit_4(input_mem[3+col*14+row+INP_BASE_4]),
    //     .input_unit_5(input_mem[4+col*14+row+INP_BASE_4]),
    //     .input_unit_6(input_mem[14+col*14+row+INP_BASE_4]),
    //     .input_unit_7(input_mem[15+col*14+row+INP_BASE_4]),
    //     .input_unit_8(input_mem[16+col*14+row+INP_BASE_4]),
    //     .input_unit_9(input_mem[17+col*14+row+INP_BASE_4]),
    //     .input_unit_10(input_mem[18+col*14+row+INP_BASE_4]),
    //     .input_unit_11(input_mem[28+col*14+row+INP_BASE_4]),
    //     .input_unit_12(input_mem[29+col*14+row+INP_BASE_4]),
    //     .input_unit_13(input_mem[30+col*14+row+INP_BASE_4]),
    //     .input_unit_14(input_mem[31+col*14+row+INP_BASE_4]),
    //     .input_unit_15(input_mem[32+col*14+row+INP_BASE_4]),
    //     .input_unit_16(input_mem[42+col*14+row+INP_BASE_4]),
    //     .input_unit_17(input_mem[43+col*14+row+INP_BASE_4]),
    //     .input_unit_18(input_mem[44+col*14+row+INP_BASE_4]),
    //     .input_unit_19(input_mem[45+col*14+row+INP_BASE_4]),
    //     .input_unit_20(input_mem[46+col*14+row+INP_BASE_4]),
    //     .input_unit_21(input_mem[56+col*14+row+INP_BASE_4]),
    //     .input_unit_22(input_mem[57+col*14+row+INP_BASE_4]),
    //     .input_unit_23(input_mem[58+col*14+row+INP_BASE_4]),
    //     .input_unit_24(input_mem[59+col*14+row+INP_BASE_4]),
    //     .input_unit_25(input_mem[60+col*14+row+INP_BASE_4]),
    //     .weight_unit_1(weight2_mem[75]),
    //     .weight_unit_2(weight2_mem[76]),
    //     .weight_unit_3(weight2_mem[77]),
    //     .weight_unit_4(weight2_mem[78]),
    //     .weight_unit_5(weight2_mem[79]),
    //     .weight_unit_6(weight2_mem[80]),
    //     .weight_unit_7(weight2_mem[81]),
    //     .weight_unit_8(weight2_mem[82]),
    //     .weight_unit_9(weight2_mem[83]),
    //     .weight_unit_10(weight2_mem[84]),
    //     .weight_unit_11(weight2_mem[85]),
    //     .weight_unit_12(weight2_mem[86]),
    //     .weight_unit_13(weight2_mem[87]),
    //     .weight_unit_14(weight2_mem[88]),
    //     .weight_unit_15(weight2_mem[89]),
    //     .weight_unit_16(weight2_mem[90]),
    //     .weight_unit_17(weight2_mem[91]),
    //     .weight_unit_18(weight2_mem[92]),
    //     .weight_unit_19(weight2_mem[93]),
    //     .weight_unit_20(weight2_mem[94]),
    //     .weight_unit_21(weight2_mem[95]),
    //     .weight_unit_22(weight2_mem[96]),
    //     .weight_unit_23(weight2_mem[97]),
    //     .weight_unit_24(weight2_mem[98]),
    //     .weight_unit_25(weight2_mem[99]),
    //     .bias_unit(12'b0),
    //     .output_unit_1(conv_res2[3])
    // );
    // calculate_2d cal_instance11(
    //     .clk(clk),
    //     .input_unit_1(input_mem[0+col*14+row+INP_BASE_5]),
    //     .input_unit_2(input_mem[1+col*14+row+INP_BASE_5]),
    //     .input_unit_3(input_mem[2+col*14+row+INP_BASE_5]),
    //     .input_unit_4(input_mem[3+col*14+row+INP_BASE_5]),
    //     .input_unit_5(input_mem[4+col*14+row+INP_BASE_5]),
    //     .input_unit_6(input_mem[14+col*14+row+INP_BASE_5]),
    //     .input_unit_7(input_mem[15+col*14+row+INP_BASE_5]),
    //     .input_unit_8(input_mem[16+col*14+row+INP_BASE_5]),
    //     .input_unit_9(input_mem[17+col*14+row+INP_BASE_5]),
    //     .input_unit_10(input_mem[18+col*14+row+INP_BASE_5]),
    //     .input_unit_11(input_mem[28+col*14+row+INP_BASE_5]),
    //     .input_unit_12(input_mem[29+col*14+row+INP_BASE_5]),
    //     .input_unit_13(input_mem[30+col*14+row+INP_BASE_5]),
    //     .input_unit_14(input_mem[31+col*14+row+INP_BASE_5]),
    //     .input_unit_15(input_mem[32+col*14+row+INP_BASE_5]),
    //     .input_unit_16(input_mem[42+col*14+row+INP_BASE_5]),
    //     .input_unit_17(input_mem[43+col*14+row+INP_BASE_5]),
    //     .input_unit_18(input_mem[44+col*14+row+INP_BASE_5]),
    //     .input_unit_19(input_mem[45+col*14+row+INP_BASE_5]),
    //     .input_unit_20(input_mem[46+col*14+row+INP_BASE_5]),
    //     .input_unit_21(input_mem[56+col*14+row+INP_BASE_5]),
    //     .input_unit_22(input_mem[57+col*14+row+INP_BASE_5]),
    //     .input_unit_23(input_mem[58+col*14+row+INP_BASE_5]),
    //     .input_unit_24(input_mem[59+col*14+row+INP_BASE_5]),
    //     .input_unit_25(input_mem[60+col*14+row+INP_BASE_5]),
    //     .weight_unit_1(weight2_mem[100]),
    //     .weight_unit_2(weight2_mem[101]),
    //     .weight_unit_3(weight2_mem[102]),
    //     .weight_unit_4(weight2_mem[103]),
    //     .weight_unit_5(weight2_mem[104]),
    //     .weight_unit_6(weight2_mem[105]),
    //     .weight_unit_7(weight2_mem[106]),
    //     .weight_unit_8(weight2_mem[107]),
    //     .weight_unit_9(weight2_mem[108]),
    //     .weight_unit_10(weight2_mem[109]),
    //     .weight_unit_11(weight2_mem[110]),
    //     .weight_unit_12(weight2_mem[111]),
    //     .weight_unit_13(weight2_mem[112]),
    //     .weight_unit_14(weight2_mem[113]),
    //     .weight_unit_15(weight2_mem[114]),
    //     .weight_unit_16(weight2_mem[115]),
    //     .weight_unit_17(weight2_mem[116]),
    //     .weight_unit_18(weight2_mem[117]),
    //     .weight_unit_19(weight2_mem[118]),
    //     .weight_unit_20(weight2_mem[119]),
    //     .weight_unit_21(weight2_mem[120]),
    //     .weight_unit_22(weight2_mem[121]),
    //     .weight_unit_23(weight2_mem[122]),
    //     .weight_unit_24(weight2_mem[123]),
    //     .weight_unit_25(weight2_mem[124]),
    //     .bias_unit(12'b0),
    //     .output_unit_1(conv_res2[4])
    // );
    // calculate_2d cal_instance12(
    //     .clk(clk),
    //     .input_unit_1(input_mem[0+col*14+row+INP_BASE_6]),
    //     .input_unit_2(input_mem[1+col*14+row+INP_BASE_6]),
    //     .input_unit_3(input_mem[2+col*14+row+INP_BASE_6]),
    //     .input_unit_4(input_mem[3+col*14+row+INP_BASE_6]),
    //     .input_unit_5(input_mem[4+col*14+row+INP_BASE_6]),
    //     .input_unit_6(input_mem[14+col*14+row+INP_BASE_6]),
    //     .input_unit_7(input_mem[15+col*14+row+INP_BASE_6]),
    //     .input_unit_8(input_mem[16+col*14+row+INP_BASE_6]),
    //     .input_unit_9(input_mem[17+col*14+row+INP_BASE_6]),
    //     .input_unit_10(input_mem[18+col*14+row+INP_BASE_6]),
    //     .input_unit_11(input_mem[28+col*14+row+INP_BASE_6]),
    //     .input_unit_12(input_mem[29+col*14+row+INP_BASE_6]),
    //     .input_unit_13(input_mem[30+col*14+row+INP_BASE_6]),
    //     .input_unit_14(input_mem[31+col*14+row+INP_BASE_6]),
    //     .input_unit_15(input_mem[32+col*14+row+INP_BASE_6]),
    //     .input_unit_16(input_mem[42+col*14+row+INP_BASE_6]),
    //     .input_unit_17(input_mem[43+col*14+row+INP_BASE_6]),
    //     .input_unit_18(input_mem[44+col*14+row+INP_BASE_6]),
    //     .input_unit_19(input_mem[45+col*14+row+INP_BASE_6]),
    //     .input_unit_20(input_mem[46+col*14+row+INP_BASE_6]),
    //     .input_unit_21(input_mem[56+col*14+row+INP_BASE_6]),
    //     .input_unit_22(input_mem[57+col*14+row+INP_BASE_6]),
    //     .input_unit_23(input_mem[58+col*14+row+INP_BASE_6]),
    //     .input_unit_24(input_mem[59+col*14+row+INP_BASE_6]),
    //     .input_unit_25(input_mem[60+col*14+row+INP_BASE_6]),
    //     .weight_unit_1(weight2_mem[125]),
    //     .weight_unit_2(weight2_mem[126]),
    //     .weight_unit_3(weight2_mem[127]),
    //     .weight_unit_4(weight2_mem[128]),
    //     .weight_unit_5(weight2_mem[129]),
    //     .weight_unit_6(weight2_mem[130]),
    //     .weight_unit_7(weight2_mem[131]),
    //     .weight_unit_8(weight2_mem[132]),
    //     .weight_unit_9(weight2_mem[133]),
    //     .weight_unit_10(weight2_mem[134]),
    //     .weight_unit_11(weight2_mem[135]),
    //     .weight_unit_12(weight2_mem[136]),
    //     .weight_unit_13(weight2_mem[137]),
    //     .weight_unit_14(weight2_mem[138]),
    //     .weight_unit_15(weight2_mem[139]),
    //     .weight_unit_16(weight2_mem[140]),
    //     .weight_unit_17(weight2_mem[141]),
    //     .weight_unit_18(weight2_mem[142]),
    //     .weight_unit_19(weight2_mem[143]),
    //     .weight_unit_20(weight2_mem[144]),
    //     .weight_unit_21(weight2_mem[145]),
    //     .weight_unit_22(weight2_mem[146]),
    //     .weight_unit_23(weight2_mem[147]),
    //     .weight_unit_24(weight2_mem[148]),
    //     .weight_unit_25(weight2_mem[149]),
    //     .bias_unit(12'b0),
    //     .output_unit_1(conv_res2[5])
    // );

    // wire [11:0] res_stage2_;
    // wire pool_done_ins2;

    // stage2_add stage2_(
    // .clk(clk),
    // .en(stage2_en),
    // .datain_a(conv_res2[0]),
    // .datain_b(conv_res2[1]),
    // .datain_c(conv_res2[2]),
    // .datain_d(conv_res2[3]),
    // .datain_e(conv_res2[4]),
    // .datain_f(conv_res2[5]),
    // .dataout(res_stage2_)
    // );


    // input [11:0] L4_output_read_data1,
    // input [11:0] L4_output_read_data2,
    // output [7:0] L4_output_read_addr1,
    // output [7:0] L4_output_read_addr2,
    // output [7:0] L4_output_write_addr1,
    // output [7:0] L4_output_write_addr2,
    // output [11:0] L4_output_write_data1,
    // output [11:0] L4_output_write_data2,
    // output L4_output_wea1,
    // output L4_output_wea2,


    // pooling_layer3 L4_pool_instance2(
    //     clk,
    //     pool_en,
    //     L4_output_read_data2,
    //     res_stage2_,
    //     L4_output_read_addr2,
    //     L4_output_write_addr2,
    //     L4_output_wea2,
    //     L4_output_write_data2,
    //     pool_done_ins2
    // );




endmodule
