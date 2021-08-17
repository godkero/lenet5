`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/27 17:23:40
// Design Name: 
// Module Name: pooling_2d
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


module pooling_2d
#(
    parameter DATA_WIDTH = 16
)
(
    input clk,
    input [1:0] cal_wait,
    input [DATA_WIDTH -1 : 0] L2_out1_dout,
    input [DATA_WIDTH -1 : 0] calculate_result,
    output reg    [7:0] L2_out1_addr_read,
    output reg    [7:0] L2_out1_addr_write,
    output reg L2_out1_wea,
    output reg [DATA_WIDTH -1:0] L2_out1_din,
    output reg pool_done,
    output reg pool_save_start
    );

    reg [DATA_WIDTH -1:0] L2_temp;
    reg [3:0] L2_wait;
    reg r_en;
    reg w_en;
    reg ev_odd;
    reg [1:0] done_cnt;

    always@(posedge clk)begin
        if(ev_odd == 1'b1)begin
            L2_temp <= (L2_out1_dout >= calculate_result) ? L2_out1_dout : calculate_result;
            L2_out1_din <= (L2_out1_dout >= calculate_result) ? L2_out1_dout : calculate_result;
        end
        else begin
            L2_temp <= 1'b0;
            L2_out1_din <= (L2_temp >= calculate_result) ? L2_temp : calculate_result ;
        end
    end

  
    always@(posedge clk)begin
        if(w_en)begin
            ev_odd <= ~ev_odd;
        end
        else begin
            ev_odd <= 1'b0;
        end
    end

    reg [4:0] r_row,r_col,w_row,w_col;

    always@(posedge clk)begin
        if(cal_wait == 2'b11)begin
            if(L2_wait == 4'd6)begin
                L2_wait <= L2_wait;
            end
            else begin
                L2_wait <= L2_wait + 1'b1;
            end
        end
        else begin
            L2_wait <= 1'b0;
        end

        //r_start
        if(L2_wait >= 4'd3)begin
            r_en <=  1'b1;
        end
        else begin
            r_en <= 1'b0;
        end

        //w_start

        if(L2_wait == 4'd6)begin
            w_en <= 1'b1;
        end
        else if(w_row == 5'd27 && w_col == 5'd 27)begin
            w_en <= 1'b0;
        end
        else begin
            w_en <= 1'b0;
        end
        
    end


    always@(posedge clk)begin
        if(r_en)begin
            if(r_row == 5'd27 && r_col == 5'd27)begin
                r_row <= r_row;
                r_col <= r_col;
            end
            else if(r_row == 5'd27)begin
                r_row <= 1'b0;
                r_col <= r_col + 1'b1;
            end
            else begin
                r_row <= r_row + 1'b1;
                r_col <= r_col;
            end
        end
        else begin
            r_row <= 1'b0;
            r_col <= 1'b0;
        end

        if(w_en)begin
            if(w_row == 5'd27 && w_col == 5'd27)begin
                if(done_cnt >= 2'b01)begin
                    L2_out1_wea <= 1'b0;    
                end
                else begin
                    L2_out1_wea <= 1'b1;
                end
                // L2_out1_wea <= 1'b0;
                w_row <= w_row;
                w_col <= w_col;
            end
            else if(w_row == 5'd27)begin
                w_row <= 1'b0;
                w_col <= w_col + 1'b1;
                L2_out1_wea <= 1'b1;
            end
            else begin
                w_row <= w_row + 1'b1;
                w_col <= w_col;
                L2_out1_wea <= 1'b1;
            end
        end
        else begin
            w_row <= 1'b0;
            w_col <= 1'b0;
            L2_out1_wea <= 1'b0; 
        end        
    end
   
    always@(posedge clk)begin
        if(w_row == 5'd27 && w_col == 5'd27)begin
            if(done_cnt ==2'b10)begin
                done_cnt <=done_cnt;
            end
            else begin
                done_cnt<=done_cnt+1'b1;
            end
        end
        else begin
            done_cnt <= 1'b0;
        end

        if(done_cnt == 2'b10)begin
            pool_done <= 1'b1;
        end
        else begin
            pool_done <= 1'b0;
        end
    end

    wire [3:0] shift_r_row;
    wire [3:0] shift_r_col;
    wire [3:0] shift_w_row;
    wire [3:0] shift_w_col;

    assign shift_r_row = r_row >>1;
    assign shift_r_col = r_col >>1;
    assign shift_w_row = w_row >>1;
    assign shift_w_col = w_col >>1; 
    

    // assign L2_out1_addr_read = shift_r_row + shift_r_col * (4'd14);
    // assign L2_out1_addr_write = shift_w_row + shift_w_col * (4'd14);


    always@(posedge clk)begin
        L2_out1_addr_read <= shift_r_row + (shift_r_col)*4'd14;
    end
    
    always@(posedge clk)begin
        L2_out1_addr_write <= shift_w_row + (shift_w_col)*4'd14;
    end

    //assign pool_done = (done_cnt == 2'b10) ? 1'b1 : 1'b0;


endmodule
