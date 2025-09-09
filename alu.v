module alu (
	input [2:0] alu_ctrl,
	input [31:0] SrcA,
	input [31:0] SrcB,

	output reg [31:0] ALU_result,
	output zero
);

localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND =  3'b010;
localparam OR = 3'b011;
localparam SLT = 3'b101;

always @(alu_ctrl, SrcA, SrcB) begin
	case (alu_ctrl)
		ADD: ALU_result = SrcA + SrcB;
		SUB: ALU_result = SrcA - SrcB;
		AND: ALU_result = SrcA & SrcB;
		OR: ALU_result = SrcA | SrcB;
		SLT: ALU_result = (SrcA < SrcB)?1:0;

		default : ALU_result = 1;
	endcase
end

assign zero = (ALU_result)?0:1;
endmodule