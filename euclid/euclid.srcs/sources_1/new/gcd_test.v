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

    /////////////////////////////////////Pipeline_reg_1
    reg                 [31:0]          rShift              [0:31];
    reg                 [31:0]          rCompMax;
    integer                             ppl_i;
    always @(posedge clk ) begin
        for (ppl_i = 0; ppl_i<32; ppl_i=ppl_i+1) begin
            rShift      [ppl_i]     <=  oShift              [ppl_i];
            rCompMax                <=  oCompMax;
        end
    end

    ////////////////////////////////////Sub
    wire                [31:0]          oSub                [0:31];
    genvar Sub_i;
    generate for(Sub_i=0;Sub_i<32;Sub_i=Sub_i+1) begin : SubArray
        assign oSub     [Sub_i]     =           rCompMax    -   rShift[Sub_i];
    end
    endgenerate

    /////////////////////////////////////Compare_Array
    wire                [31:0]          oCompArr;
    genvar Comp_i;
    generate for(Comp_i=0;Comp_i<32;Comp_i=Comp_i+1) begin : CompArray
        assign oCompArr [Comp_i]    =   ({1'b0, rShift [Comp_i]}    <   {1'b0, rCompMax});
    end
    endgenerate

    /////////////////////////////////////Pipeline_reg_2
    reg                 [31:0]          rSub                [0:31];
    reg                 [31:0]          rCompArr;
    always @(posedge clk ) begin
        for (ppl_i = 0; ppl_i<32; ppl_i=ppl_i+1) begin
            rSub        [ppl_i]     <=  oSub                [ppl_i];
        end
        rCompArr                    <=  oCompArr;
    end


    /////////////////////////////////////Mux
    reg                 [31:0]         oMuxDiv;
    reg                 [31:0]         oMuxMod;


    always @(posedge clk ) begin
        case (rCompArr)
        32'h0000_0000 : begin
                            oMuxDiv     <=  rShift[0];
                            oMuxMod     <=  rSub[0];
                        end
        32'h0000_0001 : begin
                            oMuxDiv     <=  rShift[1];
                            oMuxMod     <=  rSub[1];
                        end
        32'h0000_0003 : begin
                            oMuxDiv     <=  rShift[2];
                            oMuxMod     <=  rSub[2];
                        end
        32'h0000_0007 : begin
                            oMuxDiv     <=  rShift[3];
                            oMuxMod     <=  rSub[3];
                        end
        32'h0000_000F : begin
                            oMuxDiv     <=  rShift[4];
                            oMuxMod     <=  rSub[4];
                        end
        32'h0000_001F : begin
                            oMuxDiv     <=  rShift[5];
                            oMuxMod     <=  rSub[5];
                        end
        32'h0000_003F : begin
                            oMuxDiv     <=  rShift[6];
                            oMuxMod     <=  rSub[6];
                        end
        32'h0000_007F : begin
                            oMuxDiv     <=  rShift[7];
                            oMuxMod     <=  rSub[7];
                        end
        32'h0000_00FF : begin
                            oMuxDiv     <=  rShift[8];
                            oMuxMod     <=  rSub[8];
                        end
        32'h0000_01FF : begin
                            oMuxDiv     <=  rShift[9];
                            oMuxMod     <=  rSub[9];
                        end
        32'h0000_03FF : begin
                            oMuxDiv     <=  rShift[10];
                            oMuxMod     <=  rSub[10];
                        end
        32'h0000_07FF : begin
                            oMuxDiv     <=  rShift[11];
                            oMuxMod     <=  rSub[11];
                        end
        32'h0000_0FFF : begin
                            oMuxDiv     <=  rShift[12];
                            oMuxMod     <=  rSub[12];
                        end
        32'h0000_1FFF : begin
                            oMuxDiv     <=  rShift[13];
                            oMuxMod     <=  rSub[13];
                        end
        32'h0000_3FFF : begin
                            oMuxDiv     <=  rShift[14];
                            oMuxMod     <=  rSub[14];
                        end
        32'h0000_7FFF : begin
                            oMuxDiv     <=  rShift[15];
                            oMuxMod     <=  rSub[15];
                        end
        32'h0000_FFFF : begin
                            oMuxDiv     <=  rShift[16];
                            oMuxMod     <=  rSub[16];
                        end

        32'h0001_FFFF : begin
                        oMuxDiv     <=  rShift[17];
                            oMuxMod     <=  rSub[17];
                        end
        32'h0003_FFFF : begin
                            oMuxDiv     <=  rShift[18];
                            oMuxMod     <=  rSub[18];
                        end
        32'h0007_FFFF : begin
                            oMuxDiv     <=  rShift[19];
                            oMuxMod     <=  rSub[19];
                        end
        32'h000F_FFFF : begin
                            oMuxDiv     <=  rShift[20];
                            oMuxMod     <=  rSub[20];
                        end
        32'h001F_FFFF : begin
                            oMuxDiv     <=  rShift[21];
                            oMuxMod     <=  rSub[21];
                        end
        32'h003F_FFFF : begin
                            oMuxDiv     <=  rShift[22];
                            oMuxMod     <=  rSub[22];
                        end
        32'h007F_FFFF : begin
                            oMuxDiv     <=  rShift[23];
                            oMuxMod     <=  rSub[23];
                        end
        32'h00FF_FFFF : begin
                            oMuxDiv     <=  rShift[24];
                            oMuxMod     <=  rSub[24];
                        end
        32'h01FF_FFFF : begin
                            oMuxDiv     <=  rShift[25];
                            oMuxMod     <=  rSub[25];
                        end
        32'h03FF_FFFF : begin
                            oMuxDiv     <=  rShift[26];
                            oMuxMod     <=  rSub[26];
                        end
        32'h07FF_FFFF : begin
                            oMuxDiv     <=  rShift[27];
                            oMuxMod     <=  rSub[27];
                        end
        32'h0FFF_FFFF : begin
                            oMuxDiv     <=  rShift[28];
                            oMuxMod     <=  rSub[28];
                        end
        32'h1FFF_FFFF : begin
                            oMuxDiv     <=  rShift[29];
                            oMuxMod     <=  rSub[29];
                        end
        32'h3FFF_FFFF : begin
                            oMuxDiv     <=  rShift[30];
                            oMuxMod     <=  rSub[30];
                        end
        32'h7FFF_FFFF : begin
                            oMuxDiv     <=  rShift[31];
                            oMuxMod     <=  rSub[31];
                        end
        32'hFFFF_FFFF : begin
                            oMuxDiv     <=  rShift[1];
                            oMuxMod     <=  rSub[1];
                        end
        default :       begin : NOP
                        end
        endcase
    end


    assign      iCompA              =       oMuxDiv;
    assign      iCompB              =       oMuxMod;
    

    assign  #1  RESULT              =       oMuxDiv;

    
endmodule
