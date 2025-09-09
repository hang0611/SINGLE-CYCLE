module top (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [31:0] ins,
	
	output [31:0] PC,
	output [31:0] A,
	output [31:0] RD2,
	output mem_write
);

wire zero;
wire PC_src;
wire [1:0] imm_src;
wire [1:0] result_src;
wire [2:0] alu_control;
wire alu_src;
wire reg_write;

control_unit ctrl(.zero(zero),
					.PC_src     (PC_src),
					.imm_src    (imm_src),
					.mem_write  (mem_write),
					.opcode     (ins[6:0]),
					.funct3     (ins[14:12]),
					.funct7     (ins[31:25]),
					.result_src (result_src),
					.alu_control(alu_control),
					.alu_src    (alu_src),
					.reg_write  (reg_write));

data_path path(.clk(clk),
				.rst_n      (rst_n),
				.PC_src     (PC_src),
				.imm_src    (imm_src),
				.mem_write  (mem_write),
				.PC         (PC),
				.alu_src    (alu_src),
				.reg_write  (reg_write),
				.alu_control(alu_control),
				.result_src (result_src),
				.A          (A),
				.RD2        (RD2),
				.ins        (ins),
				.zero       (zero));

endmodule 