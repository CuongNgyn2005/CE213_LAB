library verilog;
use verilog.vl_types.all;
entity median_filter is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        p1              : in     vl_logic_vector(7 downto 0);
        p2              : in     vl_logic_vector(7 downto 0);
        p3              : in     vl_logic_vector(7 downto 0);
        p4              : in     vl_logic_vector(7 downto 0);
        p5              : in     vl_logic_vector(7 downto 0);
        p6              : in     vl_logic_vector(7 downto 0);
        p7              : in     vl_logic_vector(7 downto 0);
        p8              : in     vl_logic_vector(7 downto 0);
        p9              : in     vl_logic_vector(7 downto 0);
        median_out      : out    vl_logic_vector(7 downto 0)
    );
end median_filter;
