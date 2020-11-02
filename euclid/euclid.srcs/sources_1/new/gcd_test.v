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
    reg                 [31:0]          oMuxDiv;
    reg                 [31:0]          oMuxMod;

    assign  #1  iCompA      =           (START)             ?
                                        OPA                 :
                                        oMuxDiv;
    assign  #1  iCompB      =           (START)             ?
                                        OPB                 :
                                        oMuxMod;
    // wire                                oCompEq;
    assign  #1  oCompMax    =           (iCompA > iCompB)   ? 
                                        iCompA              : 
                                        iCompB;
    assign  #1  oCompMin    =           (iCompA > iCompB)   ? 
                                        iCompB              : 
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
    reg                 [31:0]          rShift2             [0:31];
    reg                 [31:0]          rCompArr;
    always @(posedge clk ) begin
        for (ppl_i = 0; ppl_i<32; ppl_i=ppl_i+1) begin
            rSub        [ppl_i]     <=  oSub                [ppl_i];
            rShift2     [ppl_i]     <=  rShift              [ppl_i];
        end
        rCompArr                    <=  oCompArr;
    end


    /////////////////////////////////////Mux
    // reg                 [7:0]           rMuxSel;


    // always @(posedge clk ) begin
    //     case (rCompArr)
    //     32'h0000_0000 : begin
    //                         rMuxSel     <=  7'd0;
    //                     end
    //     32'h0000_0001 : begin
    //                         rMuxSel     <=  7'd1;
    //                     end
    //     32'h0000_0003 : begin
    //                         rMuxSel     <=  7'd2;
    //                     end
    //     32'h0000_0007 : begin
    //                         rMuxSel     <=  7'd3;
    //                     end
    //     32'h0000_000F : begin
    //                         rMuxSel     <=  7'd4;
    //                     end
    //     32'h0000_001F : begin
    //                         rMuxSel     <=  7'd5;
    //                     end
    //     32'h0000_003F : begin
    //                         rMuxSel     <=  7'd6;
    //                     end
    //     32'h0000_007F : begin
    //                         rMuxSel     <=  7'd7;
    //                     end
    //     32'h0000_00FF : begin
    //                         rMuxSel     <=  7'd8;
    //                     end
    //     32'h0000_01FF : begin
    //                         rMuxSel     <=  7'd9;
    //                     end
    //     32'h0000_03FF : begin
    //                         rMuxSel     <=  7'd10;
    //                     end
    //     32'h0000_07FF : begin
    //                         rMuxSel     <=  7'd11;
    //                     end
    //     32'h0000_0FFF : begin
    //                         rMuxSel     <=  7'd12;
    //                     end
    //     32'h0000_1FFF : begin
    //                         rMuxSel     <=  7'd13;
    //                     end
    //     32'h0000_3FFF : begin
    //                         rMuxSel     <=  7'd14;
    //                     end
    //     32'h0000_7FFF : begin
    //                         rMuxSel     <=  7'd15;
    //                     end
    //     32'h0000_FFFF : begin
    //                         rMuxSel     <=  7'd16;
    //                     end
    //     32'h0001_FFFF : begin
    //                         rMuxSel     <=  7'd17;
    //                     end
    //     32'h0003_FFFF : begin
    //                         rMuxSel     <=  7'd18;
    //                     end
    //     32'h0007_FFFF : begin
    //                         rMuxSel     <=  7'd19;
    //                     end
    //     32'h000F_FFFF : begin
    //                         rMuxSel     <=  7'd20;
    //                     end
    //     32'h001F_FFFF : begin
    //                         rMuxSel     <=  7'd21;
    //                     end
    //     32'h003F_FFFF : begin
    //                         rMuxSel     <=  7'd22;
    //                     end
    //     32'h007F_FFFF : begin
    //                         rMuxSel     <=  7'd23;
    //                     end
    //     32'h00FF_FFFF : begin
    //                         rMuxSel     <=  7'd24;
    //                     end
    //     32'h01FF_FFFF : begin
    //                         rMuxSel     <=  7'd25;
    //                     end
    //     32'h03FF_FFFF : begin
    //                         rMuxSel     <=  7'd26;
    //                     end
    //     32'h07FF_FFFF : begin
    //                         rMuxSel     <=  7'd27;
    //                     end
    //     32'h0FFF_FFFF : begin
    //                         rMuxSel     <=  7'd28;
    //                     end
    //     32'h1FFF_FFFF : begin
    //                         rMuxSel     <=  7'd29;
    //                     end
    //     32'h3FFF_FFFF : begin
    //                         rMuxSel     <=  7'd30;
    //                     end
    //     32'h7FFF_FFFF : begin
    //                         rMuxSel     <=  7'd31;
    //                     end
    //     32'hFFFF_FFFF : begin
    //                         rMuxSel     <=  7'd0;
    //                     end
    //     default :       begin : NOP
    //                     end
    //     endcase
    // end

    // always @(posedge clk ) begin
    //     case (rMuxSel)
    //         7'd0 : begin 
    //                 oMuxDiv     <=  rShift[0]; 
    //                 oMuxMod     <=  rSub[0]; 
    //                 end
    //         7'd1 : begin 
    //                 oMuxDiv     <=  rShift[1]; 
    //                 oMuxMod     <=  rSub[1]; 
    //                 end
    //         7'd2 : begin 
    //                 oMuxDiv     <=  rShift[2]; 
    //                 oMuxMod     <=  rSub[2]; 
    //                 end
    //         7'd3 : begin 
    //                 oMuxDiv     <=  rShift[3]; 
    //                 oMuxMod     <=  rSub[3]; 
    //                 end
    //         7'd4 : begin 
    //                 oMuxDiv     <=  rShift[4]; 
    //                 oMuxMod     <=  rSub[4]; 
    //                 end
    //         7'd5 : begin 
    //                 oMuxDiv     <=  rShift[5]; 
    //                 oMuxMod     <=  rSub[5]; 
    //                 end
    //         7'd6 : begin 
    //                 oMuxDiv     <=  rShift[6]; 
    //                 oMuxMod     <=  rSub[6]; 
    //                 end
    //         7'd7 : begin 
    //                 oMuxDiv     <=  rShift[7]; 
    //                 oMuxMod     <=  rSub[7]; 
    //                 end
    //         7'd8 : begin 
    //                 oMuxDiv     <=  rShift[8]; 
    //                 oMuxMod     <=  rSub[8]; 
    //                 end
    //         7'd9 : begin 
    //                 oMuxDiv     <=  rShift[9]; 
    //                 oMuxMod     <=  rSub[9]; 
    //                 end
    //         7'd10 : begin 
    //                 oMuxDiv     <=  rShift[10]; 
    //                 oMuxMod     <=  rSub[10]; 
    //                 end
    //         7'd11 : begin 
    //                 oMuxDiv     <=  rShift[11]; 
    //                 oMuxMod     <=  rSub[11]; 
    //                 end
    //         7'd12 : begin 
    //                 oMuxDiv     <=  rShift[12]; 
    //                 oMuxMod     <=  rSub[12]; 
    //                 end
    //         7'd13 : begin 
    //                 oMuxDiv     <=  rShift[13]; 
    //                 oMuxMod     <=  rSub[13]; 
    //                 end
    //         7'd14 : begin 
    //                 oMuxDiv     <=  rShift[14]; 
    //                 oMuxMod     <=  rSub[14]; 
    //                 end
    //         7'd15 : begin 
    //                 oMuxDiv     <=  rShift[15]; 
    //                 oMuxMod     <=  rSub[15]; 
    //                 end
    //         7'd16 : begin 
    //                 oMuxDiv     <=  rShift[16]; 
    //                 oMuxMod     <=  rSub[16]; 
    //                 end
    //         7'd17 : begin 
    //                 oMuxDiv     <=  rShift[17]; 
    //                 oMuxMod     <=  rSub[17]; 
    //                 end
    //         7'd18 : begin 
    //                 oMuxDiv     <=  rShift[18]; 
    //                 oMuxMod     <=  rSub[18]; 
    //                 end
    //         7'd19 : begin 
    //                 oMuxDiv     <=  rShift[19]; 
    //                 oMuxMod     <=  rSub[19]; 
    //                 end
    //         7'd20 : begin 
    //                 oMuxDiv     <=  rShift[20]; 
    //                 oMuxMod     <=  rSub[20]; 
    //                 end
    //         7'd21 : begin 
    //                 oMuxDiv     <=  rShift[21]; 
    //                 oMuxMod     <=  rSub[21]; 
    //                 end
    //         7'd22 : begin 
    //                 oMuxDiv     <=  rShift[22]; 
    //                 oMuxMod     <=  rSub[22]; 
    //                 end
    //         7'd23 : begin 
    //                 oMuxDiv     <=  rShift[23]; 
    //                 oMuxMod     <=  rSub[23]; 
    //                 end
    //         7'd24 : begin 
    //                 oMuxDiv     <=  rShift[24]; 
    //                 oMuxMod     <=  rSub[24]; 
    //                 end
    //         7'd25 : begin 
    //                 oMuxDiv     <=  rShift[25]; 
    //                 oMuxMod     <=  rSub[25]; 
    //                 end
    //         7'd26 : begin 
    //                 oMuxDiv     <=  rShift[26]; 
    //                 oMuxMod     <=  rSub[26]; 
    //                 end
    //         7'd27 : begin 
    //                 oMuxDiv     <=  rShift[27]; 
    //                 oMuxMod     <=  rSub[27]; 
    //                 end
    //         7'd28 : begin 
    //                 oMuxDiv     <=  rShift[28]; 
    //                 oMuxMod     <=  rSub[28]; 
    //                 end
    //         7'd29 : begin 
    //                 oMuxDiv     <=  rShift[29]; 
    //                 oMuxMod     <=  rSub[29]; 
    //                 end
    //         7'd30 : begin 
    //                 oMuxDiv     <=  rShift[30]; 
    //                 oMuxMod     <=  rSub[30]; 
    //                 end
    //         7'd31 : begin 
    //                 oMuxDiv     <=  rShift[31]; 
    //                 oMuxMod     <=  rSub[31]; 
    //                 end
    //         default:begin 
    //                 oMuxDiv     <=  0; 
    //                 oMuxMod     <=  0; 
    //                 end
    //     endcase
    // end

    always @(posedge clk ) begin
        casex (rCompArr)
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx0 : begin
                                              oMuxDiv     <=  rShift2[0];
                                              oMuxMod     <=  rSub[0];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx01 : begin
                                              oMuxDiv     <=  rShift2[1];
                                              oMuxMod     <=  rSub[1];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011 : begin
                                              oMuxDiv     <=  rShift2[2];
                                              oMuxMod     <=  rSub[2];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_0111 : begin
                                              oMuxDiv     <=  rShift2[3];
                                              oMuxMod     <=  rSub[3];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx0_1111 : begin
                                              oMuxDiv     <=  rShift2[4];
                                              oMuxMod     <=  rSub[4];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx01_1111 : begin
                                              oMuxDiv     <=  rShift2[5];
                                              oMuxMod     <=  rSub[5];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x011_1111 : begin
                                              oMuxDiv     <=  rShift2[6];
                                              oMuxMod     <=  rSub[6];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_0111_1111 : begin
                                              oMuxDiv     <=  rShift2[7];
                                              oMuxMod     <=  rSub[7];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxx0_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[8];
                                              oMuxMod     <=  rSub[8];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_xx01_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[9];
                                              oMuxMod     <=  rSub[9];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_x011_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[10];
                                              oMuxMod     <=  rSub[10];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxxx_0111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[11];
                                              oMuxMod     <=  rSub[11];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xxx0_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[12];
                                              oMuxMod     <=  rSub[12];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_xx01_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[13];
                                              oMuxMod     <=  rSub[13];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_x011_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[14];
                                              oMuxMod     <=  rSub[14];
                                              end
