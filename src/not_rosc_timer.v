module not_rosc_timer #(
    parameter integer N = 1     // Becomes DEPTH*2+1 inverters to ensure it is odd.
)(
    input  wire rst_n,					// Async active-low reset
    input  wire clear,					// Clear count
    input  wire start,					// Start counting signal
    input  wire stop,					// Stop counting signal
    output reg [31:0] elapsed_count		// 32-bit count value store
);

	// -----------------------------------------------------------------
    // INSTANTIATION
    // -----------------------------------------------------------------
	not_rosc #(.DEPTH(N)) not_uut (
		.osc_out(ring_oscillator_out)
	);
	
    // -----------------------------------------------------------------
    // REG/WIRE DECLARATION
    // -----------------------------------------------------------------
    reg [3:0]  shortcount;
    reg [27:0] longcount;
    reg        measuring;
	wire ring_oscillator_out;
	
    // -----------------------------------------------------------------
    // Main counter block
    // clear / start / stop are treated as synchronous signals.
    // -----------------------------------------------------------------
    always @(posedge ring_oscillator_out or negedge rst_n) begin
        if (!rst_n) begin
            shortcount    <= 4'd0;
            longcount     <= 28'd0;
            measuring     <= 1'b0;
            elapsed_count <= 32'd0;
            //count         <= 32'd0;
        end else begin

            // --- Synchronous clear (highest priority after reset) ---
            if (clear == 1) begin
                shortcount    <= 4'd0;
                longcount     <= 28'd0;
                elapsed_count <= 32'd0;
                //count         <= 32'd0;
            end

            // --- Start / Stop control ---
            else if (stop == 1) begin
                measuring     <= 1'b0;
                elapsed_count <= {longcount, shortcount};
            end else if (start == 1) begin
                measuring     <= 1'b1;
            end

            // --- Counting ---
            if (!clear && (measuring == 1) && !stop) begin
                shortcount <= shortcount + 1'b1;
                if (shortcount == 4'hF) begin
                    longcount <= longcount + 1'b1;
                end

                // LED-driver
                //if (shortcount == 4'hF) begin
                    //count <= count + 1'b1;
                //end
            end

        end
    end

endmodule


