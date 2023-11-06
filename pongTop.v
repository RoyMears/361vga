`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Roy Mears, Jonathan Zavala, Luis Arevalo
// 
// Create Date: 10/17/2023 11:20:42 AM
// Design Name: 
// Module Name: pongTop
// Project Name: CECS361FinalProjectPongv
// Target Devices: nexys a7 100t
// Tool Versions: 
// Description: Top module connecting vga synchronization and pixel generation, taking external input and outputing vga signal.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pongTop(
input wire clk, reset, 
//input wire [1:0] pushButton, // for initial testing, we may utilize a potentiometer with the onboard ADC for paddle movement
output wire hsync, vsync,
output wire [3:0] rgb
//output wire [3:0] testRgb
);

wire [15:0] pix_x, pix_y; // signals for x and y coordinates
wire video_on; // signals for displayed video and 25Mhz timing
reg [3:0] rgb_reg;
wire [3:0] rgb_next;
wire clk_25M;



//clk divider circuit producing 25Mhz clk
clock_divider clk_gen(.clk(clk), .clkOutput(clk_25M));

//vga synchronization circuit
vgaSync vhSync(
.clk_25MHz(clk_25M), .reset(reset), .horizontalSync(hsync),
.verticalSync(vsync), .videoOn(video_on), .pixelX(pix_x),
.pixelY(pix_y)
 );
 
 
 staticDisplay pleaseWork(
 .video_on(video_on), .pix_x(pix_x), 
 .pix_y(pix_y), .graph_rgb(rgb_next));
 



// will need a pixel generating circuit for the pong game

//always @(posedge clk)
//    if (clk_25M)
//        rgb_reg <= rgb_next;
//// output
//assign rgb = rgb_reg;
assign rgb = ((pix_x < 784) && (pix_x > 143) && (pix_y < 515) && (pix_y > 34)) ? 4'hF : 4'h0;




endmodule
