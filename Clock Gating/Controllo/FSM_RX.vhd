library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic


entity FSM_RX is

port( 	REQ_I:	in std_logic;
		CLOCK: 	in std_logic;
		RESET:	in std_logic;
		ACK_O: buffer std_logic; 
		EN_SHIFTIN, EN_LATCHIN, STOP, RST_O:	out std_logic;
		RST_SHIFTIN, RST_LATCHIN:	out std_logic
		
);
end FSM_RX;

---------------------------------------------

architecture FSM_R of FSM_RX is
  
	type TYPE_STATE is (IDLE,Ric1,Ric2, RXstate1,RXstate2,
						END_S,
						 ResetState);--
	signal CURRENT_STATE : TYPE_STATE;
	signal NEXT_STATE : TYPE_STATE;
	signal Prec_REQ_I, Prec_ACK_I : std_logic;

begin
 	
 	P_PROC : process(CLOCK)		
     begin
		if (CLOCK'EVENT and CLOCK ='1') then 
			if RESET='1' then
	        	CURRENT_STATE <= ResetState;
			else
			CURRENT_STATE <= NEXT_STATE;
		end if;
		end if;
	end process P_PROC;

	P_NEXT_STATE : process(CURRENT_STATE, REQ_I, RESET)
			begin
	
		case CURRENT_STATE is
		     when IDLE =>   if REQ_I = Prec_REQ_I then -- protocollo basato sulle transizioni, lo uso per limitare il numero di
		                                               -- transizioni associate al protocollo
		                        NEXT_STATE <= IDLE;
		                    else
		                        NEXT_STATE <= Ric1;
		                    end if;
				
			  when Ric1 => NEXT_STATE <= Ric2;
			  
			  when Ric2 => NEXT_STATE <= RXstate1;
			  
			  when RXstate1 => NEXT_STATE <= RXstate2;
			  
			  when RXstate2 => NEXT_STATE <= END_S;
			  
		  				   
  		     when END_S =>   if REQ_I = prec_REQ_I then
                                    NEXT_STATE <= IDLE;
                                 else
                                    NEXT_STATE <= Ric1;	
                                 end if;
			
			  when ResetState =>	NEXT_STATE <= IDLE;
		end case;	
	end process P_NEXT_STATE;

	
	P_OUTPUTS: process(CURRENT_STATE)
	begin
		--O <= '0';
		case CURRENT_STATE is

			when IDLE => 		RST_SHIFTIN <= '1';
								RST_LATCHIN <= '0'; 
								ACK_O <= ACK_O; -- protocollo a fronti
								EN_SHIFTIN <= '0';
								EN_LATCHIN <= '0';
								STOP <= '0';
								Prec_REQ_I <= REQ_I;
								RST_O<='0';

			when Ric1 =>		 RST_SHIFTIN <= '1';
								ACK_O <= not ACK_O;
								EN_SHIFTIN <= '1';
								EN_LATCHIN <= '0';
								STOP <= '0';
								Prec_REQ_I <= REQ_I;

			when Ric2 => 		RST_SHIFTIN <= '1';
								ACK_O <= ACK_O; 
								EN_SHIFTIN <= '1';
								EN_LATCHIN <= '0';
								STOP <= '0';
								Prec_REQ_I <= REQ_I;

			when RXstate1 => 	RST_SHIFTIN <= '1';
								ACK_O <= ACK_O; 
								EN_SHIFTIN <= '1';
								EN_LATCHIN <= '0';
								STOP <= '0';
								Prec_REQ_I <= REQ_I;

			when RXstate2 => 	RST_SHIFTIN <= '1';
								ACK_O <= ACK_O; 
								EN_SHIFTIN <= '1';
								EN_LATCHIN <= '1';
								STOP <= '0';
								Prec_REQ_I <= REQ_I;
								
								
			when end_s => 		RST_SHIFTIN <= '1';
								ACK_O <= '0';
								EN_SHIFTIN <= '0'; 
								EN_LATCHIN <= '0';
								STOP <= '1';
								Prec_REQ_I <= REQ_I;
			
			 when ResetState =>	RST_SHIFTIN <= '0';
								Prec_REQ_I <= REQ_I;
								RST_LATCHIN <= '1'; 
								ACK_O <= '0'; 
								EN_SHIFTIN <= '0';
								EN_LATCHIN <= '0';
								STOP <= '0'; 
								RST_O <= '1';

		end case; 	
	end process P_OUTPUTS;
end FSM_R;

configuration CFG_FSM_R of FSM_RX is
	for  FSM_R
	end for;
end CFG_FSM_R;
