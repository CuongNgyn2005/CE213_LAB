library verilog;
use verilog.vl_types.all;
entity tb_median_filter is
    generic(
        WIDTH           : integer := 430;
        HEIGHT          : integer := 554;
        SIZE            : vl_notype;
        INPUT_PATH      : string  := "D:/CE213/LAB/CE213_LAB/ImageProcessing/input.hex";
        OUTPUT_PATH     : string  := "D:/CE213/LAB/CE213_LAB/ImageProcessing/pic_output.txt"
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of HEIGHT : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 3;
    attribute mti_svvh_generic_type of INPUT_PATH : constant is 1;
    attribute mti_svvh_generic_type of OUTPUT_PATH : constant is 1;
end tb_median_filter;
