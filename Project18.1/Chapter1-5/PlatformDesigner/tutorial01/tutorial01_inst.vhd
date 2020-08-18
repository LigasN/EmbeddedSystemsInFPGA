	component tutorial01 is
		port (
			clk_clk        : in  std_logic                    := 'X';             -- clk
			led_export     : out std_logic_vector(3 downto 0);                    -- export
			reset_reset_n  : in  std_logic                    := 'X';             -- reset_n
			seg_seg_export : out std_logic_vector(7 downto 0);                    -- export
			seg_sw_export  : out std_logic_vector(3 downto 0);                    -- export
			sw_export      : in  std_logic_vector(2 downto 0) := (others => 'X')  -- export
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk        => CONNECTED_TO_clk_clk,        --     clk.clk
			led_export     => CONNECTED_TO_led_export,     --     led.export
			reset_reset_n  => CONNECTED_TO_reset_reset_n,  --   reset.reset_n
			seg_seg_export => CONNECTED_TO_seg_seg_export, -- seg_seg.export
			seg_sw_export  => CONNECTED_TO_seg_sw_export,  --  seg_sw.export
			sw_export      => CONNECTED_TO_sw_export       --      sw.export
		);

