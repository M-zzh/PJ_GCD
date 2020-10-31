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
        output       [31:0]          RESULT,

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
    reg                [31:0]          oMuxDiv;
    reg                [31:0]          oMuxMod;


always @(posedge clk ) begin
    case (oCompA)
    32'h0000_0000 : begin
                  oMuxDiv     <=   oShift[0];
                  oMuxMod     <=   oSub[0];
                    end
    32'h0000_0001 : begin
                  oMuxDiv     <=   oShift[1];
                  oMuxMod     <=   oSub[1];
                    end
    32'hffff_ffff : begin
                  oMuxDiv     <=   oShift[31];
                  oMuxMod     <=   oSub[31];
                    end
    default :       begin : NOP
                    end
    endcase
end

    assign      iCompA              =       oMuxDiv;
    assign      iCompB              =       oMuxMod;
    

    assign  #1  RESULT              =       oMuxDiv;

    
endmodule
