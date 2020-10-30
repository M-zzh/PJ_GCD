`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2020 06:36:34 PM
// Design Name: 
// Module Name: gcd_tb
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


module gcd_tb(

    );
    reg                                 clk,
                                        rst_n,
                                        start;
    reg                 [31:0]          opa,
                                        opb;
    wire                [31:0]          result;
    wire                                done;

    integer                             testA       [0:10];
    integer                             testB       [0:10];
    integer                             i;
    
    initial begin
       clk      =   0;
       rst_n    =   0;
       start    =   0;
       opa      =   0;
       opb      =   0;

       i        =   0;
       testA[i] =   32'd1212;
       testB[i] =   32'd12;
       i        =   i + 1;
       testA[i] =   32'd1212;
       testB[i] =   32'd2424;
       i        =   i + 1;
       testA[i] =   32'd12112;
       testB[i] =   32'd121432;
       i        =   i + 1;
       testA[i] =   32'd22;
       testB[i] =   32'd753;
       i        =   i + 1;
       testA[i] =   32'd75288;
       testB[i] =   32'd256;
       i        =   i + 1;
       testA[i] =   32'd369;
       testB[i] =   32'd12;
       i        =   i + 1;
       testA[i] =   32'd3693;
       testB[i] =   32'd1;
       i        =   i + 1;
       testA[i] =   32'd1212;
       testB[i] =   32'd1212;
       i        =   i + 1;
       testA[i] =   32'd1212;
       testB[i] =   32'd1212;
       i        =   i + 1;
       testA[i] =   32'd1212;
       testB[i] =   32'd1212;
       i        =   i + 1;
       testA[i] =   32'd1212;
       testB[i] =   32'd1212;
       i        =   0;

       #10;
       rst_n    =   1;

        for (i = 0; i < 10+1; i=i+1) begin
            opa     =   testA[i];
            opb     =   testB[i];
            start   =   1;
            #5;
            wait    (clk);
            #5;
            start   =   0;
            wait    (clk);
            wait    (done);
            #2;
        end
        
        $finish;

    end
//////////////////////////////////////////////////////////
    gcd T1(
        .clk(clk),
        .rst_n(rst_n),

        .OPA(opa),
        .OPB(opb),
        .RESULT(result),

        .START(start),
        .DONE(done)
    );
//////////////////////////////////////////////////////////
    always @(done) begin
        if (done) begin
            $display($time,"; A=%d; B=%d; out=%d",opa, opb, result);
        end
    end
//////////////////////////////////////////////////////////
    always      #5  clk     =   ~clk;
//////////////////////////////////////////////////////////

endmodule
