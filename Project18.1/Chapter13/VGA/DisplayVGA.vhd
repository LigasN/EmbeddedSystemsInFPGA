-- Project:			Tutorial13
-- File:			DisplayVGA.vhd
-- Version:			1.0 (05.11.2018)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DisplayVGA IS
	PORT (	
				--avalon Memory-Mapped slave
				clk			: IN STD_LOGIC;
				reset_n		: IN STD_LOGIC;
				address		: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
				byteenable	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				read		: IN STD_LOGIC;
				readdata	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				write		: IN STD_LOGIC;
				writedata	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				
				--VGA exported interface
				VGA_CLK		: IN STD_LOGIC;
				VGA_R		: OUT STD_LOGIC;
				VGA_G		: OUT STD_LOGIC;
				VGA_B		: OUT STD_LOGIC;
				VGA_HS		: OUT STD_LOGIC;
				VGA_VS		: OUT STD_LOGIC
		);
END DisplayVGA;


ARCHITECTURE Structure OF DisplayVGA IS
	
	component vga_driver is
		generic(
			PX_WIDTH			: integer := 800;
			PX_FRONT_PORCH		: integer := 40;
			PX_SYNC_PULSE		: integer := 128;
			PX_BACK_PORCH		: integer := 88;
			LINE_HEIGHT			: integer := 600;
			LINE_FRONT_PORCH	: integer := 1;
			LINE_SYNC_PULSE		: integer := 4;
			LINE_BACK_PORCH		: integer := 23;
			PIXEL_OFFSET		: integer := 0
		);
		port(
			vga_r			: out 	std_logic;
			vga_g			: out 	std_logic;
			vga_b			: out 	std_logic;
			vga_in			: in 	std_logic_vector(2 downto 0);
			vga_hs_n		: out 	std_logic;
			vga_vs_n		: out 	std_logic;
			px_addr_col		: out 	std_logic_vector(12 downto 0);
			px_addr_row		: out 	std_logic_vector(12 downto 0);
			clk				: in 	std_logic;
			rst_n			: in 	std_logic
		);
	end component vga_driver;
	
	component divider IS
		PORT
		(
			denom			: IN 	STD_LOGIC_VECTOR (2 DOWNTO 0);
			numer			: IN 	STD_LOGIC_VECTOR (11 DOWNTO 0);
			quotient		: OUT 	STD_LOGIC_VECTOR (11 DOWNTO 0);
			remain			: OUT 	STD_LOGIC_VECTOR (2 DOWNTO 0)
		);	
	end component divider;
	
	component multiplier6 IS
		PORT
		(
			dataa		: IN 	STD_LOGIC_VECTOR (6 DOWNTO 0);
			result		: OUT 	STD_LOGIC_VECTOR (9 DOWNTO 0)
		);
	end component multiplier6;
	
	component multiplier85 IS
		PORT
		(
			dataa		: IN 	STD_LOGIC_VECTOR (8 DOWNTO 0);
			result		: OUT 	STD_LOGIC_VECTOR (16 DOWNTO 0)
		);
	end component multiplier85;
	
	component fontROM IS
		PORT
		(	
			address			: IN 	STD_LOGIC_VECTOR (9 DOWNTO 0);
			clock			: IN 	STD_LOGIC  := '1';
			q				: OUT 	STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	end component fontROM;
	
	component charRAM IS
		PORT
		(
			data		: IN 	STD_LOGIC_VECTOR (6 DOWNTO 0);
			rdaddress	: IN 	STD_LOGIC_VECTOR (11 DOWNTO 0);
			rdclock		: IN 	STD_LOGIC ;
			wraddress	: IN 	STD_LOGIC_VECTOR (11 DOWNTO 0);
			wrclock		: IN 	STD_LOGIC  := '1';
			wren		: IN 	STD_LOGIC  := '0';
			q			: OUT 	STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	end component charRAM;
	
	
	
	signal writedata_reg	:std_logic_vector(31 downto 0);
	signal write_reg		:std_logic;
	signal address_reg		:std_logic_vector(9 downto 0);
	signal byteenable_reg	:std_logic_vector(3 downto 0);
	
	signal chr_ram_wraddr	:std_logic_vector(11 downto 0);
	signal chr_ram_wrdata	:std_logic_vector(6 downto 0);
	
	signal px_data 			:std_logic_vector(2 downto 0);
	signal px_data_blank	:std_logic_vector(2 downto 0);

	signal px_addr_col		:std_logic_vector(12 downto 0);
	signal px_addr_row		:std_logic_vector(12 downto 0);
	
	signal chr_addr_col		:std_logic_vector(11 downto 0);
	signal chr_addr_row		:std_logic_vector(8 downto 0);
	
	signal chrpx_addr_col	:std_logic_vector(2 downto 0);
	signal chrpx_addr_row	:std_logic_vector(2 downto 0);
	
	signal char_ascii		:std_logic_vector(6 downto 0);
	signal char_ascii_reg	:std_logic_vector(6 downto 0);
	
	signal font_rom_base	:std_logic_vector(9 downto 0);
	
	signal font_rom_addr	:std_logic_vector(9 downto 0);
	signal font_rom_addr_reg:std_logic_vector(9 downto 0);
	
	signal font_column		:std_logic_vector(7 downto 0);
	
	signal char_ram_addr	:std_logic_vector(11 downto 0);
	
	signal char_ram_base	:std_logic_vector(16 downto 0);
	
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
	process(vga_clk) is
	begin
		if falling_edge(vga_clk) then
			char_ascii <= char_ascii_reg;
		end if;
	end process;
	
	-- dzielenie z resztą przez 6
	DIV_COL : divider
		port map(
			denom 	=> std_logic_vector(to_unsigned(6,3)),
			-- dzięki "downto 1" mamy dzielenie na 2
			numer 	=> px_addr_col(12 downto 1),
			quotient => chr_addr_col,
			remain 	=> chrpx_addr_col
		);

		
	-- dzielenie z resztą przez 8 (i podobnie jak powyżej przesunięcie o 1 bit aby podzielić na 2)
	-- div 8	
	chr_addr_row(8 downto 0) <= px_addr_row(12 downto 4);
	-- mod 8
	chrpx_addr_row <= px_addr_row(3 downto 1);
	
	-- mnożenie x6 (adres początku wzoru znaku w pamięci ROM
	multiplier6_inst : multiplier6 PORT MAP (
		dataa		=> char_ascii,
		result	=> font_rom_base
	);
	
	-- sumowanie - obliczenie adresu w pamięci wzorów znaków na podstawie kodu znaku oraz aktualnej kolumny
	font_rom_addr <= std_logic_vector(unsigned(font_rom_base) + unsigned(chrpx_addr_col));
	
	-- pamięć ROM ze wzorami znaków
	fontROM_inst : fontROM PORT MAP (
		address	=> font_rom_addr,
		clock	 	=> vga_clk,
		q			=> font_column
	);
	
	-- mnożenie x85 (ilość znaków w linii) w celu wyliczenia adresu w pamięci
	multiplier85_inst : multiplier85 PORT MAP (
		dataa		=> chr_addr_row,
		result	=> char_ram_base
	);
	
	-- finalne obliczanie adresu w pamięci oraz zwiększanie go o 1 jeśli konieczne (patrz wyszczególniony na szaro blok dodawania na schemacie)
	char_ram_addr <=		std_logic_vector(unsigned(char_ram_base(11 downto 0)) + unsigned(chr_addr_col) + 1) 
								when chrpx_addr_col = std_logic_vector(to_unsigned(5,3)) 
								else
								std_logic_vector(unsigned(char_ram_base(11 downto 0)) + unsigned(chr_addr_col));

	-- wybór odpowiedniego bitu z kolumny stanowiącej fragment wzoru znaku (Bit select)
	px_data(0) <= font_column(to_integer(unsigned(chrpx_addr_row)));
	px_data(1) <= font_column(to_integer(unsigned(chrpx_addr_row)));
	px_data(2) <= font_column(to_integer(unsigned(chrpx_addr_row)));
	
	-- ochrona przed wyświetlaniem kawałka znaku przy prawej krawędzi ekranu
	px_data_blank <=	px_data when to_integer(unsigned(chr_addr_col)) <= 84 else
							"000";
	
	-- adres do zapisu pamięci ram znaków na podstawie danych z magistrali AVALON z uwzględnieniem lini byteenable w celu adresowania bajt po bajcie
	chr_ram_wraddr(11 downto 2) <= address_reg(9 downto 0);
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
	charRAM_inst : charRAM PORT MAP (
		data			=> chr_ram_wrdata,
		rdaddress		=> char_ram_addr,
		rdclock			=> vga_clk,
		wraddress		=> chr_ram_wraddr,
		wrclock			=> clk,
		wren			=> write_reg,
		q				=> char_ascii_reg
	);


	-- driver VGA we własnej osobie
	VGA1 : vga_driver
		generic map(
			PX_WIDTH			=> 1024,
			PX_FRONT_PORCH		=> 24,
			PX_SYNC_PULSE		=> 136,
			PX_BACK_PORCH		=> 160,
			LINE_HEIGHT			=> 768,
			LINE_FRONT_PORCH	=> 3,
			LINE_SYNC_PULSE		=> 6,
			LINE_BACK_PORCH		=> 29,
			PIXEL_OFFSET		=> 0
		)
		port map(
			vga_r			=> vga_r,
			vga_g			=> vga_g,
			vga_b			=> vga_b,
			vga_in			=> px_data_blank,
			vga_hs_n		=> vga_hs,
			vga_vs_n		=> vga_vs,
			px_addr_col		=> px_addr_col,
			px_addr_row		=> px_addr_row,
			clk				=> vga_clk,
			rst_n			=> reset_n
		);
	
END Structure;
