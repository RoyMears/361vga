`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 05:17:32 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
input wire clk,
output wire clkOutput
    );
    
    
    reg clkOut;
    reg [1:0]count;
    initial count = 0;
    always @(posedge clk)begin
        count <= count +1;
        clkOut = count[1];
    end
    assign clkOutput = clkOut;
endmodule
