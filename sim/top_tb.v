`timescale 1ns / 1ps

module top_tb;

    reg clock;
    reg reset;
    reg [15:0] SW;

    wire AUD_SD;
    wire AUD_PWM;

    Top u_top (
        .clock(clock),
        .reset(reset),
        .SW(SW),
        .AUD_SD(AUD_SD),
        .AUD_PWM(AUD_PWM)
    );

    // 100MHz
    always #5 clock = ~clock;

    time t_start, t_end;
    real measured_period_ns;
    real expected_period_ns;
    real error_margin_ns;
    integer pwm_toggle_count = 0;

    always @(posedge AUD_PWM) begin
        pwm_toggle_count = pwm_toggle_count + 1;
    end

    initial begin
        $display("========================================");
        $display("Starting Testbench...");
        $display("========================================");
        clock = 0;
        reset = 0;
        SW = 16'd0;
        #100;
        reset = 1;
        #100;
        reset = 0;
        #100;

        // ~440 Hz
        SW = 16'd601;
        expected_period_ns = 2272727.0; // 1/440
        error_margin_ns = expected_period_ns * 0.01;

        $display("Target Frequency: ~440 Hz");
        $display("Expected Period: %0f ns", expected_period_ns);


        wait(u_top.current_phase[15] == 1);
        wait(u_top.current_phase[15] == 0);
        t_start = $time;
        
        pwm_toggle_count = 0;

       
        wait(u_top.current_phase[15] == 1);
        wait(u_top.current_phase[15] == 0);
        t_end = $time;

        measured_period_ns = t_end - t_start;
        $display("Measured Period: %0f ns", measured_period_ns);


        $display("\n--- VERIFICATION RESULTS ---");

        $display("[INFO] Accuracy is %0.3f %%", 
            100.0 * (1.0 - (
                ((measured_period_ns > expected_period_ns) ? 
                 (measured_period_ns - expected_period_ns) : 
                 (expected_period_ns - measured_period_ns)) 
                / expected_period_ns
            ))
        );
        if (measured_period_ns > (expected_period_ns - error_margin_ns) && 
            measured_period_ns < (expected_period_ns + error_margin_ns)) begin
            $display("[PASS] Frequency is within 1%% tolerance.");
        end else begin
            $display("[FAIL] Frequency is INCORRECT! Expected: %0f, Got: %0f", expected_period_ns, measured_period_ns);
        end

        
        $display("PWM toggles detected in one period: %0d", pwm_toggle_count);
        
        if (pwm_toggle_count > 100) begin
            $display("[PASS] PWM is active and toggling.");
        end else begin
            $display("[FAIL] PWM is DEAD! It did not toggle enough times. Check pwm_gen.v!");
        end

        $display("========================================");
        $display("Simulation Finished.");
        $finish;
    end

endmodule