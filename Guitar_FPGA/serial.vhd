library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity serialOut is
	port
	(
		-- Input ports 
		clk : in std_logic;
		reset: in std_logic;
		rts: in std_logic;
		data: in std_logic_vector(7 downto 0);
		cts:out std_logic;
		tx:out std_logic
		
	);
end serialOut;

architecture  bhSerialOut of serialOut is
type TSTATES is (waitingData, sendingData, sentData);
signal dataOut:std_logic_vector(8 downto 0);
signal dataCount:unsigned(3 downto 0);
signal state:TSTATES;
begin

p0:process(clk,reset)
begin
	if reset='1' then
		state<=waitingData;
		cts<='1';
		dataCount<=(others=>'0');
	elsif rising_edge(clk) then
		if rts='1' and state=waitingData then
			dataOut<='0'&data;
			state<=sendingData;
			dataCount<=(others=>'0');
			cts<='0';
		elsif state=sendingData then
			dataOut<=dataOut(7 downto 0)&'0';
			dataCount<=dataCount+1;
			cts<='0';
		elsif dataCount>=data'Length then
			state<=sentData;
			cts<='0';
		elsif state<=sentData then
			state<=waitingData;
		end if;
	end if;
end process;

tx<=dataOut(8);

end bhSerialOut;
