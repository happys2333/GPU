//蛇模块，本程序的主角


//--------------start of module define--------------
module snake(
    input                                   clk                 ,
    input                                   rst                 ,
    input                                   left_press          ,
    input                                   right_press         ,
    input                                   up_press            ,
    input                                   down_press          ,
    input               [9:0]               x_pos               ,
    input               [9:0]               y_pos               ,
    input                                   add                 ,
    input               [1:0]               game_status         ,
    input                                   die_flash           ,
    output reg          [1:0]               snake               ,
    output              [5:0]               head_x              ,
    output              [5:0]               head_y              ,
    output reg          [6:0]               snake_length        ,
    output reg                              hit_body            ,
    output reg                              hit_wall            
                );
//--------------end of module define--------------

//四种扫描状态
                        NONE                               = 2'b00             ;
                        HEAD                               = 2'b01             ;
                        BODY                               = 2'b10             ;
                        WALL                               = 2'b11             ;
//按键状态
                        UP                                 = 2'b00             ;
                        DOWN                               = 2'b01             ;
                        LEFT                               = 2'b10             ;
                        RIGHT                              = 2'b11             ;
//游戏状态
                        RESTART                            = 2'b00             ;
                        PLAY                               = 2'b10             ;
    reg                 [31:0]              cnt                 ;
    reg                                     change_to_left      ;
    reg                                     change_to_right     ;
    reg                                     change_to_up        ;
    reg                                     change_to_down      ;
    reg                                     add_it              ;
    reg                 [5:0]               cube_x              
    reg                 [5:0]               cube_y              
    reg                 [15:0]              is_exist            ;
    wire                [1:0]               direct              ;
    reg                 [1:0]               direct_r            ;

assign  direct = direct_r;
    reg                 [1:0]               direct_next         ;

assign  head_x = cube_x[0];

