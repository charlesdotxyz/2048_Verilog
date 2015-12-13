`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// VGA verilog template
// Author:  Da Cheng
//////////////////////////////////////////////////////////////////////////////////
module vga_demo(board_clk, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, reset, Test,MatrixCopy);//
	input board_clk, MatrixCopy, reset, Test; //Matrix
	output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;
	reg vga_r, vga_g, vga_b;
	wire [11:0] Matrix[15:0];
	integer i;
	reg [10:0] positionX, positionY;
	
	reg Display2,Display4,Display8,Display16,Display32,Display64,Display128,Display256;
    wire Test;
	wire [191:0] MatrixCopy;   //Changed

	wire Num2,Num4,Num8,Num16,Num32,Num64;
	
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
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/*  LOCAL SIGNALS */
	wire	reset, board_clk, clk, button_clk;

	
	reg [27:0]	DIV_CLK;
	always @ (posedge board_clk, posedge reset)  
	begin : CLOCK_DIVIDER
      if (reset)
			DIV_CLK <= 0;
      else
			DIV_CLK <= DIV_CLK + 1'b1;
	end	

	assign	button_clk = DIV_CLK[21];
	assign	clk = DIV_CLK[1];
	
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;

	hvsync_generator syncgen(.clk(clk), .reset(reset),.vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));
	
	
	//Number Segments
	assign Num2=Display2&&((CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+44) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(62+positionY))
					);
	
	assign Num4=Display4&&((CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+44) && CounterY>=(10+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
					);
	
	assign Num8=Display8&&((CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+80) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+40) && CounterX<=(positionX+44) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
					); 
	assign Num16=Display16&&((CounterX>=(positionX+50) && CounterX<=(positionX+80) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //6
				   ||(CounterX>=(positionX+50) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+50) && CounterX<=(positionX+80) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+50) && CounterX<=(positionX+54) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+76) && CounterX<=(positionX+80) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+30) && CounterX<=(positionX+34) && CounterY>=(10+positionY) && CounterY<=(104+positionY)) //1
					); 		
	assign Num32=Display32 && ((CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
				   ||(CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+55) && CounterX<=(positionX+59) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+96) && CounterX<=(positionX+100) && CounterY>=(10+positionY) && CounterY<=(62+positionY)) //2
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(10+positionY) && CounterY<=(14+positionY))
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+41) && CounterX<=(positionX+45) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
					);		
	assign Num64=Display64 && ((CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(10+positionY) && CounterY<=(14+positionY)) //6
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(58+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+45) && CounterY>=(100+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+10) && CounterX<=(positionX+14) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+41) && CounterX<=(positionX+45) && CounterY>=(58+positionY) && CounterY<=(104+positionY))
				   ||(CounterX>=(positionX+55) && CounterX<=(positionX+100) && CounterY>=(58+positionY) && CounterY<=(62+positionY)) //4
				   ||(CounterX>=(positionX+55) && CounterX<=(positionX+54) && CounterY>=(10+positionY) && CounterY<=(62+positionY))
				   ||(CounterX>=(positionX+96) && CounterX<=(positionX+100) && CounterY>=(10+positionY) && CounterY<=(104+positionY))
					); 		
					
	
	/////////////////////////////////////////////////////////////////
	///////////////		VGA control starts here		/////////////////
	/////////////////////////////////////////////////////////////////
	reg [9:0] position;
	always @(posedge DIV_CLK[19])         //CLOCK SPEED? Changed from 21 to 17  / USE 16 Always clock
		begin
			if(reset)
				begin
					positionX<=0; //Added 11/30
					positionY<=0;
					Display2 <=0;
					Display4 <=0;
					Display8 <=0;
					Display16 <=0;
					Display32 <=0;
					Display64 <=0;
				end
			else
				begin
					for (i = 0; i < 16; i = i + 1)
						begin
							
							if ( Matrix[i] == 2)  //Blocking? Non Blocking?
								begin
									Display2 =1;
									positionX = (i[1:0]) * 120;
									positionY = ((i >> 2)) * 120;
								end
							else Display2 =0;
							
							if ( Matrix[i] == 4)
								begin
									Display4 =1;
									positionX = (i[1:0]) * 120;
									positionY = ((i >> 2)) * 120;
								end
							else Display4 =0;
							
							if ( Matrix[i] == 8)
								begin
									Display8 =1;
									positionX = (i[1:0]) * 120;
									positionY = ((i >> 2)) * 120;
								end
							else Display8 =0;
							
							if ( Matrix[i] == 16)
								begin
									Display16 =1;
									positionX = (i[1:0]) * 120;
									positionY = ((i >> 2)) * 120;
								end
							else Display16 =0;
							
							if ( Matrix[i] == 32)
								begin
									Display32 =1;
									positionX = (i[1:0]) * 120;
									positionY = ((i >> 2)) * 120;
								end
							else Display32 =0;
							
							if ( Matrix[i] == 64)
								begin
									Display64 =1;
									positionX = (i[1:0]) * 120;
									positionY = ((i >> 2)) * 120;
								end
							else Display64 =0;
							
					
						end	
						
						
	
				
				
				end
		
		
		
		
		
		
		
		
		
		
		end
	
	wire R = Num2;
	//((CounterY>=(position-10) && CounterY<=(position+10) && CounterX[8:5]==7)||(CounterY>=(position-70) && CounterY<=(position-50) && CounterX[8:5]==7));
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
	wire B = 0;
	
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
