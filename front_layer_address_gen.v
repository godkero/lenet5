`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/27 19:00:11
// Design Name: 
// Module Name: front_layer_address_gen
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


module front_layer_address_gen
#(
    DATA_WIDTH = 12, 
    FILTER_WIDTH = 5, 
    FILTER_WEIGHT = 5,
    INPUT_WIDTH = 32, 
    INPUT_HEIGTH = 32,
    OUTPUT_FEATURE_MAP = 6,
    W_DEPTH = 26,
    IN_DEPTH = 1024,
    W_READ_SIZE = OUTPUT_FEATURE_MAP * DATA_WIDTH,
    IDLE = 4'b0001,
    LOAD_W = 4'b0010,
    CALCULATION = 4'b0100,
    DONE = 4'b1000
)
(   
    input clk,
    input [4:0] st,
    input [4:0] in_cell_row,
    output reg [4:0] in_addr,
    output reg [7:0] w_addr

    );


    reg [4:0] wait_change;

    //input rom address
    always@(posedge clk)begin
        if(st == IDLE)begin
            in_addr <= 10'b0;
            wait_change <= 1'b1;
            
        end
        else if(st == LOAD_W)begin
                if(in_addr < FILTER_WEIGHT-1)begin
                    in_addr <= in_addr + 10'b1;
                    wait_change <= 1'b0;                
                end
                else begin
                    in_addr <= in_addr;
                    wait_change <= 1'b0;
                end
        end

        ///////////wait change를 1로 초기화하는거 의도적임
        /////////// 상속할 떄 꼭 생각
        else if(st == CALCULATION)begin
            if(in_cell_row == 5'd28)begin
                in_addr <= in_addr;
                wait_change <= 1'b1;
            end
            else if(wait_change == 5'd27)begin
                in_addr <= in_addr + 1'b1;
                wait_change <= 1'b0;
            end
            else begin
                in_addr <= in_addr;
                wait_change <= wait_change + 1'b1;
            end
        end
        else begin
            in_addr <= 10'b0;
            wait_change <= 1'b1;
        end
    end


    //w_addr
    always @(posedge clk) begin
        if(st == IDLE)begin
            w_addr <= 5'b0;
        end
        else if(st == LOAD_W)begin
            if(w_addr <=8'd156)begin
                w_addr <= w_addr + 1'b1;
                //w_cnt <= 2'b0;
            end
            else if (w_addr == 8'd156)begin
               w_addr <= w_addr;
            end

        end
        else begin
            w_addr <= 5'b0;
        end       
    end

endmodule
