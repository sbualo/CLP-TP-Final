library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all; -- Add this library
entity image_generator is 
    Port (
            hctr : in std_logic_vector (10 downto 0);
            vctr : in std_logic_vector (9 downto 0);
            blank : in std_logic; -- blank interval signal 
            clk50MHz : in std_logic; -- main clock
            reset : in std_logic; -- global reset
            R : out std_logic; -- Red colour signal
            G : out std_logic; -- Green colour signal 
            B : out std_logic); -- Blue colour signal
end image_generator;

architecture Behavioral of image_generator is

    signal hctr_int : integer range 1586 downto 0; 
    signal vctr_int : integer range 524 downto 0; 
    signal R_int, G_int, B_int: std_logic;
    signal color: std_logic_vector (2 downto 0);

begin

    hctr_int <= CONV_INTEGER (hctr);
    vctr_int <= CONV_INTEGER (vctr);

 -- utilizamos biestables de salida para evitar posibles Glitches 
-- Inicializamos los biestables a cero
    process (clk50MHz,reset,R_int,G_int,B_int)
    begin
        if reset = '1' then
            R <= '0';
            G <= '0';
            B <= '0';
        elsif clk50MHz='1' and clk50MHz'event then
            R <= R_int;
            G <= G_int;
            B <= B_int;
        end if;
    end process;
-- Colores obtenidos en función de R G B (1 bit per signal)
-- 000: black
-- 001: blue
-- 010: green
-- 011: cyan

-- Circuito combinacional que genera los colores de cada franja 
-- en función de la posición horizontal de cada punto
-- franja vertical blanca de la izda

    color <= "111" when ((hctr_int >= 0) and (hctr_int < 308) and (blank = '1'))
else
    -- aquí comienza la imagen de 640 x 480
    -- que consiste en 7 barras verticales de diferentes colores
    "001" when ((hctr_int >= 308) and (hctr_int < 399) and (blank = '1')) else
    "010" when ((hctr_int >= 399) and (hctr_int < 490) and (blank = '1')) else
    "011" when ((hctr_int >= 490) and (hctr_int < 581) and (blank = '1')) else
    "111" when ((hctr_int >= 581) and (hctr_int < 672) and (blank = '1')) else
    "101" when ((hctr_int >= 672) and (hctr_int < 763) and (blank = '1')) else
    "110" when ((hctr_int >= 763) and (hctr_int < 854) and (blank = '1')) else
    "100" when ((hctr_int >= 854) and (hctr_int <= 948) and (blank = '1')) else 
    "111" when ((hctr_int > 948) and (hctr_int <= 1257) and (blank = '1')) else 
    "000"; -- Intérvalos blank (blank = 0)
    R_int <= color(2); 
    G_int <= color(1); 
    B_int <= color(0);
end Behavioral;