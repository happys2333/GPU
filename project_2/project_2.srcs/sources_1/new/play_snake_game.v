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


//--------------start of module define--------------
module play_snake_game(
    input                                   clk                 ,
    input                                   rst                 ,
                //四个按钮
    input               [3:0]               button              ,
                //vga输出
    output                                  hsync               ,
    output                                  vsync               ,
    output              [11:0]              color_out           ,
                //数码管
    output              [6:0]               seg_out             ,
    output              [7:0]               led                 
                );
//--------------end of module define--------------

//使用的中间变量
    wire                                    left_key            ;
    wire                                    right_key           ;
    wire                                    up_key              ;
    wire                                    down_key            ;
    wire                [1:0]               snake               ;
    wire                [9:0]               x                   ;
    wire                [9:0]               y                   ;
    wire                [5:0]               apple_x             ;
    wire                [4:0]               apple_y             ;
    wire                [5:0]               head_x              ;
    wire                [5:0]               head_y              ;
    wire                                    add                 ;
    wire                [1:0]               win                 ;
    wire                                    hit_wall            ;
    wire                                    hit_body            ;
    wire                                    die_flash           ;
    wire                                    restart             ;
    wire                [6:0]               snake_length        ;
    wire                                    rst_n               ;

assign  rst_n = ~rst;
        Game_Control c (
        .clk(clk),
        .rst(rst_n),
        .key1_press(left_key),
        .key2_press(right_key),
        .key3_press(up_key),
        .key4_press(down_key),
        .game_status(win),
        .hit_wall(hit_wall),
        .hit_body(hit_body),
        .die_flash(die_flash),
        .restart(restart)		
);
apple a (
.clk(clk),
.rst(rst_n),
.apple_x(apple_x),
.apple_y(apple_y),
.head_x(head_x),
.head_y(head_y),
.add(add)	
);
snake s (
.clk(clk),
.rst(rst_n),
.left_press(left_key),
.right_press(right_key),
.up_press(up_key),
.down_press(down_key),
.snake(snake),
.x_pos(x),
.y_pos(y),
.head_x(head_x),
.head_y(head_y),
.add(add),
.game_status(win),
.snake_length(snake_length),
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
.snake_x(x),
.snake_y(y),
.apple_x(apple_x),
.apple_y(apple_y)
);
Keyboard keyboard (
.clk(clk),
.rst(rst_n),
.left(button[0]),
.right(button[1]),
.up(button[2]),
.down(button[3]),
.left_out(left_key),
.right_out(right_key),
.up_out(up_key),
.down_out(down_key)		
);
seg_play seg (
.clk(clk),
.rst(rst_n),	
.add(add),
.win(win),
.seg_out(seg_out),
.led(led)
);

endmodule
