module phase_accumulator
#(
	parameter PHASE_WIDTH = 16 // width of accumulator register
)
(
	input wire                    clk,
	input wire                    ce,
	input wire                    rst_n,
	
	input  wire [PHASE_WIDTH-1:0] M_inc,
	output reg  [PHASE_WIDTH-1:0] phase_out
);

always @(posedge clk) begin
	if (!rst_n) begin
		phase_out <= 0;
	end else if (ce) begin
		phase_out <= phase_out + M_inc;
	end
end


endmodule
