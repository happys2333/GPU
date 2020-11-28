`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/28 16:08:38
// Design Name: 
// Module Name: ribbon
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


module ribbon(
    input clk,
    input rst, //系统复位
    output reg[3:0] red,
    output reg[3:0] green,
    output reg[3:0] blue,
    output hs, // VGA行同步信号
    output vs,  // VGA场同步信号
    output active
    );
    wire [11:0] h_cnt;
    wire [11:0] v_cnt;
    vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active);
    
    //参数
    // 分辨率为640*480时行时序各个参数定义
parameter       C_H_SYNC_PULSE     =   96  , 
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

    //功能模块
    always @(posedge clk or negedge rst)
begin
    if(!rst) 
        begin
            red   <=  4'b0000    ;
            green <=  4'b0000   ;
            blue  <=  4'b0000    ; 
        end
    else if(active)     
        begin
            if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH)) // 红色彩条
                begin
                    red   <=  4'b1111    ; // 红色彩条把红色分量全部给1，绿色和蓝色给0
                    green <=  4'b0000   ;
                    blue  <=  4'b0000    ;
                end
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*2)) // 绿色彩条
                begin
                    red   <=  4'b0000    ;
                    green <=  4'b1111   ; // 绿色彩条把绿色分量全部给1，红色和蓝色分量给0
                    blue  <=  4'b0000    ;
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*3)) // 蓝色彩条
                begin
                    red   <=  4'b0000    ;
                    green <=  4'b0000   ;
                    blue  <=  4'b1111    ; // 蓝色彩条把蓝色分量全部给1，红色和绿分量给0
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*4)) // 白色彩条
                begin
                    red   <=  4'b1111    ; // 白色彩条是有红绿蓝三基色混合而成
                    green <=  4'b1111   ; // 所以白色彩条要把红绿蓝三个分量全部给1
                    blue  <=  4'b1111    ;
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*5)) // 黑色彩条
                begin
                    red   <=  4'b0000    ; // 黑色彩条就是把红绿蓝所有分量全部给0
                    green <=  4'b0000   ;
                    blue  <=  4'b0000   ;
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*6)) // 黄色彩条
                begin
                    red   <=  4'b1111    ; // 黄色彩条是有红绿两种颜色混合而成
                    green <=  4'b1111   ; // 所以黄色彩条要把红绿两个分量给1
                    blue  <=  4'b0000    ; // 蓝色分量给0
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*7)) // 紫色彩条
                begin
                    red   <=  4'b1111    ; // 紫色彩条是有红蓝两种颜色混合而成
                    green <=  4'b0000   ; // 所以紫色彩条要把红蓝两个分量给1
                    blue  <=  4'b1111    ; // 绿色分量给0
                end 
            else                              // 青色彩条
                begin
                    red   <=  4'b0000    ; // 青色彩条是由蓝绿两种颜色混合而成
                    green <=  4'b1111   ; // 所以青色彩条要把蓝绿两个分量给1
                    blue  <=  4'b1111    ; // 红色分量给0
                end                   
        end
    else
        begin
            red   <=  4'b0000    ;
            green <=  4'b0000   ;
            blue  <=  4'b0000    ; 
        end           
end
endmodule
