`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2020 10:57:28 AM
// Design Name: 
// Module Name: gcd_pipeline
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


module gcd_pipeline(
        input                           rst_n,
        input                           clk,

        input           [31:0]          OPA,
        input           [31:0]          OPB,
        output          [31:0]          RESULT,

        input                           START,
        output  reg                     DONE
    );

    wire                [31:0]          iCompA          [0:32];
    wire                [31:0]          iCompB          [0:32];

    assign  #1  iCompA  [0] =           (START)         ?
                                        OPA             :
                                        iCompA[0];
    assign  #1  iCompB  [0] =           (START)         ?
                                        OPB             :
                                        iCompB[0];

    genvar i;
    generate for(i=0;i<32;i=i+1) begin : GenModule1
        gcd_test    GCD(
            .rst_n      (rst_n),
            .clk        (clk),

            .OPA        (iCompA[i]),
            .OPB        (iCompB[i]),
            .oMuxDiv    (iCompA[i+1]),
            .oMuxMod    (iCompB[i+1])
        );
    end
    endgenerate

    assign      RESULT      =           iCompA[32];

endmodule
