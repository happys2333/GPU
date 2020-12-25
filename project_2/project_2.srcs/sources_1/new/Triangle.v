`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 23:28:13
// Design Name: 
// Module Name: Triangle
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
module Triangle(
    input                                   choose              ,
    input               [2:0]               functionChoice      ,
    input               [11:0]              x1                  ,
    input               [11:0]              y1                  ,
    input               [11:0]              x2                  ,
    input               [11:0]              y2                  ,
    input               [11:0]              x3                  ,
    input               [11:0]              y3                  ,
    input               [3:0]               red                 ,
    input               [3:0]               green               ,
    input               [3:0]               blue                ,
    input               [11:0]              h_cnt               ,
    input               [11:0]              v_cnt               ,
    input                                   clk                 ,
    input                                   rst                 ,
    output reg          [18:0]              wr_addr6            ,
    output reg          [11:0]              wr_data6            ,
    input                                   active              
                );     
//--------------end of module define--------------

//参数
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
        //三个点的坐标，同时对其有一定的限制
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              
    wire                                    signed              

always @(posedge clk or negedge rst)
begin
    if(!rst) 
    begin
        wr_addr6 <= 19'b0;
        wr_data6 <= 12'b0;            
    end
    else if(functionChoice !=3'd4)
    begin
        wr_addr6 <= 19'b0;
        wr_data6 <= 12'b0;
    end
    else if (functionChoice == 3'd4)
    begin
        if(active)   
            //  利用两点式将底数乘以过来，取绝对值小于0.5的点，并将其设为蓝色
        begin
            if((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) < x1 &&(h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)<x2 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)<x3)
            begin
                wr_addr6 <= 19'b0;
                wr_data6 <= 12'b0;       
            end
            else if((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) > x1 &&(h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>x2 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>x3)
            begin
                wr_addr6 <= 19'b0;
                wr_data6 <= 12'b0;       
            end
            else if((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) >y1 && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) >y2 && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) > y3)
            begin
                wr_addr6 <= 19'b0;
                wr_data6 <= 12'b0;       
            end
            else if((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) <y1 && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) <y2 && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) < y3)
            begin
                wr_addr6 <= 19'b0;
                wr_data6 <= 12'b0;       
            end
            else if((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH == x1) && x1==x2 && (((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)>=y1 &&( v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH )<=y2) || ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)>=y2 &&( v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) <=y1)))
            begin
                wr_addr6 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data6[11:8] <= red;
                wr_data6[7:4] <= green;
                wr_data6[3:0] <= blue;
            end
            else if(((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) == x1)&& x1==x3 && (((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)>=y1 && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) <=y3)|| ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH)>=y3 && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) <=y1)))
            begin
                wr_addr6 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data6[11:8] <= red;
                wr_data6[7:4] <= green;
                wr_data6[3:0] <= blue;
            end
            else if(((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH == x2)) && x2==x3 && (((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH>=y2) && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH <=y3))|| ((v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH>=y3) && (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH <=y2))))
            begin
                wr_addr6 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data6[11:8] <= red;
                wr_data6[7:4] <= green;
                wr_data6[3:0] <= blue;
            end
            else if(x1!=x2 && 
                ((1000*(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) -(k1 * (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) + b1))<=1000 || 
            ((k1 * (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) + b1)-1000*(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH))<=1000) && 
            (((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>=x1 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) <= x2)|| 
            ((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>=x2 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) <= x1)))
            begin
                wr_addr6 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data6[11:8] <= red;
                wr_data6[7:4] <= green;
                wr_data6[3:0] <= blue;
            end
            else if(x1!= x3 &&
                ((1000*(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) -(k2 * (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) + b2))<=1000||
            ((k2 * (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) + b2)-1000*(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH))<=1000) &&
            (((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>=x1 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) <= x3)|| 
            ((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>=x3 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) <= x1)))
            begin
                wr_addr6 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data6[11:8] <= red;
                wr_data6[7:4] <= green;
                wr_data6[3:0] <= blue;
            end
            else if(x2 !=x3 && 
                ((1000*(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) -(k3 * (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) + b3))<=1000 ||
            ((k3 * (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) + b3)-1000*(v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH))<=1000) &&
            (((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>=x2 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) <= x3)|| 
            ((h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH)>=x3 && (h_cnt - C_H_SYNC_PULSE - C_H_BACK_PORCH) <= x2)))
            begin
                wr_addr6 <= (640) * (v_cnt - C_V_SYNC_PULSE - C_V_BACK_PORCH) + h_cnt - C_H_SYNC_PULSE  - C_H_BACK_PORCH  ;
                wr_data6[11:8] <= red;
                wr_data6[7:4] <= green;
                wr_data6[3:0] <= blue;
            end
        end   
    end
end                                    
endmodule
