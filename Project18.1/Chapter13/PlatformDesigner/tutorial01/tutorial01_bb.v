
module tutorial01 (
	clk_clk,
	led_export,
	reset_reset_n,
	vga_b,
	vga_g,
	vga_hs,
	vga_r,
	vga_vs);	

	input		clk_clk;
	output	[3:0]	led_export;
	input		reset_reset_n;
	output		vga_b;
	output		vga_g;
	output		vga_hs;
	output		vga_r;
	output		vga_vs;
endmodule
