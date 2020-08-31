-- Project:			Tutorial14
-- File:				HDMIDriver.vhd
-- Version:			1.0 (01.01.2019)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	Based on code by Piotr Chodorowski

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY HDMIDriver IS
--deklarujemy parametry modułu, któRe potem będzie można zmienić
	generic(
				PX_WIDTH				: integer := 640;
				PX_FRONT_PORCH		: integer := 16;
				PX_SYNC_PULSE		: integer := 96;
				PX_BACK_PORCH		: integer := 48;
				LINE_HEIGHT			: integer := 480;
				LINE_FRONT_PORCH	: integer := 10;
				LINE_SYNC_PULSE	: integer := 2;
				LINE_BACK_PORCH	: integer := 33
	);
	port (	
				--interface
				px_addr_col	: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
				px_addr_row	: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
				red_in		: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
				green_in		: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
				blue_in		: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
				
				--HDMI clocks
				HDMI_CLKPX		: IN STD_LOGIC;
				HDMI_CLKOUT		: IN STD_LOGIC;
				--HDMI exported interface
				HDMI_TMDS_CLK	: OUT STD_LOGIC;
				HDMI_TMDS		: OUT STD_LOGIC_VECTOR(2 downto 0)
		);
END HDMIDriver;


ARCHITECTURE Mixed OF HDMIDriver IS
	
	component TMDS is port(
	clk      : in  STD_LOGIC;								-- pixel clock
	vd_en    : in  STD_LOGIC;								-- display area indication (1=display, 0=control data)
	ctrl     : in  STD_LOGIC_VECTOR(1 downto 0);		-- sync (in blue channel) vSync & hSync
	data_in  : in  STD_LOGIC_VECTOR(7 downto 0);		-- 8-bit color data in
	data_out : out STD_LOGIC_VECTOR(9 downto 0)		-- 10-bit encoded data out
	);
	end component;
	
	component LVDS is
		port (
			tx_in  : in  std_logic := '0'; --  tx_in.tx_in
			tx_out : out std_logic         -- tx_out.tx_out
		);
	end component LVDS;
	
	signal TMDS_R : STD_LOGIC_VECTOR(9 downto 0);
	signal TMDS_G : STD_LOGIC_VECTOR(9 downto 0);
	signal TMDS_B : STD_LOGIC_VECTOR(9 downto 0);
	
	signal TMDS_R_Reg : STD_LOGIC_VECTOR(9 downto 0);
	signal TMDS_G_Reg : STD_LOGIC_VECTOR(9 downto 0);
	signal TMDS_B_Reg : STD_LOGIC_VECTOR(9 downto 0);
	
	signal TMDS_Reg_counter : integer range 0 to 10;
	signal TMDS_load			: STD_LOGIC;
	
	signal blank_n		: STD_LOGIC;
	signal hdmi_hs		: STD_LOGIC;
	signal hdmi_vs		: STD_LOGIC;
	
	signal counterX	: integer range 0 to (PX_WIDTH + PX_FRONT_PORCH + PX_SYNC_PULSE + PX_BACK_PORCH + 1);
	signal counterY	: integer range 0 to (LINE_HEIGHT + LINE_FRONT_PORCH + LINE_SYNC_PULSE + LINE_BACK_PORCH + 1);
	
