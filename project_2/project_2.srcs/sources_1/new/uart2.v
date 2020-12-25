

//--------------start of module define--------------
module uart2(
    input               [3:0]               functional          ,
    input                                   clk                 ,
    input                                   rst_n               ,
    output reg          [11:0]              x1                  
    output reg          [3:0]               r                   
    input               [18:0]              rd_addr             ,
    output              [11:0]              rd_data             ,
    input                                   uart_rx             ,
    output reg          [2:0 ]              functionChoice      
                );
//--------------end of module define--------------

    reg                 [2:0]               functionChoice2     
    reg                 [5:0]               number              
    reg                                     uart_rx_done        ;
    reg                 [7:0]               data                ;
    reg                                     start_flag          ;
    reg                 [4:0]               cnt1                ;
    reg                 [18:0]              wr_addr             ;
    reg                 [11:0]              wr_data             ;
    reg                 [1:0]               re_cnt              ;
    reg                                     fir                 ;
blk_mem_gen_1 u_ip_simple_ram (
.clka(clk),
.wea(1),
.addra(wr_addr),
.dina(wr_data),
.clkb(clk),
.addrb(rd_addr),
.doutb(rd_data)
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
    begin 	
        wr_addr <= 19'b0;
        wr_data <= 12'b0;
    end
    else if(functional[0])
    begin
        wr_addr <= 19'b0;
        wr_data <= 12'b0;
    end
    else if(uart_rx_done) 
    begin
        if(data == 8'b01100001)//点
        begin
                        functionChoice                     = 3                 
                        functionChoice2                    = 3                 
            number <= 6'd5;
        end
        else if(data == 8'b01100010)//直线
        begin
                        functionChoice                     = 3                 
                        functionChoice2                    = 3                 
            number <= 6'd7;
        end
        else if(data == 8'b01100011)//矩形
        begin
                        functionChoice                     = 3                 
                        functionChoice2                    = 3                 
            number <= 6'd11;
        end
        else if(data == 8'b01100100)//圆
        begin
                        functionChoice                     = 3                 
                        functionChoice2                    = 3                 
            number <= 6'd6;
        end
        else if(data == 8'b01100101)//三角形
        begin
                        functionChoice                     = 3                 
                        functionChoice2                    = 3                 
            number <= 6'd9;
        end
        else if(data==8'b00101100)
        begin	
            wr_addr<= wr_addr+1'b1;
            wr_data<=0;
        end
        else begin
                wr_data <= wr_data * 10 + (data-8'd48);
            case(wr_addr)
            19'd0:
            begin
                x1 <= wr_data * 10 + (data-8'd48);
            end
            19'd1:
            begin
                y1<=wr_data * 10 + (data-8'd48);
            end
            19'd2:
            begin  
                case(functionChoice2)
                3'd0:
                begin
                    r <=wr_data * 10 + (data-8'd48);
                end
                3'd1:
                begin
                    x2 <=wr_data * 10 + (data-8'd48);
                end
                3'd2:
                begin
                    x2 <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                    radius <=wr_data * 10 + (data-8'd48);
                end
                3'd4:
                begin
                    x2 <=wr_data * 10 + (data-8'd48);
                end
                endcase
            end   
            19'd3:
            begin
                case(functionChoice2)
                3'd0:
                begin
                    g <=wr_data * 10 + (data-8'd48);
                end
                3'd1:
                begin
                    y2 <= wr_data * 10 + (data-8'd48);
                end
                3'd2:
                begin
                    y2 <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                    r <=wr_data * 10 + (data-8'd48);
                end
                3'd4:
                begin
                    y2 <=wr_data * 10 + (data-8'd48);
                end
                endcase
            end
            19'd4:
            begin
                case(functionChoice2)
                3'd0:
                begin
                    b <= wr_data * 10 + (data-8'd48);
                end
                3'd1:
                begin
                    r <= wr_data * 10 + (data-8'd48);
                end
                3'd2:
                begin
                    x3 <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                    g <=wr_data * 10 + (data-8'd48);
                end
                3'd4:
                begin
                    x3 <=wr_data * 10 + (data-8'd48);
                end
                endcase
            end  
            19'd5:
            begin
                case(functionChoice2)
                3'd0:
                begin
                end
                3'd1:
                begin
                    g <=wr_data * 10 + (data-8'd48);
                end
                3'd2:
                begin
                    y3 <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                    b <= wr_data * 10 + (data-8'd48);
                end
                3'd4:
                begin
                    y3 <=wr_data * 10 + (data-8'd48);
                end
                endcase  
            end
            19'd6:
            begin
                case(functionChoice2)
                3'd0:
                begin
                end
                3'd1:
                begin
                    b <=wr_data * 10 + (data-8'd48);
                end
                3'd2:
                begin
                    x4 <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                end
                3'd4:
                begin
                    r <=wr_data * 10 + (data-8'd48);
                end
                endcase   
            end
            19'd7:
            begin
                case(functionChoice2)
                3'd0:
                begin
                end
                3'd1:
                begin
                end
                3'd2:
                begin
                    y4 <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                end
                3'd4:
                begin
                    g <=wr_data * 10 + (data-8'd48);
                end 
                endcase    
            end
            19'd8:
            begin
                case(functionChoice2)
                3'd0:
                begin
                end
                3'd1:
                begin
                end
                3'd2:
                begin
                    r <= wr_data * 10 + (data-8'd48);
                end
                3'd3:
                begin
                end
                3'd4:
                begin
                    b <=wr_data * 10 + (data-8'd48);
                end 
                endcase     
            end
            19'd9:
            begin 
                g <= wr_data * 10 + (data-8'd48);
            end
            19'd10:
            begin
                b <= wr_data * 10 + (data-8'd48);
            end                                                                              
            endcase                                                                     
        end
    end
    else if(wr_addr == number) 
    begin
        if(number ==6'd5 )
        begin
            functionChoice <= 3'd0;
            wr_addr <= 19'b0;
            number <=  6'b0;
        end
        else if(number == 6'd7)
        begin
            functionChoice <= 3'd1;
            wr_addr <= 19'b0;
            number <=  6'b0;
        end
        else if(number == 6'd11)
        begin
            functionChoice <= 3'd2;
            wr_addr <= 19'b0;
            number <=  6'b0;
        end
        else if (number == 6'd6)
        begin
            functionChoice <= 3'd3;
            wr_addr <= 19'b0;
            number <=  6'b0;
        end
        else if(number == 6'd9)
        begin
            functionChoice <= 3'd4;
            wr_addr <= 19'b0;
            number <=  6'b0; 
        end
    end
end
//读信号地址
    parameter           CLK_FREQ                           = 100000000         ;
    parameter           UART_BPS                           = 1000000           ;
localparam PERIOD   = CLK_FREQ/UART_BPS;        
//接收的数据
    reg                 [7:0]               rx_data             ;
    reg                 [3:0]               cnt                 ;
    reg                                     rx1                 ;
    reg                                     rx2                 ;
    wire                                    start_bit           ;
    reg                 [15:0]              cnt0                ;
    wire                                    add_cnt0            ;
    wire                                    end_cnt0            ;
    wire                                    add_cnt1            ;
    wire                                    end_cnt1            ;
//下降沿检测 
assign  start_bit=(rx2)&(~rx1);

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)
    begin
        rx1<=1'b0;
        rx2<=1'b0; 
    end
    else if(functional[0])
    begin
        rx1<=1'b0;
        rx2<=1'b0; 
    end
    else begin
            rx1<=uart_rx;
        rx2<=rx1;
    end
end
//开始标志位,下降沿到来时将start_flag置为1

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)
    begin
        start_flag<=0;
    end
    else if(functional[0])
    begin
        start_flag<=0;
    end
    else if(start_bit) 
    begin
        start_flag<=1;
    end
    else if(end_cnt1) 
    begin
        start_flag<=0;
    end
end
                        start_flag                         = 1                 ,

always @(posedge clk or negedge rst_n)begin
    if(!rst_n | functional[0])
    begin
        cnt0 <= 0;
    end
    else if(end_cnt1) 
    begin
        cnt0 <= 0;
    end
    else if(end_cnt0) 
    begin
        cnt0 <= 0;
    end
    else if(add_cnt0)
    begin
        cnt0 <= cnt0 + 1;
    end
end

assign  add_cnt0 = start_flag;       
assign  end_cnt0 = start_flag && cnt0==PERIOD-1;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n | functional[0])
    begin
        cnt1 <= 0;
    end
    else if(end_cnt1) 
    begin
        cnt1 <= 0;
    end
    else if(add_cnt1)
    begin
        cnt1 <= cnt1 + 1;
    end
end

assign  add_cnt1 = end_cnt0 ;    
assign  end_cnt1 = (cnt0==((PERIOD-1)/2))&& (cnt1==10-1) ;  
        //数据接收

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0 | functional[0])
    begin
        rx_data<=8'd0;
    end
    else if(start_flag) 
    begin
        if(cnt0== PERIOD/2)
        begin
            case(cnt1)
            4'd1:rx_data[0]<=rx2;
            4'd2:rx_data[1]<=rx2;
            4'd3:rx_data[2]<=rx2;
            4'd4:rx_data[3]<=rx2;
            4'd5:rx_data[4]<=rx2;
            4'd6:rx_data[5]<=rx2;
            4'd7:rx_data[6]<=rx2;
            4'd8:rx_data[7]<=rx2;
            default:rx_data<=rx_data;   
                endcase
        end
        else begin
                rx_data<=rx_data;
        end
    end
    else begin
            rx_data<=8'd0;
    end   
end 
//数据接收

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0 | functional[0])
    begin
        data<=0;
    end
    else if(end_cnt1)
    begin
        data<=rx_data;
    end  
end
//接收完成标志

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0 | functional[0])
    begin
        uart_rx_done<=0;
    end
    else if(end_cnt1)
    begin
        uart_rx_done<=1'b1;
    end
    else begin
            uart_rx_done<=0;
    end
end

endmodule
