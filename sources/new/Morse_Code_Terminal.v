`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2021 06:09:51 AM
// Design Name: 
// Module Name: morse_code_to_ASCII
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


module Morse_Code_Terminal(
        input clk, reset_n,
        input b, 
        output tx,
        
        output [6:0] SSEG,
        output [7:0] AN,
        output DP
    );
    wire b_output;
    button B0(
        .clk(clk), 
        .reset_n(reset_n),
        .noisy(b),
        .debounced(b_output),
        .p_edge(), 
        .n_edge(), 
        ._edge()
    );
    
    wire dot, dash, lg, wg;
    wire lg_or_wg;
    assign lg_or_wg = lg | wg;
    morse_decoder MD1(
        .clk(clk),
        .reset_n(reset_n),
        .b(b_output),
        .dot(dot), 
        .dash(dash), 
        .lg(lg), 
        .wg(wg)
    );
    
    wire shift;
    assign shift = dot ^ dash;
    wire [4:0] symbol;
    shift_register_enable #(.N(5)) (
        .clk(clk), 
        .reset_n(~(lg_or_wg | ~reset_n)),
        .SI(dash),
        .enable(shift),
        .Q(symbol)
    );
    
    wire [2:0] symbol_count;
    udl_counter #(.BITS(3)) (
        .clk(clk),
        .reset_n(~(lg_or_wg | ~reset_n)),
        .enable(shift),
        .up(1'b1), //when asserted the counter is up counter; otherwise, it is a down counter
        .load(symbol_count == 5),
        .D(3'b0),
        .Q(symbol_count)
    );
    
    // D Flip Flop
    reg Q_reg, Q_next;
    wire wg_delayed;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            Q_reg <= 1'b0;
        else
            Q_reg <= Q_next;
    end
    
    always @(*)
    begin
        Q_next = wg;
    end
    
    assign wg_delayed = Q_reg;
    // D Flip Flop
    
    wire [7:0] mux_output;
    mux_2x1_nbit #(.N(8)) (
        .w0(8'b1110_0000),
        .w1({symbol_count, symbol}),
        .s(wg),
        .f(mux_output)
    );
    
    wire [7:0] data_output;
    Synch_ROM(
        .clk(clk),
        .addr(mux_output),
        .data(data_output)
    );
    
    wire UART_full;
    uart(
        .clk(clk), 
        .reset_n(reset_n),
        .r_data(),
        .rd_uart(1'b0),
        .rx_empty(),
        .rx(8'b0),
        .w_data(data_output),
        .wr_uart(~UART_full & (lg_or_wg | wg_delayed)),
        .tx_full(UART_full),
        .tx(tx),
        .TIMER_FINAL_VALUE(10'b10_1000_1010)
    );
    
    sseg_driver (
        .clk(clk),
        .reset_n(reset_n),
        .I0({1'b0, 4'b0, 1'b0}), 
        .I1({1'b0, 4'b0, 1'b0}), 
        .I2({1'b0, 4'b0, 1'b0}), 
        .I3({symbol_count > 4, 3'b000, symbol[4], 1'b0}), 
        .I4({symbol_count > 3, 3'b000, symbol[3], 1'b0}), 
        .I5({symbol_count > 2, 3'b000, symbol[2], 1'b0}), 
        .I6({symbol_count > 1, 3'b000, symbol[1], 1'b0}), 
        .I7({symbol_count > 0, 3'b000, symbol[0], 1'b0}),
        .SSEG(SSEG),
        .AN(AN),
        .DP_ctrl_output(DP)
    );
    
endmodule
