`timescale 1ns/1ps

module tb_median_filter();

    // Image dimensions
    parameter WIDTH  = 430;
    parameter HEIGHT = 554;
    parameter SIZE   = WIDTH * HEIGHT;

    // Settings
    parameter INPUT_PATH  = "D:/CE213/LAB/CE213_LAB/ImageProcessing/input.hex";
    parameter OUTPUT_PATH = "D:/CE213/LAB/CE213_LAB/ImageProcessing/pic_output.txt";

    // Signals
    reg  clk;
    reg  rst_n;
    reg  [7:0] img_mem [0:SIZE-1];
    reg  [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    wire [7:0] out_pixel;
 
    integer file_read, file_write, i, x, y, scan_status;

    // Instantiate the PIPELINED DUT
    median_filter uut (
        .clk(clk),
        .rst_n(rst_n),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .median_out(out_pixel)
    );

    // 1. Clock Generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2. Main Test Process
    initial begin
        // Read input image (Same as your original code)
        $readmemh(INPUT_PATH, img_mem);

        // Open Output File
        file_write = $fopen(OUTPUT_PATH, "w");
        if (file_write == 0) begin
            $display("ERROR: Cannot open %s for write", OUTPUT_PATH);
            $finish;
        end

        // Reset the system
        rst_n = 0;
        #20;
        rst_n = 1;

        // Iterate over image
        for (y = 0; y < HEIGHT; y = y + 1) begin
            for (x = 0; x < WIDTH; x = x + 1) begin
                
                // --- CASE 1: BORDERS (Copy directly) ---
                if (x == 0 || x == WIDTH-1 || y == 0 || y == HEIGHT-1) begin
                    $fwrite(file_write, "%2h\n", img_mem[y*WIDTH + x]);
                end 
                
                // --- CASE 2: ACTIVE PIXELS (Process) ---
                else begin
                    // Setup 3x3 Window inputs
                    p1 = img_mem[(y-1)*WIDTH + (x-1)];
                    p2 = img_mem[(y-1)*WIDTH + (x  )];
                    p3 = img_mem[(y-1)*WIDTH + (x+1)];
                    p4 = img_mem[(y  )*WIDTH + (x-1)];
                    p5 = img_mem[(y  )*WIDTH + (x  )];
                    p6 = img_mem[(y  )*WIDTH + (x+1)];
                    p7 = img_mem[(y+1)*WIDTH + (x-1)];
                    p8 = img_mem[(y+1)*WIDTH + (x  )];
                    p9 = img_mem[(y+1)*WIDTH + (x+1)];

                    // Push inputs into pipeline at clock edge
                    @(posedge clk); 
                    
                    // WAIT for Pipeline Depth (3 cycles)
                    // The data needs time to travel through Stage 1 -> Stage 2 -> Stage 3
                    repeat(3) @(posedge clk);

                    // Capture Output
                    #1; // Small hold time to read stable data
                    $fwrite(file_write, "%2h\n", out_pixel);
                end
            end
        end

        $fclose(file_write);
        $display("Processing Complete. Output saved to %s", OUTPUT_PATH);
        $finish;
    end
endmodule 