`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 16:07:31
// Design Name: 
// Module Name: ssss2
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
module ssss2();
parameter CLKPERIOD=100000000/115200;
    
 reg clk,rst_n,DataIn;
// reg[18:0] number;
  wire[3:0] red;
  wire[3:0] green;
  wire[3:0] blue;
//reg[18:0]   rd_addr;
//wire [11:0] rd_data;
wire hs; // VGA行同步信号
 wire vs; // VGA场同步信号
 wire active;
 point ut(DataIn,clk,rst_n,red,green,blue,hs,vs,active);
    //初始化
    initial begin
    clk = 0;
    rst_n =0;
    DataIn = 1'b1;
//    number = 19'd2;
//    rd_addr<=1'b1;
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
     #(CLKPERIOD*4) DataIn = 0;//3
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
      #(CLKPERIOD*4) DataIn = 0;//2
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//0
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       //
       //
       //
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
       
      #(CLKPERIOD*4) DataIn = 0;//2
      #(CLKPERIOD) DataIn =0 ;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
       #(CLKPERIOD*4) DataIn = 0;//4
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       //
       //
       //
       #(CLKPERIOD*4) DataIn = 0;//1
      #(CLKPERIOD) DataIn = 0;
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