assign  head_y = cube_y[0]; 
always @(posedge clk or negedge rst) begin		
    begin
        if(!rst)
            direct_r <= RIGHT; //默认一出来向右移动
        else if(game_status == RESTART) 
            direct_r <= RIGHT;
        else
            direct_r <= direct_next;
    end

    always @(posedge clk or negedge rst) begin
        if(!rst) 
        begin
            //初始化蛇的坐标位置，初始长度3，限长16，初始化时只显示3个长度			
            cnt <= 0;
            cube_x[0] <= 10;
            cube_y[0] <= 5;
            cube_x[1] <= 9;
            cube_y[1] <= 5;
            cube_x[2] <= 8;
            cube_y[2] <= 5;
            cube_x[3] <= 0;
            cube_y[3] <= 0;
            cube_x[4] <= 0;
            cube_y[4] <= 0;
            cube_x[5] <= 0;
            cube_y[5] <= 0;
            cube_x[6] <= 0;
            cube_y[6] <= 0;
            cube_x[7] <= 0;
            cube_y[7] <= 0;
            cube_x[8] <= 0;
            cube_y[8] <= 0;
            cube_x[9] <= 0;
            cube_y[9] <= 0;					
            cube_x[10] <= 0;
            cube_y[10] <= 0;
            cube_x[11] <= 0;
            cube_y[11] <= 0;
            cube_x[12] <= 0;
            cube_y[12] <= 0;
            cube_x[13] <= 0;
            cube_y[13] <= 0;
            cube_x[14] <= 0;
            cube_y[14] <= 0;
            cube_x[15] <= 0;
            cube_y[15] <= 0;
            hit_wall <= 0;
            hit_body <= 0;
        end		
        else if(game_status == RESTART) 
        begin
            //重新开始，初始化代码同上
            cnt <= 0;
            cube_x[0] <= 10;
            cube_y[0] <= 5;
            cube_x[1] <= 9;
            cube_y[1] <= 5;
            cube_x[2] <= 8;
            cube_y[2] <= 5;
            cube_x[3] <= 0;
            cube_y[3] <= 0;
            cube_x[4] <= 0;
            cube_y[4] <= 0;
            cube_x[5] <= 0;
            cube_y[5] <= 0;
            cube_x[6] <= 0;
            cube_y[6] <= 0;
            cube_x[7] <= 0;
            cube_y[7] <= 0;
            cube_x[8] <= 0;
            cube_y[8] <= 0;
            cube_x[9] <= 0;
            cube_y[9] <= 0;
            cube_x[10] <= 0;
            cube_y[10] <= 0;
            cube_x[11] <= 0;
            cube_y[11] <= 0;
            cube_x[12] <= 0;
            cube_y[12] <= 0;
            cube_x[13] <= 0;
            cube_y[13] <= 0;
            cube_x[14] <= 0;
            cube_y[14] <= 0;
            cube_x[15] <= 0;
            cube_y[15] <= 0;
            hit_wall <= 0;
            hit_body <= 0;                              
        end
        else begin
                cnt <= cnt + 1;
            if(cnt == 12_500_000) 
                        12500000                           = 0                 
            cnt <= 0;
            if(game_status == PLAY) 
            begin
                if((direct == UP && cube_y[0] == 1)|(direct == DOWN && cube_y[0] == 28)|(direct == LEFT && cube_x[0] == 1)|(direct == RIGHT && cube_x[0] == 38))
                    hit_wall <= 1; //撞到墙壁，hit_wall置1
                else if((cube_y[0] == cube_y[1] && cube_x[0] == cube_x[1] && is_exist[1] == 1)|
                    (cube_y[0] == cube_y[2] && cube_x[0] == cube_x[2] && is_exist[2] == 1)|
                (cube_y[0] == cube_y[3] && cube_x[0] == cube_x[3] && is_exist[3] == 1)|
                (cube_y[0] == cube_y[4] && cube_x[0] == cube_x[4] && is_exist[4] == 1)|
                (cube_y[0] == cube_y[5] && cube_x[0] == cube_x[5] && is_exist[5] == 1)|
                (cube_y[0] == cube_y[6] && cube_x[0] == cube_x[6] && is_exist[6] == 1)|
                (cube_y[0] == cube_y[7] && cube_x[0] == cube_x[7] && is_exist[7] == 1)|
                (cube_y[0] == cube_y[8] && cube_x[0] == cube_x[8] && is_exist[8] == 1)|
                (cube_y[0] == cube_y[9] && cube_x[0] == cube_x[9] && is_exist[9] == 1)|
                (cube_y[0] == cube_y[10] && cube_x[0] == cube_x[10] && is_exist[10] == 1)|
                (cube_y[0] == cube_y[11] && cube_x[0] == cube_x[11] && is_exist[11] == 1)|
                (cube_y[0] == cube_y[12] && cube_x[0] == cube_x[12] && is_exist[12] == 1)|
                (cube_y[0] == cube_y[13] && cube_x[0] == cube_x[13] && is_exist[13] == 1)|
                (cube_y[0] == cube_y[14] && cube_x[0] == cube_x[14] && is_exist[14] == 1)|
                (cube_y[0] == cube_y[15] && cube_x[0] == cube_x[15] && is_exist[15] == 1))
                hit_body <= 1;//碰到身体，hit_wall置1
                else begin
                        //身体的每个小节移动到前一个小节的位置，使得蛇整体向前移动
                    cube_x[1] <= cube_x[0];
                    cube_y[1] <= cube_y[0];
                    cube_x[2] <= cube_x[1];
                    cube_y[2] <= cube_y[1];
                    cube_x[3] <= cube_x[2];
                    cube_y[3] <= cube_y[2];
                    cube_x[4] <= cube_x[3];
                    cube_y[4] <= cube_y[3];
                    cube_x[5] <= cube_x[4];
                    cube_y[5] <= cube_y[4];
                    cube_x[6] <= cube_x[5];
                    cube_y[6] <= cube_y[5];
                    cube_x[7] <= cube_x[6];
                    cube_y[7] <= cube_y[6];
                    cube_x[8] <= cube_x[7];
                    cube_y[8] <= cube_y[7];
                    cube_x[9] <= cube_x[8];
                    cube_y[9] <= cube_y[8];
                    cube_x[10] <= cube_x[9];
                    cube_y[10] <= cube_y[9];
                    cube_x[11] <= cube_x[10];
                    cube_y[11] <= cube_y[10];
                    cube_x[12] <= cube_x[11];
                    cube_y[12] <= cube_y[11];
                    cube_x[13] <= cube_x[12];
                    cube_y[13] <= cube_y[12];
                    cube_x[14] <= cube_x[13];
                    cube_y[14] <= cube_y[13];
                    cube_x[15] <= cube_x[14];
                    cube_y[15] <= cube_y[14];
                    //移动方向判断
                    case(direct)							
                    UP: begin
                        if(cube_y[0] == 1)
                            hit_wall <= 1;//撞到墙，hit_wall置1
                        else
                            cube_y[0] <= cube_y[0]-1;
                    end
                    DOWN: begin
                        if(cube_y[0] == 28)
                            hit_wall <= 1;//撞到墙，hit_wall置1
                        else
                            cube_y[0] <= cube_y[0] + 1;
                    end
                    LEFT: begin
                        if(cube_x[0] == 1)
                            hit_wall <= 1;//撞到墙，hit_wall置1
                        else
                            cube_x[0] <= cube_x[0] - 1;											
                    end
                    RIGHT: begin
                        if(cube_x[0] == 38)
                            hit_wall <= 1;//撞到墙，hit_wall置1
                        else
                            cube_x[0] <= cube_x[0] + 1;
                    end
                    endcase	
                end
            end
        end
    end
end
//给四个按键赋值

