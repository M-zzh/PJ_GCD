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


module gcd(
        input                           rst_n,
        input                           clk,

        input           [31:0]          OPA,
        input           [31:0]          OPB,
        output  reg     [31:0]          RESULT,

        input                           START,
        output  reg                     DONE
    );
    
    ////////////////////////////////////Comparator
    wire                [31:0]          iCompA, 
                                        iCompB, 
                                        oCompMax, 
                                        oCompMin;
    wire                                oCompEq;
    assign  #1  oCompMax    =           (iCompA > iCompB) ? 
                                        iCompA : 
                                        iCompB;
    assign  #1  oCompMin    =           (iCompA > iCompB) ? 
                                        iCompB : 
                                        iCompA;
    assign  #1  oCompEq     =           (iCompA == iCompB) ? 
                                        1'b1 : 
                                        0;

    ////////////////////////////////////Div
    wire                [31:0]          oDivMod;
    wire                                oDivZero;
    assign  #1  oDivMod     =           oCompMax % oCompMin;
    assign  #1  oDivZero    =           ~|oDivMod;

    ////////////////////////////////////State Machine
    reg                                 state;
    reg                                 next_state;
    localparam                          IDLE            = 3'd0,
                                        BUSY            = 3'd1;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= #1   IDLE;
        end else begin
            state <= #1   next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE:begin
                if(START)
                    next_state <= #1   BUSY;
                else
                    next_state <= #1   IDLE;
            end
            BUSY:begin
                if(oDivZero)
                    next_state <= #1   IDLE;
                else
                    next_state <= #1   BUSY;
            end
            default:begin
                next_state <= #1   IDLE;
            end
        endcase
    end

    reg                 [31:0]          rCompA,
                                        rCompB;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            rCompA  <= #1   0;
            rCompB  <= #1   0;
            RESULT  <= #1   0;
            DONE    <= #1   0;
        end else begin
            case (state)
                IDLE:begin
                    rCompA  <= #1   OPA;
                    rCompB  <= #1   OPB;
                    RESULT  <= #1   RESULT;
                    DONE    <= #1   0;
                end
                BUSY:begin
                    rCompA  <= #1   oDivMod;
                    rCompB  <= #1   oCompMin;
                    RESULT  <= #1   oDivZero ? oCompMin : RESULT;
                    DONE    <= #1   oDivZero ? 1 : 0;
                end
                default:begin
                    rCompA  <= #1   0;
                    rCompB  <= #1   0;
                    RESULT  <= #1   0;
                    DONE    <= #1   0;
                end
            endcase
        end
    end

    assign  #1  iCompA      =           rCompA;
    assign  #1  iCompB      =           rCompB;


    
endmodule
