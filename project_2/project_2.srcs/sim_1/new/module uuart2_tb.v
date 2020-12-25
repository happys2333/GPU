`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 15:28:01
// Design Name: 
// Module Name: module uuart2_tb
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

`timescale 1ns / 1ps
module uuart2_tb();
parameter CLKPERIOD=100000000/115200;
    
 reg clk,rst_n,DataIn;
 wire    uart_rx_done;
 wire	[7:0] data;
 wire    start_flag;
 wire[4:0] cnt1;
 uart ut(clk,      rst_n,DataIn,uart_rx_done,data,start_flag,cnt1);
    //初始化
    initial begin
    clk = 0;
    rst_n =0;
    DataIn = 1'b1;
    end
    //生成时钟激励
    always #1
     clk = ~clk;
    
    //复位使能
    initial begin
    #(CLKPERIOD) rst_n = 1;
    end
    //模拟发送数据
    initial begin
     #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
      #(CLKPERIOD*4) DataIn = 0;//,
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//,
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
        #(CLKPERIOD*4) DataIn = 0;//,
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
    end
endmodule

