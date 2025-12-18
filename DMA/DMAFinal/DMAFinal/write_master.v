module write_master ( iClk, iReset_n, iStart, iWM_startaddress, iLength, iWM_waitrequest, iFF_empty, iFF_q, 
						oFF_readrequest, oWM_done, oWM_write, oWM_writeaddress, oWM_writedata);

input				iClk; 				// xung clock
input				iReset_n; 			//Tin hieu resset_n
input				iStart;				//Tin hieu bat dau qua trinh DMA													
input		[31:0]	iWM_startaddress;	//Dia chi bat dau cua memory can ghi
input		[31:0]	iLength;			//chieu dai du lieu can truyen
input				iWM_waitrequest;	//iWM_waitrequest = 1: Avalon yeu cau write_master cho
input				iFF_empty;			// write_master kiem tra FIFO rong hay khong? #0 thi write_master hoat dong
input		[31:0]	iFF_q;				// Duong du lieu tu FIFO toi write_master

output				oFF_readrequest;  	//Tin hieu yeu cau can doc cua write_master
output reg			oWM_done;			//Bao hieu DMA da hoan thanh
output reg			oWM_write;			//Tin hieu =1 write_master do du lieu ra avalon
output reg	[31:0]	oWM_writeaddress;	//Dia chi ghi du lieu
output reg	[31:0]	oWM_writedata;		//Du lieu can ghi tu write_master
				
				
		
reg		[1:0]	state;
reg		[31:0]	WM_lastwriteaddress;

wire 			oFF_readrequest;

//Quan trong
assign oFF_readrequest = (~iReset_n) ? 1'b0 : (~iFF_empty && ~|state); // Khi ~reset_n = 0 --> oFF_readrequest = 0; nguoc lai khi empty = 0 va state = 2'h0; yeu cau du lieu moi 

always @ (posedge iClk)				
begin
	if (~iReset_n)
	begin
		state 				<= 2'h0;
		oWM_write			<= 1'b0;
		oWM_done			<= 1'b0;
		oWM_writedata		<= 32'h0;
		oWM_writeaddress	<= 32'h0;
		WM_lastwriteaddress	<= 32'h0;
	end
	
	else
	begin
		if (iStart) //iStart = 1, bat dau DMA
		begin
			oWM_writeaddress 	<= iWM_startaddress; //gan dia chi tu khoi control sang ouput cua write_master
			WM_lastwriteaddress	<= iWM_startaddress + iLength;  //WM_lastwriteaddress kiem tra qua trinh DMA da ket thuc hay chua dua vao iLength
		end
			
		else if (~iFF_empty || |state)		//chi can iFF_empty hoac state khong dong thoi bang 0 thi qua trinh DMA van tiep tuc, neu iFF_empty = 0 ma state chua ve 2'h0 thi no van tiep tuc cho den khi quay ve 2'h0
			case (state)
				2'h0: 
				begin 
					state 		<= 2'h1;
					oWM_write 		<= 1'b1; //cho phep du lieu xuat ra khoi write_master
					oWM_writedata 	<= iFF_q;
				end
				2'h1: 
				begin
					if (WM_lastwriteaddress == (oWM_writeaddress + 4) )//kiem tra xem DMA ket thuc chua?
						begin
							state <= 2'h2;
							oWM_done <= 1'b1;
						end
					if (~iWM_waitrequest) //kiem tra iWM_waitrequest co ban hay khong, neu = 0 thi khong ban, neu = 1 giu nguyen trang thai nay
						begin
							oWM_writeaddress <= oWM_writeaddress + 3'h4; //tang dia chi len 4 sau moi lan ghi du lieu thanh cong
							oWM_write 	<= 1'b0;
							state <= 2'h0;
						end
				end
				2'h2: begin
					oWM_done	<= 1'b0; // Tin hieu bao DMA da hoan thanh
					state 		<= 2'h0;
				end
				
			endcase
	end
end
endmodule
