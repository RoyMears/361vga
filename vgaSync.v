`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Roy Mears, Jonathan Zavala, Luis Arevalo
// 
// Create Date: 10/18/2023 04:38:03 PM
// Design Name: 
// Module Name: vga_sync
// Project Name: CECS361FinalProjectPong
// Target Devices: nexys a7 100t
// Tool Versions: 
// Description: This module is used to generate horizontal and vertical syncronization signals and keep track of pixel location

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vgaSync(
input wire clk_25MHz, reset,

output wire horizontalSync, verticalSync, videoOn,
output wire [15:0] pixelX, pixelY
);

// VGA 640-by-480 sync parameters defined in book.

localparam horizontalDisplay = 640; // horizontal display width
localparam horizontalBackPorch = 48 ; // Back porch pixel width on the front (left) border
localparam horizontalFrontPorch = 16 ; // Front porch pixel width on the back (right) border
localparam horizontalRetrace = 96 ; // Retrace horizontal return region 

localparam virticalDisplay = 480; // vertical display area
localparam virticalBackPorch = 10; // Back porch pixel width on front (top) border
localparam verticalFrontPorch = 33; // Front porch pixel width on back (bottom) border
localparam virticalRetrace = 2; //  Retrace return virtical region

// sync counters
reg [15:0] horizontalCount =0; 
//reg [9:0] nextHorizontalCount; 
reg [15:0] verticalCount =0; 
//reg [9:0] nextVerticalCount;  
reg enableVerticalCount = 0;
// buffers used in output
reg vSyncReg;
reg hSyncReg;
wire vSyncNext;
wire hSyncNext;

// status signal
//wire horizontalEnd;
//wire verticalEnd;


always @(posedge clk_25MHz, posedge reset)
    if (reset)begin       
    verticalCount <= 0;
    horizontalCount <= 0;
    vSyncReg <= 0;
    hSyncReg <= 0;
end
else
    begin
        //verticalCount <= nextVerticalCount;
        //horizontalCount <= nextHorizontalCount;
        vSyncReg <= vSyncNext;
        hSyncReg <= hSyncNext;
end



// flagging signals denoting end of sides
localparam horizontalEnd = (horizontalDisplay + horizontalBackPorch + horizontalFrontPorch + horizontalRetrace - 1);// end is true when count == maximum (0-799)
localparam verticalEnd = (virticalDisplay + virticalBackPorch + verticalFrontPorch + virticalRetrace - 1); // end is true when count == maximum (0-524)

//assign horizontalEnd = (horizontalCount == (horizontalDisplay + horizontalBackPorch + horizontalFrontPorch + horizontalRetrace - 1));// end is true when count == maximum (0-799)
//assign verticalEnd = (verticalCount == (virticalDisplay + virticalBackPorch + verticalFrontPorch + virticalRetrace - 1)); // end is true when count == maximum (0-524)

always @(posedge clk_25MHz)begin
    if(horizontalCount < horizontalEnd)begin
        horizontalCount <= horizontalCount + 1;
        enableVerticalCount <= 0;
        end
        else begin
            horizontalCount <= 0;
            enableVerticalCount <= 1;
        end
end
         
always @(posedge clk_25MHz)begin
         if (enableVerticalCount == 1'b1)begin
             if (verticalCount < verticalEnd)
                 verticalCount <= verticalCount +1;
             else
                 verticalCount <= 0; // reset vertical counter
         end
     end


//always @*// horizontal synchronization counter logic
//    if (clk_25MHz) // 25 MHz pulse
//        if (horizontalEnd)
//            nextHorizontalCount = 0;
//        else
//            nextHorizontalCount = horizontalCount + 1;
//    else
//        nextHorizontalCount = horizontalCount;
        
        
        
//always @*// vertical synchronization counter logic
//    if (clk_25MHz && horizontalEnd)// 25 MHz pulse and end of horizontal line
//        if (verticalEnd)
//            nextVerticalCount = 0;
//    else
//        nextVerticalCount = verticalCount + 1;
//    else
//        nextVerticalCount = verticalCount;


// horizontal and vertical sync
// recomended buffer to avoid glitch



//assign videoOn = (horizontalCount < horizontalDisplay) && (verticalCount < virticalDisplay); // only raise video_on when in display area
assign videoOn = ((horizontalCount < 784) && (horizontalCount > 143) && (verticalCount < 515) && (verticalCount > 34)) ? 1'b1 : 1'b0; // only raise video_on when in display area





// raise next only when in specified range
assign horizontalSync = (horizontalCount < horizontalRetrace) ? 1'b1:1'b0;
//assign hSyncNext = (horizontalCount >= (horizontalDisplay + horizontalFrontPorch) && (horizontalCount <= (horizontalDisplay + horizontalFrontPorch + horizontalRetrace - 1))); // horizontal count >= 656, and horizontal count <= 751

// raise next only when in specified range
assign verticalSync = (verticalCount < virticalRetrace) ? 1'b1:1'b0;
//assign vSyncNext = ((verticalCount >= (virticalDisplay + virticalBackPorch)) && (verticalCount <= (virticalDisplay + virticalBackPorch + virticalRetrace - 1))); // vertial count >= 490, and vertical count <= 491

//assign horizontalSync = hSyncReg;
//assign verticalSync = vSyncReg;
assign pixelX = horizontalCount;
assign pixelY = verticalCount;

endmodule 
