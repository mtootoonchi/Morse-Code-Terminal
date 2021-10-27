`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2021 06:59:48 AM
// Design Name: 
// Module Name: Synch_ROM
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


module Synch_ROM(
        input clk,
        input [7:0] addr,
        output reg [7:0] data
    );
    
    (*rom_style = "block"*) reg [7:0] rom[0:255];
    
    initial
        $readmemh("truth_table.mem", rom);
        
    always @(posedge clk)
    begin 
        data <= rom[addr];
    end
endmodule
