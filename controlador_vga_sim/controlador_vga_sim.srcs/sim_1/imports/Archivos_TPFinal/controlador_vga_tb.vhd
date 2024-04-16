library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all; -- Add this library

entity controlador_vga_tb is
end controlador_vga_tb;

architecture tb_arch of controlador_vga_tb is

    -- Constants declaration
    constant clk_period : time := 20 ns; -- Clock period (50 MHz)

    -- Signals
    signal clk50MHz_vga_tb : std_logic := '0'; -- Test bench clock signal
    signal reset_vga_tb : std_logic := '0';   -- Test bench reset signal
    signal hsync_vga_tb, vsync_vga_tb, blank_vga_tb, R_vga_tb, G_vga_tb, B_vga_tb : std_logic;

begin

    -- Instantiate the unit under test (UUT)
    UUT : entity work.controlador_vga
        port map (
            clk50MHz_vga => clk50MHz_vga_tb,
            reset_vga => reset_vga_tb,
            hsync_vga => hsync_vga_tb,
            vsync_vga => vsync_vga_tb,
            blank_vga => blank_vga_tb,
            R_vga => R_vga_tb,
            G_vga => G_vga_tb,
            B_vga => B_vga_tb
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk50MHz_vga_tb <= not clk50MHz_vga_tb;
            wait for clk_period / 2; -- Toggle clock every half period
        end loop;
    end process;

    -- Reset process
    reset_process : process
    begin
        reset_vga_tb <= '1'; -- Assert reset
        wait for 10 us;
        reset_vga_tb <= '0'; -- Deassert reset
        wait;
    end process;

 

end tb_arch;
