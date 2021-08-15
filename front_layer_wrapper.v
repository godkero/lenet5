`timescale 1ns / 1ps


module front_layer_wrapper
#(
    parameter 
    DATA_WIDTH = 12, 
    FILTER_WIDTH = 5, 
    FILTER_WEIGHT = 5,
    INPUT_WIDTH = 32, 
    INPUT_HEIGTH = 32,
    OUTPUT_WIDTH = 28,
    OUTPUT_HEIGTH = 28,
    OUTPUT_FEATURE_MAP = 6,
    INPUT_ROW = DATA_WIDTH * INPUT_WIDTH,
    W_DEPTH = 26,
    IN_DEPTH = 1024,
    W_READ_SIZE = OUTPUT_FEATURE_MAP * DATA_WIDTH,
    WEIGHT_END = FILTER_WEIGHT*FILTER_WIDTH,
    IDLE = 4'b0001,
    LOAD_W = 4'b0010,
    CALCULATION = 4'b0100,
    DONE = 4'b1000
)
(
    input clk,rst,L1_en,
    //L1 params
    input [383 : 0] L1_in_data,
    output L1_done,
    output [7:0] L1_w_addr,
    output [4:0] L1_in_addr,
    input [DATA_WIDTH - 1 : 0] L1_w_data,
    output reg [4:0] row_cnt,

    //weight load param
    output reg  w_load_done,
    output reg [1:0] load_wait,
    output reg [5:0] weight_index,
    output reg [3:0] weight_channel,
    output      w_load_en,
    //conv result
    input [DATA_WIDTH - 1 : 0] con_result_1,
    input [DATA_WIDTH - 1 : 0] con_result_2,
    input [DATA_WIDTH - 1 : 0] con_result_3,
    input [DATA_WIDTH - 1 : 0] con_result_4,
    input [DATA_WIDTH - 1 : 0] con_result_5,
    input [DATA_WIDTH - 1 : 0] con_result_6,
    //L2 output block memory 
    input [DATA_WIDTH -1 : 0] L2_out1_dout,
    input [DATA_WIDTH -1 : 0] L2_out2_dout,
    input [DATA_WIDTH -1 : 0] L2_out3_dout,
    input [DATA_WIDTH -1 : 0] L2_out4_dout,
    input [DATA_WIDTH -1 : 0] L2_out5_dout,
    input [DATA_WIDTH -1 : 0] L2_out6_dout,
    output [DATA_WIDTH -1:0] L2_out1_din,
    output [DATA_WIDTH -1:0] L2_out2_din,
    output [DATA_WIDTH -1:0] L2_out3_din,
    output [DATA_WIDTH -1:0] L2_out4_din,
    output [DATA_WIDTH -1:0] L2_out5_din,
    output [DATA_WIDTH -1:0] L2_out6_din,
   
    output L2_out_wea,
    output [7:0] L2_out_addr_read,
    output [7:0] L2_out_addr_write,



    //other flags
    output reg [1:0] cal_wait,
    output reg [5:0] position_col,
    output reg [4:0] in_cell_row,
    output reg [4:0] in_cell_col,
    output reg [4:0] st,
    output reg output_start
);
    wire all_pool_done;
    wire pool_done_ins1;
    wire pool_done_ins2;
    wire pool_done_ins3;
    wire pool_done_ins4;
    wire pool_done_ins5;
    wire pool_done_ins6;




    reg [4:0] nst;

    // reg [5:0] position_col;
    //input

    
    
    
    
   
    //input data 위치 설정이 중요
    // reg [4:0] in_cell_row;
    // reg [4:0] in_cell_col;
    reg [2:0] wait_done;
    reg c_done;




   

    always@(posedge clk)begin
        if(st == CALCULATION)begin
            if(in_cell_col == 5'd28)begin
                if(wait_done == 3'd5)begin
                    c_done <= 1'b1;
                    wait_done <= wait_done;
                end
                else begin
                    c_done <= 1'b0;
                    wait_done <= wait_done + 1'b1;
                end
            end
            else begin
                c_done <= 1'b0;
                wait_done <= 1'b0;
            end
        
        end
        else begin
            c_done<=1'b0;
            wait_done <= 1'b0;
        end

        if(cal_wait == 2'b10)begin
            output_start <= 1'b1;
        end
        else begin
            output_start <= 1'b0;
        end

    end


    

    always@(posedge clk)begin
        if(st == CALCULATION)begin
            if(cal_wait == 2'b11)begin
                if(in_cell_col == 5'd28)begin
                    in_cell_row <= in_cell_row;
                    in_cell_col <= in_cell_col;
                end
                else if(row_cnt == 5'd27)begin
                    in_cell_row <= 1'b0;
                    in_cell_col <= in_cell_col + 1'b1;
                end
                else begin
                    in_cell_row <= in_cell_row + 1'b1;
                    in_cell_col <= in_cell_col;
                end
            end
            else begin
                in_cell_row <= 1'b0;
                in_cell_col <= 1'b0;
            end
            
            
            //row_cnt == 5'd27
            //reg [5:0] position_col;
        end
    end



   
    front_layer_address_gen gen_address(
        clk,st,in_cell_col,L1_in_addr,L1_w_addr
    );


    assign w_load_en = load_wait == 2'b10;

    //load w logic 
    always@(posedge clk)begin
        if(st == LOAD_W)begin
            if(load_wait == 2'b10)begin
        /////////////////////////////////////////// weight_index 0~24 weight 채우는 과정
                if(weight_index == 25 && weight_channel == 5)begin
                    weight_index <= weight_index;
                    weight_channel <= weight_channel;
                    w_load_done <= 1'b1;
                end
                else if(weight_index < WEIGHT_END)begin
                    weight_index <= weight_index + 1'b1;
                    weight_channel <= weight_channel;
                    w_load_done <= 1'b0;
                end
                ///////////////////////////////////// bias 채우는 과정
                else begin
                    weight_index <= 1'b0;
                    weight_channel <= weight_channel + 1'b1;
                    w_load_done <= 1'b0;
                end
                load_wait <= load_wait;
            end
            //read delay
            else begin
                w_load_done <= 1'b0;
                load_wait <= load_wait + 1'b1;
                weight_index <= 1'b0;
                weight_channel <= 1'b0;
            end
        end
        //not in load state
        else begin
            w_load_done <= 1'b0;
            load_wait <= 1'b0;
            weight_index <= 1'b0;
            weight_channel <= 1'b0;
        end
    end

    reg inp_done;
    always@(posedge clk)begin
        if(in_cell_row == 27 && in_cell_col == 27)begin
            inp_done <= 1'b1;
        end
        else begin
            inp_done <= 1'b0;
        end
    end

    //row 28 일 때 까지 row로 shift
    //이후 col로 shift하기 위해 count추가

    always@(posedge clk)begin
        if(st == CALCULATION)begin
            if(cal_wait == 2'b11)begin
                if(row_cnt == 5'd27)begin
                    row_cnt <= 1'b0;
                end
                else begin
                    row_cnt <= row_cnt + 1'b1;
                end
            end
            else begin
                row_cnt <= 1'b0;    
            end
        end
        else begin
            row_cnt <= 1'b0;
        end
    end


    //input column
    // reg [5:0] position_col;
    
    
    //input data index
    always@(posedge clk)begin
        if(st == LOAD_W )begin
            if(load_wait == 2'b10)begin
                //load 5 col
                if(position_col < 5)begin
                    position_col <= position_col + 1'b1;
                    cal_wait <= 1'b0;   
                end

                else begin

                    position_col <= position_col;   
                    cal_wait <= 1'b0;    
                end

            end
            else begin

                    position_col <= 1'b0;
                    cal_wait <= 1'b0;       
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
        else if(st == CALCULATION)begin
            if(cal_wait == 2'b11)begin
                if(row_cnt == 5'd27)begin
                    position_col <= position_col + 1'b1;
                    cal_wait <= cal_wait;
                end

                else begin
                    position_col <= position_col;
                    cal_wait <= cal_wait;    
                end
            end
            else begin
                    position_col <= position_col;
                    cal_wait <= cal_wait + 1'b1;    
            end

        end

        else begin

                    position_col <= 1'b0; 
                    cal_wait <= 1'b0;      
        end

    end





    always @(posedge clk) begin
        if(rst)begin 
            st <= IDLE;
        end
        else begin
            st <= nst;
        end
    end

    always@(st,L1_en,c_done,w_load_done,all_pool_done)begin
        case(st)
            IDLE :nst = (L1_en == 1'b1) ? LOAD_W : IDLE;
            LOAD_W : nst = (L1_en == 1'b1) ? (w_load_done == 1'b1 ? CALCULATION : LOAD_W) : IDLE;
            CALCULATION : nst = (L1_en == 1'b1) ? ((c_done == 1'b1 && all_pool_done == 1'b1) ? DONE : CALCULATION) : IDLE;
            DONE :nst = (L1_en == 1'b1) ? DONE : IDLE;
            default : nst = IDLE;
        endcase
    end

    assign all_pool_done = pool_done_ins1 & pool_done_ins2 & pool_done_ins3 & pool_done_ins4 & pool_done_ins5 & pool_done_ins6;
    


    assign L1_done = (st==DONE) ? 1'b1 : 1'b0;


    //  // //each channel
    wire [7:0] L2_reserved [0:14];
    pooling_2d L2_pool_instance1(
        clk,
        cal_wait,
        L2_out1_dout,
        con_result_1,
        L2_out_addr_read,
        L2_out_addr_write,
        L2_out_wea,
        L2_out1_din,
        pool_done_ins1
    );

    pooling_2d L2_pool_instance2(
        clk,
        cal_wait,
        L2_out2_dout,
        con_result_2,
        L2_reserved[0],
        L2_reserved[1],
        L2_reserved[12],
        L2_out2_din,
        pool_done_ins2
    );

    pooling_2d L2_pool_instance3(
        clk,
        cal_wait,
        L2_out3_dout,
        con_result_3,
        L2_reserved[2],
        L2_reserved[3],
        L2_reserved[11],
        L2_out3_din,
        pool_done_ins3
    );
    
    pooling_2d L2_pool_instance4(
        clk,
        cal_wait,
        L2_out4_dout,
        con_result_4,
        L2_reserved[4],
        L2_reserved[5],
        L2_reserved[10],
        L2_out4_din,
        pool_done_ins4
    );

    pooling_2d L2_pool_instance5(
        clk,
        cal_wait,
        L2_out5_dout,
        con_result_5,
        L2_reserved[6],
        L2_reserved[7],
        L2_reserved[13],
        L2_out5_din,
        pool_done_ins5
    );

    pooling_2d L2_pool_instance6(
        clk,
        cal_wait,
        L2_out6_dout,
        con_result_6,
        L2_reserved[8],
        L2_reserved[9],
        L2_reserved[14],
        L2_out6_din,
        pool_done_ins6
    );






endmodule
