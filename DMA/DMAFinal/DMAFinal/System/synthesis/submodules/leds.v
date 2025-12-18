module leds(iclk, ireset, ichip, iwrite, idata, oleds);
input iclk, ireset, ichip, iwrite;
input [31:0] idata;
output [31:0] oleds;
reg [31:0] temp;
always @(posedge iclk)
	begin
		if (~ireset)
			temp <= 32'd0;
		else
			if (~ichip && ~iwrite)
				temp <= idata;
	end
assign oleds = temp;
endmodule
