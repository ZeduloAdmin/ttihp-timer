`default_nettype none (* keep_hierarchy *)

module nand_inv(
	input wire a,
	input wire b,
	output wire out
	);
	
	assign out = ~(a & b);

endmodule
