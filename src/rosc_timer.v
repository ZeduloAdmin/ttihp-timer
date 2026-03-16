`timescale 1ns/1ps
module rosc_timer #(
    parameter integer N = 3	// number of not gates, must be odd & >= 3
)(
    input  wire rst_n,
    input  wire rosc_enable,
    input  wire clear,
    input  wire start,
    input  wire stop,
    output reg [31:0] elapsed_count
);


    reg measuring;
    reg [3:0] lowcount;
    reg [27:0] highcount;
    wire ring_oscillator_out;
    wire [4:0] next_lowcount = lowcount + 1'b1; // Carry-out logic
    reg stop_prev; // To store the previous state of the stop signal
    
    
    // Instantiate DUT
	not_rosc #(.N(N)) dut (    
		.rosc_enable(rosc_enable),			// Enable ring oscillator
		.ring_oscillator_out(ring_oscillator_out)		//ring oscillator out 
	);
    
	// Start / stop control - REWRITTEN TO REMOVE LOOPS
    always @(posedge ring_oscillator_out or negedge rst_n) begin
        if (!rst_n) begin
            measuring     <= 1'b0;
            elapsed_count <= 32'd0;
            stop_prev     <= 1'b0;
        end else begin
            // Store the current stop signal to compare on the next clock
            stop_prev <= stop;

            if (clear == 1) begin
                measuring     <= 1'b0;
                elapsed_count <= 32'd0;
            end 
            else if (start == 1 && !measuring) begin
                measuring     <= 1'b1;
            end 
            // Only trigger when stop goes from 0 to 1 (Rising Edge)
            else if (stop == 1 && !stop_prev && measuring == 1) begin
                measuring     <= 1'b0;
                elapsed_count <= {highcount, lowcount}; 
            end
        end
    end

	// Broken down counting with counting overflow 
	always @(posedge ring_oscillator_out) begin
	    if (!rst_n || clear == 1) begin
	        lowcount <= 4'd0;
	        highcount <= 28'd0;
	    end else if (measuring == 1) begin
			lowcount <= next_lowcount[3:0]; // Take the bottom 4 bits
	        if (next_lowcount[4] == 1'b1) begin
	            highcount <= highcount + 1;
	        end
	    end else begin
			lowcount <= lowcount;
			highcount <= highcount;
	    end
	end
	
	
endmodule
