`timescale 1ns / 1ps



module control 
#(
parameter IDLE    = 8'b00000001,
           L1     = 8'b00000010,
           L3     = 8'b00000100,
           FC1    = 8'b00001000,
           FC2    = 8'b00010000,
           FC3    = 8'b00100000,
           RESULT = 8'b01000000,
           DONE   = 8'b10000000    
)
(
    input clk,rst, 
    input start,
    input L1_done,
    input L3_done,
    input FC1_done,
    input FC2_done,
    input FC3_done,
    input RESULT_done,
    output L1_en,
    output L3_en,
    output FC1_en,
    output FC2_en,
    output FC3_en,
    output RESULT_en,

    output finish
);


    reg [6:0] st,nst;

    //state transfer
    always@(posedge clk)begin
        if(rst) begin st <= IDLE; end
        else begin st <= nst; end
    end
  

    //next state logic
    always@(st,L1_en,L1_done,start,L3_done,FC1_done,FC2_done,FC3_done,RESULT_done)begin
        case(st)
        IDLE : nst = (start == 1'b1)    ? L1   : IDLE;
        L1   : nst = (L1_done == 1'b1 ) ? L3   : L1;
        L3   : nst = (L3_done == 1'b1 ) ? FC1  : L3;
        FC1  : nst = (FC1_done == 1'b1) ? FC2  : FC1;
        FC2  : nst = (FC2_done == 1'b1) ? FC3  : FC2;
        FC3  : nst = (FC3_done == 1'b1) ? RESULT : FC3;
        RESULT  : nst = (RESULT_done == 1'b1) ? DONE : RESULT;
        DONE : nst = DONE;
        default : nst = IDLE;
        endcase
    end
    

    //output logic
    assign L1_en = (st == L1); 
    assign L3_en = (st == L3); 
    assign FC1_en = (st==FC1);
    assign FC2_en = (st==FC2);
    assign FC3_en = (st==FC3);
    assign RESULT_en = (st==RESULT);
    assign finish = (st == DONE) ? 1'b1 : 1'b0;
    
endmodule
