----------------------------------------------------------------------

-- testbench for the simulation of dice an FPGA 
--this testbench really just sets a clock to run
--and toggles a switch on every 10 clock cycles

  ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity dice_TB is
end dice_TB;
 
architecture Behave of dice_TB is
   
  -- Test Bench uses a 100 MHz Clock --the goBoard uses 25MHz just FYI
  constant c_CLK_PERIOD : time := 10 ns;
   
  signal i_Switch_tb     : std_logic                    := '0';
  signal i_Clk_tb     : std_logic                    := '0';
  signal counter_tb : integer range 0 to 10 := 0;
  
   
begin
 
  -- Instantiate DICE
  DICE_INST : entity work.edice
    --generic map (
     -- width => 3
     -- )
    port map (
      i_Switch     => i_Switch_tb,
      i_Clk       => i_Clk_tb
      );
 
 
 
 --set clock signal
  i_Clk_tb <= not i_Clk_tb after c_CLK_PERIOD/2;
  
  stimuli: process(i_Clk_tb)
  begin
  	if rising_edge(i_Clk_tb) then
    	if counter_tb = 9 then
        	counter_tb <= 0;
            i_Switch_tb <= '1';
        else
        	counter_tb <= counter_tb + 1;
            i_Switch_tb <= '0';
        end if;   
    end if;    
  
  end process;
   end Behave;
   
