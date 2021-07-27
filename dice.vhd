--------------------------------------------------------------------------------
--Developed By : Jacob Seal
--sealenator@gmail.com
--07-27-2021
--filename: dice.vhd
--entity edice
--******************************************************************************
--general notes:
--dice simulation for an FPGA written in VHDL
--button press of switch triggers a new random value between 1 and 6
--the button is assumed to be already debounced
--the random number is only psuedo random
--the human is pressing the button at a random time interval....so it seems --random to the user
--******************************************************************************
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity edice is
port (
		
		--inputs
		--push button to trigger random number(assumes switch already debounced)
		i_Switch 		: 	in std_logic;									
		--25Mhz clock
		i_Clk			:	in std_logic;									 
		
		--outputs
		--output integer value between 1 and 6 
		o_rand 			: 	out integer
		);
end edice;

architecture Behavioral of edice is			
	
	--counters for psuedo_random logic
	signal r_counter_1 : integer range 1 to 6 := 1;
    signal r_counter_2 : integer range 1 to 6 := 1;

	
	--signal used to register the random number for the output rand
	signal r_rand_temp : integer range 1 to 6;	
	
	
	
begin
	
	--counter 1 counts from 1 to 6 incrementing on every clock cycle
	counter_1_proc : process(i_Clk)
    begin
    	if rising_edge(i_Clk) then
        	if r_counter_1 = 6 then
            	r_counter_1 <= 1;
            else
            	r_counter_1 <= r_counter_1 + 1;
            end if;
        end if;
    end process;   
    
	--counter 2 counts from 1 to 6 incrementing only when counter_1 rolls over
    counter_2_proc : process(i_Clk)
    begin
    	if rising_edge(i_Clk) then
        	if r_counter_1 = 6 and r_counter_2 < 6 then
            	r_counter_2 <= r_counter_2 + 1;
            elsif r_counter_1 = 6 and r_counter_2 = 6 then
            	r_counter_2 <= 1;
            end if;   
        end if;
    end process;    

	--process contains the algorithm which creates the (psuedo)random number if --the button is pressed
	create_rand : process(i_Clk)
		
	begin
		if rising_edge(i_Clk) then
			--check for button press
			if i_Switch = '1' then			
				--capture the value of counter 2 as the random number
				r_rand_temp <= r_counter_2;
			end if;
		end if;
		
		--assign random number to output "o_rand"
		o_rand <= r_rand_temp;
	end process;
	
end Behavioral;

