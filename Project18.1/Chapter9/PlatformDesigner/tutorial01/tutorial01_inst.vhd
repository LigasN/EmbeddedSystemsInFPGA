	component tutorial01 is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			reset_reset_n : in  std_logic                    := 'X'; -- reset_n
			pwm_pwm       : out std_logic_vector(3 downto 0)         -- pwm
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			pwm_pwm       => CONNECTED_TO_pwm_pwm        --   pwm.pwm
		);

