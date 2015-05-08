library ieee;
use ieee.std_logic_1164.all;

entity ShiftOut is
generic(N : integer :=8);
port( Ck, S: in std_logic;
      EN, rst: in std_logic;
      Dato_in : in std_logic_vector (N-1 downto 0);
      Dato_out : out std_logic
);
end ShiftOut;

architecture arch of ShiftOut is

signal t : std_logic;
signal temp : std_logic_vector (N-1 downto 0);

begin

	process(Ck,S, Dato_in)
	  begin
 		     if (rst = '0') then
	                  Dato_out <= '0';
                          t<= '0';
	                  temp<= (others=>'0');
	                  
	        elsif (S = '1') then
 		                   temp(N-1 downto 0) <= Dato_in (N-1 downto 0);
 		         end if;        
           if (Ck'event and Ck ='1') then
              if (EN = '1') then
			      Dato_out<= temp(N-1);
			      temp(N-1 downto 1) <= temp(N-2 downto 0);
			      temp(0) <= '0';
		         end if;
             --so <= t;
           end if;
           
	end process;

--so <= t;
end arch;
 
