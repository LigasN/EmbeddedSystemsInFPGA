library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity SEG7 is
	port (	
		--avalon memory-mapped slave
		clk			: in std_logic;
		reset_n		: in std_logic;
		address		: in std_logic_vector(2 downto 0);
		byteenable	: in std_logic_vector(3 downto 0);
		read			: in std_logic;
		readdata		: out std_logic_vector(31 downto 0);
		write			: in std_logic;
		writedata	: in std_logic_vector(31 downto 0);
		
		--display exported interface
		display		: out std_logic_vector(3 downto 0);
		segment		: out std_logic_vector(7 downto 0)
		);
end SEG7;

architecture basic of SEG7 is

	-- rejestr do zatrzaskiwania danych wyjściowych celem prawidłowej synchronizacji
	signal readdataBuffer	: std_logic_vector(31 downto 0);
	
	-- deklaracja typu tablicy i tablicy z elementami 
	type segmentsArrayType is array (0 to 3) of std_logic_vector(7 downto 0);
	signal segments			: segmentsArrayType;
	
	-- deklaracja rejestru ustawiania czasu aktywnego
	signal activeTime			: std_logic_vector(31 downto 0);
	
	-- deklaracja rejestru ustawiania czasu wyłączenia
	signal blankTime			: std_logic_vector(31 downto 0);
	
	-- deklaracja rejestru licznika
	signal counter				: std_logic_vector(31 downto 0);
	
	-- deklaracja rejestru przechowującego stan układu
	type stateType is (ACT, BLANK);
	signal state 				: stateType;
	
	-- deklaracja rejestru przechowującego aktywny wyświetlacz
	signal actDisplay			: integer range 0 to 3;
	
begin
	-- układ ma być wrażliwy na zmiany na poniżej wymienionych liniach
	process(clk, reset_n) is
	begin
	
		-- jeśli linia reset w stanie niskim
		if reset_n = '0' then
			state				<= BLANK;
			activeTime			<= (others => '0');
			blankTime			<= (others => '0');
			counter				<= (others => '0');
			segments			<= (others=> (others=>'0'));
			display				<= (others => '0');
			
		-- jeśli opadające zbocze zegara
		elsif falling_edge(clk) then
			-- w zależności od stanu
			case state is
				-- oczekiwanie na koniec czasu wygaszenia wszystkich wyświetlaczy
				when BLANK =>
					-- jeśli czas nie minał to liczymy dalej
					if counter < blankTime then
						counter <= counter + 1;
					-- jesli czas minął to zapalamy wyświetlacz, resetujemy licznik i przechodzimy do kolejnego stanu
					else
						counter <= (others => '0');
						segment <= segments(actDisplay);
						display(actDisplay) <= '1';
						state <= ACT;
					end if;
				-- oczekiwanie na koniec czasu zapalenia wyświetlacza
				when ACT =>
					-- jeśli czas nie minał to liczymy dalej
					if counter < activeTime then
						counter <= counter + 1;
					-- jeśli czas minął to gasimy wyświetlacze, resetujemy licznik
					-- zwiększamy numer wyświetlacza i przechodzimy do poprzedniego stanu
					else
						counter <= (others => '0');
						segment <= (others => '0');
						display <= (others => '0');
						actDisplay <= actDisplay + 1;
						state <= BLANK;
					end if;
				-- w niezdefiniowanych przypadkach powrót do stanu BLANK
				when others =>
					state <= BLANK;
			end case;
			
			-- obsługa magistrali Avalon-MM - zapis do układu z uwzględnieniem linii byteenable
			if write = '1' then
				-- zapis dla każdego z 4 rejestrów przechowujących kombinację segmentów dla każdego z wyświetlaczy
				-- będą one miały adresy 0-3
				for i in 0 to 3 loop
					if address = std_logic_vector(to_unsigned(i,address'length)) then
						if byteenable(0) = '1' then
							segments(i)(7 downto 0) <= writedata(7 downto 0);
						end if;
					end if;
				end loop;
				-- pod adresem 4 rejestr czasu aktywnego
				if address = std_logic_vector(to_unsigned(4,address'length)) then
					if byteenable(0) = '1' then
						blankTime(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						blankTime(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then
						blankTime(23 downto 16) <= writedata(23 downto 16);
					end if;
					if byteenable(3) = '1' then
						blankTime(31 downto 24) <= writedata(31 downto 24);
					end if;
				end if;
				-- pod adresem 5 rejestr czasu wygaszenia
				if address = std_logic_vector(to_unsigned(5,address'length)) then
					if byteenable(0) = '1' then
						activeTime(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						activeTime(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then
						activeTime(23 downto 16) <= writedata(23 downto 16);
					end if;
					if byteenable(3) = '1' then
						activeTime(31 downto 24) <= writedata(31 downto 24);
					end if;
				end if;
			end if;
			-- obsługa magistrali Avalon-MM - odczyt z układu
			if read = '1' then
				for i in 0 to 3 loop
					if address = std_logic_vector(to_unsigned(i,address'length)) then
						readdataBuffer(7 downto 0) <= segments(i);
						readdataBuffer(31 downto 8) <= (others => '0');
					end if;
				end loop;
				if address = std_logic_vector(to_unsigned(4,address'length)) then
					readdataBuffer <= blankTime;
				end if;
				if address = std_logic_vector(to_unsigned(5,address'length)) then
					readdataBuffer <= activeTime;
				end if;
				if address > std_logic_vector(to_unsigned(5,address'length)) then
					readdataBuffer <= (others => '0');
				end if;
			end if;
		-- jeśli narastające zbocze zegara - zatrzaskujemy dane wyjściowe (zgodnie z oczekiwanym timingiem)
		elsif rising_edge(clk) then
			readdata <= readdataBuffer;
		end if;
	end process;
end basic;
