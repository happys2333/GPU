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


//--------------start of module define--------------
module top(
    input                                   rst_n               ,
    input                                   choose              ,
    input                                   refresh             ,
    input               [3:0]               functional          ,
    input                                   uart_rx             ,
    input                                   clk                 ,
    input                                   rst                 ,
    input               [3:0]               button              ,
    output reg          [3:0]               red                 ,
    output reg          [3:0]               green               ,
    output reg          [3:0]               blue                ,
    output                                  hs                  ,
    output                                  vs                  ,
    output                                  active              ,
                //七段数码显示管
    output              [6:0]               seg_out             ,
    output              [7:0]               led                 
                );
//--------------end of module define--------------

    wire                                    hs2                 ;
    wire                                    vs2                 ;
    wire                                    hsync               ;
    wire                                    vsync               ;
    wire                [6:0]               seg_out2            ;
    wire                [7:0]               led2                ;
    wire                [6:0]               seg_out3            ;
    wire                [7:0]               led3                ;

assign  seg_out = functional[2] == 1'b1 ? seg_out2 : seg_out3;

assign  led = functional[2]==1'b1 ? led2 : led3; 
assign  hs = functional[2]==1'b1 ? hsync : hs2;

assign  vs = functional[2]==1'b1 ? vsync : vs2;
    wire                [11:0]              color_out           ;
    wire                                    wea                 ;
    wire                [18:0]              number              
    wire                [11:0]              h_cnt               ;
    wire                [11:0]              v_cnt               ;
    reg                 [18:0]              rd_addr             ;
    wire                [11:0]              rd_data             ;
    wire                                    clock               ;
    wire                [3:0]               r                   ;
    wire                [3:0]               g                   ;
    wire                [3:0]               b                   ;
    wire                                    clock2              ;

assign  clock2 = (functional[2] ==1'b1 || functional[3]==1'b1) ? clk : clock;//贪吃蛇为100MHz , 而正常图片显示为25MHZ，我们对此进行区分
ribbon ribbon2(choose,clock,rst,h_cnt,v_cnt,r,g,b,active);
vga vg(choose,clk,rst,hs2,vs2,h_cnt,v_cnt,active,clock);
uart ip(choose,refresh,clk,clock,h_cnt,v_cnt,rst,number,rd_addr,rd_data,uart_rx,functional,wea,active);
LEDOUT LEDOUT2(clk,rst,choose,seg_out3,led3);  
play_snake_game snake1(clk,rst_n,button,hsync,vsync,color_out,seg_out2,led2);
    wire                [9:0]               C_H_SYNC_PULSE      ;
    wire                [9:0]               C_H_BACK_PORCH      ;
C_V_SYNC_PULSE,C_V_BACK_PORCH,C_V_ACTIVE_TIME,C_V_FRONT_PORCH,C_V_FRAME_PERIOD;
// 640 * 400  640 * 480 对应各个的参数

                        C_H_SYNC_PULSE                     = 96                ;

                        C_H_BACK_PORCH                     = 48                ;

                        C_H_ACTIVE_TIME                    = 640               ;

                        C_H_FRONT_PORCH                    = 16                ;

                        C_H_LINE_PERIOD                    = 800               ;

                        C_V_SYNC_PULSE                     = 2                 ;

assign  C_V_BACK_PORCH = choose==1'b0 ? 33:35;

assign  C_V_ACTIVE_TIME = choose==1'b0 ? 480:400;

assign  C_V_FRONT_PORCH = choose==1'b0 ? 10:12;

assign  C_V_FRAME_PERIOD = choose==1'b0 ? 525:449;
        // 控制vga信号的输出。

always @(posedge clock2 or negedge rst)
begin
    if(functional[2])
    begin
        red <= color_out[3:0];
        green <=color_out[7:4];
        blue <= color_out[11:8];
    end
    else  if(!rst) 
    begin
        rd_addr  <= 19'b0;
        red <= 4'b0000;
        green <= 4'b0000;
        blue <= 4'b0000; 
    end
    else if(h_cnt >= C_H_SYNC_PULSE + C_H_BACK_PORCH  && 
        h_cnt <= C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1 &&
    v_cnt >= C_V_SYNC_PULSE +  C_V_BACK_PORCH  &&
    v_cnt <= C_V_SYNC_PULSE +  C_V_BACK_PORCH + C_V_ACTIVE_TIME -1)
    begin
        if(functional[1])
        begin
            red <= r ;
            green <= g;
            blue <= b;
        end
        else if(h_cnt == C_H_SYNC_PULSE + C_H_BACK_PORCH &&  v_cnt == C_V_SYNC_PULSE +  C_V_BACK_PORCH  )
        begin
                        rd_addr                            = 19'b0             ;
        end
        else
        begin
            red <=  rd_data[11:8];
            green <=rd_data[7:4];
            blue <= rd_data[3:0];
            if(rd_addr== number)
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
