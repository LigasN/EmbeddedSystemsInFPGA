	component tutorial01 is
		port (
			clk_clk            : in  std_logic                    := 'X'; -- clk
			hdmi_hdmi_tmds     : out std_logic_vector(2 downto 0);        -- hdmi_tmds
			hdmi_hdmi_tmds_clk : out std_logic;                           -- hdmi_tmds_clk
			reset_reset_n      : in  std_logic                    := 'X'  -- reset_n
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk            => CONNECTED_TO_clk_clk,            --   clk.clk
			hdmi_hdmi_tmds     => CONNECTED_TO_hdmi_hdmi_tmds,     --  hdmi.hdmi_tmds
			hdmi_hdmi_tmds_clk => CONNECTED_TO_hdmi_hdmi_tmds_clk, --      .hdmi_tmds_clk
			reset_reset_n      => CONNECTED_TO_reset_reset_n       -- reset.reset_n
		);

