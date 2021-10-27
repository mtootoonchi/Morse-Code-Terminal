`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2021 09:10:46 PM
// Design Name: 
// Module Name: first_sseg_driver
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


module first_sseg_driver(
        input [3:0] hex_number,
        input [2:0] seven_segment_digit_control,
        input DP_ctrl_input,
        input enable,
        output [6:0] SSEG,
        output [7:0] AN,
        output DP_ctrl_output
    );
    assign DP_ctrl_output = ~DP_ctrl_input;
    wire [7:0] g0;
    
    decoder_generic #(.N(3)) DG(
            .w(seven_segment_digit_control),
            .en(enable),
            .y(g0)
    );
    assign AN = ~g0;
    
    hex2sseg H2S(
            .hex(hex_number),
            .sseg(SSEG)
    );
    
endmodule
