`define CLK_PERIOD 20
`timescale 1ns/1ps

module hsync_tb;

	wire reset, hsync;
	wire [6:0] hpixel;
	reg clk,reset_original;

	hsync_generator hsync_inst(.clk(clk), .reset(reset), .hpixel(hpixel), .hsync(hsync), .en(en));

	synchronizer sync_inst(.clk(clk), .original_input(reset_original), .input_sync(reset));

	initial begin
		clk = 1'b0;
		reset_original = 1'b1;
		#(10 * `CLK_PERIOD) reset_original = 1'b0;
	end

	always begin
		#(`CLK_PERIOD/2) clk = ~clk;
	end

endmodule