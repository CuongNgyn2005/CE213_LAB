library verilog;
use verilog.vl_types.all;
entity System is
    port(
        clk_clk         : in     vl_logic;
        reset_reset_n   : in     vl_logic
    );
end System;
