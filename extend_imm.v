module extend_imm (
	input [24:0] immediate,
	input [1:0] imm_src,

	output reg [31:0] immExt
);

always @(imm_src, immediate) begin
	case (imm_src)
		2'b00: immExt = {{20{immediate[24]}},immediate[24:13]};   //I
		2'b01: immExt = {{20{immediate[24]}},immediate[24:18],immediate[4:0]};   //S
		2'b10: immExt = {{20{immediate[24]}},immediate[0],immediate[23:18],immediate[4:1],1'b0};  //B
		2'b11: immExt = {{12{immediate[24]}},immediate[12:5],immediate[13],immediate[23:14],1'b0};   //J
		default : immExt = 0;
	endcase
end

endmodule