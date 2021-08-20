`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/20 12:58:20
// Design Name: 
// Module Name: result_gen
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


module result_gen#(
    parameter 
    DATA_WIDTH = 16
)
(
input clk, rst, en,
input  [DATA_WIDTH - 1 : 0 ] in,
output [3:0] result_read_addr,
output [3:0] result,
output done
);

reg [DATA_WIDTH - 1 :0] value;
reg [3:0] cnt,mem_index,temp_index;

always@(posedge clk)begin
    if(en) begin
        if(cnt == 4'd9)begin
            cnt <= cnt; 
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
    else begin
        cnt <= 1'b0;
    end
end

assign result_read_addr = cnt;

reg [1:0] wait_delay;

always@(posedge clk)begin
    if(en)begin
        if(wait_delay == 2'b10)begin
            wait_delay <= wait_delay ;
        end
        else begin
            wait_delay <= wait_delay + 1'b1;
        end    
    end
    else begin
        wait_delay <= 1'b0;
    end

end


always@(posedge clk)begin
    if(wait_delay == 2'b10)begin
        if(mem_index == 4'd9)begin
            mem_index <= mem_index;
        end
        else begin
            mem_index <= mem_index + 1'b1;
        end
    end
    else begin
        mem_index <= 1'b0;
    end
end

always@(posedge clk)begin
    if(rst)begin
        value <= 1'b0;
        temp_index <= 1'b0;
    end
    else if(wait_delay == 2'b10 && mem_index < 4'd9)begin
        value <= value > in ? value :in;
        temp_index <= value > in ? temp_index : mem_index;
    end
    else begin
        value <= value ;
    end
end


assign result = temp_index;
assign done = mem_index == 4'd9;

endmodule
