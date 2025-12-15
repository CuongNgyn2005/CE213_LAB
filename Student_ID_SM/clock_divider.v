module clock_divider(clk_50,rst_n,clk_out);
input clk_50;
input rst_n;
output reg clk_out;
localparam TOGGLE_VALUE = 25000000;
reg [25:0]count;
always@(posedge clk_50 or negedge rst_n) begin
if (!rst_n) begin
	count <= 0;
	clk_out <= 0;
	end 
	else begin
	if (count == TOGGLE_VALUE - 1) begin
                clk_out <= ~clk_out; // Toggle
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule 