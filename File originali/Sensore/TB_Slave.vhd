library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
use work.all;

entity testbench is
end testbench;

architecture behavioral of testbench is
component Interface_sensore is
generic(N : integer :=3); --lunghezza in bit del pacchetto
port(	CK_I, Ack_I,RST_i,Start : in std_logic;
		Bus_o,  Req_o,EOT: out std_logic;
		dati_out : in std_logic_vector (N-1 downto 0));
end component;

signal Ck : std_logic :='0';
signal RST : std_logic;
signal Bus_out, Req_o, EOT  : std_logic;
signal ACK_I, SOT, temp_ack_i : std_logic;
signal Dato_out,tempo : std_logic_vector(2 downto 0);

begin

INTRF: Interface_sensore Port Map ( CK_I=> Ck,  Ack_I=>ACK_I,  RST_i=>RST, Start => SOT, Bus_o =>Bus_out ,Req_o =>req_o ,EOT => EOT,
                              dati_out => DAto_out);

-- clock process
Pck: process(ck)
begin
ck <= not(ck) after 5 ns;
end process;

rst <= '0', '1' after 0.1 ns, '0' after 15 ns, '1' after 400 ns;

datout: process(rst,ck) 
        file infile: text is in "./Datiout.txt";
        variable lin: line;
        variable datofile: std_logic_vector(2 downto 0);
        variable n: integer := 0;
        begin
            if rst='1' then
               tempo <= (others =>'0');
			   temp_ack_i<='0';
            elsif ck'event and ck='1' then
               if (n = 0) then
                   sot <= '1';
                   temp_ack_i <= ack_i;
                   if not(endfile(infile)) then
                    readline(infile,lin);
                    read(lin,datofile);
                    tempo <= datofile;
                    n := n + 1;
                  end if;
                elsif n=1 then
                    sot <= '1';
                    temp_ack_i <=  ack_i;
                    n := n+1;
                elsif n = 2 then
                    sot <= '0';
                    temp_ack_i <= not ack_i;
                    n:=n+1;
                elsif n=3 then
                    sot <= '0';
                    temp_ack_i <= ack_i;
                    n:=n+1;                  
                elsif (n = 4) then
                   n := 0;
                   sot <= '0';
                   temp_ack_i <= ack_i;
                end if;               
            end if;
        end process;
        DAto_out<= tempo;
        ack_i <= temp_ack_i;
        
        
 
end behavioral;