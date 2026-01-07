library verilog;
use verilog.vl_types.all;
entity DMAFinal is
    port(
        iClk            : in     vl_logic;
        iReset_n        : in     vl_logic;
        iChipselect_n   : in     vl_logic;
        iRead           : in     vl_logic;
        iWrite          : in     vl_logic;
        iAddress        : in     vl_logic_vector(2 downto 0);
        iWritedata      : in     vl_logic_vector(31 downto 0);
        oReaddata       : out    vl_logic_vector(31 downto 0);
        iRM_readdatavalid: in     vl_logic;
        iRM_waitrequest : in     vl_logic;
        iRM_readdata    : in     vl_logic_vector(31 downto 0);
        oRM_read        : out    vl_logic;
        oRM_readaddress : out    vl_logic_vector(31 downto 0);
        iWM_waitrequest : in     vl_logic;
        oWM_write       : out    vl_logic;
        oWM_writeaddress: out    vl_logic_vector(31 downto 0);
        oWM_writedata   : out    vl_logic_vector(31 downto 0)
    );
end DMAFinal;
