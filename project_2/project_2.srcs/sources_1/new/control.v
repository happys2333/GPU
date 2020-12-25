/*
* 贪吃蛇游戏
* 控制模块
*
*/
// 按键部分
//按键控制模块，通过延迟获取来防抖


//--------------start of module define--------------
module Keyboard(
    input                                   clk                 ,
    input                                   rst                 ,
    input                                   left                ,
    input                                   right               ,
    input                                   up                  ,
    input                                   down                ,
    output reg                              left_out            ,
    output reg                              right_out           ,
    output reg                              up_out              ,
    output reg                              down_out            
                );
//--------------end of module define--------------

    reg                 [31:0]              clk_con             ;
    reg                                     left_key_last       ;
    reg                                     right_key_last      ;
    reg                                     up_key_last         ;
    reg                                     down_key_last       ;
/* 当有按键按下时，每100ms
* last=up，last输出比up滞后一个周期，
* 若up_key_last==0&&up==1，则说明按键按下，press输出为1。
*/

always@(posedge clk or negedge rst) begin
    if(!rst) 
    begin
        clk_con <= 0;
        left_out <= 0;
        right_out <= 0;
        up_out <= 0;
        down_out <= 0;
        left_key_last <= 0;
        right_key_last <= 0;
        up_key_last <= 0;
        down_key_last <= 0;					
    end	
    else begin
        if(clk_con == 5_0000) 
        begin
            clk_con <= 0;
            left_key_last <= left;
            right_key_last <= right;
            up_key_last <= up;
            down_key_last <= down;
            if(left_key_last == 0 && left == 1) 
                left_out <= 1;
            if(right_key_last == 0 && right == 1)
                right_out <= 1;
            if(up_key_last == 0 && up == 1)
                up_out <= 1;
            if(down_key_last == 0 && down == 1)
                down_out <= 1;
        end						
        else begin
                clk_con <= clk_con + 1;
            left_out <= 0;
            right_out <= 0;
            up_out <= 0;
            down_out <= 0;
        end
    end	
end				
endmodule
// 操控部分
/*
* 游戏控制模块 将根据目前状态进行控制
*/

module Game_Control
(
    input                                   clk                 ,
    input                                   rst                 ,
    input                                   key1_press          ,
    input                                   key2_press          ,
    input                                   key3_press          ,
    input                                   key4_press          ,
    output reg          [1:0]               game_status         ,
    input                                   hit_wall            ,
    input                                   hit_body            ,
    output reg                              die_flash           ,
    output reg                              restart             
);
                        RESTART                            = 2'b00             ;
                        START                              = 2'b01             ;
                        DIE                                = 2'b11             ;
                        PLAY                               = 2'b10             ;
    reg                 [31:0]              clk_cnt             ;

always@(posedge clk or negedge rst)
begin
    if(!rst) 
    begin
        game_status <= START;
        clk_cnt <= 0;
        die_flash <= 1;
        restart <= 0;
    end
    else 
    begin
        case(game_status)			
        RESTART:
        begin           //游戏开始
            if(clk_cnt <= 5) 
            begin
                clk_cnt <= clk_cnt + 1;
                restart <= 1;						
            end
            else begin
                    game_status <= START;//进入开始状态
                clk_cnt <= 0;
                restart <= 0;
            end
        end
        START:
        begin
            if (key1_press | key2_press | key3_press | key4_press)//按键后运行程序，相当于一个开始信号
                game_status <= PLAY;
            else 
                game_status <= START;//循环
        end
        PLAY:begin
            if(hit_wall | hit_body)
                game_status <= DIE;
            else
                game_status <= PLAY;
        end					
        DIE:begin
                //死亡后闪烁
            if(clk_cnt <= 200_000_000) 
            begin
                clk_cnt <= clk_cnt + 1'b1;
                if(clk_cnt == 25_000_000)
                    die_flash <= 1'b0;
                else if(clk_cnt == 50_000_000)
                    die_flash <= 1'b1;//die_flash每变换一次闪一次
                else if(clk_cnt == 75_000_000)
                    die_flash <= 1'b0;
                else if(clk_cnt == 100_000_000)
                    die_flash <= 1'b1;
                else if(clk_cnt == 125_000_000)
                    die_flash <= 1'b0;
                else if(clk_cnt == 150_000_000)
                    die_flash <= 1'b1;
            end
            else
            begin
                die_flash <= 1;//显示蛇
                clk_cnt <= 0;
                game_status <= RESTART;
            end
        end
        endcase
    end
end

endmodule
