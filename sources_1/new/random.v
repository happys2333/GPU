`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: sustech
// Engineer: happys
// 
// Create Date: 2020/12/09 11:16:04
// Design Name: SnakeGame
// Module Name: snake
// Project Name: VGA
//////////////////////////////////////////////////////////////////////////////////
module createApple(
input clk,
input rst_n,
output reg[9:0] x,
output reg[9:0] y
);

endmodule
module random(
    input clk,
    input rst_n,
    output reg[8:0] rand
);
always@(posedge clk or negedge rst_n)//保证程序可以实现异步逻辑
    if(!rst_n)  rand <= 9'd132;
else
begin
            rand[0] <= rand[8];
            rand[1] <= rand[0];
            rand[2] <= rand[1];
            rand[3] <= rand[2];
            rand[4] <= rand[3]^rand[8];
            rand[5] <= rand[4]^rand[8];
            rand[6] <= rand[5]^rand[8];
            rand[7] <= rand[6];
            rand[8] <= rand[7];
end
endmodule
