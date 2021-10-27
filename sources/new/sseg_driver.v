`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2021 06:51:33 PM
// Design Name: 
// Module Name: sseg_driver
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


module sseg_driver(
        input clk, reset_n,
        input [5:0] I0, I1, I2, I3, I4, I5, I6, I7, 
        output [6:0] SSEG,
        output [7:0] AN,
        output DP_ctrl_output
    );
    wire done;
    timer_parameter #(.FINAL_VALUE(49999)) TI1(
            .clk(clk),
            .reset_n(reset_n),
            .enable(1'b1),
            .done(done)
    );
    
    wire [2:0] number;
    udl_counter #(.BITS(3)) UC1(
            .clk(clk),
            .reset_n(reset_n),
            .enable(done),
            .up(1'b1),
            .load(1'b0),
            .D(3'b000),
            .Q(number)
    );
    
    wire [5:0]muxout;
    mux_8x1_nbit #(.N(6)) mx8 
    (
            .w0(I0), 
            .w1(I1), 
            .w2(I2), 
            .w3(I3),
            .w4(I4), 
            .w5(I5), 
            .w6(I6), 
            .w7(I7),
            .s(number),
            .f(muxout)    
    );
    
    first_sseg_driver FSSD(
            .hex_number(muxout[4:1]),
            .seven_segment_digit_control(number),
            .DP_ctrl_input(muxout[0]),
            .SSEG(SSEG),
            .enable(muxout[5]),
            .AN(AN),
            .DP_ctrl_output(DP_ctrl_output)
    );
endmodule 
