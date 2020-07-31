
module tutorial01 (
	clk_clk,
	led_export,
	reset_reset_n,
	sw_export,
	seg_sw_export,
	seg_seg_export);	

	input		clk_clk;
	output	[3:0]	led_export;
	input		reset_reset_n;
	input	[2:0]	sw_export;
	output	[3:0]	seg_sw_export;
	output	[7:0]	seg_seg_export;
endmodule
