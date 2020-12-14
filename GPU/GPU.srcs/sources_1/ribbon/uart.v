module uart(
 input            clk      ,//输入板载时钟信号
 input            rst_n    ,//系统复位信号
 input [18:0]     number   , //所需参数个数
 input wire[18:0] rd_addr  ,//ram数据读取地址
 output wire [11:0] rd_data,//ram数据输出
 input    uart_rx          ,//串口输入信号 接Y19
 output  wire wea           //ram读写标志，1表示写，0表示读
 );
 reg    uart_rx_done;       //单位数据传输完成标志
 reg   [7:0] data;          //每次从串口读入的8位数据  
 reg   start_flag;          //串口数据接收开始标志
 reg   [4:0] cnt1;          //已接收数据个数记录
 reg   [18:0] 	wr_addr;    //ram写入数据地址
 reg   [11:0]	wr_data;    //ram写入数据
	
 reg[1:0] re_cnt;
 reg fir;
	
assign wea = wr_addr < number;//所需参数全部读入前，均为写模式

blk_mem_gen_0 u_ip_simple_ram (
  .clka(clk),
  .wea(wea),
  .addra(wr_addr),
  .dina(wr_data),
  .clkb(clk),
  .addrb(rd_addr),
  .doutb(rd_data)
);
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	    fir<=0;
		wr_addr <= 19'b0;
		wr_data <= 12'b0;
		re_cnt<=2'b0;
	end
	else if(uart_rx_done)begin
	if(re_cnt==2'd0)begin
	if(fir)
    wr_addr<=wr_addr+1'b1;
    fir<=1'b1; 
    end
    if(re_cnt==2'd2)begin
    re_cnt <= 0; 
    end
    else begin
        re_cnt <= re_cnt+1'b1;
    end
    case(re_cnt)
	2'd0: wr_data[11:8]<= data < 8'd64 ? data-8'd48:data-8'd55;
	2'd1: wr_data[7:4]<= data < 8'd64 ? data-8'd48:data-8'd55;
	2'd2: wr_data[3:0]<= data < 8'd64 ? data-8'd48:data-8'd55;
	endcase
	
	end
end
//读信号地址

parameter  CLK_FREQ = 100000000; //时钟频率
parameter  UART_BPS = 1000000;      //波特率
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
    else if(start_bit) begin
        start_flag<=1;
    end
    else if(end_cnt1) begin
        start_flag<=0;
    end
end

 //start_flag = 1,即传输过程中，cnt0每个时钟周期++，到一个周期后，即1个数据传来后，cnt1++
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
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
    if(!rst_n)begin
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
      if(rst_n==1'b0)begin
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
      if(rst_n==1'b0)begin
           data<=0;
      end
      else if(end_cnt1)begin
          data<=rx_data;
      end  
  end
  
  //接收完成标志
 always  @(posedge clk or negedge rst_n)begin
     if(rst_n==1'b0)begin
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
