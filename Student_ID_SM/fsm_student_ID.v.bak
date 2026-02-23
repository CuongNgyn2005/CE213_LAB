module fsm_student_ID(clk,active,rst_n,start, user_input,output_digit,Done);
input clk;
input rst_n;
input start; //tín hiệu start
input wire [3:0]user_input; 
output reg [3:0]output_digit; //xuất ra số dựa trên trạng thái hiện tại
output reg Done;// tín hiệu xong
output reg active;//tín hiệu đang xử lý
reg [3:0]current_state,next_state;
localparam IDLE = 4'd15;
localparam S0 = 4'd0;
localparam S1 = 4'd1;
localparam S2 = 4'd2;
localparam S3 = 4'd3;
localparam S4 = 4'd4;
localparam S5 = 4'd5;
localparam S6 = 4'd6;
localparam S7 = 4'd7;
// --- 1. Sequential Logic: Chuyển trạng thái ---
always@(posedge clk) begin
	if(!rst_n) 
	current_state <= IDLE;
	else
	current_state <= next_state;
	end
// --- 2. Output Logic: Ánh xạ trạng thái ra số (Moore Machine) ---
always @(current_state, start, user_input) begin
        next_state = current_state; 
        case (current_state) 
				IDLE: begin

					if(start) begin
						case(user_input)
							4'd2: next_state = S0;
							4'd3: next_state = S1;
							4'd5: next_state = S2;
							4'd0: next_state = S4;
							default: next_state = S0;
						endcase 
					end
					else next_state = IDLE;
				end
				
            S0: next_state = S1; // Xong 2 -> qua 3
            S1: next_state = S2; // Xong 3 -> qua 5
            S2: next_state = S3; // Xong 5 -> qua 2
            S3: next_state = S4; // Xong 2 -> qua 0
            S4: next_state = S5; // Xong 0 -> qua 2 (Đúng logic nhập 0 -> tiếp theo là 2)
            S5: next_state = S6; // Xong 2 -> qua 0
            S6: next_state = S7; // Xong 0 -> qua 0
            S7: next_state = IDLE; // Hết chuỗi -> Về nghỉ
            default: next_state = IDLE;
        endcase
end 
always @(current_state) begin
		  active = 1;
		  Done = 0;
		  output_digit = 4'd0;
		  case (current_state)
            S0: begin output_digit = 4'd2;  end
            S1: begin output_digit = 4'd3;  end
            S2: begin output_digit = 4'd5;  end
            S3: begin output_digit = 4'd2;  end
            S4: begin output_digit = 4'd0;  end
            S5: begin output_digit = 4'd2;  end
            S6: begin output_digit = 4'd0;  end
            S7: begin output_digit = 4'd0; Done = 1;  end
				default: begin active = 0;end
        endcase
end 
endmodule 