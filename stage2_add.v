module stage2_add(
    input clk,
    input en,
    input [11:0] datain_a,datain_b,datain_c,datain_d,datain_e,datain_f,
    output reg [11:0] dataout
);

    reg [11:0] temp_stage1 [0:2];
    reg [11:0] temp_stage2 [0:1];

    always @(posedge clk) begin
        if(en == 1'b1)begin
            temp_stage1[0] <= datain_a + datain_b;
            temp_stage1[1] <= datain_c + datain_d;
            temp_stage1[2] <= datain_e + datain_f;
            temp_stage2[0] <= temp_stage1[0] + temp_stage1[1];
            temp_stage2[1] <= temp_stage1[2];
            dataout        <= temp_stage2[0] + temp_stage2[1];
        end
        else begin
            temp_stage1[0] <= 1'b0;
            temp_stage1[1] <= 1'b0;
            temp_stage1[2] <= 1'b0;
            temp_stage2[0] <= 1'b0;
            temp_stage2[1] <= 1'b0;
            dataout        <= 1'b0;
        end
    end





endmodule



