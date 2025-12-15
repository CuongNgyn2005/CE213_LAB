`timescale 1ns/1ps

module tb_median_filter();

    // Image dimensions
	 parameter WIDTH  = 430;  // Thay số 256 bằng 430
    parameter HEIGHT = 554;  // Thay số 256 bằng 554    parameter HEIGHT = 554;  // Thay số 256 bằng 554
    parameter SIZE   = WIDTH * HEIGHT;

    // I/O control
    parameter USE_DECIMAL = 1; // 1: decimal txt via $fscanf, 0: hex via $readmemh
    parameter INPUT_PATH  = "D:/CE213/TH/ImageProcessing/pic_input.txt";
    parameter OUTPUT_PATH = "D:/CE213/TH/ImageProcessing/pic_output.txt";

    reg  [7:0] img_mem [0:SIZE-1];
    reg  [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    wire [7:0] out_pixel;
 
    integer file_read, file_write, i, x, y, scan_status;

    // DUT
    median_filter uut (
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .median_out(out_pixel)
    );

    initial begin
        // Read input image
        if (USE_DECIMAL) begin
            file_read = $fopen(INPUT_PATH, "r");
            if (file_read == 0) begin
                $display("ERROR: Cannot open %s", INPUT_PATH);
                $finish;
            end
            for (i = 0; i < SIZE; i = i + 1) begin
                scan_status = $fscanf(file_read, "%d\n", img_mem[i]);
                if (scan_status <= 0) begin
                    $display("WARN: Short read at index %0d", i);
                    img_mem[i] = 0;
                end
            end
            $fclose(file_read);
        end else begin
            $readmemh(INPUT_PATH, img_mem);
        end

        file_write = $fopen(OUTPUT_PATH, "w");
        if (file_write == 0) begin
            $display("ERROR: Cannot open %s for write", OUTPUT_PATH);
            $finish;
        end

        // Sliding window; copy borders unchanged
        for (y = 0; y < HEIGHT; y = y + 1) begin
            for (x = 0; x < WIDTH; x = x + 1) begin
                if (x == 0 || x == WIDTH-1 || y == 0 || y == HEIGHT-1) begin
                    $fwrite(file_write, "%0d\n", img_mem[y*WIDTH + x]);
                end else begin
                    // 3x3 neighborhood
                    p1 = img_mem[(y-1)*WIDTH + (x-1)];
                    p2 = img_mem[(y-1)*WIDTH + (x  )];
                    p3 = img_mem[(y-1)*WIDTH + (x+1)];
                    p4 = img_mem[(y  )*WIDTH + (x-1)];
                    p5 = img_mem[(y  )*WIDTH + (x  )];
                    p6 = img_mem[(y  )*WIDTH + (x+1)];
                    p7 = img_mem[(y+1)*WIDTH + (x-1)];
                    p8 = img_mem[(y+1)*WIDTH + (x  )];
                    p9 = img_mem[(y+1)*WIDTH + (x+1)];

                    // Combinational DUT; small delay for delta cycles
                    #1;
                    $fwrite(file_write, "%0d\n", out_pixel);
                end
            end
        end

        $fclose(file_write);
        $display("Processing Complete. Output saved to %s", OUTPUT_PATH);
        $finish;
    end
endmodule