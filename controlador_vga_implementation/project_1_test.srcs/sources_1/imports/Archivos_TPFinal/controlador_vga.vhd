library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity controlador_vga is
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
end;

architecture main_controler of controlador_vga is 

    component contador_horizontal is
        Port ( 
            clk50MHz :  in  std_logic;                      -- reloj principal 
            reset :     in  std_logic;                      -- reset global 
            h_cuenta :  out std_logic_vector (10 downto 0)
        );
    end component;

    component contador_vertical is
        Port ( 
            hsync : in std_logic; -- horizontal sync signal 
            clk50MHz: in std_logic; -- main clock
            reset : in std_logic; -- global reset
            v_cuenta : out std_logic_vector (9 downto 0)
            );
    end component;

    component generador_hsync is
        Port ( 
            h_cuenta : in std_logic_vector (10 downto 0); 
            clk50MHz : in std_logic;
            reset : in std_logic;
            hsync : out std_logic
            );
    end component;

    component generador_vsync is
        Port ( 
                v_cuenta : in std_logic_vector (9 downto 0);
                clk50MHz : in std_logic; 
                reset : in std_logic; 
                vsync : out std_logic
            );
    end component;

    component generador_blank is
        Port ( 
                hctr : in std_logic_vector (10 downto 0); 
                vctr : in std_logic_vector (9 downto 0); 
                blank : out std_logic
            );
    end component;

    component image_generator is 
        Port (
                hctr : in std_logic_vector (10 downto 0);
                vctr : in std_logic_vector (9 downto 0);
                blank : in std_logic; -- blank interval signal 
                clk50MHz : in std_logic; -- main clock
                reset : in std_logic; -- global reset
                R : out std_logic; -- Red colour signal
                G : out std_logic; -- Green colour signal 
                B : out std_logic); -- Blue colour signal
    end component;


    
   signal h_cuenta_aux:     std_logic_vector (10 downto 0);
   signal v_cuenta_aux:     std_logic_vector (9 downto 0);
   signal hsync_aux:        std_logic;
   signal vsync_aux:        std_logic;
   signal blank_vga_aux:        std_logic;
   signal R_aux: std_logic;
   signal G_aux: std_logic;
   signal B_aux: std_logic;

begin

    hsync_vga <= hsync_aux;
    vsync_vga <= vsync_aux;
    blank_vga <= blank_vga_aux;
    R_vga <= R_aux;
    G_vga <= G_aux;
    B_vga <= B_aux;

    HCOUNT: contador_horizontal port map (
        clk50MHz => clk50MHz_vga,
        reset => reset_vga,
        h_cuenta => h_cuenta_aux
    );

    HSINC_GEN: generador_hsync port map (
        h_cuenta => h_cuenta_aux , 
        clk50MHz => clk50MHz_vga,
        reset => reset_vga,
        hsync => hsync_aux
    );

    VCOUNT: contador_vertical port map (
        hsync => hsync_aux,
        clk50MHz=> clk50MHz_vga,
        reset => reset_vga,
        v_cuenta => v_cuenta_aux
    );

    VSINC_GEN: generador_vsync port map (
        v_cuenta => v_cuenta_aux ,
        clk50MHz => clk50MHz_vga,
        reset => reset_vga,
        vsync   => vsync_aux
    );

    DARK_IMAGE_GEN: generador_blank port map(
        hctr => h_cuenta_aux ,
        vctr => v_cuenta_aux,
        blank => blank_vga_aux
    );

    IMAGE_GEN: image_generator port map (
        hctr => h_cuenta_aux,
        vctr => v_cuenta_aux,
        blank => blank_vga_aux,
        clk50MHz => clk50MHz_vga,
        reset => reset_vga,
        R => R_aux,
        G => G_aux,
        B => B_aux
    );




end main_controler;