`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// VGA verilog template
// Author:  Da Cheng
//////////////////////////////////////////////////////////////////////////////////
module vga_demo(board_clk, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, reset, Done,MatrixCopy,St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar);//
	input board_clk, MatrixCopy, reset, Done; 
	output St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar;
	output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;
	
	reg vga_r, vga_g, vga_b;
	reg [3:0] i;
	reg [10:0] positionX, positionY;
	reg R, B;
	
    wire [11:0] Matrix[15:0];
	wire [191:0] MatrixCopy;   
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;
	wire clk;
	
	assign Matrix[0] = MatrixCopy[11:0];
	assign Matrix[1] = MatrixCopy[23:12];
	assign Matrix[2] = MatrixCopy[35:24];
	assign Matrix[3] = MatrixCopy[47:36];
	assign Matrix[4] = MatrixCopy[59:48];
	assign Matrix[5] = MatrixCopy[71:60];
	assign Matrix[6] = MatrixCopy[83:72];
	assign Matrix[7] = MatrixCopy[95:84];
	assign Matrix[8] = MatrixCopy[107:96];
	assign Matrix[9] = MatrixCopy[119:108];
	assign Matrix[10] = MatrixCopy[131:120];
	assign Matrix[11] = MatrixCopy[143:132];
	assign Matrix[12] = MatrixCopy[155:144];
	assign Matrix[13] = MatrixCopy[167:156];
	assign Matrix[14] = MatrixCopy[179:168];
	assign Matrix[15] = MatrixCopy[191:180];
	
	assign 	{St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
	
	//////////////////////////////////////////////////////////////////////////////////////////

	
	reg [27:0]	DIV_CLK;
	always @ (posedge board_clk, posedge reset)  
	begin : CLOCK_DIVIDER
      if (reset)
			DIV_CLK <= 0;
      else
			DIV_CLK <= DIV_CLK + 1'b1;
	end	

	assign	clk = DIV_CLK[1];
	
	
	hvsync_generator syncgen(.clk(clk), .reset(reset),.vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), 
	.inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));
	
					
	
	/////////////////////////////////////////////////////////////////
	///////////////		VGA control starts here		/////////////////
	/////////////////////////////////////////////////////////////////
	
	always @(CounterX, CounterY, Matrix, Done, reset)
		begin
			if (reset)
				B = 0;
				
			else if (Done)
				B = (CounterX>=0 && CounterX<=480 && CounterY>=0 && CounterY<=480);
			else 
				begin
		
					if ((CounterX <120) && (CounterY < 120))
					begin
						positionX = 0;
						positionY = 0;
						i = 0;
					end
					
					if ((CounterX <240) && (CounterX >120) && (CounterY < 120)) 
					begin
						positionX = 120;
						positionY = 0;
						i = 1;
					end
					
					if ((CounterX <360) && (CounterX >240) && (CounterY < 120)) 
					begin
						positionX = 240;
						positionY = 0;
						i = 2;
					end
					
					if ((CounterX <480) && (CounterX >360) && (CounterY < 120) )
					begin
						positionX = 360;
						positionY = 0;
						i = 3 ;
					end
					//Second ROW
					if ((CounterX <120) && (CounterY >120) && (CounterY <240)) 
					begin
						positionX = 0;
						positionY = 120;
						i = 4;
					end
					
					if ((CounterX <240) && (CounterX >120) && (CounterY >120) && (CounterY <240)) 
					begin
						positionX = 120;
						positionY = 120;
						i = 5;
					end
					
					if ((CounterX <360) && (CounterX >240) && (CounterY >120) && (CounterY <240)) 
					begin
						positionX = 240;
						positionY = 120;
						i = 6;
					end
					
					if ((CounterX <480) && (CounterX >360) && (CounterY >120) && (CounterY <240))
					begin
						positionX = 360;
						positionY = 120;
						i = 7;
					end
				
					//Third Row
					if ((CounterX <120) && (CounterY >240) && (CounterY <360)) 
					begin
						positionX = 0;
						positionY = 240;
						i = 8;
					end	
					if ((CounterX <240) && (CounterX >120) && (CounterY >240) && (CounterY <360)) 
					begin
						positionX = 120;
						positionY = 240;
						i = 9;
					end
					
					if ((CounterX <360) && (CounterX >240) && (CounterY >240) && (CounterY <360)) 
					begin
						positionX = 240;
						positionY = 240;
						i = 10;
					end
					
					if ((CounterX <480) && (CounterX >360) && (CounterY >240) && (CounterY <360))
					begin
						positionX = 360;
						positionY = 240;
						i = 11;
					end
					
					//Fourth Row
					if ((CounterX <120) && (CounterY >360) && (CounterY <480)) 
					begin
						positionX = 0;
						positionY = 360;
						i = 12;
					end
					
					if ((CounterX <240) && (CounterX >120) && (CounterY >360) && (CounterY <480)) 
					begin
						positionX = 120;
						positionY = 360;
						i = 13;
					end
					
					if ((CounterX <360) && (CounterX >240) && (CounterY >360) && (CounterY <480)) 
					begin
						positionX = 240;
						positionY = 360;
						i = 14;
					end
					
					if ((CounterX <480) && (CounterX >360) && (CounterY >360) && (CounterY <480))
					begin
						positionX = 360;
						positionY = 360;
						i = 15;
					end
				
				
					//CASE for Numbers
					case(Matrix[i])
						2:  R = ((CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+44) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(62+positionY))
							); 				   
						
						4:  R = ((CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+44) && CounterY>=(10+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
							);
			
						8:  R = ((CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+40) && CounterX<=(positionX+44) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
							); 
						16:  R = ((CounterX>=(positionX+50) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //6
						   ||(CounterX>=(positionX+50) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+50) && CounterX<=(positionX+80) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+50) && CounterX<=(positionX+54) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+30) && CounterX<=(positionX+34) && CounterY>=(10+positionY) && CounterY<=(104+positionY)) //1
							); 		
						32:  R = ((CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
						   ||(CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+55) && CounterX<=(positionX+59) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+96) && CounterX<=(positionX+100) && CounterY>=(10+positionY) && CounterY<=(62+positionY)) //2
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+41) && CounterX<=(positionX+45) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
							);		
						64: R = ((CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //6
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+14) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+41) && CounterX<=(positionX+45) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(58+positionY) && CounterY<=(62+positionY)) //4
						   ||(CounterX>=(positionX+55) && CounterX<=(positionX+59) && CounterY>=(10+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+96) && CounterX<=(positionX+100) && CounterY>=(10+positionY) && CounterY<=(104+positionY)));
					
						128: R=((CounterX>=(positionX+10)&& CounterX<=(positionX+15)&& CounterY>=(10+positionY) && CounterY<=(100+positionY))//1
						   ||(CounterX>=(positionX+33) && CounterX<=(positionX+70) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //2
						   ||(CounterX>=(positionX+33) && CounterX<=(positionX+70) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+33) && CounterX<=(positionX+70) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+33) && CounterX<=(positionX+37) && CounterY>=(62+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+66) && CounterX<=(positionX+70) && CounterY>=(10+positionY) && CounterY<=(59+positionY))
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+115) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //8
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+115) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+115) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+84) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+111) && CounterX<=(positionX+115) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
						   );
						256: R=((CounterX>=(positionX+10) && CounterX<=(positionX+35) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //2
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+35) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+35) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+10) && CounterX<=(positionX+14) && CounterY>=(62+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+31) && CounterX<=(positionX+35) && CounterY>=(10+positionY) && CounterY<=(59+positionY))
						   ||(CounterX>=(positionX+45) && CounterX<=(positionX+70) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //5
						   ||(CounterX>=(positionX+45) && CounterX<=(positionX+70) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+45) && CounterX<=(positionX+70) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+66) && CounterX<=(positionX+70) && CounterY>=(62+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+45) && CounterX<=(positionX+49) && CounterY>=(10+positionY) && CounterY<=(59+positionY))
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+105) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //6
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+105) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+105) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+80) && CounterX<=(positionX+84) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
						   ||(CounterX>=(positionX+101) && CounterX<=(positionX+105) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
						   );				   
						
						default: 
							begin
								R=0;
								
								
							end	
						endcase
				end
			
			
		end
		
	

	//4 X 4 Blocks
	wire G = (((CounterX>0 && CounterX<480 && CounterY>=0 && CounterY<=5)
	||(CounterX>0 && CounterX<480 && CounterY>=115 && CounterY<=125)
	||(CounterX>0 && CounterX<480 && CounterY>=235 && CounterY<=245)
	||(CounterX>0 && CounterX<480 && CounterY>=355 && CounterY<=365)
	||(CounterX>0 && CounterX<480 && CounterY>=475 && CounterY<=480))
	||((CounterY>0 && CounterY<480 && CounterX>=0 && CounterX<=5)
	||(CounterY>0 && CounterY<480 && CounterX>=115 && CounterX<=125)
	||(CounterY>0 && CounterY<480 && CounterX>=235 && CounterX<=245)
	||(CounterY>0 && CounterY<480 && CounterX>=355 && CounterX<=365)
	||(CounterY>0 && CounterY<480 && CounterX>=475 && CounterX<=480)));
	
	
	always @(posedge clk)
	begin
		vga_r <= R & inDisplayArea;
		vga_g <= G & inDisplayArea;
		vga_b <= B & inDisplayArea;
	end
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  VGA control ends here 	 ///////////////////
	/////////////////////////////////////////////////////////////////
	

endmodule
