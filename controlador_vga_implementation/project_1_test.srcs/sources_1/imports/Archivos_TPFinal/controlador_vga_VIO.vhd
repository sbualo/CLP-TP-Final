----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2024 21:31:04
-- Design Name: 
-- Module Name: controlador_vga_VIO - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlador_vga_VIO is
  Port (
    Clk_in: in std_logic
   );
end controlador_vga_VIO;

architecture Behavioral of controlador_vga_VIO is

component controlador_vga is
    Port ( 
        clk50MHz_vga :      in  std_logic;                      -- reloj principal 
        reset_vga :         in  std_logic;                      -- reset global 
        hsync_vga :         out std_logic;
        vsync_vga :         out std_logic;
        blank_vga :         out std_logic;
        R_vga :             out std_logic;
        G_vga :             out std_logic;
        B_vga :             out std_logic
    );
end component;

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_in0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

COMPONENT ila_0

PORT (
	clk : IN STD_LOGIC;



	probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
);
END COMPONENT  ;

signal clk50MHz_p,reset_p,hsync_p,vsync_p,blank_p,R_p,G_p,B_p:STD_LOGIC_VECTOR(0 DOWNTO 0);

begin

VIO_inst : vio_0
  PORT MAP (
    clk => Clk_in,
    probe_in0 => hsync_p,
    probe_in1 => vsync_p,
    probe_in2 => blank_p,
    probe_in3 => R_p,
    probe_in4 => G_p,
    probe_in5 => B_p,
    probe_out0 => reset_p
  );
  
 ILA_inst : ila_0
  PORT MAP (
      clk => Clk_in,
      probe0 => blank_p, 
      probe1 => hsync_p, 
      probe2 => vsync_p, 
      probe3 => R_p, 
      probe4 => G_p,
      probe5 => B_p
  );

VGA_inst: controlador_vga 
    PORT MAP(
        clk50MHz_vga  => Clk_in,
        reset_vga  => reset_p(0),
        hsync_vga  => hsync_p(0),
        vsync_vga  => vsync_p(0),
        blank_vga  => blank_p(0),
        R_vga  => R_p(0),
        G_vga  => G_p(0),
        B_vga  => B_p(0)
    );

end Behavioral;
