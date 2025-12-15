module median_filter(p1, p2, p3, p4, p5, p6, p7, p8, p9,median_out);
    input  [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    output reg [7:0] median_out;
    // Row-wise sort3 to get per-row min/med/max
    reg [7:0] r1a, r1b, r1c; // sorted: r1a<=r1b<=r1c
    reg [7:0] r2a, r2b, r2c; // sorted: r2a<=r2b<=r2c
    reg [7:0] r3a, r3b, r3c; // sorted: r3a<=r3b<=r3c

    // Combine signals
    reg [7:0] med_med1, med_med2, med_med3; // for median of row meds
    reg [7:0] mm_min; // max of row mins
    reg [7:0] mm_max; // min of row maxs

    reg [7:0] f1, f2, f3; // final three candidates
    reg [7:0] s1, s2, s3; // sorted final triple

    // Helper: sort3 via three compare-swaps
    task automatic sort3;
        inout [7:0] a;
        inout [7:0] b;
        inout [7:0] c;
        reg   [7:0] t;
    begin
        if (a > b) begin t = a; a = b; b = t; end
        if (b > c) begin t = b; b = c; c = t; end
        if (a > b) begin t = a; a = b; b = t; end
    end
    endtask

    always @(*) begin
        // Sort each row
        r1a = p1; r1b = p2; r1c = p3; sort3(r1a, r1b, r1c);
        r2a = p4; r2b = p5; r2c = p6; sort3(r2a, r2b, r2c);
        r3a = p7; r3b = p8; r3c = p9; sort3(r3a, r3b, r3c);

        // Median of row medians
        med_med1 = r1b; med_med2 = r2b; med_med3 = r3b;
        sort3(med_med1, med_med2, med_med3);

        // Max of row minimums
        mm_min = r1a;
        if (r2a > mm_min) mm_min = r2a;
        if (r3a > mm_min) mm_min = r3a;

        // Min of row maximums
        mm_max = r1c;
        if (r2c < mm_max) mm_max = r2c;
        if (r3c < mm_max) mm_max = r3c;

        // Final median is median of {median_of_meds, max_of_mins, min_of_maxs}
        f1 = med_med2; // after sort3 above, med_med2 is the median of row meds
        f2 = mm_min;
        f3 = mm_max;
        s1 = f1; s2 = f2; s3 = f3; sort3(s1, s2, s3);
        median_out = s2;
    end
endmodule 