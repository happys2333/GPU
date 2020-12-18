module uart2(
 input[1:0] functional,
 input            clk  ,
 input            rst_n ,
 input [18:0]   rd_addr,
 output [11:0]  rd_data,
 input       uart_rx,//串口信号 接Y19
 output [1:0 ]functionChoice//判断功能的执行模块
 );
 reg[5:0] number = 8'b10;
 reg    uart_rx_done; 
 reg   [7:0] data;
 reg   start_flag;
 reg[4:0] cnt1;
 reg		[18:0] 	wr_addr; 
 reg		[11:0]	wr_data;
 reg[1:0] re_cnt;
 reg fir;

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
	if(!rst_n) begin
        begin  	
		wr_addr <= 19'b0;
		wr_data <= 12'b0;
		end
	end
	else if(functional[0])
	begin
	wr_addr <= 19'b0;
    wr_data <= 12'b0;
	end
	else if(uart_rx_done) begin
	if(data==8'b00101100)begin
        wr_addr<= wr_addr+1'b1;
        wr_data<=0;
        end
        else begin
            wr_data <= wr_data * 10 + (data-8'd48);
        end
	end
	else if(wr_addr == number) begin
		wr_addr <= 19'b0;
		wr_data <= 12'b0;
	end
end

//读信号地址

parameter  CLK_FREQ = 100000000; //时钟频率
parameter  UART_BPS = 115200;      //波特率
localparam PERIOD   = CLK_FREQ/UART_BPS;        


//接收的数据
reg [7:0] rx_data; 
reg[3:0] cnt;
 
reg       rx1,rx2;
wire      start_bit;

reg   [15:0]   cnt0;
wire           add_cnt0;
wire           end_cnt0;
 

wire           add_cnt1;
wire           end_cnt1;

 //下降沿检测 
assign  start_bit=(rx2)&(~rx1);

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
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
    if(rst_n==1'b0)begin
        start_flag<=0;
    end
    else if(functional[0])
     begin
      start_flag<=0;
     end
    else if(start_bit) begin
        start_flag<=1;
    end
    else if(end_cnt1) begin
        start_flag<=0;
    end
end

 //start_flag = 1,即传输过程中，cnt0每个时钟周期++，到一个周期后，即1个数据传来后，cnt1++
always @(posedge clk or negedge rst_n)begin
    if(!rst_n | functional[0])begin
        cnt0 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt0 <= 0;
	 end
	 else if(end_cnt0) begin
	     cnt0 <= 0;
	 end
    else if(add_cnt0)begin
        cnt0 <= cnt0 + 1;
    end
end
assign add_cnt0 = start_flag;       
assign end_cnt0 = start_flag && cnt0==PERIOD-1;
 
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n | functional[0])begin
        cnt1 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt1 <= 0;
	 end
    else if(add_cnt1)begin
        cnt1 <= cnt1 + 1;
    end
end

assign add_cnt1 = end_cnt0 ;    
assign end_cnt1 = (cnt0==((PERIOD-1)/2))&& (cnt1==10-1) ;  
 
//数据接收
always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0 | functional[0])begin
         rx_data<=8'd0;
      end
      else if(start_flag) begin
		  if(cnt0== PERIOD/2)begin
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
      if(rst_n==1'b0 | functional[0])begin
           data<=0;
      end
      else if(end_cnt1)begin
          data<=rx_data;
      end  
  end
  
  //接收完成标志
 always  @(posedge clk or negedge rst_n)begin
     if(rst_n==1'b0 | functional[0])begin
         uart_rx_done<=0;
     end
     else if(end_cnt1)begin
         uart_rx_done<=1'b1;
     end
     else begin
        uart_rx_done<=0;
     end
 end
endmodule
