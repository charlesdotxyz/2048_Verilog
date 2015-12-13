//////////////////////////////////////////////////////////////////////////////////
// Author:			Shizhong Hao, Chiye Huang
// Create Date:   	11/17/2015
// File Name:		2048
// Description: 	EE354 Final Project.
//
//
// Revision: 	
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module Project_2048 (ClkPort,vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, Sw0, Sw1, Sw2, btnU, btnD, btnL, btnR, St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar); // , Done

input ClkPort, Sw0, Sw1, Sw2, btnU, btnD, btnL, btnR, Sw2;
output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar; //Done,


reg [11:0] Matrix[15:0];

reg [10:0] randCount;
reg [1:0] counterMove, counterMerge;
reg [3:0] buttonValue; 
reg [5:0] state;
reg flagDone;  
reg flagstate1,flagstate2,flagGen, flagGenState;

reg [3:0] randNum,randNumFirstGen;

wire [191:0] MatrixCopy;   //Flatten out Matrix
wire Reset, Start, SymClk, Ack;
wire DPB, MCEN, CCEN, DbtnU, DbtnD, DbtnL, DbtnR;
wire vga_r, vga_g, vga_b; 
//Flag may be needed for Moved and Merged to generate new number

integer i,j;

BUF BUF1 (SymClk, ClkPort); 	
BUF BUF2 (Reset, Sw0);
BUF BUF3 (Start, Sw1);
BUF BUF4 (Ack, Sw2);	

localparam
INI 	= 6'b000001,
Gen1 	= 6'b000010,
Gen2    = 6'b000100,
Move	= 6'b001000,
Merge	= 6'b010000,
Done	= 6'b100000;


//Check for Win/Lose
assign check_over = ((Matrix[0] !== Matrix[1]) && (Matrix[0] !== Matrix[4]) && (Matrix[1] !== Matrix[5]) && (Matrix[1] !== Matrix[2]) &&(Matrix[2] !== Matrix[6]) &&
	(Matrix[2] !== Matrix[3]) && (Matrix[3] !== Matrix[7]) && (Matrix[4] !== Matrix[5]) && (Matrix[4] !== Matrix[8]) && (Matrix[5] !== Matrix[9]) && 
	(Matrix[5] !== Matrix[6]) && (Matrix[6] !== Matrix[7]) && (Matrix[6] !== Matrix[10]) && (Matrix[7] !== Matrix[11]) && (Matrix[8] !== Matrix[9]) && 
	(Matrix[8] !== Matrix[12]) && (Matrix[9] !== Matrix[10]) && (Matrix[9] !== Matrix[13]) && (Matrix[10] !== Matrix[14]) && (Matrix[10] !== Matrix[11]) && 
	(Matrix[11] !== Matrix[15]) && (Matrix[12] !== Matrix[13]) && (Matrix[13] !== Matrix[14]) && (Matrix[14] !== Matrix[15])&&(Matrix[0] !== 0)&&
	(Matrix[1] !== 0)&&(Matrix[2] !== 0)&&(Matrix[3] !== 0)&&(Matrix[4] !== 0)&&(Matrix[5] !== 0)
	&&(Matrix[6] !== 0)&&(Matrix[7] !== 0)&&(Matrix[8] !== 0)&&(Matrix[9] !== 0)&&(Matrix[10] !== 0)
	&&(Matrix[11] !== 0)&&(Matrix[12] !== 0)&&(Matrix[13] !== 0)&&(Matrix[14] !== 0)&&(Matrix[15] !== 0));

assign checkWin = ((Matrix[0] == 256) || (Matrix[1] == 256) || (Matrix[2] == 256) || (Matrix[3] == 256) || (Matrix[4] == 256) || (Matrix[5] == 256) || (Matrix[6] == 256) || (Matrix[7] == 256) || 
(Matrix[8] == 256) || (Matrix[9] == 256) || (Matrix[10] == 256) || (Matrix[11] == 256) || (Matrix[12] == 256) || (Matrix[13] == 256) || (Matrix[14] == 256) || (Matrix[15] == 256));
	

//Flatten out the Matrix
assign MatrixCopy = {Matrix[15],Matrix[14],Matrix[13],Matrix[12],Matrix[11],Matrix[10],Matrix[9],
						Matrix[8],Matrix[7],Matrix[6],Matrix[5],Matrix[4],Matrix[3],Matrix[2],Matrix[1],Matrix[0]};



