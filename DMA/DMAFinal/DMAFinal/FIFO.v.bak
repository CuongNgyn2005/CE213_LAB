module FIFO(iClk, iReset_n, FF_empty, FF_almostfull, FF_data, FF_q , FF_readrequest, FF_writerequest);
input iClk, iReset_n, FF_readrequest, FF_writerequest;
output FF_empty, FF_almostfull;
input [31:0] FF_data;
output [31:0] FF_q;

reg [31:0] buffer [256:0]; // bo nho dem cho fifo
reg [7:0] pos_read, pos_write; //dia chi cho doc va ghi cua master_write va master_read
wire fifo_rd, fifo_wr; 
wire compare, equal; //2 bits trang thai dung cho bao FF_almostfull va FF_empty
assign FF_q = buffer[pos_read]; //FF_q luon duoc xuat tu fifo
assign fifo_wr = (~FF_almostfull) & FF_writerequest; //Kiem tra tin hieu FF_writerequest va FF_almostfull de tien hanh ghi
assign fifo_rd = (~FF_empty & FF_readrequest); ////Kiem tra tin hieu FF_readrequest va FF_empty de tien hanh doc
//--Ghi du lieu vao bo dem FIFO

always @ (posedge iClk)
begin
if(~iReset_n)
			pos_write <= 8'b00000000;
	if(fifo_wr)
	begin
		buffer[pos_write] <= FF_data;
		pos_write <= pos_write + 1;
	end
	else
		pos_write <= pos_write;
end

//--tang dia chi doc len 1
always @ (posedge iClk)
	begin
	if(~iReset_n)
			pos_read <= 8'b00000000;
	else if(fifo_rd)
			pos_read <= pos_read + 1;
		else 
			pos_read <= pos_read;
	end
//---------------------------------------
assign compare = pos_write[7] ^ pos_read[7];  //so sanh bit cao cua pos_read va pos_write
assign equal = (pos_write[6:0] - pos_read[6:0]) ? 0:1;   
assign FF_almostfull =  compare & equal; //Bao FF_almostfull = 1 khi buffer/2
assign FF_empty =  ~compare & equal; //Bao FF_empty=1 khi pos_read = pos_write
endmodule









