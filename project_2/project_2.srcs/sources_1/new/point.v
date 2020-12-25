`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/03 12:09:32
// Design Name: 
// Module Name: point
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


module point(
 input choose,
 input[2:0] functionChoice,
 input [11:0] x1,
 input [11:0] y1,
 input [3:0]  r,
 input [3:0]  g,
 input [3:0]  b,  
 input [11:0] h_cnt,
 input [11:0] v_cnt,
 input clk,//刷新率
 input rst, //系统复位(vga复位)
 output reg [18:0] wr_addr2,
 output reg [11:0] wr_data2,
 input active//控制vga信号是否输出
    );
   wire[9:0] C_H_SYNC_PULSE,C_H_BACK_PORCH,C_H_ACTIVE_TIME,C_H_FRONT_PORCH,C_H_LINE_PERIOD,
              C_V_SYNC_PULSE,C_V_BACK_PORCH,C_V_ACTIVE_TIME,C_V_FRONT_PORCH,C_V_FRAME_PERIOD;
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
                      //三个参数
     always @(posedge clk or negedge rst)
      begin
            if(!rst) 
                  begin
                        wr_addr2 = 19'b0;
                        wr_data2 = 12'b0;
                 end
           else if (functionChoice != 3'd0)
           begin
           wr_addr2 = 19'b0;
           wr_data2 = 12'b0;
           end
           else if(functionChoice==3'd0)
                 begin
                  if( (h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
                                        (h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1))  && 
                                        (v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
                                        (v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME-1))   )
                    begin
                        if((h_cnt == x1  +  C_H_SYNC_PULSE + C_H_BACK_PORCH) && (v_cnt == y1 +   C_V_SYNC_PULSE +   C_V_BACK_PORCH)   )
                    begin
                          wr_addr2 <= (640) * (y1) + x1 ;
                          wr_data2[11:8] <= r;
                          wr_data2[7:4] <= g;
                          wr_data2[3:0] <=b;
                    end
               end
             end  
          end
   endmodule
