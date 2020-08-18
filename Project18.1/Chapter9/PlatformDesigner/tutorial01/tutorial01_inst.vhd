	component tutorial01 is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			pwm_pwm       : out std_logic_vector(3 downto 0);        -- pwm
			reset_reset_n : in  std_logic                    := 'X'; -- reset_n
			seg7_segment  : out std_logic_vector(7 downto 0);        -- segment
			seg7_display  : out std_logic_vector(3 downto 0)         -- display
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			pwm_pwm       => CONNECTED_TO_pwm_pwm,       --   pwm.pwm
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			seg7_segment  => CONNECTED_TO_seg7_segment,  --  seg7.segment
			seg7_display  => CONNECTED_TO_seg7_display   --      .display
		);

