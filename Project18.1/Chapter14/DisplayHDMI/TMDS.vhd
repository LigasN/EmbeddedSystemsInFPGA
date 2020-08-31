-- Project:			maXimator PONG
-- File:				TMDS.vhd
-- Version:			(27.05.2016)
-- Author:			Piotr Chodorowski
-- Description:	Encoding TMDS data & control signals for HDMI interface

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TMDS is port(
    clk      : in  STD_LOGIC;								-- pixel clock
    vd_en    : in  STD_LOGIC;								-- display area indication (1=display, 0=control data)
    ctrl     : in  STD_LOGIC_VECTOR(1 downto 0);	-- sync (in blue channel) vSync & hSync
    data_in  : in  STD_LOGIC_VECTOR(7 downto 0);	-- 8-bit color data in
    data_out : out STD_LOGIC_VECTOR(9 downto 0)		-- 10-bit encoded data out
);

function count_ones(s : STD_LOGIC_VECTOR) return INTEGER is
    variable ones : NATURAL := 0;
begin
    for i in s'range loop
        if s(i) = '1' then ones := ones + 1; 
        end if;
    end loop;
    return ones;
end function count_ones;

end TMDS;


architecture structural of TMDS is

signal qm            : STD_LOGIC_VECTOR(8 downto 0);
signal ones_din      : INTEGER range 0 to 8;
signal ones_qm       : INTEGER range -16 to 15;
signal xored         : STD_LOGIC;
signal disparity     : INTEGER range -16 to 15 := 0;
signal balance_accn  : INTEGER range -16 to 15;
signal balance_acci  : INTEGER range -16 to 15;
signal sgn           : INTEGER range -16 to 15;
signal balance_sgn   : STD_LOGIC;
signal inv_qm        : STD_LOGIC;
signal qm_var        : STD_LOGIC;
signal TMDS_data     : STD_LOGIC_VECTOR(9 downto 0);
signal TMDS_ctrl     : STD_LOGIC_VECTOR(9 downto 0);

begin    

    ones_din <= count_ones(data_in);
    xored <= '1' when (ones_din > 4) OR ((ones_din = 4) AND (data_in(0) = '0')) else '0';
    qm <= NOT(xored) & (qm(6 downto 0) XOR data_in(7 downto 1) XOR (6 downto 0 => xored)) & data_in(0);
    ones_qm <= count_ones(qm) - 4;
    balance_sgn <= '1' when (ones_qm >= 0 AND disparity >= 0) OR (ones_qm < 0 AND disparity < 0) else '0';
    inv_qm <= NOT(qm(8)) when ones_qm = 0 OR disparity = 0 else balance_sgn;
    qm_var <= '0' when (ones_qm = 0) OR (disparity = 0) else '1';
    sgn <= 1 when ((qm(8) XOR NOT(balance_sgn)) AND qm_var) = '1' else 0;
    balance_acci <= ones_qm - sgn;
    balance_accn <= disparity - balance_acci when inv_qm = '1' else disparity + balance_acci;
    TMDS_data <= inv_qm & qm(8) & (qm(7 downto 0) XOR (7 downto 0 => inv_qm));    
    TMDS_ctrl <= "1101010100" when ctrl = "00" else
                 "0010101011" when ctrl = "01" else
                 "0101010100" when ctrl = "10" else
                 "1010101011" when ctrl = "11";
    process(clk)
    begin
        if rising_edge(clk) then
            if vd_en = '1' then
                data_out <= TMDS_data;
                disparity <= balance_accn;
            else
                data_out <= TMDS_ctrl;
                disparity <= 0;
            end if;
        end if;
    end process;
end structural;