`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 20:47:25
// Design Name: 
// Module Name: test
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


module test(
   input s,
   input clk,
   input rst, //ϵͳ��λ
   output [3:0] red,
   output [3:0] green,
   output [3:0] blue,
   output hs, // VGA��ͬ���ź�
   output vs, // VGA��ͬ���ź�
   output active
    );
    wire [11:0] h_cnt;                       
    wire [11:0] v_cnt; 
    vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active);
    Line tb(clk,rst,red,green,blue,hs,vs,active);
    Triangle tb2(clk,rst,red,green,blue,hs,vs,active);
endmodule
