module switch(iclk, ireset, ichip, iread, idata, oswitch);
input iclk, ireset, ichip, iread;
input [31:0] idata;
output [31:0] oswitch;
reg [31:0] temp;
always @(posedge iclk)
	begin
		if (~ireset)
			temp <= 32'd0;
		else
			if (~ichip && ~iread)
				temp <= idata;
	end
assign oswitch = temp;
endmodule
