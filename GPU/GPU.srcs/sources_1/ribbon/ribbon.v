`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/28 16:08:38
// Design Name: 
// Module Name: ribbon
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


module ribbon(
    input clk,
    input rst, //ϵͳ��λ
    output reg[3:0] red,
    output reg[3:0] green,
    output reg[3:0] blue,
    output hs, // VGA��ͬ���ź�
    output vs,  // VGA��ͬ���ź�
    output active
    );
    wire [11:0] h_cnt;
    wire [11:0] v_cnt;
    vga vg(clk,rst,hs,vs,h_cnt,v_cnt,active);
    
    //����
    // �ֱ���Ϊ640*480ʱ��ʱ�������������
parameter       C_H_SYNC_PULSE     =   96  , 
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

    //����ģ��
    always @(posedge clk or negedge rst)
begin
    if(!rst) 
        begin
            red   <=  4'b0000    ;
            green <=  4'b0000   ;
            blue  <=  4'b0000    ; 
        end
    else if(active)     
        begin
            if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH)) // ��ɫ����
                begin
                    red   <=  4'b1111    ; // ��ɫ�����Ѻ�ɫ����ȫ����1����ɫ����ɫ��0
                    green <=  4'b0000   ;
                    blue  <=  4'b0000    ;
                end
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*2)) // ��ɫ����
                begin
                    red   <=  4'b0000    ;
                    green <=  4'b1111   ; // ��ɫ��������ɫ����ȫ����1����ɫ����ɫ������0
                    blue  <=  4'b0000    ;
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*3)) // ��ɫ����
                begin
                    red   <=  4'b0000    ;
                    green <=  4'b0000   ;
                    blue  <=  4'b1111    ; // ��ɫ��������ɫ����ȫ����1����ɫ���̷�����0
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*4)) // ��ɫ����
                begin
                    red   <=  4'b1111    ; // ��ɫ�������к���������ɫ��϶���
                    green <=  4'b1111   ; // ���԰�ɫ����Ҫ�Ѻ�������������ȫ����1
                    blue  <=  4'b1111    ;
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*5)) // ��ɫ����
                begin
                    red   <=  4'b0000    ; // ��ɫ�������ǰѺ��������з���ȫ����0
                    green <=  4'b0000   ;
                    blue  <=  4'b0000   ;
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*6)) // ��ɫ����
                begin
                    red   <=  4'b1111    ; // ��ɫ�������к���������ɫ��϶���
                    green <=  4'b1111   ; // ���Ի�ɫ����Ҫ�Ѻ�������������1
                    blue  <=  4'b0000    ; // ��ɫ������0
                end 
            else if(h_cnt < (C_H_SYNC_PULSE + C_H_BACK_PORCH + C_COLOR_BAR_WIDTH*7)) // ��ɫ����
                begin
                    red   <=  4'b1111    ; // ��ɫ�������к���������ɫ��϶���
                    green <=  4'b0000   ; // ������ɫ����Ҫ�Ѻ�������������1
                    blue  <=  4'b1111    ; // ��ɫ������0
                end 
            else                              // ��ɫ����
                begin
                    red   <=  4'b0000    ; // ��ɫ������������������ɫ��϶���
                    green <=  4'b1111   ; // ������ɫ����Ҫ����������������1
                    blue  <=  4'b1111    ; // ��ɫ������0
                end                   
        end
    else
        begin
            red   <=  4'b0000    ;
            green <=  4'b0000   ;
            blue  <=  4'b0000    ; 
        end           
end
endmodule
