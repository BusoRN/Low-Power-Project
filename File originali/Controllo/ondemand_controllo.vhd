library ieee;
use ieee.std_logic_1164.all;

entity Interfaccia_ondemand_controllo is
generic (N : integer := 6);
port( 	CK_I : in std_logic;
	push :in std_logic;
	Bus_ing_ondemand, ACK_I, REQ_I, RST : in std_logic;
	Bus_out_ondemand, ACK_O, REQ_O, dato_valido : out std_logic;
	fifo_full : out std_logic;
	comandi_ing : in std_logic_vector(N-1 downto 0);
	dato_ondemand : out std_logic_vector(0 to N-1) 
);
end Interfaccia_ondemand_controllo;

Architecture A of Interfaccia_ondemand_controllo is
component ShiftReg_ing is
generic(N : integer :=8);
port(	RST,EN,Ck, Dato_in: in std_logic;
		Dato_out: buffer std_logic_vector(N-1 downto 0));
end component;
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
component fifo is  
port (  clk : in std_logic;  
        pop : in std_logic;     
        push : in std_logic;     
        dataout : out std_logic_vector(5 downto 0);     
        datain : in std_logic_vector (5 downto 0);    
        empty : out std_logic;      
        full : out std_logic;     
        rst : in std_logic  
     );  
end component;
component FF_generic is 
generic (N : integer :=3);
port(	Ck,rst, EN: in std_logic;
		d : in std_logic_vector( N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0));
end component;

component FSM_RX2 is

port( 	REQ_I:	in std_logic;
		CLOCK: 	in std_logic;
		RESET:	in std_logic;
		empty: in std_logic;
		ACK_I: in std_logic; 
		REQ_O,ACK_O: buffer std_logic; 
		EN_SHIFTIN, EN_LATCHIN, dato_valido:	out std_logic;
		EN_SHIFTOUT, EN_FFCOM, RST_SHIFTOUT, RST_FFCOM : out std_logic;
		command: in std_logic_vector(2 downto 0);
		RST_SHIFTIN, RST_LATCHIN, S_O, pop:	out std_logic
		
);
end component;

signal empty, en_ff_com, rst_ff_com, rst_sr_O, en_sr_O, S_O, rst_sr_I, en_sr_I, en_latch_I, rst_latch_I, pop : std_logic;

signal comando_da_inviare, uscita_SR : std_logic_vector(N-1 downto 0);

signal command : std_logic_vector(2 downto 0);

begin

fifo_comandi : 	fifo port map (clk => CK_I, pop => pop, push => push, dataout => comando_da_inviare, datain => comandi_ing, empty => empty, full => fifo_full, rst => RST);

SR_O : ShiftOut generic map (N)
                port map(RST => rst_sr_O, EN => en_sr_O, S => S_O, Ck => CK_I, Dato_out => Bus_out_ondemand, Dato_in => comando_da_inviare);

Comando_in_esecuzione : FF_generic generic map (3)
			port map(CK => CK_I, rst => rst_ff_com, EN => en_ff_com, d => comando_da_inviare(5 downto 3), q => command );

SR_I : ShiftReg_ing generic map(N)
		port map (RST => rst_sr_I, EN => en_sr_I,Ck => CK_I, Dato_in => Bus_ing_ondemand,Dato_out =>uscita_SR);

L2: for I in 1 to N generate
   REG2i: Latch_N port map (d =>uscita_SR(i-1), C => en_latch_I, rst => rst_latch_I, q => dato_ondemand(i-1));
end generate;

FSM: FSM_RX2 port map(	REQ_I => REQ_I, CLOCK => CK_I,	RESET => RST,	empty => empty,		ACK_I => ACK_I,	REQ_O => REQ_O,
               ACK_O => ACK_O,	EN_SHIFTIN => en_sr_i, EN_LATCHIN => en_latch_i, dato_valido => dato_valido,
		EN_SHIFTOUT => en_sr_o, EN_FFCOM => en_ff_com, RST_SHIFTOUT => rst_sr_o, RST_FFCOM => rst_ff_com,
		command => command,		RST_SHIFTIN => rst_sr_i, RST_LATCHIN => rst_latch_i, S_O => S_O, pop => pop);
end A;
