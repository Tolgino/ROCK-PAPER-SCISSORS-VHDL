library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
 
entity RockPaperScissors is
    Generic (N : INTEGER:=50*10**6;
             M: INTEGER:=65536);
 
Port ( MCLK : in STD_LOGIC;
		rps : in std_logic_vector(2 downto 0);
	   clock : in std_logic;
	   clr : in std_logic;	
	   resetButton : std_logic;
		led : out std_logic_vector(2 downto 0);
	   button : in std_logic;
      SevenSegment : out STD_LOGIC_VECTOR (6 downto 0);
		Anodes : out STD_LOGIC_VECTOR (7 downto 0));
		end RockPaperScissors;
 
architecture Behavioral of RockPaperScissors is

signal userScore : integer range 0 to 5 := 0;
signal FPGAScore : integer range 0 to 5 := 0;
signal random : integer range 0 to 2;
signal output : std_logic_vector(2 downto 0);
signal CLK_DIV : STD_LOGIC;
 
-- 100 rock
-- 010 paper
-- 001 scisscors
-- 0 scissors
-- 1 rock
-- 2 paper 
 
begin 

process(MCLK)
variable Counter : INTEGER range 0 to N;
begin   
        if rising_edge(MCLK) then
            Counter := Counter + 1;
             if (Counter = N/15-1) then
                    Counter := 0;
                    CLK_DIV <= not CLK_DIV;             
             end if;
        end if;
end process;

process(CLK_DIV)
begin
 if not(userScore = 5 or FPGAScore = 5) then
        if rising_edge(CLK_DIV) then
				random <= random + 1;
				if rps = "001" then
						if random = 0 then
								output <= "010";
						elsif random = 1 then
								output <= "001";
						else
								output <= "100";
						end if;
				elsif rps = "010" then
						if random = 0 then
								output <= "100";
						elsif random = 1 then
								output <= "010";
						else
								output <= "001";
						end if;
				elsif rps = "100" then 
						if random = 0 then
								output <= "001";
						elsif random = 1 then
								output <= "100";
						else
								output <= "010";
						end if;
				else 
						output <= "111";
				end if;

				if(button = '1') then
						if output = "001" then
								userScore <= userScore + 1;
						elsif output = "100" then
								FPGAScore <= FPGAScore + 1;
						else 
								UserScore <= UserScore;
								FPGAScore <= FPGAScore;
						end if;
				end if;
        end if; 
		  
		  if resetButton = '1' then
					userScore <= 0;
					FPGAScore <= 0;
		  end if;
 end if;
end process;

process(MCLK)
    variable Counter : INTEGER range 0 to M;
    begin       
        if(rising_edge(MCLK)) then
            Counter :=Counter+1;
            if (Counter mod M = 0) then
                if(userScore=0) then
                    Anodes <= "11111110";
                    SevenSegment <= "0000001"; 		  
						  if (FPGAScore=5) then
                    Anodes <= "11111110";
                    SevenSegment <= "1111111"; 	  
						  end if;
                elsif (userScore=1) then
                    Anodes <= "11111110";
                    SevenSegment <= "1001111";   
						  if (FPGAScore=5) then
                    Anodes <= "11111110";
                    SevenSegment <= "1111111";  
						  end if;
                elsif (userScore=2) then
                    Anodes <= "11111110";
                    SevenSegment <= "0010010"; 
						  if (FPGAScore=5) then
                    Anodes <= "11111110";
                    SevenSegment <= "1111111"; 
						  end if;
                elsif (userScore=3) then
                    Anodes <= "11111110";
                    SevenSegment <= "0000110"; 
						  if (FPGAScore=5) then
                    Anodes <= "11111110";
                    SevenSegment <= "1111111"; 	  
						  end if;		  
					 elsif (userScore=4) then
                    Anodes <= "11111110";
                    SevenSegment <= "1001100";   
						  if (FPGAScore=5) then
                    Anodes <= "11111110";
                    SevenSegment <= "1111111"; 
						  end if;
                elsif (userScore=5) then
                    Anodes <= "11101111";
                    SevenSegment <= "1101010"; 
                end if;
            elsif (Counter mod M = 1*M/8) then
                    Anodes <= "11111101";
                    SevenSegment <= "1111110";		  
						  if (userScore=5) then
                    Anodes <= "11011111";
                    SevenSegment <= "1101111"; 
						  end if;
						  if (FPGAScore=5) then
                    Anodes <= "11011111";
                    SevenSegment <= "0100100";   
						  end if;	
				elsif (Counter mod M = 2*M/8) then
						  Anodes <= "11111011";
                    SevenSegment <= "1111110";
						  if (userScore=5) then
                    Anodes <= "10111111";
                    SevenSegment <= "1000011";
						  end if; 
						  if (FPGAScore=5) then
                    Anodes <= "10111111";
                    SevenSegment <= "0000001"; 
						  end if;
            elsif (Counter mod M = 3*M/8) then
					     if(FPGAScore=0) then
                    Anodes <= "11110111";
                    SevenSegment <= "0000001";
						  if (userScore=5) then
						  Anodes <= "11110111";
                    SevenSegment <= "1111111";
					     end if;
						  elsif (FPGAScore=1) then
                    Anodes <= "11110111";
                    SevenSegment <= "1001111";
						  if (userScore=5) then
						  Anodes <= "11110111";
                    SevenSegment <= "1111111";
						  end if;
						  elsif (FPGAScore=2) then
                    Anodes <= "11110111";
                    SevenSegment <= "0010010";  
						  if (userScore=5) then
						  Anodes <= "11110111";
                    SevenSegment <= "1111111";
						  end if;
						  elsif (FPGAScore=3) then
                    Anodes <= "11110111";
                    SevenSegment <= "0000110";
						  if (userScore=5) then
						  Anodes <= "11110111";
                    SevenSegment <= "1111111";
						  end if;  
						  elsif (FPGAScore=4) then
                    Anodes <= "11110111";
                    SevenSegment <= "1001100";
						  if (userScore=5) then
						  Anodes <= "11110111";
                    SevenSegment <= "1111111";
						  end if;
						  elsif (FPGAScore=5) then
                    Anodes <= "11101111";
                    SevenSegment <= "0100100";
						  end if;
            elsif (Counter mod M = 4*M/8) then
						  if (userScore=5) then
						  Anodes <= "01111111";
                    SevenSegment <= "1100001"; 
						  end if;
						  if (FPGAScore=5) then
                    Anodes <= "01111111";
                    SevenSegment <= "1110001";
						  end if;
            end if;
        end if;
end process;
	 
	 led(0) <= rps(0);
	 led(1) <= rps(1);
	 led(2) <= rps(2);
 
end Behavioral;