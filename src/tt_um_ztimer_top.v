`default_nettype none


module tt_um_ztimer_top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,     //always 1 when the design is powered,so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
	
	wire [31:0] t0_elapsed_count;
	wire [31:0] t1_elapsed_count;
	wire [31:0] t2_elapsed_count;
	wire [31:0] t3_elapsed_count;
	
	wire [31:0] t4_elapsed_count;
	wire [31:0] t5_elapsed_count;
	wire [31:0] t6_elapsed_count;
	wire [31:0] t7_elapsed_count;
	
		
	//Instatiations
	not_rosc_timer #(1) not_timer1 (
		.rst_n			(rst_n),
		.clear			(ui_in[0]),
		.start			(ui_in[1]),
		.stop			(uio_in[0]),
		.elapsed_count  (t0_elapsed_count)
		);
		
	not_rosc_timer #(2) not_timer2 (
		.rst_n			(rst_n),
		.clear			(ui_in[2]),
		.start			(ui_in[3]),
		.stop			(uio_in[1]),
		.elapsed_count  (t1_elapsed_count)
		);
	
	nand_rosc_timer #(1) nnad_timer1 (
		.rst_n			(rst_n),
		.clear			(ui_in[4]),
		.start			(ui_in[5]),
		.stop			(uio_in[2]),
		.elapsed_count  (t2_elapsed_count)
		);
		
	nand_rosc_timer #(2) nand_timer2 (
		.rst_n			(rst_n),
		.clear			(ui_in[6]),
		.start			(ui_in[7]),
		.stop			(uio_in[3]),
		.elapsed_count  (t5_elapsed_count)
		);
		
		
	assign uo_out[7:1] = 7'b0000_000;

  	// List all unused inputs to prevent warnings
	wire dummy = &{ uio_in[7:4], ena };
	assign uo_out[0] = dummy;
	wire _unused = &{clk, 1'b0};
	
	assign uio_oe = 8'b0000_0000;
    assign uio_out = 8'b0000_0000;

	  
endmodule
