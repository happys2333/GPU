`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/05 14:15:24
// Design Name: 
// Module Name: uart
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


module uart(
 input choose,
 input refresh,
 input clk,//系统时钟
 input clock,//
 input [11:0] h_cnt,
 input [11:0] v_cnt,
 input        rst_n  ,
 input [18:0] number, 
 input [18:0] rd_addr,
 output wire [11:0] rd_data,
 input    uart_rx,//串口信号 接Y19
 input[3:0] functional,
 output  wire wea,
 input active//控制vga信号是否输出
 );
 wire isRead;
 reg    uart_rx_done; 
 reg   [7:0] data;
 reg   start_flag;
 reg[4:0] cnt1;
 reg		[18:0] 	wr_addr; 
 reg		[11:0]	wr_data;
 reg[1:0] re_cnt;
 reg fir;
assign wea = wr_addr < number;
blk_mem_gen_0_1 u_ip_simple_ram0 (
  .clka(clk),
  .wea(wea),
  .addra(wr_addr),
  .dina(wr_data),
  .clkb(clk),
  .addrb(rd_addr),
  .doutb(rd_data)
);
reg isFirst = 1'b0;
wire [2:0 ]functionChoice;
//根据输入的数据的个数来选择执行哪个画图模块
reg [18:0] rd_addr3 = 19'b0;
wire[11:0] rd_data3;
wire [11:0]radius;//定义园的半径
wire [11:0]x1;
wire [11:0]y1;
wire [11:0]x2;
wire [11:0]y2;
wire [11:0]x3;
wire [11:0]y3;
wire [11:0]x4;
wire [11:0]y4;
wire [3:0]r,g,b;
wire [18:0] wr_addr2;
wire [11:0] wr_data2;
wire [18:0] wr_addr3;
wire [11:0] wr_data3 ;
wire [18:0] wr_addr4;
wire [11:0] wr_data4 ;
wire [18:0] wr_addr5;
wire [11:0] wr_data5;
wire [18:0] wr_addr6;
wire [11:0] wr_data6;
Triangle triangle2(choose,functionChoice,x1,y1,x2,y2,x3,y3,r,g,b,h_cnt,v_cnt,clock,rst_n,wr_addr6,wr_data6,active);
point point2(choose,functionChoice,x1,y1,r,g,b,h_cnt,v_cnt,clock,rst_n,wr_addr2,wr_data2,active);  
Line line2(choose,functionChoice,x1,y1,x2,y2,r,g,b,h_cnt,v_cnt,clock,rst_n,wr_addr3,wr_data3,active);
circular Circular2(choose,functionChoice,x1,y1,radius,r,g,b,h_cnt,v_cnt,clock,rst_n,wr_addr5,wr_data5,active);
rectangular rectangular2(choose,functionChoice,x1,y1,x2,y2,x3,y3,x4,y4,r,g,b,h_cnt,v_cnt,clock,rst_n,wr_addr4,wr_data4,active);
uart2 ip(functional,clk,rst_n,x1,x2,x3,x4,y1,y2,y3,y4,radius,r,g,b,rd_addr3,rd_data3, uart_rx,functionChoice); 
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	    fir<=0;
		wr_addr <= 19'b0;
		wr_data <= 12'b0;
		re_cnt<=2'b0;
	end
	else if(refresh)
	begin
	if(!isFirst)
	begin
	wr_addr <= 19'b0;
	wr_data <= 12'b0;
	isFirst <= 1'b1;
	end
	else if(wea)
	begin
	wr_addr <= wr_addr + 1'b1;
	wr_data <= 12'b0;
	end
	else if(!wea)
	begin
	isFirst = 1'b0;
	end
	end
	else if(!functional[0])
	begin
	if(functionChoice == 3'd0)
	begin
	 wr_addr <=  wr_addr2;
     wr_data <=  wr_data2;
	end
	else if(functionChoice == 3'd1)
	begin
	 wr_addr <= wr_addr3;
	 wr_data <= wr_data3;
	end
	else if(functionChoice == 3'd2)
	begin
	 wr_addr <= wr_addr4;
     wr_data <= wr_data4;
	end
	else if(functionChoice == 3'd3)
	begin
	 wr_addr <= wr_addr5;
	 wr_data <= wr_data5;
	end
	else if(functionChoice == 3'd4)
	begin
	 wr_addr <= wr_addr6;
	 wr_data <= wr_data6;
	end
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
    if(rst_n==1'b0 | !functional[0])begin
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
    if(rst_n==1'b0 | !functional[0])begin
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
    if(!rst_n | !functional[0])begin
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
    if(!rst_n | !functional[0])begin
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
      if(rst_n==1'b0 | !functional[0])begin
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
      if(rst_n==1'b0 | !functional[0])begin
           data<=0;
      end
      else if(end_cnt1)begin
          data<=rx_data;
      end  
  end
  
  //接收完成标志
 always  @(posedge clk or negedge rst_n)begin
     if(rst_n==1'b0 | !functional[0])begin
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
