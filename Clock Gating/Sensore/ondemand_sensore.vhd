library ieee;
use ieee.std_logic_1164.all;

entity Interfaccia_ondemand_sensore is
generic (N : integer := 6);
port( 	CK_I : in std_logic;
	Bus_ing_ondemand, ACK_I, REQ_I, RST_I : in std_logic;
	Bus_out_ondemand: out std_logic; 
        ACK_O, REQ_O : buffer std_logic;
	req_ondemand: out std_logic;
	ack_ondemand : in std_logic;
	comandi_ondemand : inout std_logic_vector(0 to N-1);
	dato_ondemand : in std_logic_vector(N-1 downto 0) 
);
end Interfaccia_ondemand_sensore;

Architecture A of Interfaccia_ondemand_sensore is
component ShiftReg_ing is
generic(N : integer :=6);
port(	RST,EN,Ck, Dato_in: in std_logic;
		Dato_out: buffer std_logic_vector(N-1 downto 0));
end component;
component Latch_N is
port(	d: in std_logic;
		C,rst: in std_logic;
		q: out std_logic);
end component;
component ShiftOut is
generic(N : integer :=6);
port(	RST,EN,S,Ck: in std_logic;
		Dato_out: out std_logic;
		Dato_in: in std_logic_vector(N-1 downto 0));
end component;
component FF_generic is 
generic (N : integer :=3);
port(	Ck,rst, EN: in std_logic;
		d : in std_logic_vector( N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0));
end component;
component FSM_ondemand_sensore is

port( 	REQ_I,ack_i:	in std_logic;
		CLOCK: 	in std_logic;
		RST_I:	in std_logic;
		ACK_O,req_o: buffer std_logic; 
		command : in std_logic_vector(2 downto 0);
		req_ondemand : out std_logic;
		ack_ondemand : in std_logic;
		S_O : out std_logic;
		EN_SHIFTIN, EN_LATCHIN, EN_FFCOM, EN_SHIFTOUT, EN_LATCHOUT:	out std_logic;
		RST_SHIFTIN, RST_LATCHIN, RST_FFCOM, RST_SHIFTOUT,RST_LATCHOUT:	out std_logic
		
);
end component FSM_ondemand_sensore;

signal  en_ff_com, rst_ff_com, rst_sr_O, en_sr_O, S_O, rst_sr_I,
 en_sr_I, en_latch_I, rst_latch_I, en_latch_o, rst_latch_o : std_logic;

signal ingresso_SR, uscita_SR : std_logic_vector(N-1 downto 0);

signal command : std_logic_vector(2 downto 0);

begin
SR_I : ShiftReg_ing generic map(N)
							port map (RST => rst_sr_I, EN => en_sr_I,
							Ck => CK_I, Dato_in => Bus_ing_ondemand,Dato_out =>uscita_SR);
L1: for I in 1 to N generate
   REGi: Latch_N port map (d =>uscita_SR(i-1),
   C => en_latch_I, rst => rst_latch_I, q => comandi_ondemand(i-1));
end generate;
SR_O : ShiftOut generic map (N)
                port map(RST => rst_sr_O, EN => en_sr_O, S => S_O, Ck => CK_I,
				Dato_out => Bus_out_ondemand,Dato_in => ingresso_SR);
 L2: for I in 1 to N generate
   REG2i: Latch_N port map (d =>dato_ondemand(i-1), C => en_latch_O, rst => rst_latch_O, q => ingresso_SR(i-1));
end generate;               
Comando_in_esecuzione : FF_generic generic map (3)
			port map(CK => CK_I, rst => rst_ff_com, EN => en_ff_com, d => comandi_ondemand (0 to 2), q => command );
FSM : FSM_ondemand_sensore port map( REQ_I => req_i,ack_i => ack_i,CLOCK => ck_I,
		RST_I=> rst_i,ACK_O => ack_o,req_o => req_o, command => command,
		req_ondemand => req_ondemand, ack_ondemand => ack_ondemand,	S_O => S_O,
		EN_SHIFTIN => en_sr_i, EN_LATCHIN => en_latch_i, EN_FFCOM => en_ff_com,
		EN_SHIFTOUT => en_sr_o, EN_LATCHOUT => en_latch_o, RST_SHIFTIN => rst_sr_i,
		RST_LATCHIN => rst_latch_i, RST_FFCOM => rst_ff_com, 
		RST_SHIFTOUT => rst_sr_o,RST_LATCHOUT=> rst_latch_o);
end A;
