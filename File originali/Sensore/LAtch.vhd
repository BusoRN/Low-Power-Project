--------------Latch-------------------------------
 library ieee;
use ieee.std_logic_1164.all;

entity Latch_N is
port(	d: in std_logic;
		C,rst: in std_logic;
		q: out std_logic);
end Latch_N;
architecture behavior of Latch_N is
begin
		process (C, rst)
		begin
			if (rst = '1') then
				q <= '0';
			elsif (C ='1') then
				q <= d;
			end if;
		end process;
end behavior;
--------------------------------------------------