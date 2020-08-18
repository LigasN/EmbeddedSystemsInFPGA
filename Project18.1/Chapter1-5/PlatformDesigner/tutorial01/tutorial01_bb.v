
module tutorial01 (
	clk_clk,
	led_export,
	reset_reset_n,
	seg_seg_export,
	seg_sw_export,
	sw_export);	

	input		clk_clk;
	output	[3:0]	led_export;
	input		reset_reset_n;
	output	[7:0]	seg_seg_export;
	output	[3:0]	seg_sw_export;
	input	[2:0]	sw_export;
endmodule
