library ieee;
use ieee.std_logic_1164.all;

entity ShiftReg_ing is
    generic(N : integer :=8);
port( Ck, Dato_in: in std_logic;
      EN, rst: in std_logic;
      Dato_out : inout std_logic_vector (N-1 downto 0)
);
end ShiftReg_ing;

architecture arch of ShiftReg_ing is
begin
	process(Ck)
	  begin
	     if (rst = '0') then
           Dato_out <= (others=>'0');
        elsif (Ck'event and Ck ='1') then
       		if (EN = '1') then
			 Dato_out(N-2 downto 0) <= Dato_out(N-1 downto 1);
			 Dato_out(N-1) <= Dato_in;
		   end if;
		  end if;
	end process;
end arch;
 
