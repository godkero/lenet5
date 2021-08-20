`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/14 00:16:05
// Design Name: 
// Module Name: Fully_connected
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


module Fully_connected
#(
    parameter DATA_WIDTH = 16,
              INPUT_MAP = 400,
              OUTPUT_MAP = 120,
              INPUT_SIZE = INPUT_MAP * DATA_WIDTH,
              OUTPUT_SIZE = OUTPUT_MAP * DATA_WIDTH,
              READ_SET = 16,
              READ_SIZE = DATA_WIDTH * READ_SET
              
)
(
    input  clk,rst,
    input  en,
    input  [DATA_WIDTH - 1: 0]   in_1,
    input  [DATA_WIDTH - 1: 0]   in_2,
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

    //16개 read
    //400 * 120
    //25 * 120

    // FC1_read_addr

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
    
    // reg [6:0] read_addr;
    // reg [6:0] write_addr;




    localparam IDLE = 5'b0001 , LOAD = 5'b0010 , CAL = 5'b0100 , BIAS_ADD = 5'b01000, DONE = 5'b10000;

    reg [4:0] st,nst;

    assign FC_done = st ==DONE ? 1'b1 : 1'b0;

    reg [3:0] load_cnt;
    reg index_en;
    always@(posedge clk)begin
        if(st == LOAD)begin
            if(position == 4'd7)begin
                position <= position;
                index_en <= 1'b0;
            end
            else begin
                position <= position + 1'b1;
                index_en <= 1'b1;
            end
        end
        else begin
            position <= 1'b0;
            index_en <= 1'b0;
        end

        if(position == 4'd7)begin
            if(load_cnt == 3'b11)begin
                load_done <= 1'b1;
                load_cnt <= load_cnt;
            end
            else begin
                load_done <= 1'b0;
                load_cnt <= load_cnt + 1'b1;

            end
        end
        else begin
            load_done <= 1'b0;
            load_cnt <= 1'b0;
        end
    end

    always@(posedge clk)begin
        if(st == LOAD)begin
            if(index_en)begin
                cur_addr <= cur_addr + 1'b1;
            end
            else if(nst == CAL)begin
                cur_addr <= cur_addr + 1'b1;
            end
            else begin
                cur_addr <= cur_addr;
            end
        end
        else if(en) begin
            cur_addr <= cur_addr;
        end
        else begin
            cur_addr <= 1'b0;
        end

    end

    assign FC1_read_addr = cur_addr;

    integer i;
    // input_unit [0:READ_SET-1];
    always@(posedge clk)begin
       if(st == LOAD && load_done == 1'b0)begin
           input_unit[0] <= in_1;
           input_unit[1] <= input_unit[0];
           input_unit[2] <= input_unit[1];
           input_unit[3] <= input_unit[2];
           input_unit[4] <= input_unit[3];
           input_unit[5] <= input_unit[4];
           input_unit[6] <= input_unit[5];
           input_unit[7] <= input_unit[6];
           input_unit[8] <= in_2;
           input_unit[9 ] <= input_unit[8];
           input_unit[10] <= input_unit[9 ];
           input_unit[11] <= input_unit[10];
           input_unit[12] <= input_unit[11];
           input_unit[13] <= input_unit[12];
           input_unit[14] <= input_unit[13];
           input_unit[15] <= input_unit[14];
       end
       else ; 
    end


    reg [3:0] cal_wait;
    reg [6:0] cal_cnt;
    reg add_done;
// FC1_weight_addr


    reg  [11:0] cal_out_cnt;
    wire [11:0] temp_weight_addr = cal_cnt + cal_out_cnt;

    assign FC1_weight_addr = flag == 1'b0 ? temp_weight_addr : 1'bz;
   

    always@(posedge clk)begin
        if(st ==CAL)begin
            if(cal_wait == 4'b1001)begin
                cal_wait <= cal_wait;
            end
            else begin
                cal_wait <= cal_wait + 1'b1;
            end
        end
        else begin
            cal_wait <= 1'b0;
        end

        if(st== CAL)begin
            if(cal_cnt == 7'd119)begin
                cal_cnt <= cal_cnt;
            end
            else begin
                cal_cnt <= cal_cnt + 1'b1;
            end
        end
        else begin
            cal_cnt <= 1'b0;
        end 

        
        if(cal_cnt == 7'd119 && st == CAL)begin
            if(flag == 1'b1) begin
                cal_out_cnt <= cal_out_cnt;
            end
            else begin
                cal_out_cnt <= cal_out_cnt + cal_cnt + 1'b1;
            end
            flag <= 1'b1;
        end
        else if(en)begin
            cal_out_cnt <= cal_out_cnt;
            flag <= 1'b0;
        end
        else begin
            cal_out_cnt <= 1'b0;
            flag <= 1'b0;
        end

        if(st == BIAS_ADD)begin
            if(bias_add_wait == 3'b100)begin
                bias_add_wait <= bias_add_wait ;
            end
            else begin
                bias_add_wait <= bias_add_wait + 1'b1;
            end
        end
        else begin
            bias_add_wait <= 1'b0;
        end


    end

    

    assign cal_done = out_write_addr == 7'd119 && st==CAL ? 1'b1 : 1'b0;  
    assign all_done = out_write_addr == 7'd119 && run_cnt == 5'd25 && st ==CAL ? 1'b1 : 1'b0;
    always@(posedge clk)begin
        for(i = 0 ; i< 16 ; i = i + 1)begin
            if(cal_wait >= 3'b010)begin
                weight_unit[i] <=  weight_set[ i*16 +: 16];
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
            if(out_read_addr == 7'd119)begin
                out_read_addr <= out_read_addr;
            end
            else begin
                out_read_addr <= out_read_addr + 1'b1;
            end
        end
        else if(cal_wait >= 4'b0110)begin
            if(out_read_addr == 7'd119)begin
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
            if(bias_add_wait == 3'b100)begin
                
                if(out_write_addr == 7'd119)begin    
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
        else if(cal_wait >= 4'b1001)begin
            if(out_write_addr == 7'd119)begin
                out_write_addr <= out_write_addr;
            end
            else begin
                out_write_addr <= out_write_addr + 1'b1;
            end
        end
        else begin
            out_write_addr <= 1'b0;
        end

        if(cal_wait >=  4'b1000 && cal_done == 1'b0 && st == CAL)begin
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
            if(bias_read_addr == 7'd119)begin
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
        if(out_write_addr == 7'd119 && bias_add_wait >= 2'b11)begin
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
    mult_cell u0 (clk,input_unit[8 ],weight_unit[0 ],temp_unit[0 ]);
    mult_cell u1 (clk,input_unit[9 ],weight_unit[1 ],temp_unit[1 ]);
    mult_cell u2 (clk,input_unit[10],weight_unit[2 ],temp_unit[2 ]);
    mult_cell u3 (clk,input_unit[11],weight_unit[3 ],temp_unit[3 ]);
    mult_cell u4 (clk,input_unit[12],weight_unit[4 ],temp_unit[4 ]);
    mult_cell u5 (clk,input_unit[13],weight_unit[5 ],temp_unit[5 ]);
    mult_cell u6 (clk,input_unit[14],weight_unit[6 ],temp_unit[6 ]);
    mult_cell u7 (clk,input_unit[15],weight_unit[7 ],temp_unit[7 ]);
    mult_cell u8 (clk,input_unit[0 ],weight_unit[8 ],temp_unit[8 ]);
    mult_cell u9 (clk,input_unit[1 ],weight_unit[9 ],temp_unit[9 ]);
    mult_cell u10(clk,input_unit[2 ],weight_unit[10],temp_unit[10]);
    mult_cell u11(clk,input_unit[3 ],weight_unit[11],temp_unit[11]);
    mult_cell u12(clk,input_unit[4 ],weight_unit[12],temp_unit[12]);
    mult_cell u13(clk,input_unit[5 ],weight_unit[13],temp_unit[13]);
    mult_cell u14(clk,input_unit[6 ],weight_unit[14],temp_unit[14]);
    mult_cell u15(clk,input_unit[7 ],weight_unit[15],temp_unit[15]);

        
    reg signed [DATA_WIDTH : 0] stage1 [0:7];
    reg signed [DATA_WIDTH : 0] stage2 [0:3];
    reg signed [DATA_WIDTH : 0] stage3 [0:1];
    reg signed [DATA_WIDTH -1 : 0] stage4 ;

    reg signed [DATA_WIDTH - 1:0] result;
    //add tree
    always@(posedge clk)begin
        if(st == CAL)begin
            stage1[0] <= temp_unit[0 ] + temp_unit[1 ];
            stage1[1] <= temp_unit[2 ] + temp_unit[3 ];
            stage1[2] <= temp_unit[4 ] + temp_unit[5 ];
            stage1[3] <= temp_unit[6 ] + temp_unit[7 ];
            stage1[4] <= temp_unit[8 ] + temp_unit[9 ];
            stage1[5] <= temp_unit[10] + temp_unit[11];
            stage1[6] <= temp_unit[12] + temp_unit[13];
            stage1[7] <= temp_unit[14] + temp_unit[15];
            stage2[0] <= stage1[0] + stage1[1];
            stage2[1] <= stage1[2] + stage1[3];
            stage2[2] <= stage1[4] + stage1[5];
            stage2[3] <= stage1[6] + stage1[7];
            stage3[0] <= stage2[0] + stage2[1];
            stage3[1] <= stage2[2] + stage2[3];
            stage4    <= stage3[0] + stage3[1];
           
        end
        else begin
            stage1[0] <= 1'b0;
            stage1[1] <= 1'b0;
            stage1[2] <= 1'b0;
            stage1[3] <= 1'b0;
            stage1[4] <= 1'b0;
            stage1[5] <= 1'b0;
            stage1[6] <= 1'b0;
            stage1[7] <= 1'b0;
            stage2[0] <= 1'b0;
            stage2[1] <= 1'b0;
            stage2[2] <= 1'b0;
            stage2[3] <= 1'b0;
            stage3[0] <= 1'b0;
            stage3[1] <= 1'b0;
            stage4    <= 1'b0;
        end

        if(bias_add_wait >= 2'b01)begin
             result <= bias_read_data + out_read_data;
        end
        else  if(st == CAL && cal_wait > 4'b0111)begin
             result = stage4 + out_read_data;
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
