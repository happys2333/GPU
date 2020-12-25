`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/03 12:31:17
// Design Name: 
// Module Name: circular
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
module circular(
    input                                   choose              ,
    input               [2:0]               functionChoice      ,
    input               [11:0]              x1                  ,
    input               [11:0]              y1                  ,
    input               [11:0]              r                   ,
    input               [3:0]               red                 ,
    input               [3:0]               green               ,
    input               [3:0]               blue                ,
    input               [11:0]              h_cnt               ,
    input               [11:0]              v_cnt               ,
    input                                   clk                 ,
    input                                   rst                 ,
    output reg          [18:0]              wr_addr5            ,
    output reg          [11:0]              wr_data5            ,
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
        // 基于640 * 480的圆作图，r为输入半径，x1 y1分别为圆心大小。 
always @(posedge clk or negedge rst)
begin
    if(!rst) 
    begin
                        wr_addr5                           = 19'b0             ;
                        wr_data5                           = 12'b0             ;
    end
    else if(functionChoice!=3'd3) 
    begin
                        wr_addr5                           = 19'b0             ;
                        wr_data5                           = 12'b0             ;
    end
    else if(functionChoice == 3'd3) 
    begin   
        if(active)
        begin 
            if(choose == 1'b0)
            begin
                if((((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)*4-4* x1) * ((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)*4 -4*x1) + ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)*3 -3*y1) * ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)*3 -3*y1)) <= 16*(r*r) )//需要进行测试 我将9改变为了16
                begin
                    wr_addr5 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                    wr_data5[11:8] <= red;
                    wr_data5[7:4] <= green;
                    wr_data5[3:0] <= blue;
                end
                else
                begin
                    wr_addr5 <= wr_addr5;
                    wr_data5 <= wr_data5; 
                end 
            end
            else if(choose == 1'b1)
            begin
                if((((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)*7-7* x1) * ((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)*7 -7*x1) + ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)*6 -6*y1) * ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)*6 -6*y1)) <= 49*(r*r) )//需要进行测试 我将9改变为了16
                begin
                    wr_addr5 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                    wr_data5[11:8] <= red;
                    wr_data5[7:4] <= green;
                    wr_data5[3:0] <= blue;
                end
                else
                begin
                    wr_addr5 <= wr_addr5;
                    wr_data5 <= wr_data5; 
                end 
            end  
        end
    end    
end

endmodule
