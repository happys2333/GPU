`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 11:42:54
// Design Name: 
// Module Name: keyboard
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


module keyboard(
 input clk,
 input  rst_n,
input left,
input right,
input up,
input down,
output [1:0]move
    );
    always@(posedge clk or negedge rst_n)
    begin
    if(!rst_n)
    
    end
endmodule
