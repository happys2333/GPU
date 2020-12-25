`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 10:42:23
// Design Name: 
// Module Name: belt
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
// Create Date: 2020/11/22 00:45:58
// Design Name: 
// Module Name: belt
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


module belt
(
    input                   I_clk   , // ϵͳ100MHzʱ��
    input                   I_rst_n , // ϵͳ��λ
    input                   clk_rst , // ʱ�Ӹ�λ
    output   reg   [3:0]    O_red   , // VGA��ɫ����
    output   reg   [3:0]    O_green , // VGA��ɫ����
    output   reg   [3:0]    O_blue  , // VGA��ɫ����
    output                  O_hs    , // VGA��ͬ���ź�
    output                  O_vs  ,    // VGA��ͬ���ź�
    output flag1,
//    output [11:0]flag2,
//    output [11:0]flag3,
    output flag4
);

//(* dont_touch = "true" *)reg  RXD_d;
//wire clk_25m,locked;


// �ֱ���Ϊ640*480ʱ��ʱ�������������
parameter       C_H_SYNC_PULSE      =   96  , 
                C_H_BACK_PORCH      =   48  ,
                C_H_ACTIVE_TIME     =   640 ,
                C_H_FRONT_PORCH     =   16  ,
                C_H_LINE_PERIOD     =   800 ;

// �ֱ���Ϊ640*480ʱ��ʱ�������������               
parameter       C_V_SYNC_PULSE      =   2   , 
                C_V_BACK_PORCH      =   33  ,
                C_V_ACTIVE_TIME     =   480 ,
                C_V_FRONT_PORCH     =   10  ,
                C_V_FRAME_PERIOD    =   525 ;
                
parameter       C_COLOR_BAR_WIDTH   =   C_H_ACTIVE_TIME / 8  ;  

reg [11:0]      R_h_cnt         ; // ��ʱ�������
reg [11:0]      R_v_cnt         ; // ��ʱ�������
reg             R_clk_25M       ;
reg             R_clk_50M       ;

wire            W_active_flag   ; // �����־��������ź�Ϊ1ʱRGB�����ݿ�����ʾ����Ļ��

//clk_wiz_0 instance_name
//   (
//    // Clock out ports
//    .clk_25m(clk_25m),     // output clk_25m
//    // Status and control signals
//    .reset(clk_rst), // input reset
//    .locked(locked),       // output locked
//   // Clock in ports
//    .clk_in1(I_clk));      // input clk_in1
//////////////////////////////////////////////////////////////////
//���ܣ� ����25MHz������ʱ��
//////////////////////////////////////////////////////////////////
//initial begin
// R_clk_50M = 1'b0;
// R_clk_25M = 1'b0;
//end
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
assign flag1 = R_clk_25M;
//assign flag2 = R_h_cnt;
//assign flag3 = R_v_cnt;
assign flag4 = W_active_flag;
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// ���ܣ�������ʱ��
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

assign O_hs =   (R_h_cnt < C_H_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// ���ܣ�������ʱ��
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

assign O_vs =   (R_v_cnt < C_V_SYNC_PULSE) ? 1'b0 : 1'b1    ; 
//////////////////////////////////////////////////////////////////  

assign W_active_flag =  (R_h_cnt >= (C_H_SYNC_PULSE + C_H_BACK_PORCH                  ))  &&
                        (R_h_cnt <= (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_H_ACTIVE_TIME))  && 
                        (R_v_cnt >= (C_V_SYNC_PULSE + C_V_BACK_PORCH                  ))  &&
                        (R_v_cnt <= (C_V_SYNC_PULSE + C_V_BACK_PORCH + C_V_ACTIVE_TIME))  ;                     

//////////////////////////////////////////////////////////////////
// ���ܣ�����ʾ����Ļ�ֳ�8�����У�ÿ�����еĿ����80
//////////////////////////////////////////////////////////////////
always @(posedge R_clk_25M or negedge I_rst_n)
begin
    if(!I_rst_n) 
        begin
            O_red   <=  4'b0000    ;
            O_green <=  4'b0000   ;
            O_blue  <=  4'b0000    ; 
        end
    else if(W_active_flag)     
        begin
            if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH)) // ��ɫ����
                begin
                    O_red   <=  4'b1111    ; // ��ɫ�����Ѻ�ɫ����ȫ����1����ɫ����ɫ��0
                    O_green <=  4'b0000   ;
                    O_blue  <=  4'b0000    ;
                end
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*2)) // ��ɫ����
                begin
                    O_red   <=  4'b0000    ;
                    O_green <=  4'b1111   ; // ��ɫ��������ɫ����ȫ����1����ɫ����ɫ������0
                    O_blue  <=  4'b0000    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*3)) // ��ɫ����
                begin
                    O_red   <=  4'b0000    ;
                    O_green <=  4'b0000   ;
                    O_blue  <=  4'b1111    ; // ��ɫ��������ɫ����ȫ����1����ɫ���̷�����0
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*4)) // ��ɫ����
                begin
                    O_red   <=  4'b1111    ; // ��ɫ�������к���������ɫ��϶���
                    O_green <=  4'b1111   ; // ���԰�ɫ����Ҫ�Ѻ�������������ȫ����1
                    O_blue  <=  4'b1111    ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*5)) // ��ɫ����
                begin
                    O_red   <=  4'b0000    ; // ��ɫ�������ǰѺ��������з���ȫ����0
                    O_green <=  4'b0000   ;
                    O_blue  <=  4'b0000   ;
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*6)) // ��ɫ����
                begin
                    O_red   <=  4'b1111    ; // ��ɫ�������к���������ɫ��϶���
                    O_green <=  4'b1111   ; // ���Ի�ɫ����Ҫ�Ѻ�������������1
                    O_blue  <=  4'b0000    ; // ��ɫ������0
                end 
            else if(R_h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*7)) // ��ɫ����
                begin
                    O_red   <=  4'b1111    ; // ��ɫ�������к���������ɫ��϶���
                    O_green <=  4'b0000   ; // ������ɫ����Ҫ�Ѻ�������������1
                    O_blue  <=  4'b1111    ; // ��ɫ������0
                end 
            else                              // ��ɫ����
                begin
                    O_red   <=  4'b0000    ; // ��ɫ������������������ɫ��϶���
                    O_green <=  4'b1111   ; // ������ɫ����Ҫ����������������1
                    O_blue  <=  4'b1111    ; // ��ɫ������0
                end                   
        end
    else
        begin
            O_red   <=  4'b0000    ;
            O_green <=  4'b0000   ;
            O_blue  <=  4'b0000    ; 
        end           
end
/*
////////////////////////////////////////////////////////////////
// ���ܣ������ڰ����ĸ���ͼ��
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
