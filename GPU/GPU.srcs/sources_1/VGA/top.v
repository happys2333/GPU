`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 10:32:02
// Design Name: 
// Module Name: top
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


module top(
   input[1:0] functional,//功能控制
   input uart_rx,//串口接入
   input clk,//系统时钟信号
   input rst, //系统复位
   output reg [3:0] red,
   output reg [3:0] green,
   output reg [3:0] blue,
   output hs, // VGA行同步信号
   output vs, // VGA场同步信号
   output active//控制vga信号是否输出
    );
    reg[18:0] number = 19'd307200-1; // 像素有效点对应的大小
    wire[11:0] h_cnt;//行计数器
    wire[11:0] v_cnt;//列计数器
    reg [18:0] rd_addr;//ram寄存器中读的地址
    wire[11:0] rd_data;//ram寄存器中读的数据
    wire wea;
    wire clock; // vga对应的clock
   vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active,clock);
   uart ip(clk,clock,h_cnt,v_cnt,rst,number,rd_addr,rd_data,uart_rx,functional,wea,active);  
      parameter     C_H_SYNC_PULSE     =   96  , 
                      C_H_BACK_PORCH      =   48  ,
                      C_H_ACTIVE_TIME     =   640 ,
                      C_H_FRONT_PORCH     =   16  ,
                      C_H_LINE_PERIOD     =   800 ;
      
      // 分辨率为640*480时场时序各个参数定义               
      parameter     C_V_SYNC_PULSE      =   2   , 
                      C_V_BACK_PORCH      =   33  ,
                      C_V_ACTIVE_TIME     =   480 ,
                      C_V_FRONT_PORCH     =   10  ,
                      C_V_FRAME_PERIOD    =   525 ;
    always @(posedge clock or negedge rst)
           begin
                if(!rst) 
                     begin
                     rd_addr  <= 19'b0;
                     red <= 4'b0000;
                     green <= 4'b0000;
                     blue <= 4'b0000; 
                 end
                else if(h_cnt >= C_H_SYNC_PULSE + C_H_BACK_PORCH  && 
                        h_cnt <= C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1 &&
                        v_cnt >=C_V_SYNC_PULSE +  C_V_BACK_PORCH  &&
                        v_cnt <= C_V_SYNC_PULSE +  C_V_BACK_PORCH + C_V_ACTIVE_TIME -1)
                      begin
                         if(h_cnt == C_H_SYNC_PULSE + C_H_BACK_PORCH &&  v_cnt == C_V_SYNC_PULSE +  C_V_BACK_PORCH  )
                       begin
                          rd_addr = 19'b0;
                       end
                      else
                      begin
                             red <=  rd_data[11:8];
                             green <=rd_data[7:4];
                             blue <= rd_data[3:0];
                      if(rd_addr== 640 * 480-1)
                          begin
                             rd_addr <=19'b0;
                          end
                      else 
                          begin
                          rd_addr <= rd_addr + 1'b1;
                          end
                      end   
                    end    
                  else
                      begin
                          red <=   4'b0;
                          green<=  4'b0;
                          blue <=  4'b0;
                          rd_addr <= rd_addr;
                      end
           end   
endmodule
