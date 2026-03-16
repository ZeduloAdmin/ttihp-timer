(* keep_hierarchy *)
module nand_rosc_timer #(
    parameter integer N = 1     //  Becomes DEPTH*2+1 inverters to ensure it is odd.
)(
    input  wire rst_n,          // Async active-low reset
    input  wire clear,          // Synchronous clear (sampled on node[0] rising edge)
    input  wire start,          // Start counting
    input  wire stop,           // Stop counting, latch elapsed_count
    output reg [31:0] elapsed_count
);

	// -----------------------------------------------------------------
    // INSTANTIATION
    // -----------------------------------------------------------------

	nand_rosc #(N) nand_rosc1 (
    	.osc_out(ring_oscillator_out)
  	 );
		
    // -----------------------------------------------------------------
    // REG/WIRE DECLARATION
    // -----------------------------------------------------------------
    reg [3:0]  shortcount;
    reg [27:0] longcount;
    reg        measuring;
	wire ring_oscillator_out;
	
    logic        measuring_next;
	logic [31:0] elapsed_count_next;

	always_comb begin
	    measuring_next     = measuring; 
		elapsed_count_next = elapsed_count;

		if (clear) begin
		    elapsed_count_next = 32'd0;
		end else if (start) begin
		    measuring_next = 1'b1;
		end else if (stop) begin
		    measuring_next = 1'b0;
		    elapsed_count_next = {longcount, shortcount};
		end
	end

	always @(posedge ring_oscillator_out or negedge rst_n) begin
		if (!rst_n) begin
		    measuring     <= 1'b0;
		    elapsed_count <= 32'd0;
		end else begin
		    measuring     <= measuring_next;
		    elapsed_count <= elapsed_count_next;
		end
	end


   // -----------------------------------------------------------------
    // Main counter block
    // clear / start / stop are treated as synchronous signals.
    // -----------------------------------------------------------------

	// Broken down counting with counting overflow 
	always @(posedge ring_oscillator_out) begin		
	    if (!rst_n || clear) begin
	        shortcount <= 4'd0;
	        longcount <= 28'd0;
	    end else if (measuring_next == 1) begin
	    	shortcount <= shortcount + 1;
	        if (shortcount == 4'hF) begin
	            shortcount <= 4'd0;
	            longcount <= longcount + 1;
	        end
	    end else 
	    	shortcount <= shortcount;
	end

/*	
	//LED driver
	always @(posedge shortcount[3]) begin
		if (rst_n == 0 || clear == 1)
			count <= 32'd0;
		else if (measuring == 1)
			count <= count + 1;
		else
			count <= count;
	end
*/	

endmodule