32'bxxxx_xxxx_xxxx_xxxx_0111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[15];
                                              oMuxMod     <=  rSub[15];
                                              end
32'bxxxx_xxxx_xxxx_xxx0_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[16];
                                              oMuxMod     <=  rSub[16];
                                              end
32'bxxxx_xxxx_xxxx_xx01_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[17];
                                              oMuxMod     <=  rSub[17];
                                              end
32'bxxxx_xxxx_xxxx_x011_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[18];
                                              oMuxMod     <=  rSub[18];
                                              end
32'bxxxx_xxxx_xxxx_0111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[19];
                                              oMuxMod     <=  rSub[19];
                                              end
32'bxxxx_xxxx_xxx0_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[20];
                                              oMuxMod     <=  rSub[20];
                                              end
32'bxxxx_xxxx_xx01_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[21];
                                              oMuxMod     <=  rSub[21];
                                              end
32'bxxxx_xxxx_x011_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[22];
                                              oMuxMod     <=  rSub[22];
                                              end
32'bxxxx_xxxx_0111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[23];
                                              oMuxMod     <=  rSub[23];
                                              end
32'bxxxx_xxx0_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[24];
                                              oMuxMod     <=  rSub[24];
                                              end
32'bxxxx_xx01_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[25];
                                              oMuxMod     <=  rSub[25];
                                              end
32'bxxxx_x011_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[26];
                                              oMuxMod     <=  rSub[26];
                                              end
32'bxxxx_0111_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[27];
                                              oMuxMod     <=  rSub[27];
                                              end
32'bxxx0_1111_1111_1111_1111_1111_1111_1111 : begin                                             
                                              oMuxDiv     <=  rShift2[28];
                                              oMuxMod     <=  rSub[28];
                                              end
32'bxx01_1111_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[29];
                                              oMuxMod     <=  rSub[29];
                                              end
32'bx011_1111_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[30];
                                              oMuxMod     <=  rSub[30];
                                              end
32'b0111_1111_1111_1111_1111_1111_1111_1111 : begin
                                              oMuxDiv     <=  rShift2[31];
                                              oMuxMod     <=  rSub[31];
                                              end
        default :       begin : NOP
                        end
        endcase
    end


    // assign      iCompA              =       oMuxDiv;
    // assign      iCompB              =       oMuxMod;
    

    assign  #1  RESULT              =       oMuxDiv;

    
endmodule
