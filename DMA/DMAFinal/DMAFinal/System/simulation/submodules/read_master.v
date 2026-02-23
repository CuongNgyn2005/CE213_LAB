module read_master(iClk, iReset_n, iStart, iLength, iRM_startaddress, iRM_readdatavalid, iRM_waitrequest,
oRM_read, oRM_readaddress, iRM_readdata, iFF_almostfull, oFF_writerequest, oFF_data);

input iClk, iReset_n, iStart, iRM_readdatavalid, iRM_waitrequest, iFF_almostfull;
output reg oRM_read;
output oFF_writerequest;
input [31:0] iLength, iRM_startaddress, iRM_readdata;
output reg [31:0] oFF_data, oRM_readaddress;

reg [1:0] state;
reg [31:0] RM_lastwriteaddress;
assign oFF_writerequest = (~iReset_n)? 0 : (~iFF_almostfull && ~|state && iRM_readdatavalid); //neu reset hoat dong ->oFF_writerequest = 0.
/*
	
*/
always @(*)
begin
		if(~iReset_n)
			oFF_data = 32'h0;
		if(iRM_readdatavalid)
			oFF_data = iRM_readdata;
end
always @(posedge iClk)
begin
	if(~iReset_n)
		begin
			state <= 2'h0;
			//oFF_data <= 32'h0;
			oRM_readaddress <= 32'h0;
			oRM_read <= 1'b0;
			RM_lastwriteaddress	<= 32'h0;
		end
	else
		begin
			if(iStart)
				begin
					oRM_readaddress <= iRM_startaddress; //khoi tao dia chi doc du lieu
					RM_lastwriteaddress	<= iRM_startaddress + iLength;// tinh dia chi cuoi cung can thuc hien DMA
				end
			else begin
			if(~iFF_almostfull || |state)//neu fifo chua day thi tiep tuc viec ghi du lieu vao fifo
				begin
					case(state)
						2'h0: begin
							state <= 2'h1;
							end
						2'h1: begin
							if(oRM_readaddress  == RM_lastwriteaddress)//kiem tra dia chi hien tai da bang dia chi cuoi cung hay chua
								state <= 2'h0;
							else begin
								oRM_read <= 1'b1;
								state <= 2'h2;
							end
							
						end
						2'h2: if(~iRM_waitrequest)
							begin
								oRM_readaddress <= oRM_readaddress + 3'h4;//tang dia chi len 4 don vi
								oRM_read <= 1'b0;
								state <= 2'h0;
							end
						endcase
				end
			end
		end
end
endmodule 





















