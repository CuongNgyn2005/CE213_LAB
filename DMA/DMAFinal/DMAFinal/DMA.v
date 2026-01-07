
module DMA ( KEY, CLOCK_50);

input [0:0] KEY;
input CLOCK_50;


 System u0 (
        .clk_clk                     (CLOCK_50),                     //                  clk.clk
        .reset_reset_n               (KEY[0])             //                reset.reset_n

    );
endmodule