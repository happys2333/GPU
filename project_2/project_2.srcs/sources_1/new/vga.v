`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 10:43:24
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
    input                                   choose              ,
    input                                   I_clk               ,
    input                                   I_rst_n             ,
    output                                  O_hs                ,
    output                                  O_vs                ,
    output reg          [11:0]              R_h_cnt             ,
    output reg          [11:0]              R_v_cnt             ,
    output                                  active              ,
    output reg                              R_clk_25M           
);
    wire                                    clk_25m             ;
    wire                                    locked              ;
// 分辨率为640*480时行时序各个参数定义
// 分辨率各个参数定义
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
    reg                                     R_clk_50M           ;
    wire                                    W_active_flag       ;

assign  active = W_active_flag;
        //////////////////////////////////////////////////////////////////
        //功能： 产生25MHz的像素时钟
        //////////////////////////////////////////////////////////////////
        //也可使用clocking wizard
        //clk_wiz_0 instance_name
        //   (
        //    // Clock out ports
    output                                  clk_25m             
        //    // Status and control signals
    input                                   reset               
    output                                  locked              
        //   // Clock in ports
    input                                   clk_in1             

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
assign  O_hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
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
assign  O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
        //////////////////////////////////////////////////////////////////  
assign  W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1))  && 
        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
(R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME-1))  ;                     
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 10:43:24
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
    input                                   choose              ,
    input                                   I_clk               ,
    input                                   I_rst_n             ,
    output                                  O_hs                ,
    output                                  O_vs                ,
    output reg          [11:0]              R_h_cnt             ,
    output reg          [11:0]              R_v_cnt             ,
    output                                  active              ,
    output reg                              R_clk_25M           
);
    wire                                    clk_25m             ;
    wire                                    locked              ;
// 分辨率为640*480时行时序各个参数定义
// 分辨率各个参数定义
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
    reg                                     R_clk_50M           ;
    wire                                    W_active_flag       ;

assign  active = W_active_flag;
        //////////////////////////////////////////////////////////////////
        //功能： 产生25MHz的像素时钟
        //////////////////////////////////////////////////////////////////
        //也可使用clocking wizard
        //clk_wiz_0 instance_name
        //   (
        //    // Clock out ports
    output                                  clk_25m             
        //    // Status and control signals
    input                                   reset               
    output                                  locked              
        //   // Clock in ports
    input                                   clk_in1             

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
assign  O_hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
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
assign  O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
        //////////////////////////////////////////////////////////////////  
assign  W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1))  && 
        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
(R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME-1))  ;                     
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 10:43:24
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
    input                                   choose              ,
    input                                   I_clk               ,
    input                                   I_rst_n             ,
    output                                  O_hs                ,
    output                                  O_vs                ,
    output reg          [11:0]              R_h_cnt             ,
    output reg          [11:0]              R_v_cnt             ,
    output                                  active              ,
    output reg                              R_clk_25M           
);
    wire                                    clk_25m             ;
    wire                                    locked              ;
// 分辨率为640*480时行时序各个参数定义
// 分辨率各个参数定义
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
    reg                                     R_clk_50M           ;
    wire                                    W_active_flag       ;

assign  active = W_active_flag;
        //////////////////////////////////////////////////////////////////
        //功能： 产生25MHz的像素时钟
        //////////////////////////////////////////////////////////////////
        //也可使用clocking wizard
        //clk_wiz_0 instance_name
        //   (
        //    // Clock out ports
    output                                  clk_25m             
        //    // Status and control signals
    input                                   reset               
    output                                  locked              
        //   // Clock in ports
    input                                   clk_in1             

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
assign  O_hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
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
assign  O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
        //////////////////////////////////////////////////////////////////  
assign  W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME-1))  && 
        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
(R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME-1))  ;                     
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
