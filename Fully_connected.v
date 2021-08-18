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
    input  [READ_SIZE - 1]       weight_set,
    output [OUTPUT_SIZE - 1 :0] out,
    output  reg [11:0]               FC1_read_addr,//120*25
    output  reg                   FC1_read_en
    output FC_done
);

    //16개 read
    //400 * 120
    //25 * 120

    reg [11:0] read_address;

    reg [5:0] index_count; 
    reg [9:0] base;


    reg [1:0] wait;



    genvar ;
    generate 

        
    endgenerate
    mult_cell u0(
    input  clk,
    input  signed [DATA_WIDTH-1 : 0] input_unit,
    input  signed [DATA_WIDTH-1 : 0] weight_unit,
    output reg signed  [DATA_WIDTH-1 :0] output_unit
);



    always@(posedge clk)begin
        if(en)begin
            if(wait == 2'b10)begin
                wait <= wait;
            end
            else begin
                wait <= wait + 1'b1;
            end
        end
        else begin
            wait <= 1'b0;
        end
    end

    reg [7 : 0] change_cnt;
    //register index
    always@(posedge clk)begin
        if(wait == 2'b10)begin
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


        if(wait == 2'b10)begin
            if(change_cnt == 8'd120)begin
                change_cnt <= 1'b0;
            end
            else begin
                change_cnt <= change_cnt + 1'b;
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
            FC1_read_en <= 1'b1;
        end
        else begin
            FC_read_addr <= 1'b0;
            FC1_read_en <= 1'b0;
        end
    end





assign FC_done = 1'b0;



endmodule
