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
parameter  DATA_WIDTH = 16,
           TOTAL_SIZE = 151,
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

    //L3 weight blcok memory
    input [DATA_WIDTH - 1:0] L3_weight_douta,
    input [DATA_WIDTH - 1:0] L3_weight_doutb,
    output[DATA_WIDTH - 1:0] L3_weight_addra,
    output[DATA_WIDTH - 1:0] L3_weight_addrb,
    //L2 output block memory
    // input [DATA_WIDTH - 1:0] L2_feature1_douta,
    // input [DATA_WIDTH - 1:0] L2_feature2_douta,
    // input [DATA_WIDTH - 1:0] L2_feature3_douta,
    // input [DATA_WIDTH - 1:0] L2_feature4_douta,
    // input [DATA_WIDTH - 1:0] L2_feature5_douta,
    // input [DATA_WIDTH - 1:0] L2_feature6_douta,
    output [7:0] L2_feature_addr_read,
    //convoultion result
    input  [DATA_WIDTH - 1 : 0] result_1,
    input  [DATA_WIDTH - 1 : 0] result_2,
    
    //output block memory
    input [DATA_WIDTH - 1:0] L4_output_read_data1,
    input [DATA_WIDTH - 1:0] L4_output_read_data2,
    output [7:0] L4_output_read_addr,
    output [7:0] L4_output_write_addr,
    output [DATA_WIDTH - 1:0] L4_output_write_data1,
    output [DATA_WIDTH - 1:0] L4_output_write_data2,
    output L4_output_wea,
    //other flags
    output reg [3:0] cur_input_height_count,
    output reg [3:0] cur_input_width_count,
    output reg [1:0] inp_wait,
    output reg [2:0] wait_weight,
    output reg       load_weight_done,
    output reg       inp_load_done,
    output reg [11:0]cur_filter_count,
    output reg [3:0] col,row,
    output reg input_load_start,
    output L3_done
);

    reg inp_load_en;
    
    
    reg [1:0] after_load_inp;
    reg [3:0] st,nst;
    wire cal_done;

    wire [DATA_WIDTH - 1:0] conv_res [0:5];


    

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
            nst = (L3_en == 1'b1 ) ? DONE : IDLE;
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


        if(inp_wait == 2'b01)begin
            input_load_start <= 1'b1;
        end
        else begin
            input_load_start <= 1'b0;
        end
    end

    always@(posedge clk)begin
        //input load done
        if(cur_input_width_count == INPUT_WIDTH - 1 && cur_input_height_count == INPUT_HEIGHT - 1 )begin
            inp_load_done <= 1'b1;
        end
        else begin
            inp_load_done <= 1'b0;
        end
    end

    // assign inp_load_done = (cur_input_height_count == INPUT_WIDTH - 1) && (cur_input_width_count == INPUT_HEIGHT -1) ? 1'b1 : 1'b0;


    reg [7:0] read_address;

    //14*14*6  = 1176
    always@(posedge clk)begin
        //읽어오는 시간
        if(rst)begin
            read_address <= 1'b0;
        end
        else if(st == LOAD_INP)begin
            if(read_address == CAHNNEL_SIZE - 1)begin
                read_address <= read_address;
            end
            else begin
                read_address <= read_address + 1'b1;
            end
        end
        else begin
            read_address <= 1'b0;
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

    assign L2_feature_addr_read = read_address;
    assign L3_done = st == DONE;

    //state calculation
    //filter in
    //input data

    localparam   CAL_IDLE = 4'b0001, WEIGHT_LOAD = 4'b0010, CONVOLUTION = 4'b0100, DONE_CALCULATION = 4'b1000;

    reg [4:0]  kernel_count;

    reg [3:0] cal_st,nst_cal_st;

    reg conv_done;
    reg [11:0] weight_base1;
    reg [11:0] weight_base2;

    reg change_flag;
    
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


    always@(posedge clk)begin
        if(rst)begin
            cal_st <=CAL_IDLE;
        end        
        else begin
            cal_st <= nst_cal_st;
        end
    end

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
    end
    
    assign cal_done = cal_st == DONE_CALCULATION;

    //내부에서 커널 개수만큼 컨볼루션 반복해야하므로

    
    
    reg [11:0] filter_count_a;
    reg [11:0] filter_count_b;
    reg [11:0] filter_count;

    always@(posedge clk)begin
        if(rst)begin
            filter_count_a<=FILTER_BASE_0;
            filter_count_b<=FILTER_BASE_1;
            filter_count <= 0;
        end
        else if(st == CALCULATE)begin
            if(cal_st == WEIGHT_LOAD)begin
                if(filter_count == 12'd151)begin
                    filter_count<=filter_count;
                    filter_count_a <= filter_count_a;
                    filter_count_b <= filter_count_b;
                end
                else begin
                    filter_count<=filter_count + 1'b1;
                    filter_count_a <= filter_count_a + 1'b1;
                    filter_count_b <= filter_count_b + 1'b1;
                end
            end
            else begin
                filter_count <= 1'b0;
                filter_count_a <= filter_count_a;
                filter_count_b <= filter_count_b;
            end    
        end
        else begin
            filter_count <= 1'b0;
            filter_count_a <= FILTER_BASE_0;
            filter_count_b <= FILTER_BASE_1;
        end
    end

    assign L3_weight_addra = filter_count_a;
    assign L3_weight_addrb = filter_count_b;


    reg [3:0] wait_done;
    
//L3_done

    always@(posedge clk)begin
        if(cal_st == WEIGHT_LOAD)begin
            if(wait_weight == 2'b10)begin
                wait_weight <= wait_weight;
            end
            else begin
                wait_weight <= wait_weight + 1'b1;
            end
        end
        else begin
            wait_weight <= 1'b0;
        end

        if(wait_weight == 2'b10)begin
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

    

    //read done
    always@(posedge clk)begin
        if(col == 4'd9 && row == 4'd9)begin
            if(wait_done == 4'd9)begin
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
    end

    //read row , col
    always@(posedge clk)begin
        if(cal_st == CONVOLUTION)begin
            if(col == 5'd9 && row == 5'd9)begin
                row <= row;
                col <= col;
            end
            else if(row == 5'd9)begin
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

    
    wire signed [DATA_WIDTH -1:0] res_stage2 [0:1];
    wire pool_done_ins[0:1];
  
    wire pool_en = cal_st==CONVOLUTION;
    
    //stage 2 add tree && pooling && layer4 output block memory


    wire [4:0] L4_reserved [0:2];
    wire [11:0] pool_base_position;
    assign pool_base_position = 5'd25 * kernel_count;



    wire  [DATA_WIDTH -1:0] out_result_a,out_result_b;




    pooling_layer3 L4_pool_instance1(
        .clk(clk),
        .cal_en(pool_en),
        .base_position(pool_base_position),
        .L4_output_dout(L4_output_read_data1),
        .calculate_result(result_1),
        .L4_output_read_addr(L4_output_read_addr),
        .L4_output_write_addr(L4_output_write_addr),
        .L4_output_wea(L4_output_wea),
        .L4_out_din(L4_output_write_data1),
        .pool_done(pool_done_ins[0])
    );

    pooling_layer3 L4_pool_instance2(
        .clk(clk),
        .cal_en(pool_en),
        .base_position(pool_base_position),
        .L4_output_dout(L4_output_read_data2),
        .calculate_result(result_2),
        .L4_output_read_addr(L4_reserved[0]),
        .L4_output_write_addr(L4_reserved[1]),
        .L4_output_wea(L4_reserved[2]),
        .L4_out_din(L4_output_write_data2),
        .pool_done(pool_done_ins[1])
    );

    



endmodule
