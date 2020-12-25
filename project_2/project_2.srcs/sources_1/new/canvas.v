`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 10:44:38
// Design Name: 
// Module Name: canvas
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


module canvas(
input rst,//复位信号
input  [11:0]h_cnt,//行计算器
input  [11:0]v_cnt,//列计算器
input  clock,//刷新率
input wire  [18:0] rd_addr,
input [11:0] rd_data,
output reg [3:0] red,
output reg [3:0] green,
output reg [3:0] blue 
    );
     always @(posedge clock or negedge rst)
            begin
                 if(!rst) 
                      begin
      
                      red <= 4'b0000;
                      green <= 4'b0000;
                      blue <= 4'b0000;
                      end
            end          
endmodule
