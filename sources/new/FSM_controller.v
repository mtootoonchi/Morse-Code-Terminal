`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2021 06:42:28 PM
// Design Name: 
// Module Name: FSM_controller
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


module FSM_controller(
    input clk, reset_n,
    input b,
    input [2:0] nou,
    output timer_enable, rtc,
    output dot, dash, lg, wg
    );
    
    reg [3:0] state_reg, state_next;
    localparam s0 = 0, s1 = 1, s2 = 2, s3 = 3
              ,s4 = 4, s5 = 5, s6 = 6, s7 = 7
              ,s8 = 8, s9 = 9;
    
    // Sequential state register
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end
    
    // Next state logic
    always @(*)
    begin
        state_next = state_reg;
        case(state_reg)
            s0: if(b)
                    state_next = s1;
            s1: if(~(nou < 3))
                    state_next = s2;
                else if(~b)
                    state_next = s3;
            s2: if(~b)
                    state_next = s4;
            s3: state_next = s5;
            s4: state_next = s5;
            s5: if(~(nou < 3))
                    state_next = s6;
                else if(b)
                    state_next = s7;
            s6: if(~(nou < 7))
                    state_next = s9;
                else if(b)
                    state_next = s8;
            s7: if(b)
                    state_next = s1;
                else if(~b)
                    state_next = s3;
            s8: if(b)
                    state_next = s1;
                else if(~b)
                    state_next = s3;
            s9: state_next = s0;
            default: state_next = s0;                                             
        endcase
    end
    
    // output logic
    assign timer_enable = b | (state_reg == s5) | (state_reg == s6);
    assign rtc = (state_reg == s3) | (state_reg == s4) | (state_reg == s7) | (state_reg == s8) | (state_reg == s9);
    assign dot = (state_reg == s3);
    assign dash = (state_reg == s4);
    assign lg = (state_reg == s8);
    assign wg = (state_reg == s9);
endmodule
