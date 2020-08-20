-- Project:			maximator-Tutorial-10
-- File:				encoder.vhd
-- Version:			1.0 (03.08.2018)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	encoder driver

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity ENCODER is
	port (	
				--avalon memory-mapped slave
				clk			: in std_logic;
				reset_n		: in std_logic;
				address		: in std_logic_vector(0 downto 0);
				byteenable	: in std_logic_vector(3 downto 0);
				read		: in std_logic;
				readdata	: out std_logic_vector(31 downto 0);
				write		: in std_logic;
				writedata	: in std_logic_vector(31 downto 0);
				
				--display exported interface
				encoderAB	: in std_logic_vector(1 downto 0)
		);
end ENCODER;

architecture basic of ENCODER is
	component DEBOUNCE is
		port (	
					-- zegar
					clk				: in std_logic;
					-- wejście
					signalIn		: in std_logic;
					-- wyjście
					signalOut		: out std_logic;
					-- wejście do ustawiania czasu eliminacji drgań styków
					debounceTime	: in std_logic_vector(31 downto 0)

			);
	end component DEBOUNCE;
	-- rejestr do zatrzaskiwania danych wyjściowych celem prawidłowej synchronizacji
	signal readdataBuffer	: std_logic_vector(31 downto 0);
	-- 
	signal counter			: std_logic_vector(31 downto 0);
	-- 
	signal debounceTime		: std_logic_vector(31 downto 0);
	-- 
	signal encoderA			: std_logic;
	signal encoderB			: std_logic;
	-- 
	signal p1A				: std_logic;
	signal p1B				: std_logic;
	signal p2A				: std_logic;
	signal p2B				: std_logic;
	-- 
	signal risingA			: std_logic;
	signal risingB			: std_logic;
	signal fallingA			: std_logic;
	signal fallingB			: std_logic;
begin
	debounceA : component debounce
		port map (
			clk				=>clk,
			signalIn		=>encoderAB(0),
			signalOut		=>encoderA,
			debounceTime	=>debounceTime
		);
		
	debounceB : component debounce
		port map (
			clk				=>clk,
			signalIn		=>encoderAB(1),
			signalOut		=>encoderB,
			debounceTime	=>debounceTime
		);
		
	
	risingA <= (not p1A) and p2A;
	fallingA <= p1A and (not p2A);
	
	risingB <= (not p1B) and p2B;
	fallingB <= p1B and (not p2B);
	-- układ ma być wrażliwy na zmiany na poniżej wymienionych liniach
	process(clk, reset_n) is
	begin
		-- jeśli linia reset w stanie niskim
		if reset_n = '0' then
			debounceTime		<= (others => '0');
			counter				<= (others => '0');
		-- jeśli opadające zbocze zegara
		elsif falling_edge(clk) then
			-- zatrzaskujemy sygnały po eliminacji drgań styków celem wykrycia zbocz
			p2A <= p1A;
			p1A <= encoderA;
			
			p2B <= p1B;
			p1B <= encoderB;
			
			-- obsługa enkodera i zmiana wartości licznika
			if risingA = '1' then
				if p2B = '1' then
					counter <= counter + 1;
				else
					counter <= counter - 1;
				end if;
			elsif fallingA = '1' then
				if p2B = '1' then
					counter <= counter - 1;
				else
					counter <= counter + 1;
				end if;
			elsif risingB = '1' then
				if p2A = '1' then
					counter <= counter - 1;
				else
					counter <= counter + 1;
				end if;
			elsif fallingB = '1' then
				if p2A = '1' then
					counter <= counter + 1;
				else
					counter <= counter - 1;
				end if;
			end if;
			
			-- obsługa magistrali Avalon-MM - zapis do układu z uwzględnieniem linii byteenable
			if write = '1' then
				-- pod adresem 0 rejestr licznika
				if address = std_logic_vector(to_unsigned(0,address'length)) then
					if byteenable(0) = '1' then
						counter(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						counter(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then
						counter(23 downto 16) <= writedata(23 downto 16);
					end if;
					if byteenable(3) = '1' then
						counter(31 downto 24) <= writedata(31 downto 24);
					end if;
				end if;
				-- pod adresem 1 rejestr czasu eliminacji drgań styków
				if address = std_logic_vector(to_unsigned(1,address'length)) then
					if byteenable(0) = '1' then
						debounceTime(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						debounceTime(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then
						debounceTime(23 downto 16) <= writedata(23 downto 16);
					end if;
					if byteenable(3) = '1' then
						debounceTime(31 downto 24) <= writedata(31 downto 24);
					end if;
				end if;
			end if;
			-- obsługa magistrali Avalon-MM - odczyt z układu
			if read = '1' then
				if address = std_logic_vector(to_unsigned(0,address'length)) then
					readdataBuffer <= counter;
				end if;
				if address = std_logic_vector(to_unsigned(1,address'length)) then
					readdataBuffer <= debounceTime;
				end if;
				if address > std_logic_vector(to_unsigned(1,address'length)) then
					readdataBuffer <= (others => '0');
				end if;
			end if;
		-- jeśli narastające zbocze zegara - zatrzaskujemy dane wyjściowe (zgodnie z oczekiwanym timingiem)
		elsif rising_edge(clk) then
			readdata <= readdataBuffer;
		end if;
	end process;
end basic;
