	component tutorial is
		port (
			clk_clk       : in  std_logic                    := 'X';             -- clk
			led_export    : out std_logic_vector(3 downto 0);                    -- export
			reset_reset_n : in  std_logic                    := 'X';             -- reset_n
			sd_det_export : in  std_logic_vector(1 downto 0) := (others => 'X'); -- export
			sd_spi_MISO   : in  std_logic                    := 'X';             -- MISO
			sd_spi_MOSI   : out std_logic;                                       -- MOSI
			sd_spi_SCLK   : out std_logic;                                       -- SCLK
			sd_spi_SS_n   : out std_logic                                        -- SS_n
		);
	end component tutorial;

	u0 : component tutorial
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --    clk.clk
			led_export    => CONNECTED_TO_led_export,    --    led.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, --  reset.reset_n
			sd_det_export => CONNECTED_TO_sd_det_export, -- sd_det.export
			sd_spi_MISO   => CONNECTED_TO_sd_spi_MISO,   -- sd_spi.MISO
			sd_spi_MOSI   => CONNECTED_TO_sd_spi_MOSI,   --       .MOSI
			sd_spi_SCLK   => CONNECTED_TO_sd_spi_SCLK,   --       .SCLK
			sd_spi_SS_n   => CONNECTED_TO_sd_spi_SS_n    --       .SS_n
		);

