/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 1st lab assignment
Usage:			Synchronizes reset signal to combat metastability
*/
module synchronizer(clk, original_input, input_sync);
	input clk, original_input;
	output input_sync;

	reg input_middle, input_sync;

	always @(posedge clk) begin
		input_middle <= original_input;
		input_sync <= input_middle;
	end

endmodule
