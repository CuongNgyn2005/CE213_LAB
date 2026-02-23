module control_slave (iClk, iReset_n, iChipselect_n, iWrite, iRead, iMW_done, iAddress, iWritedata,
						oStart, oReaddata, oRM_startaddress, oWM_startaddress, oLength);

input				iClk;				//xung clock
input				iReset_n;			//Tin hieu reset	
input				iChipselect_n;		//Tin hieu select tu CPU
input				iWrite;				//iWrite = 1: cho phep ghi gia tri vao cac thanh ghi cua DMA
input				iRead;				//iRead =  1: chi phep doc gia tri cua thanh ghi trong DMA
input				iMW_done;			//Tin hieu bao qua trinh DMA da ket thuc
input		[2:0]	iAddress;			//Chon dia chi thanh ghi can doc
input		[31:0]	iWritedata; 		//Truyen gia tri vao thanh ghi DMA tu Avalon
							
						
output reg	[31:0]	oRM_startaddress; 	// Dia chi bat dau cua read_master
output reg	[31:0]	oWM_startaddress; 	// Dia chi bat dau cua write_master
output reg	[31:0]	oLength;			//Chieu dai cua du lieu can truyen
reg		[31:0]	control, status;
reg     [1:0] 	state;
reg  enable;
output reg			oStart;				//Tin hieu bat dau qua trinh DMA
output reg	[31:0]	oReaddata; 			//Tin hieu xuat gia tri cua cac thanh ghi ra Avalon khi can
			
// Khai bao cac bits trong cac thanh ghi (thanh ghi control va thanh ghi status)
wire			GO, WORD, HW, BYTE,	DONE, BUSY;
			//-----------cu the cac thanh ghi
			//|control|control|control|control|status|status|
			
//Khai bao thanh ghi control


				

assign {GO, WORD, HW, BYTE} = control[3:0]; //gan 4 bit trong thanh ghi control cho GO, WORD, HW, BYTE
assign {BUSY, DONE} = status[1:0]; //bit thong bao trang thai hoat dong cua status busy = 1: DMA dang hoat dong. DONE = 1: bao hieu qua trinh DMA da ket thuc.


always @ (posedge iClk)
begin
	if (~iReset_n) //Khi iReset_n = 0 thi se xoa toan bo thanh ghi
	begin
		oRM_startaddress		<= 32'h0;
		oWM_startaddress		<= 32'h0;
		oLength					<= 32'h0;
		control					<= 32'h0;
		oReaddata				<= 32'h0;					
	end
	
	else if (DONE)
		control 				<= 32'h0; //Khi hoan thanh DMA thi bit DONE len 1 va sex xoa thanh ghi control 
		
	else if (~iChipselect_n)
	begin
		if (iWrite & ~BUSY)  //khi tin hieu iWrite = 1 tu CPU chuyen den va ~BUSY = 0 thi bat dau chuyen cac gia tri tu CPU vao thanh ghi DMA
			case (iAddress)
				3'h0: oRM_startaddress 		<= iWritedata; //truyen dia chi can doc
				3'h1: oWM_startaddress		<= iWritedata; //truyen dia chi can ghi
				3'h2: oLength			  	<= iWritedata; //chieu dai khoi du lieu can truyen
				3'h3: control 	  			<= iWritedata; //cau hinh thanh ghi control
			endcase
		
		else if (iRead) //khi iRead = 1 thi doc trang thai cua thanh ghi status
			case (iAddress)
				3'h7: oReaddata 			<= status;		
			endcase
	end 		
end

always @ (posedge iClk)
begin
	if (~iReset_n) // khi ire = 0 thi gan thanh ghi status = 0, tin hieu start = 0
	begin
		status 			<= 32'h0;
		oStart			<= 1'b0;
		state 			<= 2'h0;
		enable 			<= 1'b0;
	end
	
	else
		case (state)
			2'h0: begin
				if (GO && ~enable) //khi cpu cau hinh GO = 1 thi DMA bat dau hoat dong.
				begin
					status 		<= 32'h2;
					oStart 		<= 1'b1;				
					state 		<= 2'h1;
				end
			end
			2'h1: begin
				oStart			 <= 1'b0;
				enable 			<= 1'b1;
				if (iMW_done) //vong lap doi den khi nao write_master bao xong thong qua iMW_done
				begin
					status 		<= 32'h1;
					state 		<= 2'h2;
				end
			end
				
			2'h2: begin
				status 			<= 32'h0;
				state 			<= 2'h0;
			end
		endcase
end

endmodule