BEGIN	

	-- generujemy odpowiednie sygnały synchronizacyjne i udostępniami adres piksela
	HDMI_PX_COUNT: process(HDMI_CLKPX)
	begin
		if falling_edge(HDMI_CLKPX) then
			
			-- obsługujemy licznik adresu X i Y oraz udostępniamy go na porcie wyjściowym
			-- i w razie potrzeby udostępniamy wartość powiększoną o 1 lub zerową, aby zawsze
			-- prezentować adres piksela, który ma zostać obsłużony w następnym cyklu
			if counterX = (PX_WIDTH + PX_FRONT_PORCH + PX_SYNC_PULSE + PX_BACK_PORCH - 1) then
				counterX <= 0;
				px_addr_col <= std_logic_vector(to_unsigned(0, px_addr_col'length));
				if counterY = (LINE_HEIGHT + LINE_FRONT_PORCH + LINE_SYNC_PULSE + LINE_BACK_PORCH - 1) then
					counterY <= 0;
					px_addr_row <= std_logic_vector(to_unsigned(0, px_addr_row'length));
				else
					counterY <= counterY + 1;
					if counterY < LINE_HEIGHT then
						px_addr_row <= std_logic_vector(to_unsigned(counterY + 1, px_addr_row'length));
					else
						px_addr_row <= std_logic_vector(to_unsigned(0, px_addr_row'length));
					end if;
				end if;
			else
				counterX <= counterX + 1;
				if counterX < PX_WIDTH then
					px_addr_col <= std_logic_vector(to_unsigned(counterX + 1, px_addr_col'length));
				else
					px_addr_col <= std_logic_vector(to_unsigned(0, px_addr_col'length));
					if counterY < LINE_HEIGHT then
						px_addr_row <= std_logic_vector(to_unsigned(counterY + 1, px_addr_row'length));
					else
						px_addr_row <= std_logic_vector(to_unsigned(0, px_addr_row'length));
					end if;
				end if;
			end if;
			
			-- Generujemy w odpowiednich momentach sygnały synchronizacji oraz sygnał sygnalizujący aktywną część obrazu
			
			if counterX < PX_WIDTH AND counterY < LINE_HEIGHT then
				blank_n <= '1';
			else
				blank_n <= '0';
			end if;

			if counterX >= (PX_WIDTH + PX_FRONT_PORCH) AND counterX < (PX_WIDTH + PX_FRONT_PORCH + PX_SYNC_PULSE) then
				hdmi_hs <= '1';
			else
				hdmi_hs <= '0';
			end if;

			if counterY >= (LINE_HEIGHT + LINE_FRONT_PORCH) AND counterY < (LINE_HEIGHT + LINE_FRONT_PORCH + LINE_SYNC_PULSE) then
				hdmi_vs <= '1';
			else
				hdmi_vs <= '0';
			end if;
		end if;
	end process;

	-- kodery TMDS, kodowanie sygnałów synchronizacji w kanale koloru niebieskiego
	R_TMDS: TMDS port map(
		clk		=> HDMI_CLKPX,
		vd_en		=> blank_n,
		ctrl		=> "00",
		data_in	=> red_in,
		data_out	=>	TMDS_R
	);
	
	G_TMDS: TMDS port map(
		clk		=> HDMI_CLKPX,
		vd_en		=> blank_n,
		ctrl		=> "00",
		data_in	=> green_in,
		data_out	=>	TMDS_G
	);
	
	B_TMDS: TMDS port map(
		clk		=> HDMI_CLKPX,
		vd_en		=> blank_n,
		ctrl		=> hdmi_vs & hdmi_hs,
		data_in	=> blue_in,
		data_out	=>	TMDS_B
	);
	
	-- rejestr przesówny nadający dane TMDS z częstotliwością 250MHz
	TMDS_Shift: process(HDMI_CLKOUT)
	begin
		if falling_edge(HDMI_CLKOUT) then
			if TMDS_Reg_counter = 9 then
				TMDS_load <= '1';
				TMDS_Reg_counter <= 0;
			else
				TMDS_load <= '0';
				TMDS_Reg_counter <= TMDS_Reg_counter + 1;
			end if;
 
			if TMDS_load = '1' then
				TMDS_R_Reg <= TMDS_R;
				TMDS_G_Reg <= TMDS_G;
				TMDS_B_Reg <= TMDS_B;
			else
				TMDS_R_Reg <= '0' & TMDS_R_Reg(9 downto 1);
				TMDS_G_Reg <= '0' & TMDS_G_Reg(9 downto 1);
				TMDS_B_Reg <= '0' & TMDS_B_Reg(9 downto 1);
			end if;

		end if;
	end process;
	
	-- generowanie sygnałów różnicowych
	CLK_LVDS: LVDS port map(
		tx_in		=>	HDMI_CLKPX,
		tx_out	=> HDMI_TMDS_CLK
	);
	
	B_LVDS: LVDS port map(
		tx_in		=>	TMDS_B_Reg(0),
		tx_out	=> HDMI_TMDS(0)
	);
	
	G_LVDS: LVDS port map(
		tx_in		=>	TMDS_G_Reg(0),
		tx_out	=> HDMI_TMDS(1)
	);
	
	R_LVDS: LVDS port map(
		tx_in		=>	TMDS_R_Reg(0),
		tx_out	=> HDMI_TMDS(2)
	);
	
END Mixed;
