library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic


entity FSM_RX2 is

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
end FSM_RX2;

---------------------------------------------

architecture FSM_R2 of FSM_RX2 is
  
	type TYPE_STATE is (IDLE,RICHIESTA,
				TX1,TX2,TX3,TX4,TX5,TX6,
				WAIT1,WAIT2,
				RX1,RX2,RX3,RX4,RX5,RX6,
				END_S, ResetState);--
	signal CURRENT_STATE : TYPE_STATE;
	signal NEXT_STATE : TYPE_STATE;
	signal Prec_REQ_I, Prec_ACK_I: std_logic;

begin
 	
 	P_PROC : process(CLOCK, reset)		
     begin
		if RESET='1' then
	        	CURRENT_STATE <= ResetState;
		elsif (CLOCK'EVENT and CLOCK ='1') then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process P_PROC;

	P_NEXT_STATE : process(CURRENT_STATE, REQ_I, RESET,clock,empty,ack_i)
			begin
		
		case CURRENT_STATE is
			  when IDLE =>   if empty ='1' then  
								     NEXT_STATE <= idle;
							      else
								      NEXT_STATE <= richiesta;	
							      end if;
				
			  when RICHIESTA => NEXT_STATE <= TX1;
			  
			  when TX1 => if ack_i = prec_ack_i then 
					NEXT_STATE <= IDLE;
				      else
					NEXT_STATE <= TX2;
				      end if;
			  
			  when TX2 => NEXT_STATE <= TX3;
			      
			  when TX3 => NEXT_STATE <= TX4;
			  
			  when TX4 => NEXT_STATE <= TX5;
			      
			  when TX5 => NEXT_STATE <= TX6;
			  
			  when TX6 => NEXT_STATE <= WAIT1;

			  when WAIT1 => NEXT_STATE <= WAIT2;

			  when WAIT2 => if REQ_I = prec_REQ_i then
					NEXT_STATE <= WAIT2;
				      else
					NEXT_STATE <= rx1;
				      end if;
			  
			  when RX1 => NEXT_STATE <= RX2;
			  
			  when RX2 => NEXT_STATE <= RX3;
			  
			  when RX3 => if command = "111" then
					NEXT_STATE <= RX4;
				      else
					NEXT_STATE <= END_S;
				      end if;
			  when RX4 => NEXT_STATE <= RX5;

			  when RX5 => NEXT_STATE <= RX6;
  
			  when RX6=> NEXT_STATE <= END_S;
			      			  				   
  		     when END_S =>   if EMPTY ='0' then
                                    NEXT_STATE <= RICHIESTA;
                                 else
                                    NEXT_STATE <= IDLE;	
                                 end if;
			
			  when ResetState =>	NEXT_STATE <= IDLE;
		end case;	
	end process P_NEXT_STATE;

	
	P_OUTPUTS: process(CURRENT_STATE)
	begin
		case CURRENT_STATE is

			when IDLE => 	REQ_O <= REQ_O; -- faccio un protocollo a transizione per diminuire la Esw sul bus
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '0';
			      RST_LATCHIN <= '0'; 
					EN_SHIFTIN <= '0';
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					RST_FFCOM <= '1';--
					EN_SHIFTOUT <= '0';
					EN_FFCOM<= '0';--
					S_O <= '0';
					dato_valido <= '0';
					POP <= '0';
					Prec_REQ_I<= REQ_I;

			when RICHIESTA =>	REQ_O <= REQ_O;
						ACK_O <=ACK_O;
                  RST_SHIFTIN <= '1';
                  RST_LATCHIN <= '0'; 
                  EN_SHIFTIN <= '0';
                  EN_LATCHIN <= '0';
                  RST_SHIFTOUT <= '0';
                  RST_FFCOM <= '1';--
                  EN_SHIFTOUT <= '1';
                  EN_FFCOM<= '1';--
                  S_O <= '0';
                  dato_valido <= '0';
                  POP <='1';

			when TX1 => 		REQ_O <= NOT(REQ_O); 
						ACK_O <=ACK_O;
                  RST_SHIFTIN <= '1';
                  RST_LATCHIN <= '0'; 
                  EN_SHIFTIN <= '0';
                  EN_LATCHIN <= '0';
                  RST_SHIFTOUT <= '0';
                  RST_FFCOM <= '0';--
                  EN_SHIFTOUT <= '1';
                  EN_FFCOM<= '1';--
                  S_O <= '1';
                  dato_valido <= '0';
                  POP <= '0';
						

			when TX2 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '1';
               EN_FFCOM<= '1';--
               S_O <= '0';
               dato_valido <= '0';
               POP <= '0';
               Prec_ack_I <= ack_I;
	
			when TX3 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '1';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               POP <= '0';

			when TX4 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '1';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               POP <='0';

			when TX5 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '1';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               POP <='0';

			when TX6 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '1';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               POP <='0';

			when WAIT1 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '1';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               POP <='0';


			when WAIT2 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
				RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               POP <='0';
			   
   			when RX1 => 	REQ_O <= REQ_O; 
					ACK_O <=not(ACK_O);
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop <= '0';
               Prec_REQ_I <= REQ_I;

			when RX2 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop<='0';

			when RX3 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop<='0';

			when RX4 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop<='0';

			when RX5 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop<='0';

			when RX6 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop<='0';


			when end_s => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
               RST_SHIFTIN <= '1';
               RST_LATCHIN <= '0'; 
               EN_SHIFTIN <= '1';
               EN_LATCHIN <= '1';
               RST_SHIFTOUT <= '0';
               RST_FFCOM <= '0';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '1';
               pop<='0';
			
			 when ResetState =>	Prec_REQ_I<= REQ_I;
					ACK_O <='0';
					REQ_O <= '0';
					Prec_ACK_I <= ACK_I;
               RST_SHIFTIN <= '0';
               RST_LATCHIN <= '1'; 
               EN_SHIFTIN <= '0';
               EN_LATCHIN <= '0';
               RST_SHIFTOUT <= '1';
               RST_FFCOM <= '1';--
               EN_SHIFTOUT <= '0';
               EN_FFCOM<= '0';--
               S_O <= '0';
               dato_valido <= '0';
               pop<='0';
 

		end case; 	
	end process P_OUTPUTS;
end FSM_R2;

configuration CFG_FSM_R of FSM_RX2 is
	for  FSM_R2
	end for;
end CFG_FSM_R;