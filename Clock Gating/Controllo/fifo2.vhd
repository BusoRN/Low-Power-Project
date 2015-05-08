library IEEE;  
use IEEE.STD_LOGIC_1164.ALL;  
use IEEE.STD_LOGIC_ARITH.ALL;  
use IEEE.STD_LOGIC_UNSIGNED.ALL;  

entity fifo is  
port (  clk : in std_logic;  
   pop : in std_logic;   --enable read,should be '0' when not in use.  
   push : in std_logic;    --enable write,should be '0' when not in use.  
   dataout : out std_logic_vector(5 downto 0);    --output data  
   datain : in std_logic_vector (5 downto 0);     --input data  
   empty : out std_logic;     --set as '1' when the queue is empty  
   full : out std_logic;     --set as '1' when the queue is full
  --error_no_push : out std_logic; -- asserita in caso di push non riuscita
   rst : in std_logic  
);  
end fifo;  

architecture Behavioral of fifo is  
   type memory_type is array (0 to 3) of std_logic_vector(5 downto 0);  
   signal memory : memory_type :=(others => (others => '0')); --memory for queue.  
   signal readptr,writeptr : std_logic_vector(1 downto 0); --read/write pointers.  
      begin  
   process(clk, rst)  
      begin
      if rst = '1' then
         dataout <= (others => '0');
         memory <= (others=>(others=>'0')); 
         readptr <= "00";
         empty <='1';
         writeptr <= "00";   
         full <= '0';
            --error_no_push <= '0';
        elsif(clk'event and clk='0') then 
            if (pop ='1') then
                dataout <= memory(conv_integer(readptr));
                full <= '0';
                --controllo che la memoria non sia vuota
                if (writeptr = readptr) then
                    empty <= '1';
                --incremento dei puntatori
                else 
                   if (readptr = "11") then
                       readptr <= "00";
                       empty <= '0';
                    else
                       readptr <= readptr + "01";
                       empty <= '0';
                   end if;
                 end if;
             --end if; --end pop
            elsif (push = '1') then
                memory(conv_integer(writeptr)) <= datain; 
                empty <='0';
                --controllo che la memoria non sia piena
                --if(writeptr = readptr - "01") then
                if ((readptr = "00") and (writeptr = "11")) or ((readptr = "10") and (writeptr = "01")) or ((readptr = "01") and (writeptr = "00")) or ((readptr = "11") and (writeptr = "10")) then
                    full <= '1';
                --incremento i puntatori
                else
                   if (writeptr = "11") then
                       writeptr <= "00";
                       full <= '0';
                    else
                       writeptr <= writeptr + "01";
                       full <= '0';
                   end if;
               end if;
               
               else
                   if (writeptr = readptr) then
                       empty <= '1';
                    else 
                       empty <= '0';
                    end if;
				END IF;
            end if;--end clk
    end process;
end Behavioral; 

