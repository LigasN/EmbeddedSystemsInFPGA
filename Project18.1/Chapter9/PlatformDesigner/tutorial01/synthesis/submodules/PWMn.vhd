library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PWMn is 
	generic (
		CHANNELS : integer := 4;
		ADDRBITS : integer := 3
	);
	port( --avalon memory-mapped slave
		clk 		: in std_logic;
		reset_n 	: in std_logic;
		address 	: in std_logic_vector(ADDRBITS - 1 downto 0);
		byteenable 	: in std_logic_vector(3 downto 0);
		read 		: in std_logic;
		readdata 	: out std_logic_vector(31 downto 0);
		write 		: in std_logic;
		writedata 	: in std_logic_vector(31 downto 0);
		
		--pwm exported interface
		pwm 		: out std_logic_vector(CHANNELS - 1 downto 0)
			
		);
end PWMn;

--...(1)...
architecture basic of PWMn is

	-- rejestr do zatrzaskiwania danych wyjściowych celem prawidłowej synchronizacji
	signal readdataBuffer 	: std_logic_vector(31 downto 0);
	
	-- deklaracja rejestru przechowującego wartość preskalera
	signal counterPrescMax 	: std_logic_vector(31 downto 0);
	
	-- deklaracja rejestru licznika preskalera
	signal counterPresc 	: std_logic_vector(31 downto 0);
	
	-- deklaracja licznika do generowania PWM
	signal counterPWM 		: std_logic_vector(15 downto 0);
	
	-- deklarajca rejestru maksymalnej wartości pwm (rozdzielczość)
	signal counterPWMMax 	: std_logic_vector(15 downto 0);
	
	-- deklaracja typu tablicy i tablicy z elementami
	type PWMArrayType is array(0 to CHANNELS - 1) of std_logic_vector(15 downto 0);
	signal PWMValue 		: PWMArrayType;
	
begin 
--...(2)...
process(clk, reset_n) is 
	begin 
		--jesli linia reset w stanie niskim
		if reset_n = '0' then
			counterPrescMax <= (others=>'0');
			counterPresc 	<= (others=>'0');
			counterPWM 		<= (others=>'0');
			counterPWMMax 	<= (others=>'0');
			PWMValue 		<= (others=> (others=>'0'));
			
		-- jeśli opadające zbocze zegara
		elsif falling_edge(clk) then
			--...(3)..
			-- generowanie sygnału PWM
			-- obsługujemy podzielnik sygnału zegarowego / preskaler
			if counterPresc < counterPrescMax then
				counterPresc <= counterPresc + 1;
			else
				counterPresc <= (others=>'0');
				
				-- obsługujemy licznik PWM z zachowaniem maksymalnej wartości
				if counterPWM < counterPWMMax then
					counterPWM <= counterPWM +1;
				else
					counterPWM <= (others=>'0');
				end if;
				
				-- dla każdego z kanałów tworzymy "komparator" do generowania sygnału wyjściowego
				for i in 0 to CHANNELS - 1 loop
					if PWMValue(i) >= counterPWM then 
						pwm(i) <= '1';
					else
						pwm(i) <= '0';
					end if;
				end loop;
			end if;
			
			--...(4)...
			-- Obsługa magistrali Avalon-MM - zapis do układu z uwzględnieniem linii byteenable
			if write = '1' then
			
				-- zapis dla każdego z rejestrów przechowujących wartość wypełnienia dla każdego z kanałów
				for i in 0 to CHANNELS - 1 loop
					if address = std_logic_vector( to_unsigned(i, address'length)) then
						if byteenable(0) = '1' then	
							PWMValue(i)(7 downto 0) <= writedata(7 downto 0);
						end if;
						if byteenable(1) = '1' then
							PWMValue(i)(15 downto 8) <= writedata(15 downto 8);
						end if;
					end if;
				end loop;
				
				--pod adresem 4 preskaler używamy celem zmiany częstotliwości PWM
				if address = std_logic_vector( to_unsigned(CHANNELS, address'length)) then
					if byteenable(0) = '1' then 
						counterPrescMax(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then 
						counterPrescMax(15 downto 8) <= writedata(15 downto 8);
					end if;
					if byteenable(2) = '1' then 
						counterPrescMax(23 downto 16) <= writedata(23 downto 16);
					end if;
					if byteenable(3) = '1' then 
						counterPrescMax(31 downto 24) <= writedata(31 downto 24);
					end if;
				end if;
				
				--pod adresem 5 wartość definiująca maksymalną wartość licznika, a zatem rozdzielczość PWM
				if address = std_logic_vector(to_unsigned(CHANNELS + 1, address'length)) then
					if byteenable(0) = '1' then
						counterPWMMax(7 downto 0) <= writedata(7 downto 0);
					end if;
					if byteenable(1) = '1' then
						counterPWMMax(15 downto 8) <= writedata(15 downto 8);
					end if;
				end if;
			end if;
			
			--...(5)...
			-- obsługa magistrali Avalon-MM - odczyt z układu
			if read = '1' then
				for i in 0 to CHANNELS - 1 loop
					if address = std_logic_vector(to_unsigned(i, address'length)) then
						readdataBuffer(15 downto 0) <= PWMValue(i);
						readdataBuffer(31 downto 16) <= (others=>'0');
					end if;
				end loop;
				
				if address = std_logic_vector(to_unsigned(CHANNELS, address'length)) then
					readdataBuffer <= counterPrescMax;
				end if;
				
				if address = std_logic_Vector(to_unsigned(CHANNELS + 1, address'length)) then
					readdataBuffer(15 downto 0) <= counterPWMMax;
					readdataBuffer(31 downto 16) <= (others=>'0');
				end if;
				
				if address > std_logic_vector(to_unsigned(CHANNELS + 1, address'length)) then
					readdataBuffer <= (others=>'0');
				end if;
			end if;
				
		-- jeśli narastające zbocze zegara - zatrzaskujemy dane wyjściowe (zgodnie z odpowiednim timingiem)
		elsif rising_edge(clk) then
			readdata <= readdataBuffer;
		end if;
end process;

end basic;	




























