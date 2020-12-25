/*
* ̰������Ϸ
* ����ģ��
*
*/
// ��������
//��������ģ�飬ͨ���ӳٻ�ȡ������


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
/* ���а�������ʱ��ÿ100ms
* last=up��last�����up�ͺ�һ�����ڣ�
* ��up_key_last==0&&up==1����˵���������£�press���Ϊ1��
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
// �ٿز���
/*
* ��Ϸ����ģ�� ������Ŀǰ״̬���п���
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
        begin           //��Ϸ��ʼ
            if(clk_cnt <= 5) 
            begin
                clk_cnt <= clk_cnt + 1;
                restart <= 1;						
            end
            else begin
                    game_status <= START;//���뿪ʼ״̬
                clk_cnt <= 0;
                restart <= 0;
            end
        end
        START:
        begin
            if (key1_press | key2_press | key3_press | key4_press)//���������г����൱��һ����ʼ�ź�
                game_status <= PLAY;
            else 
                game_status <= START;//ѭ��
        end
        PLAY:begin
            if(hit_wall | hit_body)
                game_status <= DIE;
            else
                game_status <= PLAY;
        end					
        DIE:begin
                //��������˸
            if(clk_cnt <= 200_000_000) 
            begin
                clk_cnt <= clk_cnt + 1'b1;
                if(clk_cnt == 25_000_000)
                    die_flash <= 1'b0;
                else if(clk_cnt == 50_000_000)
                    die_flash <= 1'b1;//die_flashÿ�任һ����һ��
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
                die_flash <= 1;//��ʾ��
                clk_cnt <= 0;
                game_status <= RESTART;
            end
        end
        endcase
    end
end

endmodule
