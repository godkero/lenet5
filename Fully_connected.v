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
    input  clk,
    input  en,
    input  [INPUT_SIZE - 1: 0]   in,
    input  [READ_SIZE - 1 : 0]   weight_set,
    output [OUTPUT_SIZE - 1 :0]  out,
    output [6:0]                 out_index,
    output reg [11:0]            FC1_weight_addr,
    output reg [11:0]            FC1_read_addr,//120*25
    output FC_done
);

    //16개 read
    //400 * 120
    //25 * 120

    reg [11:0] read_address;
    reg [5:0] index_count; 
    reg [9:0] base;
    reg [1:0] delay;

    
    reg [DATA_WIDTH : 0] stage1 [0:7];
    reg [DATA_WIDTH : 0] stage2 [0:3];
    reg [DATA_WIDTH : 0] stage3 [0:1];
    reg [DATA_WIDTH : 0] stage4 [0:1];

    wire [DATA_WIDTH - 1:0] input_unit [0:READ_SET-1];
    wire [DATA_WIDTH - 1:0] weight_unit [0:READ_SET-1];
    wire [DATA_WIDTH - 1:0] temp_unit [0:READ_SET-1];
    //[row][col]  row = 120 / col = 400
    
    //120 * 400 --> 120 * 25
    

    always@(posedge clk)begin
        if(en)begin
            if(delay == 2'b10)begin
                delay <= delay;
            end
            else begin
                 delay <=  delay + 1'b1;
            end
        end
        else begin
             delay <= 1'b0;
        end
    end

    reg [7 : 0] change_cnt;
    
    always@(posedge clk)begin
        if( delay == 2'b10)begin
            if(index_count == 12'd25)begin
                index_count <= index_count ;
            end
            else begin
                if(change_cnt == 8'd120)begin
                    index_count <= index_count + 1'b1;
                end
                else begin
                    index_count <= index_count;
                end
            end
        end
        else begin
            index_count <= 0;            
        end

        if(delay == 2'b10)begin
            if(change_cnt == 8'd120)begin
                change_cnt <= 1'b0;
            end
            else begin
                change_cnt <= change_cnt + 1'b1;
            end
        end
        else begin
            change_cnt <= 1'b0;
        end

    end

    //8개 --> 
    
    // weight block memory read
    //120 60 30 15

    always@(posedge clk)begin
        if(en)begin
            if(read_address == 8'd120)begin
                read_address <= 1'b0;       
            end
            else begin
                read_address <= read_address + 1'b1;
            end
        end
        else begin
            read_address <= 1'b0;
        end

        if(en)begin
            if(read_address == 8'd120)begin
                base <= base + 10'd200;
            end
            else begin
                base <= base ;
            end
        end
        else begin
            base <= 1'b0;
        end

    end

    always@(posedge clk)begin
        if(en)begin
            FC1_read_addr <= base + read_address;
        end
        else begin
            FC1_read_addr <= 1'b0;
        end
    end




    //operation
    mult_cell u0 (clk,input_unit[0 ],weight_unit[0 ],temp_unit[0 ]);
    mult_cell u1 (clk,input_unit[1 ],weight_unit[1 ],temp_unit[1 ]);
    mult_cell u2 (clk,input_unit[2 ],weight_unit[2 ],temp_unit[2 ]);
    mult_cell u3 (clk,input_unit[3 ],weight_unit[3 ],temp_unit[3 ]);
    mult_cell u4 (clk,input_unit[4 ],weight_unit[4 ],temp_unit[4 ]);
    mult_cell u5 (clk,input_unit[5 ],weight_unit[5 ],temp_unit[5 ]);
    mult_cell u6 (clk,input_unit[6 ],weight_unit[6 ],temp_unit[6 ]);
    mult_cell u7 (clk,input_unit[7 ],weight_unit[7 ],temp_unit[7 ]);
    mult_cell u8 (clk,input_unit[8 ],weight_unit[8 ],temp_unit[8 ]);
    mult_cell u9 (clk,input_unit[9 ],weight_unit[9 ],temp_unit[9 ]);
    mult_cell u10(clk,input_unit[10],weight_unit[10],temp_unit[10]);
    mult_cell u11(clk,input_unit[11],weight_unit[11],temp_unit[11]);
    mult_cell u12(clk,input_unit[12],weight_unit[12],temp_unit[12]);
    mult_cell u13(clk,input_unit[13],weight_unit[13],temp_unit[13]);
    mult_cell u14(clk,input_unit[14],weight_unit[14],temp_unit[14]);
    mult_cell u15(clk,input_unit[15],weight_unit[15],temp_unit[15]);

    //add tree
    always@(posedge clk)begin
        if(en)begin
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
            stage3[1] <= stage2[2] + stage2[4];
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
        end
    end






assign FC_done = 1'b0;



endmodule
