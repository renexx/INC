-- fsm.vhd: Projekt FITKIT Prístupový terminal
-- Author(s): René Bolf - xbolfr00
--
library ieee;
use ieee.std_logic_1164.all;
-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity fsm is
port(
   CLK         : in  std_logic;
   RESET       : in  std_logic;

   -- Input signals
   KEY         : in  std_logic_vector(15 downto 0);
   CNT_OF      : in  std_logic;

   -- Output signals
   FSM_CNT_CE  : out std_logic;
   FSM_MX_MEM  : out std_logic;
   FSM_MX_LCD  : out std_logic;
   FSM_LCD_WR  : out std_logic;
   FSM_LCD_CLR : out std_logic
);
end entity fsm;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of fsm is
   type t_state is (CODE1,CODE2,CODE3_1,CODE3_2,CODE4_1,CODE4_2,CODE5_1,CODE5_2,CODE6_1,CODE6_2,CODE7,CODE8,CODE9,CODE10_1,CODE10_2,CODE_END, ACCESS_AUTHORIZED, ACCESS_UNAUTHORIZED, WRONG, FINISH);
   signal present_state, next_state : t_state;

begin
-- -------------------------------------------------------
sync_logic : process(RESET, CLK)
begin
   if (RESET = '1') then
      present_state <= CODE1;
   elsif (CLK'event AND CLK = '1') then
      present_state <= next_state;
   end if;
end process sync_logic;

-- -------------------------------------------------------
next_state_logic : process(present_state, KEY, CNT_OF)
variable DIFF : integer;
begin
   case (present_state) is
-----------------------------------------------------------
     when CODE1 =>
        next_state <= CODE1;
        if(KEY(6) = '1') then
            next_state <= CODE2;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
      end if;
-----------------------------------------------------------
    when CODE2 =>
        next_state <= CODE2;
        if(KEY(9) = '1') then
            DIFF := 1;
            next_state <= CODE3_1;
        elsif(KEY(5) = '1') then
            DIFF := 2;
            next_state <= CODE3_2;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
-------------------------------------------------------------
    when CODE3_1 =>
        next_state <= CODE3_1;
        if(KEY(0) = '1') then
            next_state <= CODE4_1;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
----------------------------------------------------------------
    when CODE3_2 =>
        next_state <= CODE3_2;
        if(KEY(3) = '1') then
            next_state <= CODE4_2;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
-----------------------------------------------------------------------
    when CODE4_1 =>
        next_state <= CODE4_1;
        if(KEY(8) = '1') then
              next_state <= CODE5_1;
        elsif (KEY(15) = '1') then
              next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
              next_state <= WRONG;
        end if;
---------------------------------------------------------------------------
    when CODE4_2 =>
        next_state <= CODE4_2;
        if(KEY(5) = '1') then
            next_state <= CODE5_2;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
------------------------------------------------------------------------
    when CODE5_1 =>
        next_state <= CODE5_1;
        if(KEY(4) = '1') then
            next_state <= CODE6_1;
        elsif (KEY(15) = '1') then
                next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
              next_state <= WRONG;
        end if;
-------------------------------------------------------------------
    when CODE5_2 =>
        next_state <= CODE5_2;
        if(KEY(2) = '1') then
            next_state <= CODE6_2;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
------------------------------------------------------------
    when CODE6_1 =>
        next_state <= CODE6_1;
        if(KEY(5) = '1') then
            next_state <= CODE7;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
-------------------------------------------------------------------
    when CODE6_2 =>
        next_state <= CODE6_2;
        if(KEY(1) = '1') then
            next_state <= CODE7;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
-------------------------------------------------------------------------------
    when CODE7 =>
        next_state <= CODE7;
        if(KEY(1) = '1') then
            next_state <= CODE8;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
-------------------------------------------------------------------------------
    when CODE8 =>
        next_state <= CODE8;
        if(KEY(4) = '1') then
            next_state <= CODE9;
        elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
-------------------------------------------------------------------------------
    when CODE9 =>
        next_state <= CODE9;
        if(KEY(7) = '1') and (DIFF = 1) then
            next_state <= CODE10_1;
       elsif(KEY(3) = '1') and (DIFF = 2) then
            next_state <= CODE10_2;
       elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
       elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
       end if;
-------------------------------------------------------------------------------
    when CODE10_1 =>
        next_state <= CODE10_1;
        if(KEY(2) = '1') then
            next_state <= CODE_END;
        elsif(KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
        elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
        end if;
--------------------------------------------------------------------------------
   when CODE10_2 =>
        next_state <= CODE10_2;
       if(KEY(8) = '1') then
            next_state <= CODE_END;
       elsif (KEY(15) = '1') then
            next_state <= ACCESS_UNAUTHORIZED;
       elsif(KEY(14 downto 0) /= "000000000000000") then
            next_state <= WRONG;
       end if;
-----------------------------------------------------------------------------
   when CODE_END =>
        next_state <= CODE_END;
        if(KEY(14 downto 0) /= "000000000000000") then
           next_state <= WRONG;
        elsif(KEY(15) = '1') then
            next_state <= ACCESS_AUTHORIZED;
        end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when WRONG =>
      next_state <= WRONG;
      if (KEY(15) = '1') then
         next_state <= ACCESS_UNAUTHORIZED;
      end if;
      -- - - - - - - - - - - - - - - - - - - - - - -
   when ACCESS_AUTHORIZED =>
      next_state <= ACCESS_AUTHORIZED;
      if (CNT_OF = '1') then
         next_state <= FINISH;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when ACCESS_UNAUTHORIZED =>
      next_state <= ACCESS_UNAUTHORIZED;
      if (CNT_OF = '1') then
         next_state <= FINISH;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
      next_state <= FINISH;
      if (KEY(15) = '1') then
         next_state <= CODE1;
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
      next_state <= CODE1;
   end case;
end process next_state_logic;

-- -------------------------------------------------------
output_logic : process(present_state, KEY)
begin
   FSM_CNT_CE     <= '0';
   FSM_MX_MEM     <= '0';
   FSM_MX_LCD     <= '0';
   FSM_LCD_WR     <= '0';
   FSM_LCD_CLR    <= '0';

   case (present_state) is
   -- - - - - - - - - - - - - - - - - - - - - - -
    when ACCESS_AUTHORIZED =>
       FSM_CNT_CE     <= '1';
       FSM_MX_LCD     <= '1';
       FSM_LCD_WR     <= '1';
       FSM_MX_MEM     <= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
   when ACCESS_UNAUTHORIZED =>
      FSM_CNT_CE     <= '1';
      FSM_MX_LCD     <= '1';
      FSM_LCD_WR     <= '1';
   -- - - - - - - - - - - - - - - - - - - - - - -
   when FINISH =>
      if (KEY(15) = '1') then
         FSM_LCD_CLR    <= '1';
      end if;
   -- - - - - - - - - - - - - - - - - - - - - - -
   when others =>
   if (KEY(14 downto 0) /= "000000000000000") then
      FSM_LCD_WR <='1';
   end if;
   if (KEY(15) = '1') then
      FSM_LCD_CLR <= '1';
  end if;
  end case;
end process output_logic;

end architecture behavioral;
