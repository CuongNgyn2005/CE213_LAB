library verilog;
use verilog.vl_types.all;
entity FIFO is
    port(
        iClk            : in     vl_logic;
        iReset_n        : in     vl_logic;
        FF_empty        : out    vl_logic;
        FF_almostfull   : out    vl_logic;
        FF_data         : in     vl_logic_vector(31 downto 0);
        FF_q            : out    vl_logic_vector(31 downto 0);
        FF_readrequest  : in     vl_logic;
        FF_writerequest : in     vl_logic
    );
end FIFO;
