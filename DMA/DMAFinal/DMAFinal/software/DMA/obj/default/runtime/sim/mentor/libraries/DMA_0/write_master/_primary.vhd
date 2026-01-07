library verilog;
use verilog.vl_types.all;
entity write_master is
    port(
        iClk            : in     vl_logic;
        iReset_n        : in     vl_logic;
        iStart          : in     vl_logic;
        iWM_startaddress: in     vl_logic_vector(31 downto 0);
        iLength         : in     vl_logic_vector(31 downto 0);
        iWM_waitrequest : in     vl_logic;
        iFF_empty       : in     vl_logic;
        iFF_q           : in     vl_logic_vector(31 downto 0);
        oFF_readrequest : out    vl_logic;
        oWM_done        : out    vl_logic;
        oWM_write       : out    vl_logic;
        oWM_writeaddress: out    vl_logic_vector(31 downto 0);
        oWM_writedata   : out    vl_logic_vector(31 downto 0)
    );
end write_master;
