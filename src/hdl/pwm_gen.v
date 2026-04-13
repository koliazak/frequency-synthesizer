module pwm_gen 
#(
	parameter PWM_RES = 256
)
(
	input  wire                       clk,
	input  wire                       rst_n,
	input  wire [$clog2(PWM_RES)-1:0] duty_cycle,
	input  wire                       duty_valid,
	output reg                        pwm_out
);
	

	reg [$clog2(PWM_RES)-1:0] counter;
	reg [$clog2(PWM_RES)-1:0] duty_active;
	reg [$clog2(PWM_RES)-1:0] duty_shadow;


	always @(posedge clk) begin
		if (!rst_n) begin
			duty_shadow <= 0;
			duty_active <= 0;
		end else begin			
			if (duty_valid)   duty_shadow <= duty_cycle;
			if (counter == 0) duty_active <= duty_shadow;
		end
	end

    always @(posedge clk) begin
	    if (!rst_n) begin
	        counter <= 0;
	    end else begin   
            counter <= counter + 1'b1;
        end
	end
    
    always @(posedge clk) begin
    	pwm_out <= (counter < duty_active);
    end
	
endmodule
