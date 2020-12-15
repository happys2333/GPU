`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 09:45:03
// Design Name: Game
// Module Name: snake
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


module snake(
    input [3:0] button
    );
endmodule
module move(
    clk,rst_n,//时钟
	button,//按钮
	start,//游戏开始
	x0,y0,x1,y1,x2,y2,x3,y3,
	x4,y4,x5,y5,x6,y6,x7,y7,x8,y8,
	x9,y9,x10,y10,x11,y11,x12,y12,x13,y13,
	x14,y14,x15,y15,
	IsOver,IsWin//游戏情况
);
/*
* 输入内容
*/
    input clk;
	input rst_n;
	input [3:0] button;
	input start;
	output [5:0]x0;
	output [5:0]y0;	
	output [5:0]x1;
	output [5:0]y1;
	output [5:0]x2;
	output [5:0]y2;
	output [5:0]x3;
	output [5:0]y3;	
	output [5:0]x4;
	output [5:0]y4;
	output [5:0]x5;
	output [5:0]y5;
	output [5:0]x6;
	output [5:0]y6;
	output [5:0]x7;
	output [5:0]y7;
	output [5:0]x8;
	output [5:0]y8;
	output [5:0]x9;
	output [5:0]y9;	
	output [5:0]x10;
	output [5:0]y10;	
	output [5:0]x11;
	output [5:0]y11;	
	output [5:0]x12;
	output [5:0]y12;	
	output [5:0]x13;
	output [5:0]y13;	
	output [5:0]x14;
	output [5:0]y14;
	output [5:0]x15;
	output [5:0]y15;
	output IsOver;
	output IsWin;
	/*
	* 寄存数据
	*/
	reg [4:0]moving_cstate,moving_nstate;
	reg [5:0]reg_x1;
	reg [5:0]reg_x2;
	reg [5:0]reg_x3;	
	reg [5:0]reg_x4;	
	reg [5:0]reg_x5;
	reg [5:0]reg_x6;
	reg [5:0]reg_x7;
	reg [5:0]reg_x8;
	reg [5:0]reg_x9;
	reg [5:0]reg_x10;
	reg [5:0]reg_x11;
	reg [5:0]reg_x12;
	reg [5:0]reg_x13;
	reg [5:0]reg_x14;
	reg [5:0]reg_x15;										
	reg [5:0]reg_x0;					
	reg [5:0]reg_y1;
	reg [5:0]reg_y2;
	reg [5:0]reg_y3;
	reg [5:0]reg_y4;
	reg [5:0]reg_y5;
	reg [5:0]reg_y6;
	reg [5:0]reg_y7;
	reg [5:0]reg_y8;
	reg [5:0]reg_y9;
	reg [5:0]reg_y10;
	reg [5:0]reg_y11;
	reg [5:0]reg_y12;
	reg [5:0]reg_y13;
	reg [5:0]reg_y14;
	reg [5:0]reg_y15;				
	reg [5:0]reg_y0;		 
	reg [25:0]counter;//level 1 情况下的速度
	reg [10:0]count0;//随机数生成器
	reg [10:0]count1;//随机数生成器
	reg [25:0]count2;//level 2 情况下的速度
	reg [3:0]i;
	reg over;
	reg win;
	reg left,right,up,down;
	parameter T1S=39_999_999,T2S=19_999_999;	
	parameter idle = 5'b00001,snake_up = 5'b00010,
	snake_down = 5'b00100,snake_left = 5'b01000,snake_right = 5'b10000;
	/**
	* 实现不同等级下的情况
	*/
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			counter<=26'd0;
		else if(counter==T1S)
			counter<=26'd0;
		else
			counter<=counter+26'd1;
	end 
	
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			count2<=26'd0;
		else if(count2==T2S)
			count2<=26'd0;
		else
			count2<=count2+26'd1;
	end 
	/*
	* 随机数生成器，对应一个二维坐标
	*/
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			count0<=11'd1;
		else if(count0==11'd15)	
			count0<=11'd1;		
		else if(counter==T1S)
			count0<=count0+11'd1;
	end 
	
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			count1<=11'd1;
		else if(count1==11'd15)	
			count1<=11'd1;		
		else if(count2==T2S)
			count1<=count1+11'd1;
	end 

endmodule
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 11:42:54
// Design Name: 
// Module Name: keyboard
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


module keyboard(
 input clk,
 input  rst_n,
input left,
input right,
input up,
input down,
output reg [2:0]move
    );
    always@(posedge clk or negedge rst_n)
    begin
    if(!rst_n)
    move <= 3'b000;
    else 
    if(left)
    move <= 3'b 001;
    else if (right)
    move <= 3'b 011;
    else if (up)
    move <= 3'b 010;
    else if (down)
    move <= 3'b 110;
    end
endmodule

module toVGA(

);













endmodule