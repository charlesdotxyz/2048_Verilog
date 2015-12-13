		//////////////////////////////////////////////////////////////////////////////////
// Author:      Shizhong Hao/ Chiye Huang
// Create Date: 2015-09-15
// Modified:      
// File Name:   ee201_pulse_atN.v 
// Description: 
//
//
// Revision: 		1.1
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ee201_pulse_atN(Clk, Reset, Pulse, N);	

	// parameters
	/** TODO: update WIDTH = COUNTER width 
	use MINIMUM required WIDTH to count for N <= 1000 (decimal)
 	**/
	
	parameter WIDTH = 10;


	/*  INPUTS */
	// Clock & Reset
	input		Clk, Reset;
	// Terminal count
	input [WIDTH-1:0] N;	
	// store the previous N to allow reset if N change
	// prevents clock run away if N << Nlast
	reg [WIDTH-1:0] Nlast;	

	
	reg [WIDTH-1:0] Count;	

	
	/*  OUTPUTS */
	// output clock
	output Pulse;
	/**
	TODO: fix assign so that Pulse does not equal 1 if N=0	
	**/
	assign Pulse = (Count == N-1) && (~(N==0)); 

		
	always @ (posedge Clk, posedge Reset)
	begin : PULSE_GENERATOR
		if(Reset)
			Count <= 0;
		else
			begin
		    	// nonblocking so check occurs with old Nlast
    			Nlast <= N;
    		  
    		  	/**
			  	TODO:
			  	update condition to reset Count if N "changes" between clocks
        		**/
		    	if(~(Nlast==N))
		      		Count <= 0;
        		else if(Count == N-1)
          			begin
						/**
						TODO: complete            
						**/
						Count<=0;
						/* */
          			end
			  	else
			  		begin
						/**
						TODO: complete            
						**/
						Count <= Count + 1;
						/* */
					end
		  end
	end
	
endmodule


