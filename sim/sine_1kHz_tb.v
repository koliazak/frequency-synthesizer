`timescale 1ns/1ps

module sine_1kHz_tb;

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

    integer file;

    initial begin
        
        file = $fopen("sine_out.txt", "w");
        
        clock = 0;
        reset = 0;
        // 1kHz
        SW = 16'd0;    
        #100;
        reset = 1;
        #100
        reset = 0;
        #100;
        
        SW = 16'd1365;    
        
        // 2 periods of 1kHz freq sinus
        #2000000
        $display("Simulation finished");
        $finish;
    end
    
    always @(posedge clock) begin
        if (u_top.ce_48kHz) begin
            $fdisplay(file, "%d", u_top.sine_val); 
        end
    end

endmodule