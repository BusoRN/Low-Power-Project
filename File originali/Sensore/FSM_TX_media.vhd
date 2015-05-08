library IEEE;
use IEEE.std_logic_1164.all; 

entity FSM_TX_sens is
port( 	ACK_I, START:	in std_logic;
	CLOCK: 	in std_logic;
	RST_i:	in std_logic;
	RST_SHIFTOUT, RST_LATCHOUT, S_O :out std_logic;
	REQ_O : buffer std_logic;
	EN_SHIFTOUT, EN_LATCHOUT, STOP:	out std_logic 
);
end	FSM_TX_sens;

---------------------------------------------

architecture FSM_T of FSM_TX_sens is
  
	type TYPE_STATE is (IDLE, Request1, Request2,Request3, TXstate1,
								END_S,ResetState ); 
	signal CURRENT_STATE : TYPE_STATE;
	signal NEXT_STATE : TYPE_STATE;
	signal prec_ack_i: std_logic;
	

begin
 	P_PROC : process(CLOCK)		

begin
		if (CLOCK'EVENT and CLOCK ='1' ) then 
			if RST_i='1' then
	        	CURRENT_STATE <= ResetState;
			else
				CURRENT_STATE <= NEXT_STATE;
			end if;
		end if;
	end process P_PROC;

	P_NEXT_STATE : process(CURRENT_STATE, START, RST_i, ACK_I, prec_ack_i)
			begin
	
		case CURRENT_STATE is
			  when IDLE => 	if START ='0' then
								NEXT_STATE <= IDLE;
							elsif START ='1' then
								NEXT_STATE <= Request1;
							end if;
				   
			  when Request1 =>	NEXT_STATE <= Request2;
			  
			  when Request2 =>	if ACK_I = prec_ACK_I then
									NEXT_STATE <= IDLE;
								else
									NEXT_STATE <= Request3 ;
								end if;
							
			  when Request3 => 	NEXT_STATE <= TXstate1;
								
			  when TXstate1 => 	NEXT_STATE <=  END_S;
			
			  when END_S => 	if START = '1' then
									NEXT_STATE <= Request1; 
								else
									NEXT_STATE <= IDLE;
								end if;
								
			  when ResetState =>	NEXT_STATE <= IDLE;
		end case;	
	end process P_NEXT_STATE;

	
	P_OUTPUTS: process(CURRENT_STATE)
	begin
		--O <= '0';
		case CURRENT_STATE is

			when IDLE => 	REQ_O <= REQ_O;
							RST_SHIFTOUT <= '0';
							RST_LATCHOUT <= '1';--
							EN_SHIFTOUT <= '0';
							EN_LATCHOUT <= '0';--
							STOP <= '0';
							prec_ack_i <= ack_i;
			       
			when Request1 => REQ_O <= not req_O;
							EN_SHIFTOUT <= '1';
							EN_LATCHOUT <= '1';
							RST_SHIFTOUT <= '0';
							RST_LATCHOUT <= '0';
							S_O<='1';
							STOP <= '0';
							prec_ack_i <= ack_i;
			             
			when Request2 => REQ_O <= req_O; 
							EN_SHIFTOUT <= '1';
							EN_LATCHOUT <= '1';
							RST_SHIFTOUT <= '0';
							RST_LATCHOUT <= '0';
							S_O<='0';
							STOP <= '0';
							prec_ack_i <= ack_i;
							
			when Request3 => REQ_O <= req_O; 
							EN_SHIFTOUT <= '1';
							EN_LATCHOUT <= '0';
							RST_SHIFTOUT <= '0';
							RST_LATCHOUT <= '1';
							S_O<='0';
							STOP <= '0';
							prec_ack_i <= ack_i;

			when TXstate1 => REQ_O <= req_O; 
							EN_SHIFTOUT <= '1';
							EN_LATCHOUT <= '0';
							RST_SHIFTOUT <= '0';
							RST_LATCHOUT <= '1';
							S_O<='0';
							STOP <= '0';
							prec_ack_i <= ack_i;							
			             
			when end_s => REQ_O <= req_O;
							EN_SHIFTOUT <= '1';
							EN_LATCHOUT <= '0';
							RST_SHIFTOUT <= '0';
							RST_LATCHOUT <= '1';
							S_O<='0';
							STOP <= '1';
							prec_ack_i <= ack_i;
			
			 when ResetState => REQ_O <= '0'; 
							EN_SHIFTOUT <= '0';
							EN_LATCHOUT <= '0';
							RST_SHIFTOUT <= '1';
							RST_LATCHOUT <= '1';
							S_O<='0';
							STOP <= '0'; 
							prec_ack_i <= ack_i;
		end case; 	
	end process P_OUTPUTS;
end FSM_T;
 

configuration CFG_FSM_T of FSM_TX_sens is
	for  FSM_T
	end for;
end CFG_FSM_T;

