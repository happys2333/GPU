module picture(
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
     reg[18:0] number = 19'd30720;
     reg[18:0] adress;
     wire[11:0] signal;
     wire [11:0] h_cnt;                       
     wire [11:0] v_cnt;                   
     vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active);
     uart ip(clk,rst,number,adress,signal, uart_rx);     
       parameter         C_H_SYNC_PULSE     =   96  , 
                          C_H_BACK_PORCH      =   48  ,
                          C_H_ACTIVE_TIME     =   640 ,
                          C_H_FRONT_PORCH     =   16  ,
                          C_H_LINE_PERIOD     =   800 ;
          
          // 分辨率为640*480时场时序各个参数定义               
          parameter      C_V_SYNC_PULSE      =   2   , 
                          C_V_BACK_PORCH      =   33  ,
                          C_V_ACTIVE_TIME     =   480 ,
                          C_V_FRONT_PORCH     =   10  ,
                          C_V_FRAME_PERIOD    =   525 ;
                          //这里用于输入各个顶点的参数
           always @(posedge clk or negedge rst)
         begin
              if(!rst) 
                   begin
                   adress  <= 19'b0;
                   end
              else if(h_cnt - C_H_SYNC_PULSE-C_H_BACK_PORCH  >=0 && 
                      h_cnt-C_H_SYNC_PULSE - C_H_BACK_PORCH <=  C_H_ACTIVE_TIME-1 &&
                      v_cnt - C_V_SYNC_PULSE -  C_V_BACK_PORCH >=0 &&
                      v_cnt - C_V_SYNC_PULSE -  C_V_BACK_PORCH <= C_V_ACTIVE_TIME -1 )
                    begin
                           red <= signal[11:8];
                           green <= signal[7:4];
                           blue <= signal[3:0];
                    if(adress == adress + 600 * 480-1)
                        begin
                           adress <=19'b0;
                        end
                    else 
                        begin
                        adress = adress + 1'b1;
                        end
                    end     
                else
                    begin
                        red <=   4'b0;
                        green<=  4'b0;
                        blue <=  4'b0;
                        adress <= adress;
                    end
         end
endmodule
