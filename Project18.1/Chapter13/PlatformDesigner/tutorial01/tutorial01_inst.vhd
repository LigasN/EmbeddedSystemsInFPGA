	component tutorial01 is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			led_export    : out std_logic_vector(3 downto 0);        -- export
			reset_reset_n : in  std_logic                    := 'X'; -- reset_n
			vga_b         : out std_logic;                           -- b
			vga_g         : out std_logic;                           -- g
			vga_hs        : out std_logic;                           -- hs
			vga_r         : out std_logic;                           -- r
			vga_vs        : out std_logic                            -- vs
		);
	end component tutorial01;

	u0 : component tutorial01
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			led_export    => CONNECTED_TO_led_export,    --   led.export
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			vga_b         => CONNECTED_TO_vga_b,         --   vga.b
			vga_g         => CONNECTED_TO_vga_g,         --      .g
			vga_hs        => CONNECTED_TO_vga_hs,        --      .hs
			vga_r         => CONNECTED_TO_vga_r,         --      .r
			vga_vs        => CONNECTED_TO_vga_vs         --      .vs
		);

