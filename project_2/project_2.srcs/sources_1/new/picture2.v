`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 21:00:20
// Design Name: 
// Module Name: picture2
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

//--------------start of module define--------------


//--------------start of module define--------------
module picture2(
    input                                   uart_rx             ,
    input                                   clk                 ,
    input                                   rst                 ,
    output reg          [3:0]               red                 ,
    output reg          [3:0]               green               ,
    output reg          [3:0]               blue                ,
    output                                  hs                  ,
    output                                  vs                  ,
    output                                  active              
                );
//--------------end of module define--------------


//--------------end of module define--------------
    wire                                    tt                  ;
    reg                 [18:0]              number              
    reg                 [18:0]              adress              ;
    wire                [11:0]              signal              ;
    wire                [11:0]              h_cnt               ;
    wire                [11:0]              v_cnt               ;
    wire                                    clock               ;
vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active,clock);
uart ip(clk,rst,number,adress,signal, uart_rx,tt);     
    parameter           C_H_SYNC_PULSE                     = 96                ,
                        C_H_BACK_PORCH                     = 48                ,
                        C_H_ACTIVE_TIME                    = 640               ,
                        C_H_FRONT_PORCH                    = 16                ,
                        C_H_LINE_PERIOD                    = 800               ;
// 分辨率为640*480时场时序各个参数定义               
    parameter           C_V_SYNC_PULSE                     = 2                 ,
                        C_V_BACK_PORCH                     = 33                ,
                        C_V_ACTIVE_TIME                    = 480               ,
                        C_V_FRONT_PORCH                    = 10                ,
                        C_V_FRAME_PERIOD                   = 525               ;
//这里用于输入各个顶点的参数

always @(posedge clock or negedge rst)
begin
    if(!rst) 
    begin
        adress  <= 19'b0;
    end
    else if(h_cnt >= C_H_SYNC_PULSE + C_H_BACK_PORCH  && 
        h_cnt <= C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1 &&
    v_cnt >=C_V_SYNC_PULSE +  C_V_BACK_PORCH  &&
    v_cnt <= C_V_SYNC_PULSE +  C_V_BACK_PORCH + C_V_ACTIVE_TIME -1 &&
    tt == 0)
    begin
        if(h_cnt == C_H_SYNC_PULSE + C_H_BACK_PORCH &&  v_cnt == C_V_SYNC_PULSE +  C_V_BACK_PORCH  )
        begin
                        adress                             = 19'b0             ;
        end
        else
        begin
            red <=  signal[11:8];
            green <=signal[7:4];
            blue <= signal[3:0];
            if(adress== 640 * 480-1)
            begin
                adress <=19'b0;
            end
            else 
            begin
                adress <= adress + 1'b1;
            end
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
