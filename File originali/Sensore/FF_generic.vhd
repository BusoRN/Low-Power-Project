 library ieee;
use ieee.std_logic_1164.all;

entity FF_generic is 
generic (N : integer :=3);
port(	Ck,rst, EN: in std_logic;
		d : in std_logic_vector( N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0));
end FF_generic;
architecture behavior of FF_generic is
begin
		process (Ck)
		begin
			if (rst = '1') then
				q<=(others =>'0');
			elsif (Ck'event and Ck ='1') then
				if (EN = '1') then
					q <= d;
				end if;
			end if;
		end process;
end behavior;
