`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 14:55:36
// Design Name: 
// Module Name: test
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


module test(
    input clk,
    input  rst_n,
    input button_up,
    input button_down,
    input button_left,
    input button_right,
    output reg led1,
    output reg led2,
    output reg led3,
    output reg led4,
    output reg error
    );
    wire [2:0] way;
    keyboard k(clk,rst_n,button_left,button_right,button_up,button_down,way);
    always@(posedge clk or negedge rst_n)
    begin 
    if(!rst_n) 
    begin
        led1 <= 0 ;
        led2 <= 0;
        led3 <= 0;
        led4 <= 0;
        error <= 0;
        end
    else 
    begin
    if(way == 3'b001)
    begin
        led1 <= 1 ;
        led2 <= 0;
        led3 <= 0;
        led4 <= 0;
        error <= 0;
        end
    else if(way == 3'b011)
    begin
        led1 <= 0 ;
        led3 <= 0;
        led4 <= 0;
        error <= 0;
        led2 <= 1;
        end
    else if(way == 3'b010)
    begin
        led1 <= 0 ;
        led3 <= 1;
        led4 <= 0;
        error <= 0;
        led2 <= 0;
        end
    else if(way == 3'b110)
    begin
        led1 <= 0 ;
        led3 <= 0;
        error <= 0;
        led2 <= 0;
        led4 <= 1;
        end
    else
    begin
        led1 <= 0 ;
        led3 <= 0;
        led4 <= 0;
        led2 <= 0;
        led4 <= 0;
        error <= 1;
        end
    end
    end
endmodule
