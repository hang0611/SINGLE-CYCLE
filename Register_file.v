module Register_file (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD3,
	input WE3,

	output [31:0] RD1,
	output [31:0] RD2
);

reg [31:0] register_file [0:255];

integer i;

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		for (i = 0; i < 256; i = i + 1) begin
			register_file[i] <= 0;
		end

	end else begin
		if (WE3) begin
			register_file[A3] <= WD3;
		end
	end
end

assign RD1 = register_file[A1];
assign RD2 = register_file[A2];
endmodule