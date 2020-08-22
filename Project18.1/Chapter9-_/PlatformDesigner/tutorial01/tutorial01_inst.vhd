	component tutorial01 is
		port (
			clk_clk         : in  std_logic := 'X'; -- clk
			reset_reset_n   : in  std_logic := 'X'; -- reset_n
			led_out_led_out : out std_logic         -- led_out
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --     clk.clk
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --   reset.reset_n
			led_out_led_out => CONNECTED_TO_led_out_led_out  -- led_out.led_out
		);

