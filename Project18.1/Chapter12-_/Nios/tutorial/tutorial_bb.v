
module tutorial (
	clk_clk,
	led_export,
	reset_reset_n,
	sd_det_export,
	sd_spi_MISO,
	sd_spi_MOSI,
	sd_spi_SCLK,
	sd_spi_SS_n);	

	input		clk_clk;
	output	[3:0]	led_export;
	input		reset_reset_n;
	input	[1:0]	sd_det_export;
	input		sd_spi_MISO;
	output		sd_spi_MOSI;
	output		sd_spi_SCLK;
	output		sd_spi_SS_n;
endmodule
