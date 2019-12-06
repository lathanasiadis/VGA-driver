/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 3rd lab assignment (VGA driver)
Description:	Since I'm displaying an object stored in the video ram
				at the center of the screen, I need to know if the current address,
				which is derived by concatenating vpixel and hpixel, is within the bounds
				of the box in which I'll display the object
			(0,0)
				+---A-------B---+
				|   +-------+   |
				|   |       |   |
				|   |   X   |   |
				|   |       |   |
				|   +-------+   |
				+---D-------C---+
				The outer box is the displayed image, which is 128x96, while the inner box ABCD
				is the object I'll display (42x48).
				X is the center of both squares, and its coordinates are (63,47)
				Knowing X, the coordinates of A,B,C,D, in order for the smaller square to be in the center
				of the screen are:
				A = 42,23
				B = 84,23
				C = 84,71
				D = 42,71
*/
module image_source(hpixel, vpixel, source);

	input [6:0] hpixel, vpixel;
	output source; //will be used as a control signal for a multiplexer
	reg source;

	always @(hpixel, vpixel) begin
		if (hpixel >= 42 && hpixel <= 83 && vpixel >= 23 && vpixel <= 70)
			source = 1; //image source is video ram
		else
			source = 0; //image source is a static color
	end

endmodule