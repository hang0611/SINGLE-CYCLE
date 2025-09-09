module Data_mem (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input [31:0] A,
	input [31:0] WD,
	input WE,

	output [31:0] RD	
);

reg [31:0] data_mem [0:4095];

integer i;

always @(posedge clk or negedge rst_n) begin 
	if(~rst_n) begin
		for (i = 0; i < 4096; i = i + 1) begin
			data_mem[i] <= 0;
		end
	end else begin
		if(WE) begin
			data_mem[A] <= WD;
		end
	end
end

assign RD = data_mem[A];
endmodule 