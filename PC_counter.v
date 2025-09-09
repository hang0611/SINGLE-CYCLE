module PC_counter (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input PC_src,
	input [31:0] immExt,

	output reg [31:0] PC
);

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		PC <= 0;
	end else begin
		if(PC_src) begin
			PC <= PC + immExt;
		end
		else begin
			PC <= PC + 4;
		end
	end
end

endmodule