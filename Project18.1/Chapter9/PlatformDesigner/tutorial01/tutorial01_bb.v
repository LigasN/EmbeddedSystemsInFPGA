
module tutorial01 (
	clk_clk,
	encoder_encoder,
	pwm_pwm,
	reset_reset_n,
	seg7_segment,
	seg7_display);	

	input		clk_clk;
	input	[1:0]	encoder_encoder;
	output	[3:0]	pwm_pwm;
	input		reset_reset_n;
	output	[7:0]	seg7_segment;
	output	[3:0]	seg7_display;
endmodule
