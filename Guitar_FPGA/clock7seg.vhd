library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock7seg is
	port
	(
		-- Input ports 
		clk : in std_logic;
		reset: in std_logic;
		start: in std_logic;
		stop: in std_logic;
		
		-- output ports
		dig7seg : out std_logic_vector(1 downto 0); -- Seletor do display
		d7seg : out std_logic_vector(8 downto 0) -- Indicator de 7seg selecionado por dig7seg
		
	);
end clock7seg;


architecture  ss of clock7seg is
signal clkLocal,max1:std_logic;
signal state:std_logic:='0';
signal dig0,dig1,dig2,dig3:std_logic_vector(3 downto 0);
signal binCount:std_logic_vector(18 downto 0);
signal countN:std_logic_vector(13 downto 0);
begin

ff:process(start,stop,reset)
begin
	if start='1' then
		state<='1';
	elsif stop='1' then
		state<='0';
	elsif reset='0' then
		state<='0';
	end if;
end process;

clkLocal<=clk and state;

c0: work.BinaryCounterMod
generic map (N=>27)
port map(clk=>clkLocal,
M=>5000000,
reset=>reset,
maxOut=>max1);

c1: work.BinaryCounterMod
generic map (N=>14)
port map(clk=>max1,
M=>10000,
reset=>reset, Q=>countN);

decod: work.bcd 
generic map(N=>14)
port map(number=>countN,dig3=>dig3,dig2=>dig2,dig1=>dig1,dig0=>dig0);

d0: work.display7seg 
port map(clk=>clk,ena=>'1',
clockPoint=>'1',
point=>"10",
dig0=>dig0,
dig1=>dig1,
dig2=>dig2,
dig3=>dig3,
dig7seg=>dig7seg,
d7seg=>d7seg);

end ss;

architecture  mmss of clock7seg is
signal clkLocal,max1,max2,max3,max4:std_logic;
signal state:std_logic:='0';
signal dig0,dig1,dig2,dig3:std_logic_vector(3 downto 0);
signal binCount:std_logic_vector(18 downto 0);
signal countN:std_logic_vector(13 downto 0);
begin

ff:process(start,stop,reset)
begin
	if start='1' then
		state<='1';
	elsif stop='1' then
		state<='0';
	elsif reset='0' then
		state<='0';
	end if;
end process;

clkLocal<=clk and state;

c0: work.BinaryCounterMod
generic map (N=>27)
port map(clk=>clkLocal,
M=>50000000,
reset=>reset,
maxOut=>max1);

c1: work.BinaryCounterMod
generic map (N=>4)
port map(clk=>max1,
M=>10,
maxOut=>max2,
reset=>reset, Q=>dig0);

c2: work.BinaryCounterMod
generic map (N=>4)
port map(clk=>max2,
M=>6,
maxOut=>max3,
reset=>reset, Q=>dig1);

c3: work.BinaryCounterMod
generic map (N=>4)
port map(clk=>max3,
M=>10,
maxOut=>max4,
reset=>reset, Q=>dig2);

c4: work.BinaryCounterMod
generic map (N=>4)
port map(clk=>max4,
M=>10,
reset=>reset, Q=>dig3);


d0: work.display7seg 
port map(clk=>clk,ena=>'1',
clockPoint=>'0',
point=>"11",
dig0=>dig0,
dig1=>dig1,
dig2=>dig2,
dig3=>dig3,
dig7seg=>dig7seg,
d7seg=>d7seg);

end mmss;
