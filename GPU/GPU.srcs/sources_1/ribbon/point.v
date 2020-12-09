module point(
 input uart_rx,
 input clk,
 input rst, //系统复位
 output reg[3:0] red,
 output reg[3:0] green,
 output reg[3:0] blue,
 output hs, // VGA行同步信号
 output vs, // VGA场同步信号
 output active
    );
    wire tt;
    wire [11:0] h_cnt;//行计数器
    wire [11:0] v_cnt;//列计数器
    reg [18:0] rd_addr;
    wire [11:0] rd_data;
    wire  [2:0]number = 3'b010;
    reg [1:0] wea = 2'b0;
          vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active);
          uart2 ip(clk,rst,number,rd_addr,rd_data, uart_rx,tt);         
          //参数
          // 分辨率为640*480时行时序各个参数定义
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
    reg [11:0]x1;
    reg [11:0]y1;
     always @(posedge clk or negedge rst)
     begin
     if(wea != 2'd3)
     begin
      case(wea)
                2'd0:
                begin
                if(tt==1)
                begin
                wea<= wea;
                end
                else
                begin
                rd_addr <= 19'b0;
                wea <= wea +1'b1;
                end
                end 
                2'd1:
                begin
                 x1 <= rd_data;
                 rd_addr <= rd_addr+1'b1;
                 wea <= wea +1'b1;
                end
                2'd2:
                begin
                 y1<=rd_data;
                 wea <= wea +1'b1;
                end
                default:wea <= wea;   
           endcase
    end
    else 
    begin
          if(!rst) 
              begin
                 rd_addr <=19'b0;
                 wea <= 0;
                 red   <=  4'b0000    ;
                 green <=  4'b0000   ;
                 blue  <=  4'b0000    ; 
              end
              else if(active)
              begin 
              if(h_cnt == x1  +  C_H_SYNC_PULSE + C_H_BACK_PORCH && v_cnt == y1 +   C_V_SYNC_PULSE +   C_V_BACK_PORCH   )
              begin
                   red   <=  4'b1111    ;
                   green <=  4'b0000   ;
                   blue  <=  4'b0000   ; 
              end
              else
              begin
                              red   <=  4'b0000    ;
                              green <=  4'b0000   ;
                              blue  <=  4'b0000    ; 
              end
          end
  
       end
       end
endmodule
