library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic


entity FSM_ondemand_sensore is

port( 	REQ_I,ack_i:	in std_logic;
		CLOCK: 	in std_logic;
		RST_I:	in std_logic;
		ACK_O,req_o: inout std_logic; 
		command : in std_logic_vector(2 downto 0);
		req_ondemand : out std_logic;
		ack_ondemand : in std_logic;
		S_O : out std_logic;
		EN_SHIFTIN, EN_LATCHIN, EN_FFCOM, EN_SHIFTOUT, EN_LATCHOUT:	out std_logic;
		RST_SHIFTIN, RST_LATCHIN, RST_FFCOM, RST_SHIFTOUT,RST_LATCHOUT:	out std_logic
		
);
end FSM_ondemand_sensore;


architecture FSM_R2 of FSM_ondemand_sensore is
  
	type TYPE_STATE is (IDLE,RICHIESTA,
				TX1,TX2,TX3,TX4,TX5,TX6,
				WAIT1,WAIT2,
				RX1,RX2,RX3,RX4,RX5,RX6,
				END_S, ResetState);--
	signal CURRENT_STATE : TYPE_STATE;
	signal NEXT_STATE : TYPE_STATE;
	signal Prec_REQ_I, Prec_ACK_I: std_logic;

begin
 	
 	P_PROC : process(CLOCK, rst_i)		
     begin
		if RST_i='1' then
	        	CURRENT_STATE <= ResetState;
		elsif (CLOCK'EVENT and CLOCK ='1') then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process P_PROC;

	P_NEXT_STATE : process(CURRENT_STATE, REQ_I, RST_i,ack_i,ack_ondemand,command)
			begin
		
		case CURRENT_STATE is
		     when IDLE =>   if REQ_I = Prec_REQ_I then -- protocollo basato sulle transizioni, lo uso per limitare il numero di
		                                               -- transizioni associate al protocollo
		                        NEXT_STATE <= IDLE;
		                    else
		                        NEXT_STATE <= RX1;
		                    end if;
							
			  when RX1 => NEXT_STATE <= RX2;
			  
			  when RX2 => NEXT_STATE <= RX3;
			  
			  when RX3 =>  NEXT_STATE <= RX4;
			  
			  when RX4 => NEXT_STATE <= RX5;

			  when RX5 => NEXT_STATE <= RX6;
  
			  when RX6=> NEXT_STATE <= WAIT1;
			  
			  when WAIT1 => NEXT_STATE <= WAIT2;

			  when WAIT2 => if ACK_ondemand = '0' then
					NEXT_STATE <= WAIT2;
				      else
					NEXT_STATE <= RICHIESTA;
				      end if;
			  
			  when RICHIESTA => NEXT_STATE <= TX1;
			  
			  when TX1 => if ack_i = prec_ack_i then 
					NEXT_STATE <= IDLE;
				      else
					NEXT_STATE <= TX2;
				      end if;
			  
			  when TX2 => if command = "111" then
					NEXT_STATE <= TX3;
				      else
					NEXT_STATE <= END_S;
				      end if;
			      
			  when TX3 => NEXT_STATE <= TX4;
			  
			  when TX4 => NEXT_STATE <= TX5;
			      
			  when TX5 => NEXT_STATE <= TX6;
			  
			  when TX6 => NEXT_STATE <= END_S;


  		     when END_S =>   if req_i =Prec_REQ_I then
                                    NEXT_STATE <= IDLE;
                                 else
                                    NEXT_STATE <= RX1;	
                                 end if;
			
			  when ResetState =>	NEXT_STATE <= IDLE;
		end case;	
	end process P_NEXT_STATE;

	
	P_OUTPUTS: process(CURRENT_STATE)
	begin
		case CURRENT_STATE is

			when IDLE => 	REQ_O <= REQ_O;
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '0';
					EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0';
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '1';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '1';
					EN_FFCOM<= '0';
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I<= REQ_I;
					REQ_ONDEMAND <= '0';
					
			when RX1 => 	REQ_O <= REQ_O; 
					ACK_O <=not(ACK_O);
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when RX2 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when RX3 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when RX4 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when RX5 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when RX6 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';
			   
			when WAIT1 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '1';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '1';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '1';

			when WAIT2 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '1';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '1';


			when RICHIESTA =>	REQ_O <= REQ_O; -- faccio un protocollo a transizione per diminuire la Esw sul bus
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '1';
					S_O <= '1';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when TX1 => 		REQ_O <= NOT(REQ_O); 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '1';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';
						

			when TX2 => 	REQ_O <= REQ_O; 
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';
	
			when TX3 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when TX4 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when TX5 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when TX6 => 	REQ_O <= REQ_O;  
					ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '0';
					EN_SHIFTOUT <= '1';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';

			when end_s => 	REQ_O <= REQ_O; 
               		ACK_O <=ACK_O;
					RST_SHIFTIN <= '1';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '0'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '1';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '0';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '0';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';
			
			 when ResetState =>	
					ACK_O <='0';
					req_o<='0';
					RST_SHIFTIN <= '0';
	                EN_SHIFTIN <= '0';
					RST_LATCHIN <= '1'; 
					EN_LATCHIN <= '0';
					RST_SHIFTOUT <= '1';
					EN_SHIFTOUT <= '0';
					RST_FFCOM <= '1';--
					EN_FFCOM<= '0';--
					RST_LATCHOUT <= '1';
					EN_LATCHOUT <= '0';
					S_O <= '0';
					Prec_REQ_I <= REQ_I;
					REQ_ONDEMAND <= '0';
 

		end case; 	
	end process P_OUTPUTS;
end FSM_R2;

configuration CFG_FSM_R of FSM_ondemand_sensore is
	for  FSM_R2
	end for;
end CFG_FSM_R;
