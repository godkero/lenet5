module stage2_add
#(
    DATA_WIDTH = 16
)
(
    input clk,
    input en,
    input  signed [DATA_WIDTH - 1:0] datain_a,datain_b,datain_c,datain_d,datain_e,datain_f,
    output signed [DATA_WIDTH -1:0] dataout
);

    reg signed [DATA_WIDTH -1 :0] temp_stage1 [0:2];
    reg signed [DATA_WIDTH -1 :0] temp_stage2 [0:1];

    reg signed [DATA_WIDTH -1 :0] result;


    //3cycle delayed
    always @(posedge clk) begin
        if(en == 1'b1)begin
            temp_stage1[0] <= datain_a + datain_b;
            temp_stage1[1] <= datain_c + datain_d;
            temp_stage1[2] <= datain_e + datain_f;
            temp_stage2[0] <= temp_stage1[0] + temp_stage1[1];
            temp_stage2[1] <= temp_stage1[2];
            result        <=  temp_stage2[0] + temp_stage2[1];
        end
        else begin
            temp_stage1[0] <= 1'b0;
            temp_stage1[1] <= 1'b0;
            temp_stage1[2] <= 1'b0;
            temp_stage2[0] <= 1'b0;
            temp_stage2[1] <= 1'b0;
            result        <= 1'b0;
        end
    end



    assign dataout = result;

endmodule



