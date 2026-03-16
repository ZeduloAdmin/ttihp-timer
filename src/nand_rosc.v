module nand_rosc #(
    parameter DEPTH = 1 // Becomes DEPTH*2+1 inverters to ensure it is odd.
) (
    output osc_out
);

    (* keep = "true" *) wire [DEPTH*2:0] inv_in;
    (* keep = "true" *) wire [DEPTH*2:0] inv_out;
    assign inv_in[DEPTH*2:1] = inv_out[DEPTH*2-1:0]; // Chain.
    assign inv_in[0] = inv_out[DEPTH*2]; // Loop back.
    // Generate an instance array of inverters, 
    // chained and looped back via the 2 assignments above:
    (* keep_hierarchy *) nand_inv inv_array [DEPTH*2:0](
		.a(inv_in),
		.b(1'b1),
		.out(inv_out)
    );
    
    assign osc_out = inv_in[0];

endmodule


