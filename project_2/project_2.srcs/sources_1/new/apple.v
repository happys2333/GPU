//对蛇吃到苹果的情况判断


//--------------start of module define--------------
module apple(
                clk,rst,head_x,head_y,apple_x,apple_y,add
                );
//--------------end of module define--------------
    input                                   clk                 ;
    input                                   rst                 ;
    input               [5:0]               head_x              ;
    input               [5:0]               head_y              ;
    output reg          [5:0]               apple_x             ;
    output reg          [4:0]               apple_y             ;
    output reg                              add                 ;
    reg                 [31:0]              clk_cnt             ;
    reg                 [10:0]              random_num          ;

always@(posedge clk)
random_num <= random_num + 999;  //用加法产生随机数，随机数高5位为苹果X坐标 低5位为苹果Y坐标

always@(posedge clk or negedge rst) begin
    begin
        if(!rst) 
        begin
            //初始化苹果位置
            clk_cnt <= 0;
            apple_x <= 24;
            apple_y <= 10;
            add <= 0;
        end
        else begin
                clk_cnt <= clk_cnt+1;
            if(clk_cnt == 250_000) 
            begin
                clk_cnt <= 0;
                if(apple_x == head_x && apple_y == head_y) 
                begin
                    add <= 1;
                    apple_x <= (random_num[10:5] > 38) ? (random_num[10:5] - 25) : (random_num[10:5] == 0) ? 1 : random_num[10:5];
                    apple_y <= (random_num[4:0] > 28) ? (random_num[4:0] - 3) : (random_num[4:0] == 0) ? 1:random_num[4:0];
                end   //判断随机数是否超出频幕坐标范围 将随机数转换为下个苹果的X Y坐标
                else
                    add <= 0;
            end
        end
    end
end

endmodule
