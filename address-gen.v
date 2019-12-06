/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 3rd lab assignment (VGA driver)
Description:	This module calculates the correct VRAM adress for the current pixel,
				as long as the image-source module has outputted source = 1.
*/

module address_generator(clk, reset, frame, hpixel, vpixel, address, select);

	input clk, reset;
	input [5:0] frame;
	input [6:0] hpixel, vpixel;

	output [13:0] address;
	output select;

	reg select;
	reg [5:0] old_frame;
	//My animation consists of 8 sprites, therefore I need a 3 bit reg to cycle through them
	reg [2:0] current_sprite; 
	/*
	My animation's speed will be 10FPS.
	My VGA driver works at 60FPS, so, in order to achive 10FPS,
	the same frame must be displayed 6 times.
	*/
	reg [2:0] frame_counter;

	reg [6:0] H; //horizontal offset
	reg [6:0] V; //vertical offset

	//7 most/least significant bits of address
	wire [6:0] address_high, address_low;

	parameter [2:0] MAX_FRAME = 3'd6; //resulting FPS will be 60/MAX_FRAME

	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			frame_counter = 3'b000;
			current_sprite = 3'b000;
		end
		else begin
			old_frame <= frame;

			if (old_frame != frame) begin
				//frame changed
				frame_counter = frame_counter + 3'b1;
			end
			if (frame_counter == MAX_FRAME) begin
				//time to change the displayed sprite
				frame_counter = 3'd0;
				current_sprite = current_sprite + 3'b1;
			end

			/*
			First set of block RAMs has the first 6 sprites, while the second
			set has the last 2.

			The sprites are stored left-to-right, top-to-bottom.
			All offsets are in regard of the first pixel (leftmost of first row)
			of the first sprite.

			So each for each sprite that was displayed in the same row, the horizontal
			offset must be incremented by 42, while the bottom sprites have a
			vertical offset of 48.
			*/
			case (current_sprite)
				3'd0:
				begin
					H = 7'd0; //no offsets
					V = 6'd0;
					//first 6 sprites are stored in the first set of block RAMs
					select = 1'b0;
				end
				3'd1:
				begin
					H = 7'd42; //
					V = 6'd0;
				end
				3'd2:
				begin
					H = 7'd84;
					V = 6'd0;
				end
				3'd3:
				begin
					H = 7'd0;
					V = 6'd48;
				end
				3'd4:
				begin
					H = 7'd42;
					V = 6'd48;
				end
				3'd5:
				begin
					H = 7'd84;
					V = 6'd48;
				end
				//same as case 0, since this is the same position at the second atlas
				3'd6: 
				begin
					H = 7'd0;
					V = 6'd0;
					//last 2 sprites are stored in the second set of block RAMs
					select = 1'b1;
				end
				//same as case 1, since this is the same position at the second atlas
				3'd7:
				begin
					H = 7'd42;
					V = 6'd0;
				end
			endcase
		end
	end

	/*
	I subtract 23 from vpixel and 42 from hpixel to align the displayed sprite with
	point A, which is the start of the box in which the sprites are displayed

	<---------128-------->
      43      42       43
    <---><----------><--->  
^   +--------------------+  ^
|24 |                    |  |  
v   |    A(42,23)        |  |
^   |    +----------+    |  |
|48 |    |          |    |  | 96
|   |    |          |    |  |
v   |    +----------+    |  |
^   |                    |  |
|24 |                    |  |
v   +--------------------+  v


	*/
	assign address_low = hpixel - 6'd42 + H;
	assign address_high = vpixel - 6'd23 + V;

	assign address = {address_high,address_low};

endmodule