// File: tb_image_to_grayscale.v
// Description: Testbench for image_to_grayscale module
// Tests RGB to grayscale conversion with various pixel values

`timescale 1ns / 1ps

module tb_image_to_grayscale;

    // Clock and reset
    reg        clk;
    reg        rst_n;
    
    // Inputs to DUT
    reg  [7:0] r_in;
    reg  [7:0] g_in;
    reg  [7:0] b_in;
    reg        in_valid;
    
    // Outputs from DUT
    wire [7:0] gray_out;
    wire       out_valid;
    
    // Instantiate the Unit Under Test (UUT)
    image_to_grayscale uut (
        .clk(clk),
        .rst_n(rst_n),
        .r_in(r_in),
        .g_in(g_in),
        .b_in(b_in),
        .in_valid(in_valid),
        .gray_out(gray_out),
        .out_valid(out_valid)
    );
    
    // Clock generation:  10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test variables
    integer i;
    real expected_gray;
    integer error_count;
    
    // Task to apply a test case
    task apply_test;
        input [7:0] r;
        input [7:0] g;
        input [7:0] b;
        input string color_name;
        begin
            @(posedge clk);
            r_in = r;
            g_in = g;
            b_in = b;
            in_valid = 1'b1;
            
            @(posedge clk);
            in_valid = 1'b0;
            
            @(posedge clk);
            if (out_valid) begin
                // Calculate expected value using the same formula
                expected_gray = (77. 0 * r + 150.0 * g + 29.0 * b + 128.0) / 256.0;
                $display("%-15s: RGB(%3d,%3d,%3d) -> Gray=%3d (Expected≈%3.1f)", 
                         color_name, r, g, b, gray_out, expected_gray);
                
                // Check if within reasonable tolerance (±1 due to rounding)
                if (gray_out > expected_gray + 1.5 || gray_out < expected_gray - 1.5) begin
                    $display("  ERROR: Output %d is outside expected range!", gray_out);
                    error_count = error_count + 1;
                end
            end else begin
                $display("ERROR: out_valid not asserted for %s!", color_name);
                error_count = error_count + 1;
            end
        end
    endtask
    
    // Main test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        r_in = 0;
        g_in = 0;
        b_in = 0;
        in_valid = 0;
        error_count = 0;
        
        // VCD dump for waveform viewing
        $dumpfile("tb_image_to_grayscale.vcd");
        $dumpvars(0, tb_image_to_grayscale);
        
        $display("\n========================================");
        $display("Image to Grayscale Conversion Testbench");
        $display("========================================\n");
        
        // Apply reset
        #20;
        rst_n = 1;
        #10;
        
        // Test 1: Common colors
        $display("--- Test 1: Common Colors ---");
        apply_test(8'd0,   8'd0,   8'd0,   "Black");
        apply_test(8'd255, 8'd255, 8'd255, "White");
        apply_test(8'd255, 8'd0,   8'd0,   "Red");
        apply_test(8'd0,   8'd255, 8'd0,   "Green");
        apply_test(8'd0,   8'd0,   8'd255, "Blue");
        apply_test(8'd255, 8'd255, 8'd0,   "Yellow");
        apply_test(8'd255, 8'd0,   8'd255, "Magenta");
        apply_test(8'd0,   8'd255, 8'd255, "Cyan");
        $display("");
        
        // Test 2: Gray values (R=G=B)
        $display("--- Test 2: Pure Gray Levels ---");
        apply_test(8'd64,  8'd64,  8'd64,  "Gray 25%");
        apply_test(8'd128, 8'd128, 8'd128, "Gray 50%");
        apply_test(8'd192, 8'd192, 8'd192, "Gray 75%");
        $display("");
        
        // Test 3: Edge cases
        $display("--- Test 3: Edge Cases ---");
        apply_test(8'd1,   8'd1,   8'd1,   "Near Black");
        apply_test(8'd254, 8'd254, 8'd254, "Near White");
        apply_test(8'd255, 8'd0,   8'd1,   "Mostly Red");
        apply_test(8'd1,   8'd255, 8'd0,   "Mostly Green");
        apply_test(8'd0,   8'd1,   8'd255, "Mostly Blue");
        $display("");
        
        // Test 4: Real-world colors
        $display("--- Test 4: Real-world Colors ---");
        apply_test(8'd255, 8'd165, 8'd0,   "Orange");
        apply_test(8'd128, 8'd0,   8'd128, "Purple");
        apply_test(8'd165, 8'd42,  8'd42,  "Brown");
        apply_test(8'd255, 8'd192, 8'd203, "Pink");
        apply_test(8'd0,   8'd128, 8'd0,   "Dark Green");
        apply_test(8'd0,   8'd0,   8'd128, "Navy");
        $display("");
        
        // Test 5: Reset during operation
        $display("--- Test 5: Reset Behavior ---");
        @(posedge clk);
        r_in = 8'd100;
        g_in = 8'd150;
        b_in = 8'd200;
        in_valid = 1'b1;
        
        @(posedge clk);
        rst_n = 0; // Apply reset
        #20;
        rst_n = 1;
        
        @(posedge clk);
        if (gray_out == 8'd0 && out_valid == 1'b0) begin
            $display("Reset test: PASS - Outputs cleared correctly");
        end else begin
            $display("Reset test:  FAIL - gray_out=%d, out_valid=%b", gray_out, out_valid);
            error_count = error_count + 1;
        end
        $display("");
        
        // Test 6: Invalid input (in_valid = 0)
        $display("--- Test 6: Invalid Input Handling ---");
        @(posedge clk);
        r_in = 8'd123;
        g_in = 8'd234;
        b_in = 8'd210;
        in_valid = 1'b0; // Invalid
        
        @(posedge clk);
        @(posedge clk);
        if (out_valid == 1'b0) begin
            $display("Invalid input test:  PASS - out_valid correctly low");
        end else begin
            $display("Invalid input test:  FAIL - out_valid should be low");
            error_count = error_count + 1;
        end
        $display("");
        
        // Test 7:  Continuous stream
        $display("--- Test 7: Continuous Pixel Stream ---");
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            r_in = i * 50;
            g_in = i * 40;
            b_in = i * 30;
            in_valid = 1'b1;
        end
        @(posedge clk);
        in_valid = 1'b0;
        
        repeat(5) @(posedge clk);
        $display("Continuous stream test completed");
        $display("");
        
        // Summary
        $display("========================================");
        if (error_count == 0) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("TESTS FAILED: %0d errors detected", error_count);
        end
        $display("========================================\n");
        
        // End simulation
        #50;
        $finish;
    end
    
    // Monitor for debugging
    initial begin
        $monitor("Time=%0t | rst_n=%b | RGB=(%3d,%3d,%3d) | in_valid=%b | gray_out=%3d | out_valid=%b",
                 $time, rst_n, r_in, g_in, b_in, in_valid, gray_out, out_valid);
    end

endmodule