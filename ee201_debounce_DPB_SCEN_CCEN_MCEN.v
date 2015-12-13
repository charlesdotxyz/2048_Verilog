//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Gandhi Puvvada
// Create Date:   08/21/09,  Minor Revision: 2/10/2012, 9/24/2014
// File Name:	ee201_debouncer.v 
// Description: Debouncer module
// Additional Comments: Translated from VHDL by Matthew Christian and Gandhi Puvvada 2/21/2010
//
//////////////////////////////////////////////////////////////////////////////////

/* --------------------------------------------------------------------------------
-- Description:
-- 	A verilog design for debouncing a Push Button (PB) and producing the following: 
-- 		(1) a debounced pulse DPB (DPB = debounced PB)
--		(2) a single clock-enable pulse (SCEN) after ~0.084 sec
--			- for single-stepping the design using a push button
--		(3) a contunuous clock-enable pulse (CCEN) after another ~0.168 sec.
-- 			- for running at full-speed
--		(4) a sequence of (multiple of) clock-enable pulses (MCEN) every ~0.084 sec 
--			- after the ~0.168 sec.
-- 
-- 	Once 'PB' is pressed, after the initial bouncing finishes in the WQ (wait quarter 
--  second) state (actually 0.084 sec), the DPB is activated, and all three  pulses
--  (SCEN, CCEN, and MCEN) are produced just for *one clock* in SCEN_state. 
-- 	Then, after waiting another half second in the WH (wait half second) state 
--  (actually 0.168 sec), the MCEN goes active for 1 clock every quarter second (every
--  0.084 sec). The CCEN goes active continuously both in the MCEN_state and the CCEN_state.
--  Finally, if the PB is released, we wait in WFCR (Wait for a Complete Release) state 
--  for a quarter second (0.084 sec) and return to the INI state. 

-- 	The  additional half-second (or 0.168sec) waiting after producing the first 
--  single-clock wide pulse allows the user	to release the button in time to avoid 
--  multi-stepping or running at full-speed even if he/she has used MCEN or CCEN 
--  in his/her design.
--
--  Please see the state diagram or read the code to understand the exact behavior.
--  In fact, the code has one extra state (MCEN_cont state),
--  which is not shown in the state diagram.
--  Try to revise the state diagram with this state and figure out the state
--  transition conditions using the four-bit counter MCEN_count.

-- 	To achieve all of this and generate glitch-free outputs (though this is not necessary),
--  let us use output coding. In output coding the state memory bits are thoughtfully 
--  chosen in order to form the needed outputs directly (with no additional combinational 
--  logic).
--	   In this case, the DPB, SCEN, MCEN, and CCEN are those outputs.  
--     However, the output combinations may repeat in different states.
--	   So we need two tie-breakers (TB1 and TB2).
--
--	State Name      State      DPB SCEN MCEN CCEN TB1  TB0
--	initial         INI         0 	0    0    0    -    0
--	wait quarter    WQ          0   0    0    0    -    1
--	SCEN_state      SCEN_st     1   1    1    1    -    -
--	wait half       WH          1   0    0    0    0    0
--	MCEN_state      MCEN_st     1   0    1    1    -    0
--	CCEN_state      CCEN_st     1   0    0    1    -    -
--	MCEN_cont       MCEN_st     1   0    1    1    -    1  -- <==*****
--	Counter Clear   CCR         1   0    0    0    0    1
--	WFCR_state      WFCR        1   0    0    0    1    -

--	Timers (Counters to keep time):  2^20 clocks of 10ns =  
--  = approximately 10 milliseconds = accurately 10.48576 ms
--  We found by experimentation that we press and release buttons much faster than we
--	initially thought. So, instead of quarter second, let us wait for 2^23 clocks 
--  (0.084 sec.) and instead of half second, let us wait for 2^24 clocks (0.168 seconds).
--	If we use a 25-bit counter, count[24:0], and start it with 0, then the first time, 
--  count[23] goes high, we know that the lower 23 bits [count[22:0]] have gone through 
--  their 2^23 combinations. So count[23] is used as 
-- 	the 0.084 sec timer and the count[24] is used as the 0.168 sec timer.

--	We will use a parameter called N_dc (dc for debounce count) in place of 25 
--  (and [N_dc-1:0] in place of [24:0]), so that N_dc can be made 5 during behavioral 
--  simulation to test this debouncing module.

--	As the names say, the SCEN, MCEN, and the CCEN are clock enables and are not 
--  clocks (clock pulses) by themselves. If you use SCEN (or MCEN) as a clock by itself, 
--  then you would be creating a lot of skew as these outputs of the internal
--  state machine take ordinary routes and do not get to go on the special routes 
--  used for clock distribution on the FPGA.
--  However, when they are used as clock enables, the static timing analyzer checks 
--  timing of these signals with respect to the main clock signal (100 MHz clock) properly. 
--  This results in a good timing design.  Moreover, you can use different
--	clock enables in different parts of the control unit so that the system is 
--  single-stepped in some critical areas/states and multi-stepped or made to run at full 
--  speed in others.  This will not be possible if you try to use both SCEN and MCEN as 
--  clocks (instead of clock enables) as it will be very clumsy (if not impossible) to 
--  combine these clocks based on which part of the state machine you are currently travelling at. 
   --------------------------------------------------------------------------------*/

