`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2021 06:26:37 PM
// Design Name: 
// Module Name: morse_decoder
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


module morse_decoder(
    input clk, reset_n, b,
    output dot, dash, lg, wg
    );
    wire timer_enable;
    wire rtc;
    wire [2:0] number_of_units;
    FSM_controller FSM1(
        .clk(clk),
        .reset_n(reset_n),
        .b(b),
        .nou(number_of_units),
        .timer_enable(timer_enable),
        .rtc(rtc),
        .dot(dot),
        .dash(dash),
        .lg(lg),
        .wg(wg)
    );
    
    wire timer_done;
    timer_parameter #(.FINAL_VALUE(20_000_000)) (   // 200ms per unit
        .clk(clk),
        .reset_n(~(rtc | ~reset_n)),
        .enable(timer_enable),
        .done(timer_done)
    );
    
    udl_counter #(.BITS(3)) UDL1(
        .clk(clk),
        .reset_n(~(rtc | ~reset_n)),
        .enable(timer_done),
        .up(1'b1), //when asserted the counter is up counter; otherwise, it is a down counter
        .load(1'b0),
        .D(3'b0),
        .Q(number_of_units)
    );
endmodule
