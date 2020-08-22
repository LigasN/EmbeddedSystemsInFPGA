-- Project:			maximator-Tutorial-11
-- File:				WS2812_OPT.vhd
-- Version:			1.0 (16.09.2018)
-- Author:			Piotr Rzeszut (http://piotr94.net21.pl)
-- Description:	Driver for WS2812 leds with external RAM and interrupt

library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity WS2812_OPT is
	generic (
				NUM_DIODES	: integer := 2
	);
	port (	
				--avalon memory-mapped slave
				clk			: in std_logic;
				reset_n		: in std_logic;
				address		: in std_logic;
				byteenable	: in std_logic_vector(3 downto 0);
				read			: in std_logic;
				readdata		: out std_logic_vector(31 downto 0);
				write			: in std_logic;
				writedata	: in std_logic_vector(31 downto 0);
				
				--avalon memory-mapped master
				m_address		: out std_logic_vector(16 downto 0);
				m_byteenable	: out std_logic_vector(3 downto 0);
				m_read			: out std_logic;
				m_readdata		: in std_logic_vector(31 downto 0);
				m_write			: out std_logic;
				m_writedata		: out std_logic_vector(31 downto 0);
				
				--led_out exported interface
				led_out		: out std_logic;
				
				--interrupt
				irq			: out std_logic

		);
end WS2812_OPT;

architecture basic of WS2812_OPT is
	-- rejestr do zatrzaskiwania danych wyjściowych celem prawidłowej synchronizacji
	signal readdataBuffer	: std_logic_vector(31 downto 0);
	signal data					: std_logic_vector(23 downto 0);
	signal t0h					: std_logic_vector(7 downto 0);
	signal t0l					: std_logic_vector(7 downto 0);
	signal t1h					: std_logic_vector(7 downto 0);
	signal t1l					: std_logic_vector(7 downto 0);
	signal tres					: std_logic_vector(15 downto 0);
	signal counter				: std_logic_vector(15 downto 0);
	type stateType is (S_RES, S_PRES, S_0H, S_0L, S_1H, S_1L);
	signal state 				: stateType;
	signal actLed				: integer range 0 to NUM_DIODES - 1;
	signal bitcounter			: integer range 0 to 23;
	signal lastLed				: std_logic;
	-- proste jednobitowe rejestry
	signal irqInternal		: std_logic;
	signal irqEnable			: std_logic;
	signal start				: std_logic;
	--
begin
	-- będziemy zawsze prowadzić odczyt całego słowa 32-bitowego z pamięci - ustawiamy linie
	m_write <= '0';
	m_writedata <= (others => '0');
	m_read <= '1';
	m_byteenable <= "1111";
	-- nasze dane będą zawsze ostatnio pobranymi danymi z pamięci - z pominięciem najstarszych 8 bitów (aby ułatwić adresowanie)
	data <= m_readdata(23 downto 0);
	-- układ ma być wrażliwy na zmiany na poniżej wymienionych liniach
	process(clk, reset_n) is
	begin
		-- jeśli linia reset w stanie niskim
		if reset_n = '0' then
			state				 	<= S_PRES;
			
			irqInternal 		<= '0';
			irqEnable			<= '0';
			start					<= '0';
			
			t0h					<= (others => '0');
			t0l					<= (others => '0');
			t1h					<= (others => '0');
			t1l					<= (others => '0');
			tres					<= (others => '0');
			counter				<= (others => '0');
			
			actLed				<= 0;
			bitcounter			<= 0;
		-- jeśli opadające zbocze zegara
		elsif falling_edge(clk) then
			-- w zależności od stanu
			case state is				
				when S_PRES =>
					-- idziemy dalej, tylko jeśli start jest jedynką
					if start = '1' then
						counter <= (others => '0');
						led_out <= '0';
						state <= S_RES;
					end if;
					
				when S_RES =>
					start <= '0';
					if counter < tres then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						led_out <= '1';
						lastLed <= '0';
						if data(23 - bitcounter) = '1' then
							state <= S_1H;
						else
							state <= S_0H;
						end if;
					end if;
					
					
				when S_1H =>
					if counter < t1h then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						led_out <= '0';
						state <= S_1L;
						if bitcounter < 23 then
							bitcounter <= bitcounter + 1;
						else
							bitcounter <= 0;
							if actLed < NUM_DIODES - 1 then
								actLed <= actLed + 1;
							else
								actLed <= 0;
								lastLed <= '1';
							end if;
						end if;
					end if;
					
					
					
				when S_0H =>
					if counter < t0h then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						led_out <= '0';
						state <= S_0L;
						if bitcounter < 23 then
							bitcounter <= bitcounter + 1;
						else
							bitcounter <= 0;
							if actLed < NUM_DIODES - 1 then
								actLed <= actLed + 1;
							else
								actLed <= 0;
								lastLed <= '1';
							end if;
						end if;
					end if;
					
					
					
				when S_1L =>
					if counter < t1l then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						led_out <= '1';
						if lastLed = '1' then
							state <= S_PRES;
							irqInternal <= '1';
						else
							if data(23 - bitcounter) = '1' then
								state <= S_1H;
							else
								state <= S_0H;
							end if;
						end if;
					end if;
					
				when S_0L =>
					if counter < t0l then
						counter <= counter + 1;
					else
						counter <= (others => '0');
						led_out <= '1';
						if lastLed = '1' then
							state <= S_PRES;
							irqInternal <= '1';
						else
							if data(23 - bitcounter) = '1' then
								state <= S_1H;
							else
								state <= S_0H;
							end if;
						end if;
					end if;

				-- w niezdefiniowanych przypadkach powrót do stanu BLANK
				when others =>
					state <= S_PRES;
			end case;
			
			-- obsługa magistrali Avalon-MM - zapis do układu z uwzględnieniem linii byteenable
			if write = '1' then

				if address = '0' then
					if byteenable(0) = '1' then
						t0h(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						t0l(7 downto 0) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then
						t1h(7 downto 0) <= writedata(23 downto 16);
					end if;
					if byteenable(3) = '1' then
						t1l(7 downto 0) <= writedata(31 downto 24);
					end if;
				end if;

				if address = '1' then
					if byteenable(0) = '1' then
						tres(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						tres(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then
						irqEnable		<= writedata(17);
						start				<= writedata(16);
					end if;
					if byteenable(3) = '1' then
						irqInternal		<= writedata(24);
					end if;
				end if;

				
			end if;
			-- obsługa magistrali Avalon-MM - odczyt z układu
			if read = '1' then
				if address = '0' then
					readdataBuffer(7 downto 0) <= t0h;
					readdataBuffer(15 downto 8) <= t0l;
					readdataBuffer(23 downto 16) <= t1h;
					readdataBuffer(31 downto 24) <= t1l;
				end if;
				if address = '1' then
					readdataBuffer(15 downto 0) <= tres;
					readdataBuffer(16) <= start;
					readdataBuffer(17) <= irqEnable;
					readdataBuffer(23 downto 18) <= (others => '0');
					readdataBuffer(24) <= irqInternal;
					readdataBuffer(31 downto 25) <= (others => '0');
				end if;
			end if;
		-- jeśli narastające zbocze zegara - zatrzaskujemy dane wyjściowe (zgodnie z oczekiwanym timingiem)
		elsif rising_edge(clk) then
			readdata <= readdataBuffer;
			-- oraz zatrzaskujemy adres na magistrali adresowej podłączonej do drugiej pamięci ram
			m_address <= std_logic_vector(to_unsigned(actLed,m_address'length));
			-- wewnętrzny sygnał sygnalizacji przerwania podłączony do wyjścia wraz z możliwością jego wyłączenia
			irq <= irqInternal and irqEnable;
		end if;
	end process;
end basic;
