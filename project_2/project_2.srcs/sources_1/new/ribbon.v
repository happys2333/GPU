`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 10:43:02
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
    input choose,
    input clk,
    input rst, //系统复位
    input [11:0]h_cnt,
    input [11:0]v_cnt,
    output reg[3:0] red,
    output reg[3:0] green,
    output reg[3:0] blue,
    input active
    );
    //参数
    // 分辨率为640*480时行时序各个参数定义
  wire[9:0] C_H_SYNC_PULSE,C_H_BACK_PORCH,C_H_ACTIVE_TIME,C_H_FRONT_PORCH,C_H_LINE_PERIOD,
                C_V_SYNC_PULSE,C_V_BACK_PORCH,C_V_ACTIVE_TIME,C_V_FRONT_PORCH,C_V_FRAME_PERIOD;
                
           // 640 * 400  640 * 480 对应各个的参数
           assign C_H_SYNC_PULSE = 96;
           assign C_H_BACK_PORCH = 48;
           assign C_H_ACTIVE_TIME = 640;
           assign C_H_FRONT_PORCH = 16;
           assign C_H_LINE_PERIOD = 800;
           assign C_V_SYNC_PULSE = 2;
           assign C_V_BACK_PORCH = choose==1'b0 ? 33:35;
           assign C_V_ACTIVE_TIME = choose==1'b0 ? 480:400;
           assign C_V_FRONT_PORCH = choose==1'b0 ? 10:12;
           assign C_V_FRAME_PERIOD = choose==1'b0 ? 525:449;
                
    wire[9:0] C_COLOR_BAR_WIDTH;
    assign   C_COLOR_BAR_WIDTH   =   C_H_ACTIVE_TIME / 8  ;

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
