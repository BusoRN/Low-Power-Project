library ieee;
use ieee.std_logic_1164.all;

entity Lato_sensore is
generic( N: integer := 3; --lunghezza della misura del rumore minimo
		 M: integer := 6);--lunghezza della trasmissione ondemand
port(	 CK_I : in std_logic;
		 Ack_I,RST_I,Start : in std_logic;
		 Bus_o, Req_o, EOT : out std_logic;--EOT = End Of Transmission
		 media_minima : in std_logic_vector (N-1 downto 0); -- è la media che viene trasmessa periodicamente
		 Bus_ing_ondemand, ACK_I_ondemand, REQ_I_ondemand : in std_logic;-- questi sono i segnali che gestiscono la 
		 Bus_out_ondemand, ACK_O_ondemand, REQ_O_ondemand : out std_logic;-- comunicazione tra l'interfaccia lato sensore
																		 -- l'interfaccia lato controllo
		 req_ondemand: out std_logic;--segnali che gestiscono la comunicazione tra l'interfaccia lato sensore
		 ack_ondemand : in std_logic;-- e l'unità di calcolo ed elaborazione delle misure dei sensori
		 comandi_ondemand : buffer std_logic_vector(0 to M-1);--invertito per mantenere l'endianess
		 dato_ondemand : in std_logic_vector(M-1 downto 0) 
);
end Lato_sensore;

architecture A of Lato_sensore is
---Componenti
--- parte dedicata alla trasmissione della media minima
component Interface_sensore is
generic(N : integer :=3); --lunghezza in bit del pacchetto
port(	CK_I, Ack_I,RST_I,Start : in std_logic;
		Bus_o,  Req_o,EOT: out std_logic;
		dati_out : in std_logic_vector (N-1 downto 0));
end component Interface_sensore;

--- parte dedicata alla trasmissione di tipo ondemand
component Interfaccia_ondemand_sensore is
generic (N : integer := 6);
port( 	CK_I : in std_logic;
	Bus_ing_ondemand, ACK_I, REQ_I, RST_I : in std_logic;
	Bus_out_ondemand, ACK_O, REQ_O : out std_logic;
	req_ondemand: out std_logic;
	ack_ondemand : in std_logic;
	comandi_ondemand : buffer std_logic_vector(0 to N-1);
	dato_ondemand : in std_logic_vector(N-1 downto 0) 
);
end component Interfaccia_ondemand_sensore;

begin

interfaccia_media_minima: Interface_sensore generic map(N)
					port map(CK_I => CK_I, Ack_I => Ack_I, RST_I => RST_I,
						Start => Start, Bus_o => Bus_o, Req_o => Req_o,
						EOT => EOT, dati_out => media_minima);
ondemand: Interfaccia_ondemand_sensore generic map(M)
					port map(CK_I => CK_I, Bus_ing_ondemand => Bus_ing_ondemand,
					ACK_I => ACK_I_ondemand, REQ_I => REQ_I_ondemand,
					RST_I => RST_I,Bus_out_ondemand => Bus_out_ondemand, 
					ACK_O => ACK_O_ondemand, REQ_O => REQ_O_ondemand, 
					req_ondemand => req_ondemand,ack_ondemand => ack_ondemand,
					comandi_ondemand => comandi_ondemand,dato_ondemand => dato_ondemand);
end A;