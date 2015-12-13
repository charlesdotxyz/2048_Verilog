//Project_2048 Testbench

module Project_2048_tb;


reg ClkPort_tb;
reg ack_tb;
reg Sw0_tb, Sw1_tb, btnU_tb, btnD_tb, btnL_tb, btnR_tb;
wire vga_h_sync_tb, vga_v_sync_tb, vga_r_tb, vga_g_tb, vga_b_tb, St_ce_bar_tb, St_rp_bar_tb, Mt_ce_bar_tb, Mt_St_oe_bar_tb, Mt_St_we_bar_tb;

Project_2048 uut (
.ClkPort(ClkPort_tb), 
.Sw0(Sw0_tb), 
.Sw1(Sw1_tb), 
.btnU(btnU_tb), 
.btnD(btnD_tb), 
.btnL(btnL_tb), 
.btnR(btnR_tb),
.vga_h_sync(vga_h_sync_tb), 
.vga_v_sync(vga_v_sync_tb),
.vga_r(vga_r_tb), 
.vga_g(vga_g_tb), 
.vga_b(vga_b_tb),
.St_ce_bar(St_ce_bar_tb), .St_rp_bar(St_rp_bar_tb), .Mt_ce_bar(Mt_ce_bar_tb), .Mt_St_oe_bar(Mt_St_oe_bar_tb), .Mt_St_we_bar(Mt_St_we_bar_tb)
);

initial
	begin: Clock_gen
		ClkPort_tb=0;
		forever
			begin
				#5 ClkPort_tb = ~ ClkPort_tb;
			end
	end

initial
	begin
		ClkPort_tb = 1;
		Sw0_tb = 0;
		Sw1_tb = 0; 
		btnU_tb = 0; 
		btnD_tb = 0;
		btnL_tb = 0;
		btnR_tb = 0;
		
		#208
		Sw0_tb = 1;
		#10;
		Sw0_tb = 0;
		#60;
		Sw1_tb = 1;
		#10;
		Sw1_tb = 0;
		#500;
		btnU_tb=1;
		#500;
		btnU_tb=0;
		#500;
		btnD_tb=1;
		#500;
		btnD_tb=0;
		#500;
		btnL_tb=1;
		#500;
		btnL_tb=0;
		#500;
		btnR_tb=1;
		#500;
		btnR_tb=0;
	end
	
	
	
	
	
endmodule	