library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_main is
    end tb_main;

architecture tb of tb_main is
    component main_file is
    Port (
             slide_switch       : in  STD_LOGIC_VECTOR (7 downto 0);
             led                : out  STD_LOGIC_VECTOR (7 downto 0)
         );
    end component;
    component counter is
        generic (
            match_val   : integer
        );
        port (
            clk_50Mhz   : in STD_LOGIC;
            rst         : in STD_LOGIC;
            done        : out STD_LOGIC
         );
    end component;

signal led              : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal slide_switch     : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clk              : STD_LOGIC := '0';
signal counter_rst      : STD_LOGIC := '1';
signal counter_done     : STD_LOGIC;
begin
    main : main_file
    port map (
                 slide_switch => slide_switch,
                 led => led
             );
    counter_50 : counter
    generic map (
        match_val => 50
    )
    port map (
        clk_50MHZ => clk,
        rst => counter_rst,
        done => counter_done
    );
    clk <= not clk after 20 ns;
    process
    begin
        for I in 0 to 255 loop
            slide_switch <= std_logic_vector(to_unsigned(I, slide_switch'length));
            wait for 20 ns;
            assert led = std_logic_vector(to_unsigned(I, slide_switch'length)) report "The LED output is unexpected" severity ERROR;
        end loop;
        assert false report "LED test done" severity note;
        wait;
    end process;
   process
   begin
       counter_rst <= '0';
        wait until counter_done = '1';
        assert false report "counter test done" severity note;
        wait;
   end process;
end tb;
