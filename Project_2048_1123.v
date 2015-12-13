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

module Project_2048 (ClkPort,vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, Sw0, Sw1, btnU, btnD, btnL, btnR); // Ack, Done

input ClkPort, Sw0, Sw1, btnU, btnD, btnL, btnR;  	//Ack
output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b; //Done,


reg [11:0] Matrix[15:0];
wire [192:0] MatrixCopy;   //Changed
reg [10:0] randCount;
reg [1:0] counter;
reg [4:0] buttonValue;
reg [4:0] state;
reg Test;  //TEST
reg flagstate1,flagstate2;

reg [3:0] randNum;


wire Reset, Start, SymClk;
wire SlowClk;  //Question
wire buttonPushed;

wire vga_r, vga_g, vga_b; //Question!!

integer i,j;

BUF BUF1 (SymClk, ClkPort); 	
	BUF BUF2 (Reset, Sw0);
	BUF BUF3 (Start, Sw1);
	
localparam
INI 	= 5'b00001,
Gen 	= 5'b00010,
Move	= 5'b00100,
Merge	= 5'b01000,
Done	= 5'b10000;


assign buttonPushed = btnU || btnD || btnL || btnR;

//Number Assignments


assign MatrixCopy = {Matrix[15],Matrix[14],Matrix[13],Matrix[12],Matrix[11],Matrix[10],Matrix[9],
						Matrix[8],Matrix[7],Matrix[6],Matrix[5],Matrix[4],Matrix[3],Matrix[2],Matrix[1],Matrix[0]};



//Connection. Instantation Problem
//
//Clock 
ee201_clk_60Hz SlowerClock (
		.Clk(SymClk), .Reset(Reset), .Clk60(SlowClk)
	);

vga_demo VGATEST (.board_clk(SymClk), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync),
 .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b), .reset(Reset),.Test(Test),.MatrixCopy(MatrixCopy));  //
	
//Counter for Random Number
always @ (posedge SymClk, posedge Reset)
	begin
		if (Reset)
			randCount <=0;
		else if (randCount == 11'b11111111111)
			randCount <=0;
		else randCount <= randCount + 1;
	
	end





always @ (posedge SlowClk, posedge Reset)
	begin
		if (Reset)
			begin
				state <= INI;
				 for(i=0; i<16; i= i+1) 
					begin
						Matrix[i] <= 0;
					end				
				Test <= 0;
				
			end
		else
			begin
				case(state)
					INI:
						begin
							//state transition
							if (Start) 
								state <= Gen;
								
							//RTL
							//Matrix <= 0;  //Question
							randNum <= randCount[3:0];
							Test <= 0;
							
						end
						
					
					Gen:
						begin
							//state transition
							if ((buttonPushed) && (Matrix[randNum] == 0))  //defined
								
								state <= Move;
							//RTL
							randNum <= randCount[3:0];
							if (Matrix[randNum] == 0)  //defined
								begin
								Matrix[randNum] <= 2;       //randNum in binary is a problem????
				
								end
							if (btnU) buttonValue <= 4'b0001;
							if (btnD) buttonValue <= 4'b0010;
							if (btnL) buttonValue <= 4'b0100;
							if (btnR) buttonValue <= 4'b1000;
							
							flagstate1 <=0;
							flagstate2 <=0;
						
						end
						
					Move:
						begin
							//state transition
							if (flagstate1 == 1)
								state <= Merge;							
							
							//RTL
							if (buttonValue == 4'b0001)  //ButtonPushed
								begin
									for (i = 0; i < 4; i = i + 1)				//defined i,j
										begin	
											for (j = 0; j < 4; j = j + 1)
												begin
													if (Matrix[i+4*j] == 0)
														counter <= counter + 1;			//defined counter
													else
														begin
															Matrix[i+4*j-4*counter] <= Matrix[i+4*j];
															Matrix[i+4*j] <= 0;
														end
												end
										end
								
									Test <= 1;   //TEST
								end
							
							//if (Down)
							//Incomplete
						
						flagstate1<=1;
						end
						
					Merge:
						begin
							//state transition
							if (flagstate2 == 1)
								state <= Gen;   //NEED a check state, probably
							
							//RTL
							if (buttonValue == 4'b0001) //defined, not mentioned previously
								begin
										for (i = 0; i <4; i = i + 1)	
											begin
												for (j = 0; j < 3; j = j + 1)
													begin
														if (Matrix[i+4*j] == Matrix[i+4*j+4])
														begin
																Matrix[i+4*j] <= 2*Matrix[i+4*j];
																counter <= counter + 1;	
																Matrix[i+4*j+4] <= 0;
														end
														if ((counter !== 0) && (Matrix[i+4*j+4] !== 0))
															begin
																Matrix[i+4*j] <= Matrix[i+4*j+4];
																Matrix[i+4*j+4] <= 0;
															end
													end
											end
									flagstate2 <= 1;	
								end
							
							
						
						end
				endcase		
			end				
							
	end					
						

				
			
			
endmodule
