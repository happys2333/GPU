`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 10:42:23
// Design Name: 
// Module Name: belt
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
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/22 00:45:58
// Design Name: 
// Module Name: belt
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


module belt
(
    input                   I_clk   , // 系统100MHz时钟
    input                   I_rst_n , // 系统复位
    input                   clk_rst , // 时钟复位
    output   reg   [3:0]    O_red   , // VGA红色分量
    output   reg   [3:0]    O_green , // VGA绿色分量
    output   reg   [3:0]    O_blue  , // VGA蓝色分量
    output                  O_hs    , // VGA行同步信号
    output                  O_vs  ,    // VGA场同步信号
    output flag1,
//    output [11:0]flag2,
//    output [11:0]flag3,
    output flag4
);

//(* dont_touch = "true" *)reg  RXD_d;
//wire clk_25m,locked;


// 分辨率为640*480时行时序各个参数定义
parameter       C_H_SYNC_PULSE      =   96  , 
                C_H_BACK_PORCH      =   48  ,
                C_H_ACTIVE_TIME     =   640 ,
                C_H_FRONT_PORCH     =   16  ,
                C_H_LINE_PERIOD     =   800 ;

// 分辨率为640*480时场时序各个参数定义               
parameter       C_V_SYNC_PULSE      =   2   , 
                C_V_BACK_PORCH      =   33  ,
                C_V_ACTIVE_TIME     =   480 ,
                C_V_FRONT_PORCH     =   10  ,
                C_V_FRAME_PERIOD    =   525 ;
                
parameter       C_COLOR_BAR_WIDTH   =   C_H_ACTIVE_TIME / 8  ;  

reg [11:0]      R_h_cnt         ; // 行时序计数器
reg [11:0]      R_v_cnt         ; // 列时序计数器
reg             R_clk_25M       ;
reg             R_clk_50M       ;

wire            W_active_flag   ; // 激活标志，当这个信号为1时RGB的数据可以显示在屏幕上

//clk_wiz_0 instance_name
//   (
//    // Clock out ports
//    .clk_25m(clk_25m),     // output clk_25m
//    // Status and control signals
//    .reset(clk_rst), // input reset
//    .locked(locked),       // output locked
//   // Clock in ports
//    .clk_in1(I_clk));      // input clk_in1
//////////////////////////////////////////////////////////////////
//功能： 产生25MHz的像素时钟
//////////////////////////////////////////////////////////////////
//initial begin
// R_clk_50M = 1'b0;
// R_clk_25M = 1'b0;
//end
always @(posedge I_clk or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_clk_50M   <=  1'b0        ;
    else
        R_clk_50M   <=  ~R_clk_50M  ;     
end

always @(posedge R_clk_50M or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_clk_25M   <=  1'b0        ;
    else
        R_clk_25M   <=  ~R_clk_25M  ;     
end
assign flag1 = R_clk_25M;
//assign flag2 = R_h_cnt;
//assign flag3 = R_v_cnt;
assign flag4 = W_active_flag;
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// 功能：产生行时序
//////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_h_cnt <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        R_h_cnt <=  12'd0   ;
    else
        R_h_cnt <=  R_h_cnt + 1'b1  ;                
end                

assign O_hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// 功能：产生场时序
//////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n)
        R_v_cnt <=  12'd0   ;
    else if(R_v_cnt == C_V_FRAME_PERIOD - 1'b1)
        R_v_cnt <=  12'd0   ;
    else if(R_h_cnt == C_H_LINE_PERIOD - 1'b1)
        R_v_cnt <=  R_v_cnt + 1'b1  ;
    else
        R_v_cnt <=  R_v_cnt ;                        
end                

assign O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
//////////////////////////////////////////////////////////////////  

assign W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
                        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME))  && 
                        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
                        (R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME))  ;                     

//////////////////////////////////////////////////////////////////
// 功能：把显示器屏幕分成8个纵列，每个纵列的宽度是80
//////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n) 
        begin
            O_red   <=  4'b0000    ;
            O_green <=  4'b0000   ;
            O_blue  <=  4'b0000    ; 
        end
    else if(W_active_flag)     
        begin
            if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH)) // 红色彩条
                begin
                    O_red   <=  4'b1111    ; // 红色彩条把红色分量全部给1，绿色和蓝色给0
                    O_green <=  4'b0000   ;
                    O_blue  <=  4'b0000    ;
                end
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*2)) // 绿色彩条
                begin
                    O_red   <=  4'b0000    ;
                    O_green <=  4'b1111   ; // 绿色彩条把绿色分量全部给1，红色和蓝色分量给0
                    O_blue  <=  4'b0000    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*3)) // 蓝色彩条
                begin
                    O_red   <=  4'b0000    ;
                    O_green <=  4'b0000   ;
                    O_blue  <=  4'b1111    ; // 蓝色彩条把蓝色分量全部给1，红色和绿分量给0
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*4)) // 白色彩条
                begin
                    O_red   <=  4'b1111    ; // 白色彩条是有红绿蓝三基色混合而成
                    O_green <=  4'b1111   ; // 所以白色彩条要把红绿蓝三个分量全部给1
                    O_blue  <=  4'b1111    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*5)) // 黑色彩条
                begin
                    O_red   <=  4'b0000    ; // 黑色彩条就是把红绿蓝所有分量全部给0
                    O_green <=  4'b0000   ;
                    O_blue  <=  4'b0000   ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*6)) // 黄色彩条
                begin
                    O_red   <=  4'b1111    ; // 黄色彩条是有红绿两种颜色混合而成
                    O_green <=  4'b1111   ; // 所以黄色彩条要把红绿两个分量给1
                    O_blue  <=  4'b0000    ; // 蓝色分量给0
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*7)) // 紫色彩条
                begin
                    O_red   <=  4'b1111    ; // 紫色彩条是有红蓝两种颜色混合而成
                    O_green <=  4'b0000   ; // 所以紫色彩条要把红蓝两个分量给1
                    O_blue  <=  4'b1111    ; // 绿色分量给0
                end 
            else                              // 青色彩条
                begin
                    O_red   <=  4'b0000    ; // 青色彩条是由蓝绿两种颜色混合而成
                    O_green <=  4'b1111   ; // 所以青色彩条要把蓝绿两个分量给1
                    O_blue  <=  4'b1111    ; // 红色分量给0
                end                   
        end
    else
        begin
            O_red   <=  4'b0000    ;
            O_green <=  4'b0000   ;
            O_blue  <=  4'b0000    ; 
        end           
end
/*
////////////////////////////////////////////////////////////////
// 功能：产生黑白相间的格子图案
////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n) 
        begin
            O_red   <=  5'b00000    ;
            O_green <=  6'b000000   ;
            O_blue  <=  5'b00000    ; 
        end
    else if(W_active_flag)     
        begin
            if((R_h_cnt[4]==1'b1) ^ (R_v_cnt[4]==1'b1))
                begin
                    O_red   <=  5'b00000    ;
                    O_green <=  6'b000000   ;
                    O_blue  <=  5'b00000    ;
                end
            else
                begin
                    O_red   <=  5'b11111    ;
                    O_green <=  6'b111111   ;
                    O_blue  <=  5'b11111    ;
                end                   
        end
    else
        begin
            O_red   <=  5'b00000    ;
            O_green <=  6'b000000   ;
            O_blue  <=  5'b00000    ; 
        end           
end
*/

endmodule
