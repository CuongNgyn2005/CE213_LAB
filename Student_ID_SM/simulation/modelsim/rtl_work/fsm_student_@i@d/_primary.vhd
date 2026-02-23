library verilog;
use verilog.vl_types.all;
entity fsm_student_ID is
    port(
        clk             : in     vl_logic;
        active          : out    vl_logic;
        rst_n           : in     vl_logic;
        start           : in     vl_logic;
        user_input      : in     vl_logic_vector(3 downto 0);
        output_digit    : out    vl_logic_vector(3 downto 0);
        Done            : out    vl_logic
    );
end fsm_student_ID;
