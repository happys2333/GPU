`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 18:09:07
// Design Name: 
// Module Name: seg_play
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
//数码管模块
//输入：时钟信号，复位信号，添加情况，游戏情况
//输出：数码管输出，及显示位数
module seg_play(
    clk,rst,add_cube,win,seg_out,led
    );
    input clk;
    input rst;
    input add_cube;
    input [1:0] win;
    output reg[6:0]seg_out;
    output reg[7:0]led;
    parameter RE = 0;
    reg tempofadd;
    reg [31:0]sorce;//总计分数
    reg [31:0] clk_s;//当前分数情况
    always @(posedge clk or negedge rst)
    begin 
        if(!rst)
            begin
                seg_out   <= 0;
                clk_s <= 0;
                led <= 0;
            end
        else if(win == RE)
            begin
                seg_out <= 0;
                clk_s <= 0;
                led <= 0;
            end
        else
            begin
				if(clk_s <= 400000)	
				begin
					clk_s <= clk_s+1;
					if(clk_s == 50000)
						begin
						led<=8'b11111110;
							case(sorce[3:0])
								4'b0000:seg_out <= 7'b100_0000;
								4'b0001:seg_out <= 7'b111_1001;
								4'b0010:seg_out <= 7'b010_0100;
								4'b0011:seg_out <= 7'b011_0000;
								4'b0100:seg_out <= 7'b001_1001;
								4'b0101:seg_out <= 7'b001_0010;
								4'b0110:seg_out <= 7'b000_0010;
								4'b0111:seg_out <= 7'b111_1000;
								4'b1000:seg_out <= 7'b000_0000;
								4'b1001:seg_out <= 7'b001_0000;
								default;
							endcase					
						end					
					else if(clk_s == 100000)
						begin		
						led <= 8'b11111101;				
							case(sorce[7:4])
						        4'b0000:seg_out <= 7'b100_0000;
                                4'b0001:seg_out <= 7'b111_1001;
                                4'b0010:seg_out <= 7'b010_0100;
                                4'b0011:seg_out <= 7'b011_0000;
                                4'b0100:seg_out <= 7'b001_1001;
                                4'b0101:seg_out <= 7'b001_0010;
                                4'b0110:seg_out <= 7'b000_0010;
                                4'b0111:seg_out <= 7'b111_1000;
                                4'b1000:seg_out <= 7'b000_0000;
                                4'b1001:seg_out <= 7'b001_0000;
								default;							
							endcase							
						end					
					else if(clk_s == 150000)
						begin
						led <= 8'b11111011;
							case(sorce[11:8])
								4'b0000:seg_out <= 7'b100_0000;
                                4'b0001:seg_out <= 7'b111_1001;
                                4'b0010:seg_out <= 7'b010_0100;
                                4'b0011:seg_out <= 7'b011_0000;
                                4'b0100:seg_out <= 7'b001_1001;
                                4'b0101:seg_out <= 7'b001_0010;
                                4'b0110:seg_out <= 7'b000_0010;
                                4'b0111:seg_out <= 7'b111_1000;
                                4'b1000:seg_out <= 7'b000_0000;
                                4'b1001:seg_out <= 7'b001_0000;
								default;					
							endcase
						end					
					else if(clk_s == 200000)
						begin
						led <= 8'b11110111;
							case(sorce[15:12])
								4'b0000:seg_out <= 7'b100_0000;
                                4'b0001:seg_out <= 7'b111_1001;
                                4'b0010:seg_out <= 7'b010_0100;
                                4'b0011:seg_out <= 7'b011_0000;
                                4'b0100:seg_out <= 7'b001_1001;
                                4'b0101:seg_out <= 7'b001_0010;
                                4'b0110:seg_out <= 7'b000_0010;
                                4'b0111:seg_out <= 7'b111_1000;
                                4'b1000:seg_out <= 7'b000_0000;
                                4'b1001:seg_out <= 7'b001_0000;
								default;					
							endcase
						end
					else if(clk_s == 250000)
                            begin        
                            led <= 8'b11101111;                
                                case(sorce[19:16])
                                    4'b0000:seg_out <= 7'b100_0000;
                                    4'b0001:seg_out <= 7'b111_1001;
                                    4'b0010:seg_out <= 7'b010_0100;
                                    4'b0011:seg_out <= 7'b011_0000;
                                    4'b0100:seg_out <= 7'b001_1001;
                                    4'b0101:seg_out <= 7'b001_0010;
                                    4'b0110:seg_out <= 7'b000_0010;
                                    4'b0111:seg_out <= 7'b111_1000;
                                    4'b1000:seg_out <= 7'b000_0000;
                                    4'b1001:seg_out <= 7'b001_0000;
                                    default;                            
                                endcase                            
                            end
					else if(clk_s == 300000)
                                begin        
                                led <= 8'b11011111;                
                                    case(sorce[23:20])
                                        4'b0000:seg_out <= 7'b100_0000;
                                        4'b0001:seg_out <= 7'b111_1001;
                                        4'b0010:seg_out <= 7'b010_0100;
                                        4'b0011:seg_out <= 7'b011_0000;
                                        4'b0100:seg_out <= 7'b001_1001;
                                        4'b0101:seg_out <= 7'b001_0010;
                                        4'b0110:seg_out <= 7'b000_0010;
                                        4'b0111:seg_out <= 7'b111_1000;
                                        4'b1000:seg_out <= 7'b000_0000;
                                        4'b1001:seg_out <= 7'b001_0000;
                                        default;                            
                                    endcase                            
                                end
					else if(clk_s == 350000)
                                    begin        
                                    led <= 8'b10111111;                
                                        case(sorce[27:24])
                                            4'b0000:seg_out <= 7'b100_0000;
                                            4'b0001:seg_out <= 7'b111_1001;
                                            4'b0010:seg_out <= 7'b010_0100;
                                            4'b0011:seg_out <= 7'b011_0000;
                                            4'b0100:seg_out <= 7'b001_1001;
                                            4'b0101:seg_out <= 7'b001_0010;
                                            4'b0110:seg_out <= 7'b000_0010;
                                            4'b0111:seg_out <= 7'b111_1000;
                                            4'b1000:seg_out <= 7'b000_0000;
                                            4'b1001:seg_out <= 7'b001_0000;
                                            default;                            
                                        endcase                            
                                    end
					else if(clk_s == 400000)
                                        begin        
                                        led <= 8'b01111111;                
                                            case(sorce[31:28])
                                                4'b0000:seg_out <= 7'b100_0000;
                                                4'b0001:seg_out <= 7'b111_1001;
                                                4'b0010:seg_out <= 7'b010_0100;
                                                4'b0011:seg_out <= 7'b011_0000;
                                                4'b0100:seg_out <= 7'b001_1001;
                                                4'b0101:seg_out <= 7'b001_0010;
                                                4'b0110:seg_out <= 7'b000_0010;
                                                4'b0111:seg_out <= 7'b111_1000;
                                                4'b1000:seg_out <= 7'b000_0000;
                                                4'b1001:seg_out <= 7'b001_0000;
                                                default;                            
                                            endcase                            
                                        end                                                                            										
				end				
				else
					clk_s <= 0;
			end		
	end
    always@(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
					sorce <= 0;
					tempofadd <= 0;					
				end
			else if( win == RE) begin
                sorce <= 0;
                tempofadd <= 0;              
            end
			else begin
				case(tempofadd)				
				    0: begin
				    //得分后进行加分，对每个数码管进行判断				
					    if(add_cube) begin
					        if(sorce[3:0] < 9)
						        sorce[3:0] <= sorce[3:0] + 1;
					        else begin
						        sorce[3:0] <= 0;
							    if(sorce[7:4] < 9)
							 	    sorce[7:4] <= sorce[7:4] + 1;
							    else begin
								    sorce[7:4] <= 0;
								    if(sorce[11:8] < 9)
									    sorce[11:8] <= sorce[11:8] + 1;
								    else begin
								        sorce[11:8] <= 0;
								        if(sorce[15:12]<9)
								        sorce[15:12]<=sorce[15:12]+1;
							                 else begin
                                            sorce[15:12] <= 0;
                                            if(sorce[19:16] < 9)
                                                sorce[19:16] <= sorce[19:16] + 1;
                                                    else begin
                                                    sorce[19:16] <= 0;
                                                    if(sorce[23:20] < 9)
                                                        sorce[23:20] <= sorce[23:20] + 1;
                                                         else begin
                                                            sorce[23:20] <= 0;
                                                            if(sorce[27:24] < 9)
                                                                sorce[27:24] <= sorce[27:24] + 1;
                                                        		    else begin
                                                                    sorce[27:24] <= 0;
                                                                    if(sorce[31:28] < 9)
                                                                        sorce[31:28] <= sorce[31:28] + 1;
                                                     end
                                                end
                                            end
                                        end
								    end
							    end
						    end
					       tempofadd <= 1;
				        end
				    end				
				    1: begin
				        if(!add_cube)
					        tempofadd <= 0;
				    end				
				endcase			
			end										
	   end								
endmodule
