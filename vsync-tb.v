`define CLK_PERIOD 20
`timescale 1ns/1ps

module vsync_tb;

	wire reset, vsync;
	wire [5:0] frame;
	wire [6:0] vpixel;
	reg clk,reset_original;

	vsync_generator vsync_inst(.clk(clk), .reset(reset), .frame(frame), .vpixel(vpixel), .vsync(vsync), .en(en));

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