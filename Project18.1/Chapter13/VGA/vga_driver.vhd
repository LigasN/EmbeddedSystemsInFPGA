-- Project:			Tutorial13
-- File:				vga_driver.vhd
-- Version:			1.3 (15.12.2018)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	Generates VGA signals and pixel address


library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity vga_driver is
--deklarujemy parametry modułu, któRe potem będzie można zmienić
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
--poniżej standardowa deklaracja portów
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
end vga_driver;

architecture basic of vga_driver is
	signal px_counter 		: integer := 0;
	signal line_counter 	: integer := 0;
	signal vga_r_int 		: std_logic;
	signal vga_g_int 		: std_logic;
	signal vga_b_int 		: std_logic;
	signal vga_blank_n 		: std_logic;
	signal vga_vs_n_int 	: std_logic;
	signal vga_hs_n_int 	: std_logic;
	signal px_addr_int 		: integer := 0;
	signal px_addr_int_inc 	: integer := 0;
begin
	--do wyjść przypisujemy sygnały koloróW bramkowane sygnałami synchronizacji (kolor czarny w czasie synchronizacji)
	vga_r <= vga_r_int and (vga_vs_n_int and vga_hs_n_int and vga_blank_n);
	vga_g <= vga_g_int and (vga_vs_n_int and vga_hs_n_int and vga_blank_n);
	vga_b <= vga_b_int and (vga_vs_n_int and vga_hs_n_int and vga_blank_n);
	
	vga_hs_n <= vga_hs_n_int;
	vga_vs_n <= vga_vs_n_int;
	
	
	--obliczamy adres piksela (XY) na podstawie jego "numeru"
	px_addr_int_inc <= px_addr_int + PIXEL_OFFSET;
	
	px_addr_col <= std_logic_vector(to_unsigned((px_addr_int_inc mod PX_WIDTH), px_addr_col'length));
	px_addr_row <= std_logic_vector(to_unsigned((px_addr_int_inc / PX_WIDTH), px_addr_row'length));
	
	--obsługa sygnałów clk i reset
	process(clk, rst_n)
	begin
	--co reset robi wiadomo
		if rst_n='0' then
			px_counter <= 0;
			line_counter <= 0;
			px_addr_int <= 0;
	--na opadającym zboczu zegara
		elsif falling_edge(clk) then
			--jeśli numer piksela w linii jest w zakresie aktywnego obrazu...
			if px_counter<PX_WIDTH then--data
			--...oraz linia także jest w tym zakresie
				if line_counter<LINE_HEIGHT then
					-- to zatrzaskujemy kolor i wyłączamy wszelkie sygnały "blank"
					vga_r_int <= vga_in(0);
					vga_g_int <= vga_in(1);
					vga_b_int <= vga_in(2);
					-- tu zliczamy tylko piksele wewnątrz obszaru aktywnego
					px_addr_int <= px_addr_int + 1;
					
					vga_blank_n <= '1';
					vga_hs_n_int <= '1';
				else
					-- jeśli linia poza oszarem aktywnym - włączamy "blank" - kolor czarny
					vga_blank_n <= '0';
					vga_hs_n_int <= '1';
				end if;
				--a tu zliczamy piksele gdziekolwiek
				px_counter <= px_counter + 1;
			-- poniższy zestaw warunkóW zajmuje się generowaniem impulsu HS oraz aktywacją na ten czas "blank"
			elsif px_counter<(PX_WIDTH+PX_FRONT_PORCH) then--front porch
				vga_blank_n <= '0';
				px_counter <= px_counter + 1;
			elsif px_counter<(PX_WIDTH+PX_FRONT_PORCH+PX_SYNC_PULSE) then--HS
				vga_blank_n <= '0';
				vga_hs_n_int <= '0';
				px_counter <= px_counter + 1;
			elsif px_counter<(PX_WIDTH+PX_FRONT_PORCH+PX_SYNC_PULSE+PX_BACK_PORCH-1) then--back porch
				vga_blank_n <= '0';
				vga_hs_n_int <= '1';
				px_counter <= px_counter + 1;
			else
			--ten warunek wykona się tylko dla ostatniego piksela w linii (patrz na -1 powyżej)
				px_counter <= 0;
				--powyżej reset licznika pikseli w linii
				--a poniżej obsługa zliczania linii i synchronizacji pionowej
				if line_counter<LINE_HEIGHT then--video
					line_counter <= line_counter + 1;
					vga_vs_n_int <= '1';
				elsif line_counter<(LINE_HEIGHT+LINE_FRONT_PORCH) then--front porch
					line_counter <= line_counter + 1;
				elsif line_counter<(LINE_HEIGHT+LINE_FRONT_PORCH+LINE_SYNC_PULSE) then--vs
					line_counter <= line_counter + 1;
					vga_vs_n_int <= '0';
				elsif line_counter<(LINE_HEIGHT+LINE_FRONT_PORCH+LINE_SYNC_PULSE+LINE_BACK_PORCH-1) then--back porch
					line_counter <= line_counter + 1;
					vga_vs_n_int <= '1';
				else
					line_counter <= 0;
					px_addr_int <= 0;
				end if;
			end if;
			
			
		end if;
	end process;
end basic;