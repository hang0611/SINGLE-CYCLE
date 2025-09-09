module control_unit (
	input [6:0] opcode,
	input [2:0] funct3,
	input [6:0] funct7,
	input zero,

	output reg [1:0] result_src,
	output reg mem_write,
	output reg [2:0] alu_control,
	output reg alu_src,
	output reg [1:0] imm_src,
	output reg reg_write,
	output PC_src
);

reg [1:0] alu_op;
reg branch;
reg jump;

assign PC_src = (zero & branch) | jump;

always @(opcode, funct3, funct7) begin
	case (opcode)
		7'b0000011: begin //lw
			reg_write = 1;
			imm_src = 2'b00;
			alu_src = 1;
			mem_write = 0;
			result_src = 01;
			alu_op = 2'b00;
			branch = 0;
			jump = 0;

		end
		7'b0100011: begin //sw
			reg_write = 0;
			imm_src = 2'b01;
			alu_src = 1;
			mem_write = 1;
			result_src = 00;
			alu_op = 2'b00;
			branch = 0;
			jump = 0;

		end
		7'b0110011: begin //R-type
			reg_write = 1;
			imm_src = 2'b00;
			alu_src = 0;
			mem_write = 0;
			result_src = 00;	
			alu_op = 2'b10;	
			branch = 0;
			jump = 0;	
		end
		7'b1100011: begin //beq
			reg_write = 0;
			imm_src = 2'b10;
			alu_src = 0;
			mem_write = 0;
			result_src = 00;		
			alu_op = 2'b01;	
			branch = 1;
			jump = 0;

		end

		7'b0010011: begin //I-type ALU
			reg_write = 1;
			imm_src = 2'b00;
			alu_src = 1;
			mem_write = 0;
			result_src = 2'b00;		
			alu_op = 2'b10;	
			branch = 0;
			jump = 0;

		end

		7'b1101111: begin //jal
			reg_write = 1;
			imm_src = 2'b11;
			alu_src = 0;
			mem_write = 0;
			result_src = 10;		
			alu_op = 2'b00;	
			branch = 0;
			jump = 1;

		end
		default : begin
			reg_write = 0;
			imm_src = 2'b00;
			alu_src = 0;
			mem_write = 0;
			result_src = 00;		
			alu_op = 2'b00;
			branch = 0;
			jump = 0;		
		end
	endcase
end

always @(alu_op, funct3, funct7) begin

	case (alu_op)
		2'b00: alu_control = 3'b000;
		2'b01: alu_control = 3'b001;

		2'b10: begin
			if(~(|funct3)) begin
				if(opcode[5]&funct7[5]) begin
					alu_control = 3'b001;
				end

				else begin
					alu_control = 3'b000;
				end 
			end

			else if(funct3 == 3'b010) begin
				alu_control = 3'b101;
			end

			else if(funct3 == 3'b110) begin
				alu_control = 3'b011;
			end

			else if(funct3 == 3'b111) begin
				alu_control = 3'b010;
			end

			else begin
				alu_control = 3'b111;
			end
		end
	
		default : alu_control = 3'b111;
	endcase
end
endmodule 