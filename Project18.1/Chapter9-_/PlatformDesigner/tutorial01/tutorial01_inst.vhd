	component tutorial01 is
		port (
			clk_clk         : in  std_logic                    := 'X';             -- clk
			encoder_encoder : in  std_logic_vector(1 downto 0) := (others => 'X'); -- encoder
			led_out_led_out : out std_logic;                                       -- led_out
			pwm_pwm         : out std_logic_vector(3 downto 0);                    -- pwm
			reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
			seg7_segment    : out std_logic_vector(7 downto 0);                    -- segment
			seg7_display    : out std_logic_vector(3 downto 0)                     -- display
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk         => CONNECTED_TO_clk_clk,         --     clk.clk
			encoder_encoder => CONNECTED_TO_encoder_encoder, -- encoder.encoder
			led_out_led_out => CONNECTED_TO_led_out_led_out, -- led_out.led_out
			pwm_pwm         => CONNECTED_TO_pwm_pwm,         --     pwm.pwm
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --   reset.reset_n
			seg7_segment    => CONNECTED_TO_seg7_segment,    --    seg7.segment
			seg7_display    => CONNECTED_TO_seg7_display     --        .display
		);

