module compare_swap(
    input [7:0] a, b,
    output [7:0] min, max
);
    // If a > b, swap them. Otherwise pass them through.
    assign min = (a > b) ? b : a;
    assign max = (a > b) ? a : b;
endmodule