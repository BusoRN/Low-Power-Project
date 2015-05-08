library ieee;
use ieee.std_logic_1164.all;

entity ShiftReg_ing is
generic(N : integer :=8);
port(	RST,EN,Ck, Dato_in: in std_logic;
		Dato_out: buffer std_logic_vector(N-1 downto 0));
end ShiftReg_ing;
architecture A of ShiftReg_ing is
component FF is 
port(	d,Ck,rst,en: in std_logic;
		q: out std_logic);
end component;
	begin
	ff0: FF port map(d => dato_in, ck => ck, rst => rst, en => en, q => dato_out(N-1));
   u1: for i in N-2 downto 1 generate
		ffi: ff port map (d => dato_out(i+1), CK => CK, Q => dato_out(i), rst => rst, en => en);
	end generate;
	ff7: ff port map ( D => dato_out(1), CK => CK, Q => dato_out(0), en => en, rst => rst);
 end A;
 
 ------------------ Flip Flop ------------------
 library ieee;
use ieee.std_logic_1164.all;

entity FF is 
port(	d,Ck,rst, EN: in std_logic;
		q: out std_logic);
end FF;
architecture behavior of FF is
begin
		process (Ck)
		begin
			if (rst = '0') then
				q<='0';
			elsif (Ck'event and Ck ='0') then
				if (EN = '1') then
					q <= d;
				end if;
			end if;
		end process;
end behavior;
--------------------------------------------------