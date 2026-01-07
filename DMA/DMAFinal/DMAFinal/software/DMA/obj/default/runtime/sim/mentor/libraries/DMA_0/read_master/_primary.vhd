library verilog;
use verilog.vl_types.all;
entity read_master is
    port(
        iClk            : in     vl_logic;
        iReset_n        : in     vl_logic;
        iStart          : in     vl_logic;
        iLength         : in     vl_logic_vector(31 downto 0);
        iRM_startaddress: in     vl_logic_vector(31 downto 0);
        iRM_readdatavalid: in     vl_logic;
        iRM_waitrequest : in     vl_logic;
        oRM_read        : out    vl_logic;
        oRM_readaddress : out    vl_logic_vector(31 downto 0);
        iRM_readdata    : in     vl_logic_vector(31 downto 0);
        iFF_almostfull  : in     vl_logic;
        oFF_writerequest: out    vl_logic;
        oFF_data        : out    vl_logic_vector(31 downto 0)
    );
end read_master;
