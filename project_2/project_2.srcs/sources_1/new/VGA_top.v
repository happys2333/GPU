`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 19:29:09
// Design Name: 
// Module Name: VGA_top
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
//vga时钟
module clk_use(
	input clk,
	input rst,
	output reg clk_n
	);
    reg tmp;
    always @(posedge tmp or posedge rst) 
    begin
       if (rst)
        clk_n <= 0;
      else
        clk_n <= ~clk_n;
    end
    always @(posedge clk or posedge rst) begin
        if (rst)
            tmp <= 0;
        else
            tmp <= ~tmp;
    end
endmodule
//VGA核心模块，获取当前扫描到的点需要输出什么颜色
module VGA_use(
    clk,rst,snake,apple_x,apple_y,snake_x,snake_y,hsync,vsync,
    color_out
);
    input clk;
    input rst;
    input [1:0]snake;
    input [5:0]apple_x;
    input [4:0]apple_y;
    output reg [9:0] snake_x;
    output reg [9:0] snake_y;
    output reg hsync;
    output reg vsync;
    output reg [11:0]color_out;
    
    reg [19:0]clk_cnt;
	reg [9:0]line_cnt;
	reg clk_25M;
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam head_c = 12'b000011110000;//蛇头的颜色
	localparam body_c = 12'b000011111111;//蛇身颜色
	
	reg [3:0]lox;
	reg [3:0]loy;
		
	always@(posedge clk or negedge rst) begin
		if(rst) begin
			clk_cnt <= 0;
			line_cnt <= 0;
			hsync <= 1;
			vsync <= 1;
		end
		else begin
		    snake_x <= clk_cnt - 144;
			snake_y <= line_cnt - 33;	
			if(clk_cnt == 0) begin
			    hsync <= 0;
				clk_cnt <= clk_cnt + 1;
            end
			else if(clk_cnt == 96) begin
				hsync <= 1;
				clk_cnt <= clk_cnt + 1;
            end
			else if(clk_cnt == 799) begin
				clk_cnt <= 0;
				line_cnt <= line_cnt + 1;
			end
			else clk_cnt <= clk_cnt + 1;
			
			if(line_cnt == 0) begin
				vsync <= 0;
            end
			else if(line_cnt == 2) begin
				vsync <= 1;
			end
			else if(line_cnt == 521) begin
				line_cnt <= 0;
				vsync <= 0;
			end
			
			if(snake_x >= 0 && snake_x < 640 && snake_y >= 0 && snake_y < 480) begin
			    lox = snake_x[3:0];
				loy = snake_y[3:0];
				
				//根据当前扫描到的点找到应该输出什么颜色			
				if(snake_x[9:4] == apple_x && snake_y[9:4] == apple_y)//扫描是否为苹果
					case({loy,lox})
						8'b00000000:color_out = 12'b000000000000;
						default:color_out = 12'b000000001111;//苹果颜色
					endcase						
				else if(snake == NONE)
					color_out = 12'b0000_0000_0000;
				else if(snake == WALL)
					color_out = 3'b101;
				else if(snake == HEAD|snake == BODY) begin   
					case({lox,loy})
						8'b0000_0000:color_out = 12'b0000_0000_0000;
						default:color_out = (snake == HEAD) ?  head_c : body_c;
					endcase
				end
			end
		    else
			    color_out = 12'b0000_0000_0000;
		end
    end
endmodule

module VGA_top(
	input clk,
    input rst,
    input [1:0]snake,
    input [5:0]apple_x,
    input [4:0]apple_y,
    output [9:0]snake_x,
    output [9:0]snake_y,    
    output hsync,
    output vsync,
    output [11:0] color_out
    );
    
    wire clk_n;
    
    clk_use c(
        .clk(clk),
        .rst(rst),
        .clk_n(clk_n)
    );


    VGA_use V
    (
    	.clk(clk_n),
		.rst(rst),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
        .color_out(color_out),
		.snake_x(snake_x),
		.snake_y(snake_y),
		.apple_x(apple_x),
		.apple_y(apple_y)
	);
endmodule
