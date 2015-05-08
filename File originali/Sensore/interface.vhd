library ieee;
use ieee.std_logic_1164.all;

entity Interface_sensore is
generic(N : integer :=3); --lunghezza in bit del pacchetto
port(	CK_I, Ack_I,RST_I,Start : in std_logic;
		Bus_o,  Req_o,EOT: out std_logic;
		dati_out : in std_logic_vector (N-1 downto 0));
end Interface_sensore;
architecture A of Interface_sensore is

component Latch_N is
port(	d: in std_logic;
		C,rst: in std_logic;
		q: out std_logic);
end component;


component ShiftOut is
generic(N : integer :=8);
port(	RST,EN,S,Ck: in std_logic;
		Dato_out: out std_logic;
		Dato_in: in std_logic_vector(N-1 downto 0));
end component;
component FSM_TX_sens is
port( 	ACK_I, START:	in std_logic;
	CLOCK: 	in std_logic;
	RST_i:	in std_logic;
	RST_SHIFTOUT, RST_LATCHOUT, S_O :out std_logic;
	REQ_O, EN_SHIFTOUT, EN_LATCHOUT, STOP:	out std_logic 
);
end	component;

signal ingresso_SR : std_logic_vector(N-1 downto 0);
signal  en_sr_O,rst_sr_O, en_latch_O, rst_latch_O,S_O: std_logic; 
begin
SR_O : ShiftOut generic map (N)
                port map(RST => rst_sr_O, EN => en_sr_O, S => S_O, Ck => CK_I, Dato_out => Bus_o,Dato_in => ingresso_SR);

FSM_O : FSM_TX_sens port map(ACK_I => Ack_I,START => Start,CLOCK => CK_I,RST_i => RST_i,RST_SHIFTOUT => rst_sr_O,
               RST_LATCHOUT => rst_latch_O ,S_O => S_O ,REQ_O => Req_o,EN_SHIFTOUT => en_sr_O,EN_LATCHOUT => en_latch_O,STOP => EOT);
L2: for I in 1 to N generate
   REG2i: Latch_N port map (d =>dati_out(i-1), C => en_latch_O, rst => rst_latch_O, q => ingresso_SR(i-1));
end generate;


end A;