module ee201_debouncer(CLK, RESET, PB, DPB, SCEN, MCEN, CCEN);

//inputs
input	CLK, RESET;
input PB;

//outputs
output DPB;
output SCEN, MCEN, CCEN;

//parameters
parameter N_dc = 5;

//local variables
// the next line is an attribute specification allowed by Verilog 2001. 
// The "* fsm_encoding = "user" *"  tells XST synthesis tool that the user chosen 
// state codes are retained. This is essential for our carefully chosen output-coding to 
// prevail and make the OFL "null" there by ensuring that the outputs will not have 
// glitches. Frankly, it is not needed as we are *not* using these SCEN and MCEN pulses 
// as clock pulses. We are rather using them as enable pulses enabling the clock 
// (or more appropriately enabling the data).

(* fsm_encoding = "user" *)
reg [5:0] state;
// other items not controlled by the special attribute
reg [N_dc-1:0] debounce_count;
reg [3:0] MCEN_count;


//concurrent signal assignment statements
// The following is possible because of the output coding used by us.
assign {DPB, SCEN, MCEN, CCEN} = state[5:2];

//constants used for state naming // the don't cares are replaced here with zeros
localparam
 INI        = 6'b000000,
 WQ         = 6'b000001,
 SCEN_st    = 6'b111100,
 WH         = 6'b100000,
 MCEN_st    = 6'b101100,
 CCEN_st    = 6'b100100,
 MCEN_cont  = 6'b101101,
 CCR        = 6'b100001,
 WFCR       = 6'b100010;
		      
//logic
always @ (posedge CLK, posedge RESET)
	begin : State_Machine
		
		if (RESET)
		   begin
		      state <= INI;
		      debounce_count <= 'bx;
		      MCEN_count <= 4'bx;
		   end
		else 
		   begin
			   case (state)
				   INI: begin					
					     debounce_count <= 0;
					     MCEN_count <= 0;  
					     if (PB)
						   begin
							   state <= WQ;
						   end
			            end
			       WQ: begin
					   debounce_count <= debounce_count + 1;
			           if (!PB)
			             begin
			                state <= INI;
			             end
				       else if (debounce_count[N_dc-2]) // for N_dc of 25, it is debounce_count[23], i.e T = 0.084 sec for f = 100MHz
				         begin
				             state <= SCEN_st;
				         end
				      end
				   SCEN_st: begin
					  debounce_count <= 0;
				      MCEN_count <= MCEN_count + 1;
				      state <= WH;
				      end
				   
				   WH: begin
					  debounce_count <= debounce_count + 1;
				      if (!PB)
				         begin
								state <= CCR;
							end	
				      else if (debounce_count[N_dc-1]) // for N_dc of 25, it is debounce_count[24], i.e T = 0.168 sec for f = 100MHz
				         begin
								state <= MCEN_st;
							end
				      end
				      
				   MCEN_st: begin
					  debounce_count <= 0;
				      MCEN_count <= MCEN_count + 1;
				      state <= CCEN_st;
				      end
				   
				   CCEN_st: begin
					  debounce_count <= debounce_count + 1;
				      if (!PB)
				        begin
							state <= CCR;
						end
				      else if (debounce_count[N_dc-2]) // for N_dc of 25, it is debounce_count[23], i.e T = 0.084 sec for f = 100MHz
				        begin
				            if (MCEN_count == 4'b1000)
				                begin
									state <= MCEN_cont;
								end
				            else
				                begin
									state <= MCEN_st;
								end
				        end
				      end
				      
				   MCEN_cont: begin // remain here until the PB is released
					  if (!PB)
				         begin
								state <= CCR;
						 end
				      end
				   
				   CCR: begin
					  debounce_count <= 0;
				      MCEN_count <= 0;
				      state <= WFCR;
				      end
				   
				   WFCR: begin
					  debounce_count <= debounce_count + 1;
				      if (PB)
				         begin
								state <= WH;
							end
				      else if (debounce_count[N_dc-2])// for N_dc of 25, it is debounce_count[23], i.e T = 0.084 sec for f = 100MHz
				         begin
								state <= INI;
							end
				      end
				endcase		    
	      end
	end // State_Machine

	
endmodule // ee201_debouncer