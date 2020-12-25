`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/04 17:40:38
// Design Name: 
// Module Name: Line
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
module Line(
    input                                   choose              ,
    input               [2:0]               functionChoice      ,
    input               [11:0]              x1                  ,
    input               [11:0]              y1                  ,
    input               [11:0]              x2                  ,
    input               [11:0]              y2                  ,
    input               [3:0]               red                 ,
    input               [3:0]               green               ,
    input               [3:0]               blue                ,
    input               [11:0]              h_cnt               ,
    input               [11:0]              v_cnt               ,
    input                                   clk                 ,
    input                                   rst                 ,
    output reg          [18:0]              wr_addr3            ,
    output reg          [11:0]              wr_data3            ,
    input                                   active              
                );                   
//--------------end of module define--------------

    wire                [9:0]               C_H_SYNC_PULSE      ;
    wire                [9:0]               C_H_BACK_PORCH      ;
C_V_SYNC_PULSE,C_V_BACK_PORCH,C_V_ACTIVE_TIME,C_V_FRONT_PORCH,C_V_FRAME_PERIOD;

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
        //这里用于输入各个顶点的参数
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              

always @(posedge clk or negedge rst)
begin
    if(!rst) 
    begin
                        wr_data3                           = 12'b0             ;
                        wr_addr3                           = 19'b0             ;
    end
    else if( functionChoice != 3'd1)
    begin
                        wr_data3                           = 12'b0             ;
                        wr_addr3                           = 19'b0             ;
    end
    else if (functionChoice == 3'd1)
    begin    
        if( (h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
            (h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1))  && 
        (v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
        (v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME-1)))
        begin
            if(x1 == x2  &&   
                (h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH == x1-1) &&
            (h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH == x2-1))
            begin
                wr_addr3 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data3[11:8] <= red;
                wr_data3[7:4] <= green;
                wr_data3[3:0] <= blue;
            end
            else if(x1!=x2 && 
                (((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)*1000 - ((h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH ) *k + b )) <=1000 ||
            (((h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH ) * k + b )-(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)*1000) <=1000))
            begin
                wr_addr3 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH ) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data3[11:8] <= red;
                wr_data3[7:4] <= green;
                wr_data3[3:0] <= blue;
            end
            else
            begin
                wr_data3 <= wr_data3;
                wr_addr3 <= wr_addr3;
            end
        end
    end
end               
endmodule
