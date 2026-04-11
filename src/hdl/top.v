module Top(
	input clock,
	input reset,
	input [15:0] SW,
	output AUD_SD,
	output AUD_PWM
);
	localparam CLK_FREQ       = 100_000_000;
	localparam PHASE_INC_FREQ = 48_000;
	localparam PHASE_WIDTH    = 16;
	localparam SINE_ROM_DEPTH = 512;
	localparam SINE_SAMPLE_WIDTH = 8;
	localparam PWM_RESOLUTION = 256;

	assign AUD_SD = 1;
	wire ce_48kHz;
	wire rst_n = ~reset;
	wire [PHASE_WIDTH-1:0] current_phase;
	wire [SINE_SAMPLE_WIDTH-1:0] sine_val;

	reg ce_48kHz_delayed;
	always @(posedge clock) begin
    	ce_48kHz_delayed <= ce_48kHz;
	end


	clk_div #(.INPUT_FREQ(CLK_FREQ), .OUTPUT_FREQ(PHASE_INC_FREQ)) 
	u_clk_div(
		.clk_in (clock), 
		.rst_n  (rst_n), 
		.ce_out (ce_48kHz)
	);

	phase_accumulator #(.PHASE_WIDTH(PHASE_WIDTH))
	u_phase_acc(
		.clk       (clock),
		.rst_n     (rst_n),
		.ce        (ce_48kHz),
		.M_inc     (SW),
		.phase_out (current_phase)
	);

	sine_rom #(.ROM_DEPTH(SINE_ROM_DEPTH), .SAMPLE_WIDTH(SINE_SAMPLE_WIDTH))
	u_sine_rom
	(
		.clk      (clock),
		.addr     (current_phase[PHASE_WIDTH-1:PHASE_WIDTH-$clog2(SINE_ROM_DEPTH)]),
		.data_out (sine_val)
	);

	pwm_gen #(.PWM_RES(PWM_RESOLUTION))
	u_pwm
	(
		.clk       (clock),
		.rst_n     (rst_n),
		.duty_cycle(sine_val),
		.duty_valid(ce_48kHz_delayed),
		.pwm_out   (AUD_PWM)		
	);

endmodule