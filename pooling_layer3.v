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


module pooling_layer3
#(parameter 
        DATA_WIDTH = 16
)
(
    input               clk,
    input               cal_en,
    input [11:0]        base_position,
    input [DATA_WIDTH - 1 : 0]      L4_output_dout,
    input [DATA_WIDTH - 1 : 0]      calculate_result,
    output reg [7:0]    L4_output_read_addr,
    output reg [7:0]    L4_output_write_addr,
    output reg          L4_output_wea,
    output reg [DATA_WIDTH - 1:0]   L4_out_din,
    output reg          pool_done
    );

    reg [DATA_WIDTH - 1:0] L4_temp;
    reg [3:0] L4_wait;
    reg r_en;
    reg w_en;
    reg ev_odd;
    reg [1:0] done_cnt;



    // always@(L4_output_dout,calculate_result,L4_temp)begin
    //     if()
    //     else if(L4_output_dout >= calculate_result) 
    //         L4_temp = L4_output_dout;
    //     else 
    //         L4_temp = calculate_result;

    // end

    always@(posedge clk)begin
        if(ev_odd == 1'b1)begin
            L4_temp <= (L4_output_dout >= calculate_result) ? L4_output_dout : calculate_result;
            L4_out_din <= (L4_output_dout >= calculate_result) ? L4_output_dout : calculate_result;
        end
        else begin
            L4_temp <= L4_temp;
            L4_out_din <= (L4_temp >= calculate_result) ? L4_temp : calculate_result ;
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
        if(cal_en)begin
            if(L4_wait == 4'd10)begin
                L4_wait <= L4_wait;
            end
            else begin
                L4_wait <= L4_wait + 1'b1;
            end
        end
        else begin
            L4_wait <= 1'b0;
        end

        //r_start
        if(L4_wait >= 4'd4)begin
            r_en <=  1'b1;
        end
        else begin
            r_en <= 1'b0;
        end

        //w_start

        if(L4_wait >= 4'd7)begin
            w_en <= 1'b1;
        end
        else if(w_row == 5'd9 && w_col == 5'd9)begin
            w_en <= 1'b0;
        end
        else begin
            w_en <= 1'b0;
        end
        
    end

    always@(posedge clk)begin
        if(r_en)begin
            if(r_row == 5'd9 && r_col == 5'd9)begin
                r_row <= r_row;
                r_col <= r_col;
            end
            else if(r_row == 5'd9)begin
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
            if(w_row == 5'd9 && w_col == 5'd9)begin
                w_row <= w_row;
                w_col <= w_col;
            end
            else if(w_row == 5'd9)begin
                w_row <= 1'b0;
                w_col <= w_col + 1'b1;
            end
            else begin
                w_row <= w_row + 1'b1;
                w_col <= w_col;
            end
        end
        else begin
            w_row <= 1'b0;
            w_col <= 1'b0;
        end    

        if(w_en == 1'b1 && L4_wait == 4'd10 && done_cnt < 2'b10)begin
            L4_output_wea <= 1'b1;
        end
        else begin
            L4_output_wea <= 1'b0;
        end


    end
   
    always@(posedge clk)begin
        if(w_row == 5'd9 && w_col == 5'd9)begin
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
    

    reg [DATA_WIDTH -1:0] base_addr;
    reg [DATA_WIDTH -1:0] shifted_addr [0:1];

    always@(posedge clk)begin

        //calcaulte address 2cycle delayed
        base_addr <= base_position;
        
        shifted_addr [0] <= shift_r_row + (shift_r_col)*4'd5;
        shifted_addr [1] <= shift_w_row + (shift_w_col)*4'd5;

        L4_output_read_addr  <=  base_addr + shifted_addr [0];
        L4_output_write_addr <=  base_addr  + shifted_addr [1];
    end

endmodule
