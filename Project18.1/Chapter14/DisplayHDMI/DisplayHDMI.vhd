-- Project:			Tutorial14
-- File:				DisplayHDMI.vhd
-- Version:			1.0 (01.01.2019)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	HDMI 640x480 character display

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DisplayHDMI IS
	PORT (	
				--avalon Memory-Mapped slave
				clk			: IN STD_LOGIC;
				reset_n		: IN STD_LOGIC;
				address		: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
				byteenable	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				read			: IN STD_LOGIC;
				readdata		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				write			: IN STD_LOGIC;
				writedata	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				
				--HDMI clocks
				HDMI_CLK25		: IN STD_LOGIC;
				HDMI_CLK250		: IN STD_LOGIC;
				--HDMI exported interface
				HDMI_TMDS_CLK	: OUT STD_LOGIC;
				HDMI_TMDS		: OUT STD_LOGIC_VECTOR(2 downto 0)
		);
END DisplayHDMI;


ARCHITECTURE Structure OF DisplayHDMI IS
	
	COMPONENT HDMIDriver IS
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
	END COMPONENT;
	
	component dividerHDMI IS
		PORT
		(
			denom			: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			numer			: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
			quotient		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
			remain		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		);
	end component dividerHDMI;
	
	component multiplier6HDMI IS
		PORT
		(
			dataa		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
		);
	end component multiplier6HDMI;
	
	component multiplier106HDMI IS
		PORT
		(
			dataa		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (16 DOWNTO 0)
		);
	end component multiplier106HDMI;
	
	component fontROMHDMI IS
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			clock			: IN STD_LOGIC  := '1';
			q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	end component fontROMHDMI;
	
	component charRAMHDMI IS
		PORT
		(
			data		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			rdaddress		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			rdclock		: IN STD_LOGIC ;
			wraddress		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			wrclock		: IN STD_LOGIC  := '1';
			wren		: IN STD_LOGIC  := '0';
			q		: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	end component charRAMHDMI;
	
	
	
	signal writedata_reg	:std_logic_vector(31 downto 0);
	signal write_reg		:std_logic;
	signal address_reg	:std_logic_vector(10 downto 0);
	signal byteenable_reg:std_logic_vector(3 downto 0);
	
	signal chr_ram_wraddr:std_logic_vector(12 downto 0);
	signal chr_ram_wrdata:std_logic_vector(6 downto 0);
	
	signal px_data 		:std_logic_vector(2 downto 0);
	signal px_data_blank	:std_logic_vector(2 downto 0);

	signal px_addr_col	:std_logic_vector(12 downto 0);
	signal px_addr_row	:std_logic_vector(12 downto 0);
	
	signal chr_addr_col	:std_logic_vector(11 downto 0);
	signal chr_addr_row	:std_logic_vector(8 downto 0);
	
	signal chrpx_addr_col:std_logic_vector(2 downto 0);
	signal chrpx_addr_row:std_logic_vector(2 downto 0);
	
	signal char_ascii		:std_logic_vector(6 downto 0);
	signal char_ascii_reg:std_logic_vector(6 downto 0);
	
	signal font_rom_base	:std_logic_vector(9 downto 0);
	
	signal font_rom_addr	:std_logic_vector(9 downto 0);
	signal font_rom_addr_reg	:std_logic_vector(9 downto 0);
	
	signal font_column	:std_logic_vector(7 downto 0);
	
	signal char_ram_addr	:std_logic_vector(12 downto 0);
	
	signal char_ram_base	:std_logic_vector(16 downto 0);

	signal red_in			:std_logic_vector(7 downto 0);
	signal green_in		:std_logic_vector(7 downto 0);
	signal blue_in			:std_logic_vector(7 downto 0);
	
BEGIN	

	readdata <= (others => '0');
	
	process(clk) is
	begin
		if falling_edge(clk) then
		-- na zboczu opadającym zatrzaskujemy dane z interfejsu AVALON
			address_reg <= address;
			writedata_reg <= writedata;
			byteenable_reg <= byteenable;
			case byteenable is
				when "0001" => write_reg <= write;
				when "0010" => write_reg <= write;
				when "0100" => write_reg <= write;
				when "1000" => write_reg <= write;
				when others => write_reg <= '0';
			end case;
		end if;
	end process;
	
	-- zatrzaskujemy na zboczu opadającym zegara VGA kod ASCII - patrz szara przerywana linia na schemacie
	process(HDMI_CLK25) is
	begin
		if falling_edge(HDMI_CLK25) then
			char_ascii <= char_ascii_reg;
		end if;
	end process;
	
	-- dzielenie z resztą przez 6
	DIV_COL : dividerHDMI
		port map(
			denom 	=> std_logic_vector(to_unsigned(6,3)),
			numer 	=> px_addr_col(11 downto 0),
			quotient => chr_addr_col,
			remain 	=> chrpx_addr_col
		);

		
	-- dzielenie z resztą przez 8
	-- div 8	
	chr_addr_row(8 downto 0) <= px_addr_row(11 downto 3);
	-- mod 8
	chrpx_addr_row <= px_addr_row(2 downto 0);
	
	-- mnożenie x6 (adres początku wzoru znaku w pamięci ROM
	multiplier6_inst : multiplier6HDMI PORT MAP (
		dataa		=> char_ascii,
		result	=> font_rom_base
	);
	
	-- sumowanie - obliczenie adresu w pamięci wzorów znaków na podstawie kodu znaku oraz aktualnej kolumny
	font_rom_addr <= std_logic_vector(unsigned(font_rom_base) + unsigned(chrpx_addr_col));
	
	-- pamięć ROM ze wzorami znaków
	fontROM_inst : fontROMHDMI PORT MAP (
		address	=> font_rom_addr,
		clock	 	=> HDMI_CLK25,
		q			=> font_column
	);
	
	-- mnożenie x106 (ilość znaków w linii) w celu wyliczenia adresu w pamięci
	multiplier106_inst : multiplier106HDMI PORT MAP (
		dataa		=> chr_addr_row,
		result	=> char_ram_base
	);
	
	-- finalne obliczanie adresu w pamięci oraz zwiększanie go o 1 jeśli konieczne (patrz wyszczególniony na szaro blok dodawania na schemacie)
	char_ram_addr <=		std_logic_vector(unsigned(char_ram_base(12 downto 0)) + unsigned(chr_addr_col) + 1) 
								when chrpx_addr_col = std_logic_vector(to_unsigned(5,3)) 
								else
								std_logic_vector(unsigned(char_ram_base(12 downto 0)) + unsigned(chr_addr_col) + 0);

	-- wybór odpowiedniego bitu z kolumny stanowiącej fragment wzoru znaku (Bit select)
	px_data(0) <= font_column(to_integer(unsigned(chrpx_addr_row)));
	px_data(1) <= font_column(to_integer(unsigned(chrpx_addr_row)));
	px_data(2) <= font_column(to_integer(unsigned(chrpx_addr_row)));
	
	-- ochrona przed wyświetlaniem kawałka znaku przy prawej krawędzi ekranu
	px_data_blank <=	px_data when to_integer(unsigned(chr_addr_col)) <= 105 else
							"000";
							
	red_in <= (others =>px_data_blank(0));
	green_in <= (others =>px_data_blank(1));
	blue_in <= (others =>px_data_blank(2));
	
	-- adres do zapisu pamięci ram znaków na podstawie danych z magistrali AVALON z wuzględnieniem lini byteenable w celu adresowania bajt po bajcie
	chr_ram_wraddr(12 downto 2) <= address_reg(10 downto 0);
	chr_ram_wraddr(1 downto 0) <= 	"00" when byteenable(0) = '1' else
												"01" when byteenable(1) = '1' else
												"10" when byteenable(2) = '1' else
												"11" when byteenable(3) = '1';
	-- odpowiednie wybranie danych z magistrali z uwzględnieniem lini byteenable
	chr_ram_wrdata <=	writedata_reg(6 downto 0) when byteenable_reg(0) = '1' else
								writedata_reg(14 downto 8) when byteenable_reg(1) = '1' else
								writedata_reg(22 downto 16) when byteenable_reg(2) = '1' else
								writedata_reg(30 downto 24) when byteenable_reg(3) = '1';
	
	-- 2 portowa pamięć ram znaków (zawartości ekranu)
	charRAM_inst : charRAMHDMI PORT MAP (
		data			=> chr_ram_wrdata,
		rdaddress	=> char_ram_addr,
		rdclock		=> HDMI_CLK25,
		wraddress	=> chr_ram_wraddr,
		wrclock		=> clk,
		wren			=> write_reg,
		q				=> char_ascii_reg
	);


	HDMI: HDMIDriver 
		generic map(
			PX_WIDTH				=> 640,
			PX_FRONT_PORCH		=> 16,
			PX_SYNC_PULSE		=> 96,
			PX_BACK_PORCH		=> 48,
			LINE_HEIGHT			=> 480,
			LINE_FRONT_PORCH	=> 10,
			LINE_SYNC_PULSE	=> 2,
			LINE_BACK_PORCH	=> 33
		)
		port map(
			--interface
			px_addr_col	=> px_addr_col,
			px_addr_row	=> px_addr_row,
			red_in		=> red_in,
			green_in		=> green_in,
			blue_in		=> blue_in,
			
			--HDMI clocks
			HDMI_CLKPX		=> HDMI_CLK25,
			HDMI_CLKOUT		=> HDMI_CLK250,
			--HDMI exported interface
			HDMI_TMDS_CLK	=>HDMI_TMDS_CLK, 
			HDMI_TMDS		=>HDMI_TMDS
		);
	
END Structure;
