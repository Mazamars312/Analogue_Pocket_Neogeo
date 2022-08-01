library IEEE;
use IEEE.std_logic_1164.all;

package jt12 is 

component jt12
port
(
    rst        : in  std_logic;
    clk        : in  std_logic;         -- CPU clock
    cen        : in  std_logic := '1';  -- optional clock enable, if not needed leave as '1'
    din        : in  std_logic_vector(7 downto 0);
    addr       : in  std_logic_vector(1 downto 0);
    cs_n       : in  std_logic;
    wr_n       : in  std_logic;

    dout       : out std_logic_vector(7 downto 0);
    irq_n      : out std_logic;
    en_hifi_pcm: in  std_logic;     -- set high to use interpolation on PCM samples

    -- combined output
    snd_right  : out std_logic_vector(15 downto 0); -- signed
    snd_left   : out std_logic_vector(15 downto 0); -- signed
    snd_sample : out std_logic
);
end component;

component jt12_genmix
port 
(
    rst     : in  std_logic;
    clk     : in  std_logic;    -- expects 54 MHz clock
    fm_left : in  std_logic_vector(15 downto 0); -- FM at 55kHz
    fm_right: in  std_logic_vector(15 downto 0); -- FM at 55kHz
    psg_snd : in  std_logic_vector(10 downto 0); -- PSG at 220kHz
    fm_en   : in  std_logic;
    psg_en  : in  std_logic;
    -- Mixed sound at 54 MHz
    snd_left  : out std_logic_vector(15 downto 0);
    snd_right : out std_logic_vector(15 downto 0)
);
end component;

end;
