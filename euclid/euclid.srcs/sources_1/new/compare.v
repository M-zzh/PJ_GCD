`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2020 03:39:25 PM
// Design Name: 
// Module Name: compare
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


module compare(
    input               [31:0]          iCompA,
    input               [31:0]          iCompB,
    output              [31:0]          oCompMax,
    output              [31:0]          oCompMin
    );
    


    assign  #1  oCompMax    =           (iCompA > iCompB) ? 
                                        iCompA : 
                                        iCompB;
    assign  #1  oCompMin    =           (iCompA > iCompB) ? 
                                        iCompB : 
                                        iCompA;
    
endmodule
