-- Project:			maximator-Tutorial-10
-- File:				debounce.vhd
-- Version:			1.0 (03.08.2018)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	Signal debouncing

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity DEBOUNCE is
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
end DEBOUNCE;

architecture basic of DEBOUNCE is
	-- rejestr licznika
	signal counter	: std_logic_vector(31 downto 0);
	-- rejestry do zatrzaskiwania poprzedniego stanu wejścia
	signal p1		: std_logic;
	signal p2		: std_logic;
begin
	-- układ ma być wrażliwy na zmiany na poniżej wymienionych liniach
	process(clk) is
	begin
		-- jeśli opadające zbocze zegara
		if falling_edge(clk) then
			-- zatrzaksujemy poprzedni stan w p2
			p2 <= p1;
			-- a aktualny w p1
			p1 <= signalIn;
			-- jeśli było zbocze (zmiana)
			if (p1 xor p2) = '1' then
				-- reset licznika
				counter <= (others => '0');
			elsif counter < debounceTime then
				counter <= counter + 1;
			else
				signalOut <= p2;
			end if;
		end if;
	end process;
end basic;
