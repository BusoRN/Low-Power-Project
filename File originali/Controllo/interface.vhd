library ieee;
use ieee.std_logic_1164.all;

entity Interface_minimo_controllo is
generic(N : integer :=3); --lunghezza in bit del pacchetto
port(	CK_I, Bus_ing,Req_I,RST : in std_logic;
		RST_O,  ACK_O, EOR  : out std_logic;
		dati_ing : out std_logic_vector(0 to N-1)--e' invertito al fine di avere un endianess di tipo big endian 
		);
end Interface_minimo_controllo;
architecture A of Interface_minimo_controllo is
component ShiftReg_ing is
generic(N : integer :=3);
port(	RST,EN,Ck, Dato_in: in std_logic;
		Dato_out: buffer std_logic_vector(N-1 downto 0));
end component;
component Latch_N is
port(	d: in std_logic;
		C,rst: in std_logic;
		q: out std_logic);
end component;
component FSM_RX2 is
port( 	REQ_I:	in std_logic;
		CLOCK: 	in std_logic;
		RESET:	in std_logic;
		ACK_O, EN_SHIFTIN, EN_LATCHIN, STOP, RST_O:	out std_logic;
		RST_SHIFTIN, RST_LATCHIN:	out std_logic
		
);
end component;

signal uscita_SR : std_logic_vector(N-1 downto 0);
signal en_sr_I, rst_sr_I, en_latch_I, rst_latch_I: std_logic; 
begin
SR_I : ShiftReg_ing generic map(N)
							port map (RST => rst_sr_I, EN => en_sr_I,Ck => CK_I, Dato_in => Bus_ing,Dato_out =>uscita_SR);
L1: for I in 1 to N generate
   REGi: Latch_N port map (d =>uscita_SR(i-1), C => en_latch_I, rst => rst_latch_I, q => dati_ing(i-1));
end generate;
FSM_I : FSM_RX2 port map(REQ_I => Req_I, CLOCK=> CK_I, RESET=> RST, ACK_O=> ACK_O, EN_SHIFTIN => en_sr_I,
               EN_LATCHIN => en_latch_I, STOP => EOR,RST_SHIFTIN=>rst_sr_I, RST_LATCHIN=>rst_latch_I, RST_O => RST_O);

end A;

