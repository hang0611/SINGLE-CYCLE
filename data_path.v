module data_path (
	input clk,
	input rst_n,
	input [31:0] ins,
	input reg_write,
	input mem_write,
	input alu_src,
	input [2:0] alu_control,
	input PC_src,
	input [1:0] imm_src,
	input [1:0] result_src,

	output [31:0] PC,
	output [31:0] A,
	output [31:0] RD2,
	output zero
);

wire [31:0] read_data;
wire [31:0] RD1;
wire [31:0] WD3;

wire [31:0] immExt;

assign WD3 = (result_src == 2'b01)?read_data:
			(result_src == 2'b00)? A:
			PC + 4;

Register_file RE(	.clk(clk),
					.rst_n(rst_n),
					.A1   (ins[19:15]),
					.A2   (ins[24:20]),
					.A3   (ins[11:7]),
					.WD3  (WD3),
					.WE3  (reg_write),
					.RD1  (RD1),
					.RD2  (RD2));

extend_imm ext(	.immediate(ins[31:7]),
				.immExt   (immExt),
				.imm_src  (imm_src));

alu ALU(.SrcA		(RD1),
		.SrcB      	((alu_src)?immExt:RD2),
		.ALU_result	(A),
		.alu_ctrl  (alu_control),
		.zero      (zero));

Data_mem DM(.clk(clk),
			.rst_n(rst_n),
			.A    (A),
			.WD   (RD2),
			.WE   (mem_write),
			.RD   (read_data));

PC_counter PC_count(	.clk(clk),
				.rst_n(rst_n),
				.PC   (PC),
				.immExt(immExt),
				.PC_src(PC_src));

endmodule