`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 18:01:54
// Design Name: 
// Module Name: play_snake_game
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
// 贪吃蛇游玩模块
// 直接通过play_snake_game即可
module play_snake_game(
    input clk,//时钟
	input rst_n,//复位
    //四个按钮
	input left,
	input right,
	input up,
	input down,
    //vga输出
	output hsync,
	output vsync,
	output [11:0]color_out,
    //数码管
	output [6:0]seg_out,
	output [7:0]sel
    );
    //使用的中间变量
    wire left_key;
	wire right_key;
	wire up_key;
	wire down_key;//按键
	wire [1:0]snake;//蛇及其位置
	wire [9:0]x;
	wire [9:0]y;
	wire [5:0]apple_x;//苹果位置
	wire [4:0]apple_y;
	wire [5:0]head_x;//蛇头位置
	wire [5:0]head_y;
	
	wire add_cube;
	wire[1:0]win;//输赢
	wire hit_wall;//判断是否输了
	wire hit_body;
	wire die_flash;//死亡频闪
	wire restart;//重启游戏
	wire [6:0]cube_num;//蛇长度
	
	wire rst_n1;
	assign rst_n1 = rst_n;

    Game_Ctrl_Unit c (
        .clk(clk),
	    .rst(rst_n),
	    .key1_press(leftkey),
	    .key2_press(right_key),
	    .key3_press(up_key),
	    .key4_press(down_key),
        .win(win),
		.hit_wall(hit_wall),
		.hit_body(hit_body),
		.die_flash(die_flash),
		.restart(restart)		
	);
	
	Snake_Eatting_Apple a (
        .clk(clk),
		.rst(rst_n),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube)	
	);
	
	Snake s (
	    .clk(clk),
		.rst(rst_n),
		.left_press(leftkey),
		.right_press(right_key),
		.up_press(up_key),
		.down_press(down_key),
		.snake(snake),
		.x_pos(x),
		.y_pos(y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.game_status(win),
		.cube_num(cube_num),
		.hit_body(hit_body),
		.hit_wall(hit_wall),
		.die_flash(die_flash)
	);

	VGA_top vg (
		.clk(clk),
		.rst(rst),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
        .color_out(color_out),
		.x_pos(x),
		.y_pos(y),
		.apple_x(apple_x),
		.apple_y(apple_y)
	);
	
	Key keyboard (
		.clk(clk),
		.rst(rst_n),
		.left(left),
		.right(right),
		.up(up),
		.down(down),
		.leftkey(leftkey),
		.right_key(right_key),
		.up_key(up_key),
		.down_key(down_key)		
	);
	
	seg_play seg (
		.clk(clk),
		.rst(rst_n),	
		.add_cube(add_cube),
		.win(win),
		.seg_out(seg_out),
		.sel(sel)
	);
endmodule
