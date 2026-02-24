module not_rosc #(
    parameter DEPTH = 1 // Becomes DEPTH*2+1 inverters to ensure it is odd.
) (
    output osc_out
);

    wire [DEPTH*2:0] inv_in;
    wire [DEPTH*2:0] inv_out;
    assign inv_in[DEPTH*2:1] = inv_out[DEPTH*2-1:0]; // Chain.
    assign inv_in[0] = inv_out[DEPTH*2]; // Loop back.
    // Generate an instance array of inverters, 
    // chained and looped back via the 2 assignments above:
    (* keep_hierarchy *) inverter inv_array [DEPTH*2:0] ( 
    	.in(inv_in), 
    	.out(inv_out)
    );
    
    assign osc_out = inv_in[0];

endmodule
























/*
module not_rosc #(
    parameter integer N = 3
)(
	input  wire rosc_enable,
    output wire ring_oscillator_out
);

    //(* keep = "true" *) wire [N-1:0] node;
    (* keep = "true" *) wire node1;
    (* keep = "true" *) wire node2;
    (* keep = "true" *) wire node3;

    // NAND-style enable gate
    assign node1 = ~(node3 & rosc_enable);
    assign node2 = ~node1;
    assign node3 = ~node2;
/*    
    genvar i;
    generate
        for (i = 0; i < N-1; i = i + 1) begin
            assign node[i+1] = ~node[i];
        end
    endgenerate

    // gated closing inverter
    //assign node[0] = ~node[N-1];

    assign ring_oscillator_out = node1;

endmodule


`timescale 1ns/1ps
module ring_oscillator_en (
    input  wire en,
    output wire ro_out
);

    (* keep = "true" *) wire n1;
    (* keep = "true" *) wire n2;
    (* keep = "true" *) wire n3;


    // NAND-style enable gate
    assign #2 n1 = ~(n3 & en);
    assign #2 n2 = ~n1;
    assign #2 n3 = ~n2;

    // Output buffer
    assign ro_out = n3;

endmodule
*/
