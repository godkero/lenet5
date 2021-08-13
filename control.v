`timescale 1ns / 1ps



module control 
#(
parameter IDLE  = 4'b0001,
           L1   = 4'b0010,
           L3   = 4'b0100,
           DONE = 4'b1000    
)
(
    input clk,rst, 
    input start,
    input L1_done,
    input L3_done,
    output L1_en,
    output L3_en,
    output finish
);


    reg [3:0] st,nst;

    //state transfer
    always@(posedge clk)begin
        if(rst) begin st <= IDLE; end
        else begin st <= nst; end
    end


    //next state logic
    always@(st,L1_en,L1_done,start,L3_done)begin
        case(st)
        IDLE : nst = (start == 1'b1)    ? L1   : IDLE;
        L1   : nst = (L1_done == 1'b1 ) ? L3   : L1;
        L3   : nst = (L3_done == 1'b1 ) ? DONE : L3;
        DONE : nst = DONE;
        default : nst = IDLE;
        endcase
    end


    //output logic
    assign L1_en = (st == L1) ? 1'b1 : 1'b0;
    // assign L3_en = (st == L3) ? 1'b1 : 1'b0;
    assign L3_en = (st == L3) ? 1'b1 : 1'b0;


    assign finish = (st == DONE) ? 1'b1 : 1'b0;
    
endmodule
