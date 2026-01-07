library verilog;
use verilog.vl_types.all;
entity control_slave is
    port(
        iClk            : in     vl_logic;
        iReset_n        : in     vl_logic;
        iChipselect_n   : in     vl_logic;
        iWrite          : in     vl_logic;
        iRead           : in     vl_logic;
        iMW_done        : in     vl_logic;
        iAddress        : in     vl_logic_vector(2 downto 0);
        iWritedata      : in     vl_logic_vector(31 downto 0);
        oStart          : out    vl_logic;
        oReaddata       : out    vl_logic_vector(31 downto 0);
        oRM_startaddress: out    vl_logic_vector(31 downto 0);
        oWM_startaddress: out    vl_logic_vector(31 downto 0);
        oLength         : out    vl_logic_vector(31 downto 0)
    );
end control_slave;
