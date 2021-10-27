`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2021 09:40:56 PM
// Design Name: 
// Module Name: shift_register_enable
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


module shift_register_enable
    #(parameter N = 4)(
    input clk, reset_n,
    input SI,
    input enable,
    output [N - 1:0] Q //If we care about the content
    //output SO        
    );
    
    reg [N - 1:0] Q_reg, Q_next;
    
    always @(posedge clk)
    begin
        Q_reg <= Q_next;
    end
    
    // Next state logic
    
    always @(Q_reg, SI, enable, reset_n)
    begin
        if(~reset_n)
            Q_next = 0;
        else if(enable)
            // Right shift
            // Q_next = {SI, Q_reg[N - 1: 1]};
            
            // Left shift
            Q_next = {Q_reg[N - 2:0], SI};
        else
            Q_next = Q_reg;
    end
    
    // output logic
    // SO for a right shift
    //assign SO = Q_reg[0];
    assign Q = Q_reg;
endmodule
