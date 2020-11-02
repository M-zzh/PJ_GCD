`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2020 04:01:08 PM
// Design Name: 
// Module Name: gcd
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


module gcd_test(
        input                           rst_n,
        input                           clk,

        input           [31:0]          OPA,
        input           [31:0]          OPB,
        output          [31:0]          RESULT,

        input                           START,
        output  reg                     DONE
    );
    
    ////////////////////////////////////Comparator
    wire                [31:0]          iCompA, 
                                        iCompB, 
                                        oCompMax, 
                                        oCompMin;

    assign  #1  iCompA      =           OPA;
    assign  #1  iCompB      =           OPB;
    // wire                                oCompEq;
    assign  #1  oCompMax    =           (iCompA > iCompB) ? 
                                        iCompA : 
                                        iCompB;
    assign  #1  oCompMin    =           (iCompA > iCompB) ? 
                                        iCompB : 
                                        iCompA;
    // assign  #1  oCompEq     =           (iCompA == iCompB) ? 
    //                                     1'b1 : 
    //                                     0;

    ////////////////////////////////////Div
    wire                [31:0]          oDivMod;
    wire                                oDivZero;
    // assign  #1  oDivMod     =           oCompMax % oCompMin;
    // assign  #1  oDivZero    =           ~|oDivMod;

    ////////////////////////////////////Shift
    wire                [31:0]          oShift              [0:31];
    genvar Shift_i;
    generate for(Shift_i=0;Shift_i<32;Shift_i=Shift_i+1) begin : ShiftArray
        assign oShift   [Shift_i]   =           oCompMin    <<  Shift_i;
    end
    endgenerate

    ////////////////////////////////////Sub
    wire                [31:0]          oSub                [0:31];
    genvar Sub_i;
    generate for(Sub_i=0;Sub_i<32;Sub_i=Sub_i+1) begin : SubArray
        assign oSub     [Sub_i]     =           oCompMax    -   oShift[Sub_i];
    end
    endgenerate

    /////////////////////////////////////Compare_Array
    wire                [31:0]          oCompA;
    genvar Comp_i;
    generate for(Comp_i=0;Comp_i<32;Comp_i=Comp_i+1) begin : CompArray
        assign oCompA   [Comp_i]    =   (oShift [Comp_i]    <   oCompMax);
    end
    endgenerate

    /////////////////////////////////////Mux
    reg                 [31:0]         oMuxDiv;
    reg                 [31:0]         oMuxMod;


always @(posedge clk ) begin
    case (oCompA)
    32'h0000_0000 : begin
                        oMuxDiv     <=  oShift[0];
                        oMuxMod     <=  oSub[0];
                    end
    32'h0000_0001 : begin
                        oMuxDiv     <=  oShift[1];
                        oMuxMod     <=  oSub[1];
                    end
    32'h0000_0002 : begin
                        oMuxDiv     <=  oShift[2];
                        oMuxMod     <=  oSub[2];
                    end
    32'h0000_0004 : begin
                        oMuxDiv     <=  oShift[3];
                        oMuxMod     <=  oSub[3];
                    end
    32'h0000_0008 : begin
                        oMuxDiv     <=  oShift[4];
                        oMuxMod     <=  oSub[4];
                    end
    32'h0000_0010 : begin
                        oMuxDiv     <=  oShift[5];
                        oMuxMod     <=  oSub[5];
                    end
    32'h0000_0020 : begin
                        oMuxDiv     <=  oShift[6];
                        oMuxMod     <=  oSub[6];
                    end
    32'h0000_0040 : begin
                        oMuxDiv     <=  oShift[7];
                        oMuxMod     <=  oSub[7];
                    end
    32'h0000_0080 : begin
                        oMuxDiv     <=  oShift[8];
                        oMuxMod     <=  oSub[8];
                    end
    32'h0000_0100 : begin
                        oMuxDiv     <=  oShift[9];
                        oMuxMod     <=  oSub[9];
                    end
    32'h0000_0200 : begin
                        oMuxDiv     <=  oShift[10];
                        oMuxMod     <=  oSub[10];
                    end
    32'h0000_0400 : begin
                        oMuxDiv     <=  oShift[11];
                        oMuxMod     <=  oSub[11];
                    end
    32'h0000_0800 : begin
                        oMuxDiv     <=  oShift[12];
                        oMuxMod     <=  oSub[12];
                    end
    32'h0000_1000 : begin
                        oMuxDiv     <=  oShift[13];
                        oMuxMod     <=  oSub[13];
                    end
    32'h0000_2000 : begin
                        oMuxDiv     <=  oShift[14];
                        oMuxMod     <=  oSub[14];
                    end
    32'h0000_4000 : begin
                        oMuxDiv     <=  oShift[15];
                        oMuxMod     <=  oSub[15];
                    end
    32'h0000_8000 : begin
                        oMuxDiv     <=  oShift[16];
                        oMuxMod     <=  oSub[16];
                    end

    32'h0001_0000 : begin
                      oMuxDiv     <=  oShift[17];
                        oMuxMod     <=  oSub[17];
                    end
    32'h0002_0000 : begin
                        oMuxDiv     <=  oShift[18];
                        oMuxMod     <=  oSub[18];
                    end
    32'h0004_0000 : begin
                        oMuxDiv     <=  oShift[19];
                        oMuxMod     <=  oSub[19];
                    end
    32'h0008_0000 : begin
                        oMuxDiv     <=  oShift[20];
                        oMuxMod     <=  oSub[20];
                    end
    32'h0010_0000 : begin
                        oMuxDiv     <=  oShift[21];
                        oMuxMod     <=  oSub[21];
                    end
    32'h0020_0000 : begin
                        oMuxDiv     <=  oShift[22];
                        oMuxMod     <=  oSub[22];
                    end
    32'h0040_0000 : begin
                        oMuxDiv     <=  oShift[23];
                        oMuxMod     <=  oSub[23];
                    end
    32'h0080_0000 : begin
                        oMuxDiv     <=  oShift[24];
                        oMuxMod     <=  oSub[24];
                    end
    32'h0100_0000 : begin
                        oMuxDiv     <=  oShift[25];
                        oMuxMod     <=  oSub[25];
                    end
    32'h0200_0000 : begin
                        oMuxDiv     <=  oShift[26];
                        oMuxMod     <=  oSub[26];
                    end
    32'h0400_0000 : begin
                        oMuxDiv     <=  oShift[27];
                        oMuxMod     <=  oSub[27];
                    end
    32'h0800_0000 : begin
                        oMuxDiv     <=  oShift[28];
                        oMuxMod     <=  oSub[28];
                    end
    32'h1000_0000 : begin
                        oMuxDiv     <=  oShift[29];
                        oMuxMod     <=  oSub[29];
                    end
    32'h2000_0000 : begin
                        oMuxDiv     <=  oShift[30];
                        oMuxMod     <=  oSub[30];
                    end
    32'h4000_0000 : begin
                        oMuxDiv     <=  oShift[31];
                        oMuxMod     <=  oSub[31];
                    end
    32'h8000_0000 : begin
                        oMuxDiv     <=  oShift[1];
                        oMuxMod     <=  oSub[1];
                    end
    default :       begin : NOP
                    end
    endcase
end

    assign      iCompA              =       oMuxDiv;
    assign      iCompB              =       oMuxMod;
    

    assign  #1  RESULT              =       oMuxDiv;

    
endmodule
