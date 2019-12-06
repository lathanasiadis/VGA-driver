`define CLK_PERIOD 20
`timescale 1ns/1ps

module vram_tb;
	reg clk;
	reg [13:0] address;

	vram vram_inst(.clk(clk), .address(address), .red(red), .green(green), .blue(blue));

	initial begin
		clk = 1'b0;
		address = 14'b0;
	end

	always begin
		#(`CLK_PERIOD/2) clk = ~clk;
	end

	always @(posedge clk) begin
		if (address == 14'd12287) begin
			address = 14'b0;
		end
		else begin
			address = address + 14'b1;
		end
		
	end

endmodule