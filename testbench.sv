module testbench();
	 logic clk;
	 logic rst_n;
	 logic [31:0] RD2, A;
	 logic mem_write;
	 logic [31:0] ins;
	 logic [31:0] PC;
  reg [31:0] ins_mem [0:255];  // tối đa 256 lệnh
  //integer pc;  // program counter = index dòng
	 // instantiate device to be tested
	 top dut(.clk(clk),
	 			.A        (A),
	 			.PC       (PC),
	 			.RD2      (RD2),
	 			.rst_n    (rst_n),
	 			.ins      (ins),
	 			.mem_write(mem_write));
	 // initialize test
	 initial
	 begin
	 	rst_n <= 0; # 22; rst_n <= 1;
	 end

	 // generate clock to sequence tests
	 always
	 begin
	 	clk <= 1; # 5; clk <= 0; # 5;
	 end

  // Load chương trình từ file
  initial begin
    $readmemh("D:/RISC_V/single_cycle/riscV_test.txt", ins_mem);
  end

  // Mỗi chu kỳ đọc 1 lệnh
  always @(*) begin
      ins <= ins_mem[PC/4];
      $display("Time=%0t | PC=%0d | ins=%h", $time, PC/4, ins_mem[PC/4]);
  end

	 // check results
	 always @(negedge clk)
	 begin
	 	if(mem_write) begin
	 		if(A === 100 & RD2 === 25) begin
	 			$display("Simulation succeeded");
	 			$stop;
	 		end

	 		else if (A !== 96) begin
	 			$display("Simulation failed");
	 			$stop;
	 		end
	 	end
	 end
endmodule