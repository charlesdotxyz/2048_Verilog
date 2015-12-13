// File Name:   ee201_clk_60Hz.v 

`timescale 1ns / 1ps

module ee201_slowerclk(Clk, Reset, Clk100K);	

	// parameters
	/**
	TODO: fix width to allow for 60H z
	use MINIMUM required WIDTH to allow 60Hz  
  	**/
	parameter WIDTH = 21;

		/*  INPUTS */
	// Clock & Reset
	input Clk, Reset;
	
	/*  OUTPUTS */
	// output clock
	output Clk60;	
	reg ClkReg;
	assign Clk60 = ClkReg;

	
	/* signal to toggle register */
	wire Toggle;

	
	/**
	TODO: calculate proper MAXCOUNT to achieve 60Hz
	notice that the number is multiplied by 2 below 
	  to account for the x2 toggles per clock
	  so you shouldnt account for this
	   
	HINT:
	  MAXCOUNT = # of 100MHz clocks / period for 60Hz clock
	**/
	localparam
		MAXCOUNT			=  21'd1666667;

	 
	wire [WIDTH-1:0] N;
	// shift right 1 = divide by 2
	// count to 1/2 desired frequency since clock = 2 toggles
	assign N = (MAXCOUNT >> 1);
 	 
	 
	/**
	TODO: complete parameter list
	HINT: check ee201_pulse_atN parameter list
	**/
	ee201_pulse_atN #(.WIDTH(WIDTH)) PGEN1 (
		.Pulse(Toggle),.Clk(Clk),.Reset(Reset),.N(N)
	);

		
	always @ (posedge Clk, posedge Reset)
	begin : SLOW_CLK
		if(Reset)
			ClkReg <= 0;
		else
			if(Toggle)
				begin
					/** TODO: complete toggle code **/
					ClkReg<=~ClkReg;
			  		/* */				
				end
	end
	
endmodule

