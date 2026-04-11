module clk_div 
#(
	parameter INPUT_FREQ  = 100_000_000,
	parameter OUTPUT_FREQ = 48_000
)
(
	input wire clk_in,
	input wire rst_n,

	output reg ce_out
);
	
	localparam div = INPUT_FREQ / OUTPUT_FREQ;
	
	reg [$clog2(div)-1:0] counter;

	always @(posedge clk_in) begin
		if (!rst_n) begin
			counter <= 0;
			ce_out <= 0;
		end else begin
			if (counter >= (div - 1)) begin
				counter <= 0;
				ce_out <= 1;
			end else begin
				counter <= counter + 1'b1; 
				ce_out <= 0;
			end
		end
	end

endmodule