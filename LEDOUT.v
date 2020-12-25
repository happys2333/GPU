`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 19:20:24
// Design Name: 
// Module Name: LEDOUT
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


module LEDOUT(
  input clk,
  input rst,
  input open,
  output reg[6:0] seg_out,
  output reg[7:0] led
    );
    localparam zero = 7'b100_0000;
    localparam eight = 7'b000_0000;
    localparam six = 7'b000_0010;
    localparam four = 7'b001_1001;
    reg [31:0] clk_s;
    always @(posedge clk or negedge rst)
    begin
      if(!rst)
       begin 
          seg_out <= 0;
          led <= 0;
       end 
       else
       begin
            if(clk_s <= 400000)
            begin
            clk_s <= clk_s+1;
                if(clk_s == 50000)
                    begin
                    led <= 8'b1111_1110;
                    seg_out <= zero;
                    end
                else if(clk_s == 100000)
                    begin
                    led <= 8'b1111_1101;
                    if(open)
                    seg_out <= zero;
                    else seg_out <= eight;
                    end
                else if(clk_s == 150000)
                    begin
                    led <= 8'b1111_1011;
                    if (open)
                    seg_out <= six;
                    else seg_out <= four;
                    end
                else if(clk_s == 200000)
                    begin
                    led <= 8'b1111_1111; 
                    end
                else if(clk_s == 250000)
                    begin
                    led <= 8'b1110_1111;
                    seg_out <= zero;
                    end 
                else if(clk_s == 300000)
                    begin
                    led <= 8'b1101_1111;
                    if(open) seg_out <= zero;
                    else seg_out <= four;
                    end
                else if(clk_s == 350000)
                begin
                    led <= 8'b1011_1111;
                    if(open) seg_out <= eight;
                    else seg_out <= six;
                end
            end
            else
            clk_s <=0;
        end    
    end
endmodule
