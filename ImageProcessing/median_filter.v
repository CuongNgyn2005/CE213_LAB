module median_filter (clk,rst_n,p1,p2,p3,p4,p5,p6,p7,p8,p9,median_out);
    input         clk;
    input         rst_n;      // Active-low reset
    input   [7:0] p1, p2, p3; // Row 1 pixels
    input   [7:0] p4, p5, p6; // Row 2 pixels
    input   [7:0] p7, p8, p9; // Row 3 pixels
    output reg  [7:0] median_out;

    // --- PIPELINE STAGE 1 REGISTERS ---
    // Stores the sorted results (Min, Med, Max) for each row
    reg [7:0] r1_min, r1_med, r1_max;
    reg [7:0] r2_min, r2_med, r2_max;
    reg [7:0] r3_min, r3_med, r3_max;

    // --- PIPELINE STAGE 2 REGISTERS ---
    // Stores the three final candidates
    reg [7:0] cand1; // Median of Row Medians
    reg [7:0] cand2; // Max of Row Mins
    reg [7:0] cand3; // Min of Row Maxs

    // Temporary variables for sorting logic (Combinational)
    reg [7:0] t1, t2, t3;
    reg [7:0] tmp;

    // --- HELPER FUNCTION: SORT 3 ---
    // Input: 3 values. Output: {Max, Med, Min} concatenated
    // Uses 3 Compare-Swap steps (Bubble Sort network). NO LOOPS.
    function [23:0] sort3_func;
        input [7:0] a, b, c;
        reg [7:0] s_a, s_b, s_c;
        reg [7:0] s_tmp;
        begin
            s_a = a; 
            s_b = b; 
            s_c = c;

            // Step 1: Compare A vs B
            if (s_a > s_b) begin
                s_tmp = s_a; s_a = s_b; s_b = s_tmp;
            end

            // Step 2: Compare B vs C (s_c becomes global Max)
            if (s_b > s_c) begin
                s_tmp = s_b; s_b = s_c; s_c = s_tmp;
            end

            // Step 3: Compare A vs B again (s_a becomes global Min)
            if (s_a > s_b) begin
                s_tmp = s_a; s_a = s_b; s_b = s_tmp;
            end

            // Return {Max, Med, Min}
            sort3_func = {s_c, s_b, s_a};
        end
    endfunction

    // --- SEQUENTIAL LOGIC ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r1_min <= 0; r1_med <= 0; r1_max <= 0;
            r2_min <= 0; r2_med <= 0; r2_max <= 0;
            r3_min <= 0; r3_med <= 0; r3_max <= 0;
            cand1  <= 0; cand2  <= 0; cand3  <= 0;
            median_out <= 0;
        end else begin
            // ---------------------------------------------------------
            // STAGE 1: Sort each row independently
            // ---------------------------------------------------------
            {r1_max, r1_med, r1_min} <= sort3_func(p1, p2, p3);
            {r2_max, r2_med, r2_min} <= sort3_func(p4, p5, p6);
            {r3_max, r3_med, r3_min} <= sort3_func(p7, p8, p9);

            // ---------------------------------------------------------
            // STAGE 2: Calculate 3 final candidates
            // ---------------------------------------------------------
            
            // 1. Median of the Row Medians
            // We use sort3_func but only keep the middle 8 bits (the median)
            {t3, cand1, t1} <= sort3_func(r1_med, r2_med, r3_med);

            // 2. Max of the Row Mins (Matches your original code logic)
            // Logic: Start with r1_min, compare with r2_min, then r3_min
            if (r1_min >= r2_min && r1_min >= r3_min)
                cand2 <= r1_min;
            else if (r2_min >= r1_min && r2_min >= r3_min)
                cand2 <= r2_min;
            else
                cand2 <= r3_min;

            // 3. Min of the Row Maxs (Matches your original code logic)
            // Logic: Start with r1_max, compare with r2_max, then r3_max
            if (r1_max <= r2_max && r1_max <= r3_max)
                cand3 <= r1_max;
            else if (r2_max <= r1_max && r2_max <= r3_max)
                cand3 <= r2_max;
            else
                cand3 <= r3_max;

            // ---------------------------------------------------------
            // STAGE 3: Final Sort to find the Median
            // ---------------------------------------------------------
            // Sort the 3 candidates and take the middle value
            {t3, median_out, t1} <= sort3_func(cand1, cand2, cand3);
        end
    end

endmodule