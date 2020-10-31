`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2020 04:04:21 PM
// Design Name: 
// Module Name: Sub
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


module Sub(
    input               [31:0]          iCompA,
    input               [31:0]          iCompB,
    output              [31:0]          oCompMax,
    output              [31:0]          oCompMin
    );
    
    assign              oCompMax =      iCompA - iCompB;
    
endmodule
