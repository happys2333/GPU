`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/28 15:52:37
// Design Name: 
// Module Name: vga
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


module vga
(
    input                   I_clk   , // 系统100MHz时钟
    input                   I_rst_n , // 系统复位
    output                  O_hs    , // VGA行同步信号
    output                  O_vs    , // VGA场同步信号
    output reg[11:0]        R_h_cnt , // 行时序计数器
    output reg[11:0]        R_v_cnt , // 场时序计数器
    output                  active  
);
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
reg             R_clk_25M       ;
reg             R_clk_50M       ;
wire            W_active_flag   ; // 激活标志，当这个信号为1时RGB的数据可以显示在屏幕上
assign active = W_active_flag;
//////////////////////////////////////////////////////////////////
//功能： 产生25MHz的像素时钟
//////////////////////////////////////////////////////////////////
//也可使用clocking wizard
//clk_wiz_0 instance_name
//   (
//    // Clock out ports
//    .clk_25m(clk_25m),     // output clk_25m
//    // Status and control signals
//    .reset(clk_rst), // input reset
//    .locked(locked),       // output locked
//   // Clock in ports
//    .clk_in1(I_clk));      // input clk_in1
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
