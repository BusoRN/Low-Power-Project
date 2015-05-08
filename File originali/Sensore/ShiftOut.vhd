library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ShiftOut is
generic(N : integer :=8);
port(	RST,EN,S,Ck: in std_logic;
		Dato_out: out std_logic;
		Dato_in: in std_logic_vector(N-1 downto 0));
end ShiftOut;
architecture A of ShiftOut is
component Blocco is
port(	a,b,s, en,CK, rst : in std_logic;
		o : out std_logic);
end component;
signal Y : std_logic_vector(N-1 downto 1);
begin
	blocco0: blocco port map(a => '0', b => Dato_in(0),s=>S, en => en, ck => ck, rst => rst, o => Y(1));
   u1: for i in 1 to N-2 generate
		bloccoi: blocco port map (a => Y(i), b => Dato_in(i),s=>S, en => en, ck => ck, rst => rst, o => Y(i+1));
	end generate;
	blocco7: blocco port map (a => Y(N-1), b => Dato_in(N-1),s=>S, en => en, ck => ck, rst => rst, o => Dato_out);
 end A;
 

-------------------------Multiplexer----------------
library ieee;
use ieee.std_logic_1164.all;

entity mux_2 is
port( a,b,s : in std_logic;
		o : out std_logic);
end mux_2;
architecture a of mux_2 is
begin
	process(a,b,s)
	begin
		case s is
			when '0' => o <= a;
			when '1' => o <= b;
			when others => null;
		end case;
	end process;
end a;
-------------------------------------------------------

-----------------FF con ingresso multiplexato ---------
library ieee;
use ieee.std_logic_1164.all;

entity Blocco is
port(	a,b,s,en ,CK, rst : in std_logic;
		o : out std_logic);
end Blocco;

architecture a of Blocco is
component FFo is 
port(	d,Ck,rst,en: in std_logic;
		q: out std_logic);
end component;
component mux_2 is
port( a,b,s : in std_logic;
		o : out std_logic);
end component;
signal temp : std_logic;
begin
 mul0: mux_2 port map(a => a, b => b, s => s, o =>temp);
 flip0 : ffo port map(d => temp, Ck => CK, rst => rst, en => en, q =>o);
end a;
------------------------------------------------------------

 ------------------ Flip Flop ------------------
 library ieee;
use ieee.std_logic_1164.all;

entity FFo is 
port(	d,Ck,rst, EN: in std_logic;
		q: out std_logic);
end FFo;
architecture behavior of FFo is
begin
		process (Ck)
		begin
			if (Ck'event and Ck ='1') then
				if (rst = '1') then
					q<='0';
				elsif (EN = '1') then
					q <= d;
				end if;
			end if;
		end process;
end behavior;
