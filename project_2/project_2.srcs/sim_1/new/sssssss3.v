`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 18:51:30
// Design Name: 
// Module Name: sssssss3
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

module sssssss3();
parameter CLKPERIOD=100000000/1000000;
reg [2:0] functional;
    
 reg clk,rst_n,DataIn,choose;
 wire[3:0]r,g,b;
 wire hs,vs,active,wea;
// wire    uart_rx_done;
// wire	[7:0] data;
// wire    start_flag;
// reg [11:0]number = 12'd100;
//reg [18:0] rd_addr;
//wire [11:0] rd_data;
// wire[4:0] cnt1;
 top ut(1'b0,3'b010,DataIn,clk,rst_n,r,g,b,hs,vs,active,wea);
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
     #(CLKPERIOD*4) DataIn = 0;//b
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 0;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 1;
      #(CLKPERIOD) DataIn = 0;
       #(CLKPERIOD) DataIn = 1;
       
//      #(CLKPERIOD*4) DataIn = 0;//3
//      #(CLKPERIOD) DataIn = 1;
//      #(CLKPERIOD) DataIn = 1;
//      #(CLKPERIOD) DataIn = 0;
//      #(CLKPERIOD) DataIn = 0;
//      #(CLKPERIOD) DataIn = 1;
//      #(CLKPERIOD) DataIn = 1;
//      #(CLKPERIOD) DataIn = 0;
//      #(CLKPERIOD) DataIn = 0;
//       #(CLKPERIOD) DataIn = 1;
       
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
       
//        #(CLKPERIOD*4) DataIn = 0;//2
//        #(CLKPERIOD) DataIn = 0;
//        #(CLKPERIOD) DataIn = 1;
//        #(CLKPERIOD) DataIn = 0;
//        #(CLKPERIOD) DataIn = 0;
//        #(CLKPERIOD) DataIn = 1;
//        #(CLKPERIOD) DataIn = 1;
//        #(CLKPERIOD) DataIn = 0;
//        #(CLKPERIOD) DataIn = 0;
//         #(CLKPERIOD) DataIn = 1;
             
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
                                         #(CLKPERIOD) DataIn = 0;
                                         #(CLKPERIOD) DataIn = 1;
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
       
       #(CLKPERIOD*4) DataIn = 0;//5
      #(CLKPERIOD) DataIn = 1;
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