//Connection. Instantation
ee201_debouncer ButtonDown(.CLK(SymClk), .RESET(Reset), .PB(btnD), .DPB(DPB), .SCEN(DbtnD), .MCEN(MCEN), .CCEN(CCEN));
ee201_debouncer ButtonUp(.CLK(SymClk), .RESET(Reset), .PB(btnU), .DPB(DPB), .SCEN(DbtnU), .MCEN(MCEN), .CCEN(CCEN));
ee201_debouncer ButtonLeft(.CLK(SymClk), .RESET(Reset), .PB(btnL), .DPB(DPB), .SCEN(DbtnL), .MCEN(MCEN), .CCEN(CCEN));
ee201_debouncer ButtonRight(.CLK(SymClk), .RESET(Reset), .PB(btnR), .DPB(DPB), .SCEN(DbtnR), .MCEN(MCEN), .CCEN(CCEN));
	
vga_demo VGATEST (.board_clk(SymClk), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync),
 .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b), .reset(Reset),.Done(flagDone),.MatrixCopy(MatrixCopy),
 .St_ce_bar(St_ce_bar), .St_rp_bar(St_rp_bar), .Mt_ce_bar(Mt_ce_bar), .Mt_St_oe_bar(Mt_St_oe_bar), .Mt_St_we_bar(Mt_St_we_bar));  //
	
	
	