always @(posedge clk) begin     
    begin
        if(left_press == 1)
            change_to_left <= 1;
        else if(right_press == 1)
            change_to_right <= 1;
        else if(up_press == 1)
            change_to_up <= 1;
        else if(down_press == 1)
            change_to_down <= 1;
        else begin
                change_to_left <= 0;
            change_to_right <= 0;
            change_to_up <= 0;
            change_to_down <= 0;
        end
    end
    //根据当前运动状态和算按下键位判断下一步运动情况

    always @(*) begin   
        direct_next = direct;
        //由于只有与当前移动方向垂直才能改变方向，如当前向上走，只有向左或向右才有效果，据此进行判断并对direct_next赋值
        case(direct)	
        UP: begin   
            if(change_to_left)
                direct_next = LEFT;
            else if(change_to_right)
                direct_next = RIGHT;
            else
                direct_next = UP;			
        end		
        DOWN: begin
            if(change_to_left)
                direct_next = LEFT;
            else if(change_to_right)
                direct_next = RIGHT;
            else
                direct_next = DOWN;			
        end		
        LEFT: begin
            if(change_to_up)
                direct_next = UP;
            else if(change_to_down)
                direct_next = DOWN;
            else
                direct_next = LEFT;			
        end
        RIGHT: begin
            if(change_to_up)
                direct_next = UP;
            else if(change_to_down)
                direct_next = DOWN;
            else
                direct_next = RIGHT;
        end	
        endcase
    end
    //若吃到苹果则add==1，显示体长增加一位，"is_exixt[snake_length]<=1",让第snake_length位显示出来

    always @(posedge clk or negedge rst) begin
        if(!rst) 
        begin
                        is_exist                           = 0000              
            is_exist <= 16'd7;
            snake_length <= 3;
            add_it <= 0;
        end
        //重新开始则重新初始化  
        else if (game_status == RESTART) 
        begin
            is_exist <= 16'd7;
            snake_length <= 3;
            add_it <= 0;
        end
        else begin			
                case(add_it) //判断蛇头与苹果坐标是否重合
            0:begin
                if(add) 
                begin
                        add                                = 1                 
                    snake_length <= snake_length + 1;
                    is_exist[snake_length] <= 1;
                    add_it <= 1;
                end						
            end
            1:begin
                if(!add)
                    add_it <= 0;				
            end
            endcase
        end
    end

    always @(x_pos or y_pos ) begin				
        if(x_pos >= 0 && x_pos < 640 && y_pos >= 0 && y_pos < 480) 
        begin
            if(x_pos[9:4] == 0 | y_pos[9:4] == 0 | x_pos[9:4] == 39 | y_pos[9:4] == 29)
                snake = WALL;//扫描墙
            else if(x_pos[9:4] == cube_x[0] && y_pos[9:4] == cube_y[0] && is_exist[0] == 1) 
                snake = (die_flash == 1) ? HEAD : NONE;//扫描头
            else if
                ((x_pos[9:4] == cube_x[1] && y_pos[9:4] == cube_y[1] && is_exist[1] == 1)|
            (x_pos[9:4] == cube_x[2] && y_pos[9:4] == cube_y[2] && is_exist[2] == 1)|
            (x_pos[9:4] == cube_x[3] && y_pos[9:4] == cube_y[3] && is_exist[3] == 1)|
            (x_pos[9:4] == cube_x[4] && y_pos[9:4] == cube_y[4] && is_exist[4] == 1)|
            (x_pos[9:4] == cube_x[5] && y_pos[9:4] == cube_y[5] && is_exist[5] == 1)|
            (x_pos[9:4] == cube_x[6] && y_pos[9:4] == cube_y[6] && is_exist[6] == 1)|
            (x_pos[9:4] == cube_x[7] && y_pos[9:4] == cube_y[7] && is_exist[7] == 1)|
            (x_pos[9:4] == cube_x[8] && y_pos[9:4] == cube_y[8] && is_exist[8] == 1)|
            (x_pos[9:4] == cube_x[9] && y_pos[9:4] == cube_y[9] && is_exist[9] == 1)|
            (x_pos[9:4] == cube_x[10] && y_pos[9:4] == cube_y[10] && is_exist[10] == 1)|
            (x_pos[9:4] == cube_x[11] && y_pos[9:4] == cube_y[11] && is_exist[11] == 1)|
            (x_pos[9:4] == cube_x[12] && y_pos[9:4] == cube_y[12] && is_exist[12] == 1)|
            (x_pos[9:4] == cube_x[13] && y_pos[9:4] == cube_y[13] && is_exist[13] == 1)|
            (x_pos[9:4] == cube_x[14] && y_pos[9:4] == cube_y[14] && is_exist[14] == 1)|
            (x_pos[9:4] == cube_x[15] && y_pos[9:4] == cube_y[15] && is_exist[15] == 1))
            snake = (die_flash == 1) ? BODY : NONE;//扫描身体
            else snake = NONE;
        end
    end

endmodule
