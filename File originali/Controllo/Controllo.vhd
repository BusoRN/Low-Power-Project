library ieee;
use ieee.std_logic_1164.all;

entity Lato_controllo is
generic( N : integer := 3;
         M : integer := 6);
port(	 CK_I :in std_logic;
		 Bus_ing,Req_I : in std_logic;
		 RST : in std_logic;
		 RST_O,  ACK_O, EOR  : out std_logic;
		 media_minima : out std_logic_vector(0 to N-1);
		 push :in std_logic;
		 Bus_ing_ondemand, ACK_I_ondemand, REQ_I_ondemand: in std_logic;
		 Bus_out_ondemand, ACK_O_ondemand, REQ_O_ondemand, dato_valido : out std_logic;
		 fifo_full : out std_logic;
		 comandi_ondemand : in std_logic_vector(N-1 downto 0);
		 dato_ondemand : out std_logic_vector(0 to N-1) --invertito per mantenere l'endianess
);
end Lato_controllo;

architecture A of Lato_controllo is
component Interfaccia_ondemand_controllo is
generic (N : integer := 6);
port( 	CK_I : in std_logic;
	push :in std_logic;
	Bus_ing_ondemand, ACK_I, REQ_I, RST : in std_logic;
	Bus_out_ondemand, ACK_O, REQ_O, dato_valido : out std_logic;
	fifo_full : out std_logic;
	comandi_ing : in std_logic_vector(N-1 downto 0);
	dato_ondemand : out std_logic_vector(0 to N-1) 
);
end component Interfaccia_ondemand_controllo;

component Interface_minimo_controllo is
generic(N : integer :=3); --lunghezza in bit del pacchetto
port(	CK_I, Bus_ing,Req_I,RST : in std_logic;
		RST_O,  ACK_O, EOR  : out std_logic;
		dati_ing : out std_logic_vector(0 to N-1)
		);
end component Interface_minimo_controllo;

begin

interfaccia_minimo: Interface_minimo_controllo generic map (N)
						port map(CK_I => CK_I, Bus_ing => Bus_ing,Req_I => Req_i,
							RST => RST,RST_O => RST_O,  ACK_O=> ACK_O,
							EOR => EOR, dati_ing => media_minima);
							
controllo_ondemand: Interfaccia_ondemand_controllo generic map (M)
						port map(CK_I => CK_I,push => push,Bus_ing_ondemand =>Bus_ing_ondemand, 
						ACK_I => ACK_I_ondemand, REQ_I => REQ_I_ondemand, 
						RST => RST,Bus_out_ondemand => Bus_out_ondemand, 
						ACK_O => ACK_O_ondemand, REQ_O => REQ_O_ondemand,
						dato_valido => dato_valido,fifo_full => fifo_full,
						comandi_ing => comandi_ondemand,dato_ondemand => dato_ondemand);
						
end A;