//Counter for Random Number
always @ (posedge SymClk, posedge Reset)
	begin
		if (Reset)
			randCount <=0;
		else if (randCount == 11'b11111111111)
			randCount <=0;
		else randCount <= randCount + 1;
	
	end



always @ (posedge SymClk, posedge Reset) 
	begin
		if (Reset)
			begin
				state <= INI;
				 for(i=0; i<16; i= i+1) 
					begin
						Matrix[i] <= 0;
					end				
				
				
			end
		else
			begin
				case(state)
					INI:
						begin
							//state transition
							if (Start) 
								state <= Gen1;
								
							//RTL
							randNum <= randCount[3:0];
							randNumFirstGen <= randCount[7:4];
							
							flagGen <= 1;
							flagGenState <=0;
							buttonValue <=0;
							flagDone <=0;
							for(i=0; i<16; i= i+1) 
								begin
									Matrix[i] <= 0;
								end		
						end
						
						
					Gen1:
						begin
							//state transition
							state <= Gen2;
						
							//RTL
							Matrix[randNumFirstGen] <= 2;
							
						end
						
					
					Gen2:
				
						begin
							//state transition
							if ((check_over || checkWin) && (flagGenState))
								state <= Done;
							if (((check_over==0)&& (flagGenState))||((Matrix[randNum] == 0) && (flagGenState)))  
								
								state <= Move;
							//RTL
							randNum <= randCount[3:0];
							if ((Matrix[randNum] == 0) && (flagGen))   
								begin
									Matrix[randNum] <= 2;       
									flagGen <= 0;
								end
						
								
							if (DbtnU) buttonValue <= 4'b0001;
							if (DbtnD) buttonValue <= 4'b0010;
							if (DbtnL) buttonValue <= 4'b0100;
							if (DbtnR) buttonValue <= 4'b1000;
							if (DbtnU || DbtnD || DbtnL || DbtnR ) flagGenState <=1;
							flagstate1 <=0;
							flagstate2 <=0;
							counterMove <= 0;
							counterMerge <=0;
						end
						
					Move:
						begin
							//state transition
							if (flagstate1 ==1 )
								state <= Merge;							
							
							//RTL
							counterMove = 0;
							//UP MOVE
							if (buttonValue == 4'b0001)  //UP Pressed
								begin
									for (i = 0; i < 4; i = i + 1)				
										begin	
											
											for (j = 0; j < 4; j = j + 1)
												begin
													if (Matrix[i+4*j] == 0)
														counterMove = counterMove + 1;			
													else if (counterMove !== 0)
														begin
															Matrix[i+4*j-4*counterMove] = Matrix[i+4*j];
															Matrix[i+4*j] = 0;
														end
													if (j == 3) counterMove = 0;
												end
										end
									flagstate1<=1;
									
								end
								
							//DOWN MOVE
							if (buttonValue == 4'b0010)  //DOWN Pressed
								begin
									for (i = 0; i < 4; i = i + 1)				
										begin	
											
											for (j = 3; j >= 0; j = j - 1)
												begin
													if (Matrix[i+4*j] == 0)
														counterMove = counterMove + 1;			
													else if (counterMove !== 0)
														begin
															Matrix[i+4*j+4*counterMove] = Matrix[i+4*j];
															Matrix[i+4*j] = 0;
														end
													if (j == 0) counterMove = 0;
												end
										end
									flagstate1<=1;
									
								end
								
								//LEFT MOVE
							if (buttonValue == 4'b0100)  //LEFT Pressed
								begin
									for (j = 0; j < 4; j = j + 1)				
										begin	
											
											for (i = 0; i < 4; i = i + 1)
												begin
													if (Matrix[i+4*j] == 0)
														counterMove = counterMove + 1;			
													else if (counterMove !== 0)
														begin
															Matrix[i+4*j-counterMove] = Matrix[i+4*j];
															Matrix[i+4*j] = 0; 
														end
													if (i == 3) counterMove = 0;
												end
										end
									flagstate1<=1;
								end
								
								//RIGHT MOVE
							if (buttonValue == 4'b1000)  //LEFT Pressed
								begin
									for (j = 0; j < 4; j = j + 1)				
										begin	
											
											for (i = 3; i >= 0; i = i - 1)
												begin
													if (Matrix[i+4*j] == 0)
														counterMove = counterMove + 1;			
													else if (counterMove !== 0)
														begin
															Matrix[i+4*j+counterMove] = Matrix[i+4*j];
															Matrix[i+4*j] = 0; 
														end
													if (i == 0) counterMove = 0;
												end
										end
									flagstate1<=1;
								end
							
						flagGen <= 1; 
						
						end
						
					Merge:
						begin
							//state transition
							if ((flagstate2 == 1))
								state <= Gen2;   
							
							//RTL
							counterMerge = 0;
							//UP Merge 
							if (buttonValue == 4'b0001) 
								begin
										for (i = 0; i <4; i = i + 1)	
											begin
												for (j = 0; j < 3; j = j + 1)
													begin
														if (Matrix[i+4*j] == Matrix[i+4*j+4])
														begin
																Matrix[i+4*j] = 2*Matrix[i+4*j];
																counterMerge = counterMerge + 1;	
																Matrix[i+4*j+4] = 0;
														end
														if ((counterMerge !== 0) && (Matrix[i+4*j+4] !== 0))
															begin
																Matrix[i+4*j] = Matrix[i+4*j+4];
																Matrix[i+4*j+4] = 0;
															end
														if (j == 2) counterMerge = 0;
													end
											end
										flagstate2 <= 1;	
								end
														
							//Down Merge
							if (buttonValue == 4'b0010) 
								begin
										for (i = 0; i <4; i = i + 1)	
											begin
												for (j = 3; j >0; j = j - 1)
													begin
														if (Matrix[i+4*j] == Matrix[i+4*j-4])
														begin
																Matrix[i+4*j] = 2*Matrix[i+4*j];
																counterMerge = counterMerge + 1;	
																Matrix[i+4*j-4] = 0;
														end
														if ((counterMerge !== 0) && (Matrix[i+4*j-4] !== 0))
															begin
																Matrix[i+4*j] = Matrix[i+4*j-4];
																Matrix[i+4*j-4] = 0;
															end
														if (j == 1) counterMerge = 0;
													end
											end	
										flagstate2 <= 1;	
								end
								
								
								//LEFT Merge
							if (buttonValue == 4'b0100) 
								begin
										for (j = 0; j <4; j = j + 1)	
											begin
												for (i = 0; i < 3; i = i + 1)
													begin
														if (Matrix[i+4*j] == Matrix[i+4*j+1])
														begin
																Matrix[i+4*j] = 2*Matrix[i+4*j];
																counterMerge = counterMerge + 1;	
																Matrix[i+4*j+1] = 0;
														end
														if ((counterMerge !== 0) && (Matrix[i+4*j+1] !== 0))
															begin
																Matrix[i+4*j] = Matrix[i+4*j+1];
																Matrix[i+4*j+1] = 0;
															end
														if (i == 2) counterMerge = 0;
													end
											end	
										flagstate2 <= 1;	
								end
								
							//Right Merge	
							if (buttonValue == 4'b1000)
								begin
										for (j = 0; j <4; j = j + 1)	
											begin
												for (i = 3; i > 0; i = i - 1)
													begin
														if (Matrix[i+4*j] == Matrix[i+4*j-1])
														begin
																Matrix[i+4*j] = 2*Matrix[i+4*j];
																counterMerge = counterMerge + 1;	
																Matrix[i+4*j-1] = 0;
														end
														if ((counterMerge !== 0) && (Matrix[i+4*j-1] !== 0))
															begin
																Matrix[i+4*j] = Matrix[i+4*j-1];
																Matrix[i+4*j-1] = 0;
															end
														if (i == 1) counterMerge = 0;
													end
											end	
										flagstate2 <= 1;	
								end
						
						buttonValue <= 0;
						flagGenState <=0;
						end
						
						
						
					Done:
						begin
						//state transition
						if (Ack)
							state <= INI;
							
						//RTL
						flagDone <=1;
						
						
						end
					
				endcase		
			end				
							
	end					
						

				
			
			
endmodule
