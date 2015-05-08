
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
use work.all;

entity testbench is
end testbench;

architecture behavioral of testbench is
component Interfaccia_ondemand_sensore is
generic (N : integer := 6);
port( 	CK_I : in std_logic;
	Bus_ing_ondemand, ACK_I, REQ_I, RST_I : in std_logic;
	Bus_out_ondemand, ACK_O, REQ_O : out std_logic;
	req_ondemand: out std_logic;
	ack_ondemand : in std_logic;
	comandi_ondemand : out std_logic_vector(0 to N-1);
	dato_ondemand : in std_logic_vector(N-1 downto 0) --invertito per mantenere l'endianess
);
end component;

signal Ck  : std_logic:='0';
signal RST,temp_req_I : std_logic;
signal Bus_out_ondemand, ack_o, Req_o : std_logic;
signal Bus_ing_ondemand, ACK_I, REQ_I : std_logic;
signal comandi_ondemand,dato_ondemand,tempo: std_logic_vector(5 downto 0);
signal temp, temp_ack_i,temp_ack_ondemand,ack_ondemand,req_ondemand : std_logic;

begin

INTRF: Interfaccia_ondemand_sensore Port Map ( CK_I => Ck,
 Bus_ing_ondemand => Bus_ing_ondemand, ACK_I => ACK_I, REQ_I => REQ_I, 
 RST_i => rst,Bus_out_ondemand => Bus_out_ondemand, ACK_O => ack_o, 
 REQ_O => req_o,req_ondemand =>req_ondemand,ack_ondemand => ack_ondemand,
 comandi_ondemand => comandi_ondemand,dato_ondemand => dato_ondemand );

-- clock process
Pck: process(ck)
begin
ck <= not(ck) after 10 ns;
end process;

rst <= '0', '1' after 0.1 ns, '0' after 15 ns;

-- trasmissione comandi e ricezione dato
TX_RX: process(rst,ck) 
file infile: text is in "./datin.txt";
variable n: integer := 0;
variable lin: line;
variable datofile: std_logic;

file infile2: text is in "./Datiout.txt";
variable lin2: line;
variable datofile2: std_logic_vector(5 downto 0);
variable n2: integer := 0;


begin
   if rst='1' then
       temp_ack_ondemand <= '0';
	  temp_ack_i <= '0';
      temp <= '0';
      temp_req_I <= '0';
      tempo <= (others =>'0');
      n:= 0;
	elsif ck'event and ck='1' then
			if n=0 then
				temp <='0';
				temp_req_i <= not(req_i);
				n := n+1;
			elsif n=1 then
				readline(infile,lin);
				read(lin,datofile);
				temp <= datofile;
				n := n + 1;
				temp_req_i <= req_i;
			elsif n=2 then
				readline(infile,lin);
				read(lin,datofile);
				temp <= datofile;
				n := n + 1;
				temp_req_i <= req_i;
			elsif n=3 then
				readline(infile,lin);
				read(lin,datofile);
				temp <= datofile;
				n := n + 1;
				temp_req_i <= req_i;
			elsif n=4 then
				readline(infile,lin);
				read(lin,datofile);
				temp <= datofile;
				n := n + 1;
				temp_req_i <= req_i;
			elsif n=5 then
				readline(infile,lin);
				read(lin,datofile);
				temp <= datofile;
				n := n + 1;
				temp_req_i <= req_i;
			elsif n=6 then
				readline(infile,lin);
				read(lin,datofile);
				temp <= datofile;
				n := n + 1;
				temp_req_i <= req_i;
			elsif n=7 then
				temp <='0';
				n:=n+1;
			elsif n=8 then
				temp <='0';
				n:=n+1; 
			elsif n=9 then
				temp <='0';
				temp_ack_ondemand <= ack_ondemand;
				n:=n+1;
			elsif (n = 10) then
				temp_ack_ondemand <= '1';
				temp <= '0';
				temp_req_I <= REQ_I;
				if not(endfile(infile2)) then
					readline(infile2,lin2);
					read(lin2,datofile2);
					tempo <= datofile2;
				end if;
				n:= n+1;
			elsif (n=11) then
				temp_ack_ondemand <= '0';
				temp_ack_i <= ack_i;
				temp <= '0';
				n := n + 1;
				temp_req_I <= REQ_I;
			elsif n=12 then

					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=13 then
					temp_ack_i <= not ack_i;
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=14 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=15 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=16 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=17 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=18 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=19 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=20 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=21 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=22 then
					temp <= '0';
					n := n + 1;
					temp_req_I <= REQ_I;
			elsif n=23 then
					temp <= '0';
					n := 0;
					temp_req_I <= REQ_I;
			end if;
	end if;
end process;
Bus_ing_ondemand <= temp;
req_i<=temp_req_I;
dato_ondemand<= tempo;
ack_i <= temp_ack_i;
ack_ondemand <= temp_ack_ondemand;

        
 
end behavioral;            
