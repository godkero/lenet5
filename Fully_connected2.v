`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/20 04:21:45
// Design Name: 
// Module Name: Fully_connected2
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


module Fully_connected2  
#( parameter DATA_WIDTH = 16,
              INPUT_MAP = 120,
              OUTPUT_MAP = 84,
              INPUT_SIZE = INPUT_MAP * DATA_WIDTH,
              OUTPUT_SIZE = OUTPUT_MAP * DATA_WIDTH,
              READ_SET = 4,
              READ_SIZE = DATA_WIDTH * READ_SET
              )
(


    //4
    input  clk,rst,
    input  en,
    input  [DATA_WIDTH - 1: 0]   in,
    input  [READ_SIZE - 1 : 0]   weight_set,
    output  reg                    out_write_ena,
    output reg [6:0]                 out_read_addr,
    input signed [DATA_WIDTH -1:0]     out_read_data,
    output reg [6:0]                 out_write_addr,
    output  [DATA_WIDTH -1:0]     out_write_data,
    output [11:0]            FC1_weight_addr,
    output [11:0]                FC1_read_addr,//120*25

    output reg   [6:0]        bias_read_addr,
    input signed [DATA_WIDTH - 1:0]   bias_read_data,
    output FC_done
    );



    
    reg load_done;
    wire cal_done;
    wire all_done;
    
    reg [3:0] position;
    reg [11:0] cur_addr;

    reg  signed [DATA_WIDTH - 1:0] input_unit [0:READ_SET-1];
    reg  signed [DATA_WIDTH - 1:0] weight_unit [0:READ_SET-1];
    wire signed [DATA_WIDTH - 1:0] temp_unit [0:READ_SET-1];

    reg flag;
    reg [2:0] bias_add_wait;

    // cal 끝내는 변수
    reg [6:0] run_cnt;
    reg run_flag;
    
    localparam IDLE = 5'b0001 , LOAD = 5'b0010 , CAL = 5'b0100 , BIAS_ADD = 5'b01000, DONE = 5'b10000;

    reg [3:0] st,nst;

    assign FC_done = st ==DONE ? 1'b1 : 1'b0;

    reg [3:0] load_cnt;

    always@(posedge clk)begin
        if(st == LOAD)begin
            if(load_cnt < 4'd4)begin
                cur_addr <= cur_addr + 1'b1;
                load_cnt <= load_cnt + 1'b1;
            end
            else begin
                cur_addr <= cur_addr;
                load_cnt <= load_cnt;
            end        
        end
        else if(en) begin
            cur_addr <= run_cnt * 5'd4;
            load_cnt <= 1'b0;
        end
        else begin
            cur_addr <= 1'b0;
            load_cnt <= 1'b0;
        end
    end

    assign FC1_read_addr = cur_addr;

    integer i;
    // input_unit [0:READ_SET-1];
    always@(posedge clk)begin
       if(st == LOAD && load_done == 1'b0)begin
           input_unit[0] <= in;
           input_unit[1] <= input_unit[0];
           input_unit[2] <= input_unit[1];
           input_unit[3] <= input_unit[2];
       end
       else ; 
    end


    reg [3:0] cal_wait;
    reg [6:0] cal_cnt;
    reg add_done;
// FC1_weight_addr



    reg [11:0] temp_weight_addr;
    reg [11:0] weight_cnt;
    reg [2:0]  done_wait;

    always@(posedge clk)begin
        if(st ==CAL)begin
            if(weight_cnt < 7'd84)begin
                temp_weight_addr <= temp_weight_addr + 1'b1;
                weight_cnt <= weight_cnt + 1'b1;
            end
            else begin
                temp_weight_addr <= temp_weight_addr;
                weight_cnt <= weight_cnt;
            end
        end
        else begin
            temp_weight_addr <= run_cnt * 7'd84;
            weight_cnt <= 1'b0;
        end

        if(weight_cnt == 7'd84)begin
            load_done<=1'b1;
        end
        else begin
            load_done<=1'b0;
        end

    end

    
    assign FC1_weight_addr = temp_weight_addr;
   

    assign cal_done = out_write_addr == 7'd119 && st==CAL ? 1'b1 : 1'b0;  
    assign all_done = out_write_addr == 7'd119 && run_cnt == 5'd25 && st ==CAL ? 1'b1 : 1'b0;

    always@(posedge clk)begin
        for(i = 0 ; i< 4 ; i = i + 1)begin
            if(cal_wait >= 3'b010)begin
                weight_unit[i] <=  weight_set[ i*4 +: 4];
            end
            else begin
                weight_unit[i] <= 1'b0;
            end
        end
    end


    always@(posedge clk)begin
        if(en)begin
            if(st == LOAD && nst == CAL)begin
                run_flag <= 1'b1;
                if(run_flag)begin
                    run_cnt <= run_cnt ;
                end
                else begin
                    run_cnt <= run_cnt + 1'b1;
                end
            end
            else begin
                run_cnt <=run_cnt;
                run_flag <= 1'b0;
            end
        end
        else begin
            run_cnt <= 1'b0;
            run_flag <= 1'b0;

        end
    end

    //[row][col]  row = 120 / col = 400
    
    //120 * 400 --> 120 * 25
    


    always@(posedge clk)begin
        if(rst)begin
            st <= IDLE;
        end
        else 
            st <= nst;
    end
    // output [6:0]                 out_index,
    // output [DATA_WIDTH -1:0]     out_data,

    always@(posedge clk)begin
        
    /////read addr
        if(all_done == 1'b1)begin
            out_read_addr <= 1'b0;
        end
        
        else if(st == BIAS_ADD)begin
            if(out_read_addr == 7'd83)begin
                out_read_addr <= out_read_addr;
            end
            else begin
                out_read_addr <= out_read_addr + 1'b1;
            end
        end
        else if(cal_wait >= 4'd04)begin
            if(out_read_addr < 7'd84)begin
                out_read_addr <= out_read_addr;
            end
            else begin
                out_read_addr <= out_read_addr + 1'b1;
            end
        end

        else begin
            out_read_addr <= 1'b0;
        end

    ///////write addr
        if(all_done == 1'b1)begin
            out_write_addr <= 1'b0;
        end
        
        else if(st == BIAS_ADD)begin
            if(bias_add_wait == 3'd3)begin
                if(out_write_addr == 7'd83)begin    
                    out_write_addr <= out_write_addr;
                end
                else begin
                    out_write_addr <= out_write_addr + 1'b1;
                end
            end
            else begin
                out_write_addr <= 1'b0;
            end
        end
        else if(cal_wait >= 4'd7)begin
            if(out_write_addr == 7'd83)begin
                out_write_addr <= out_write_addr;
            end
            else begin
                out_write_addr <= out_write_addr + 1'b1;
            end
        end
        else begin
            out_write_addr <= 1'b0;
        end

        if(cal_wait >=  4'd6 && cal_done == 1'b0 && st == CAL)begin
             out_write_ena <= 1'b1;
        end
        else if(bias_add_wait >= 2'b11 && add_done == 1'b0 && st == BIAS_ADD)begin
            out_write_ena <= 1'b1;
        end
        else begin
             out_write_ena <= 1'b0;
        end

    end


    always@(posedge clk)begin
        if(st == BIAS_ADD)begin
            if(bias_read_addr == 7'd83)begin
                bias_read_addr <= bias_read_addr ;
            end
            else begin
                bias_read_addr <= bias_read_addr + 1'b1;
            end
        end
        else begin
            bias_read_addr <= 1'b0;
        end
    end


    always@(posedge clk)begin
        if(out_write_addr == 7'd83 && bias_add_wait == 2'b11)begin
            add_done <= 1'b1;
        end
        else begin
            add_done <= 1'b0;
        end
    end




    always@(st,en,load_done,cal_done,all_done,add_done)begin
        case(st)
            IDLE : nst = en == 1'b1 ?LOAD : IDLE;
            LOAD : nst = en == 1'b1 && load_done == 1'b1 ? CAL : en == 1'b1 ? LOAD :IDLE;
            CAL :  nst = en == 1'b1 && all_done == 1'b1 ? BIAS_ADD : en == 1'b1 && cal_done == 1'b1 ? LOAD : en == 1'b1 ? CAL : IDLE ;
            BIAS_ADD : nst = en == 1'b1 && add_done == 1'b1 ? DONE : en == 1'b1 ? BIAS_ADD : IDLE;
            DONE : nst = en == 1'b1 ? DONE : IDLE;
        endcase 
    end



    //operation
    mult_cell u0 (clk,input_unit[0 ],weight_unit[0 ],temp_unit[0 ]);
    mult_cell u1 (clk,input_unit[1 ],weight_unit[1 ],temp_unit[1 ]);
    mult_cell u2 (clk,input_unit[2],weight_unit[2 ],temp_unit[2 ]);
    mult_cell u3 (clk,input_unit[3],weight_unit[3 ],temp_unit[3 ]);
 

        
    reg signed [DATA_WIDTH : 0] stage1 [0:1];
    reg signed [DATA_WIDTH -1 : 0] stage2 ;

    reg signed [DATA_WIDTH - 1:0] result;
    //add tree
    always@(posedge clk)begin
        if(st == CAL)begin
            stage1[0] <= temp_unit[0 ] + temp_unit[1 ];
            stage1[1] <= temp_unit[2 ] + temp_unit[3 ];
            stage2    <= stage1[0] + stage1[1];
           
        end
        else begin
            stage1[0] <= 1'b0;
            stage1[1] <= 1'b0;
            stage2    <= 1'b0;
        end

        if(st == BIAS_ADD)begin
             result <= bias_read_data + out_read_data;
        end
        else  if(st == CAL)begin
             result = stage2 + out_read_data;
        end
        else begin
              result = 1'b0;
        end
    end
    
    wire [DATA_WIDTH - 1: 0] relu_out;
   

     relu_function FC1_relu1(
        clk,
        result,
        relu_out
    );
    
    assign out_write_data = st == CAL ? result : st == BIAS_ADD ? relu_out : 1'b0;



endmodule
