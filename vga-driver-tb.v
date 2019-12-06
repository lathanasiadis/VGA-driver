`define CLK_PERIOD 20
`timescale 1ns/1ps

module vga_driver_tb;

	reg clk, reset;

	vga_driver vga_driver_tb (
		.clk(clk),
		.resetbutton(reset),
		.vga_red(vga_red),
		.vga_green(vga_green), 
		.vga_blue(vga_blue),
		.vga_vsync(vga_vsync),
		.vga_hsync(vga_hsync)
		);

	initial begin
		clk = 1'b0;
		reset = 1'b1;
		#(200* `CLK_PERIOD) reset = 1'b0;
		#(`CLK_PERIOD) reset = 1'b1;
		#(200* `CLK_PERIOD) reset = 1'b0;
	end

	always begin
		#(`CLK_PERIOD/2) clk = ~clk;
	end

endmodule