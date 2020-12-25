`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/04 10:36:28
// Design Name: 
// Module Name: square_2
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


module square_2(
    input clk,
input rst, //系统复位
output reg[3:0] red,
output reg[3:0] green,
output reg[3:0] blue,
output hs, // VGA行同步信号
output vs, // VGA场同步信号
output active
    );
     wire [11:0] h_cnt;
     wire [11:0] v_cnt;
     vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active);
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
                     
     parameter       x1 =  C_H_ACTIVE_TIME/4;
     parameter       y1 =  C_V_ACTIVE_TIME/4;
     parameter       x2 = 400;
     parameter       y2 =  C_V_ACTIVE_TIME/4;
     parameter       x3 =  C_H_ACTIVE_TIME/4;
     parameter       y3 =  C_V_ACTIVE_TIME/4 +C_H_ACTIVE_TIME/2;
     parameter       x4 = 400 ;
     parameter       y4 =  C_V_ACTIVE_TIME/4 +C_H_ACTIVE_TIME/2; 
     
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
                if((h_cnt -  C_H_SYNC_PULSE - C_H_BACK_PORCH == x1) &&( (v_cnt-C_V_SYNC_PULSE-  C_V_BACK_PORCH>=y1) && (v_cnt-C_V_SYNC_PULSE-  C_V_BACK_PORCH <= y3)))
                  begin
                       red   <=  4'b0000    ;
                       green <=  4'b0000   ;
                       blue  <=  4'b1111    ; 
                  end
               else if((h_cnt -  C_H_SYNC_PULSE - C_H_BACK_PORCH == x2) &&( (v_cnt-C_V_SYNC_PULSE-  C_V_BACK_PORCH>=y1) && (v_cnt-C_V_SYNC_PULSE-  C_V_BACK_PORCH <= y3)))
                      begin
                              red   <=  4'b0000    ;
                              green <=  4'b0000   ;
                              blue  <=  4'b1111    ; 
                      end
               else if(v_cnt -  C_V_SYNC_PULSE - C_V_BACK_PORCH == y1 &&( (h_cnt-C_H_SYNC_PULSE-  C_H_BACK_PORCH>=x1) && (h_cnt-C_H_SYNC_PULSE-  C_H_BACK_PORCH <= x2)))
                      begin
                              red   <=  4'b0000    ;
                              green <=  4'b0000  ;
                              blue  <=  4'b1111    ; 
                      end
              else if(v_cnt -  C_V_SYNC_PULSE - C_V_BACK_PORCH == y3 &&( (h_cnt-C_H_SYNC_PULSE-  C_H_BACK_PORCH>=x1) && (h_cnt-C_H_SYNC_PULSE-  C_H_BACK_PORCH <= x2)))    
                       begin
                              red   <=  4'b0000    ;
                              green <=  4'b0000  ;
                              blue  <=  4'b1111    ; 
                       end    
              else 
                     begin 
                            red   <=  4'b0000    ;
                            green <=  4'b0000  ;
                            blue  <=  4'b0000    ; 
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
