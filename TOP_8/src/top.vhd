library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        CLK100MHZ    : in  std_logic;
        uart_txd_in  : in  std_logic;
        uart_rxd_out : out std_logic
    );
end entity top;

architecture str of top is
	signal data_to_send : std_logic_vector(7 downto 0) := X"00";
	signal data_valid   : std_logic;
	signal busy         : std_logic;
	signal uart_tx      : std_logic;
	signal data_to_filter: std_logic_vector(7 downto 0) := X"00";

	component uart_receiver is
        port(
            clock         : in  std_logic;
            uart_rx       : in  std_logic;
            valid         : out std_logic;
            received_data : out std_logic_vector(7 downto 0));
	end component uart_receiver;

  	component fir8 is 
		port(
			-- clock
			clock: in std_logic;
			-- for resetting the values inside the entity
			data_valid: in std_logic;
			-- input data
			i_data: in std_logic_vector(7 downto 0);
			-- ouput (filtered) data
			o_data: out std_logic_vector(7 downto 0)
		);
	end component fir8;

    component uart_transmitter is
        port(
            clock        : in  std_logic;
            data_to_send : in  std_logic_vector(7 downto 0);
            data_valid   : in  std_logic;
            busy         : out std_logic;
            uart_tx      : out std_logic);
	end component uart_transmitter;

begin  -- architecture str

    uart_receiver_1 : uart_receiver
        port map(
            clock         => CLK100MHZ,
            uart_rx       => uart_txd_in,
            valid         => data_valid,
            received_data => data_to_filter
        );
	  
	fir8_1: fir8
		port map(
			clock => CLK100MHZ,
			data_valid => data_valid,
			i_data => data_to_filter,
			o_data => data_to_send
	);
    
    uart_transmitter_1 : uart_transmitter
        port map(
            clock        => CLK100MHZ,
            data_to_send => data_to_send,
            data_valid   => data_valid,
            busy         => busy,
            uart_tx      => uart_rxd_out
        );
	 
end architecture str;
