/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 3rd lab assignment (VGA driver)
Description:	Horizontal timings for the vga driver. Outputs hsync, a signal
				that goes straight to the VGA, and enable, a signal that I use
				to determine whether I should display pixels,
				meaning the FSM is at its DISPLAY state, or not.
*/
module hsync_generator(clk, reset, hpixel, hsync, en);

	input clk, reset;
	output hsync, en;
	output [6:0] hpixel;

	reg hsync, en;
	reg [1:0] state, next_state;
	reg [6:0] hpixel;
	//Assuming a 20ns clock...
	/*
	pixel_counter: count up to 9 to change hpixel value.
	On a 640*480 display, I would only need to count up to 1 (2 steps) to change the value of hpixel,
	since there would be 1280 steps in the DISPLAY time to display 640 pixels.
	In my case of a 640*480 display with a 128*96 VRAM, I have 1280 steps to display 128 pixels, therefore
	need to count up to 9 (10 steps)	
	*/
	reg [3:0] pixel_counter;
	reg [7:0] pulse_counter; //count up to 191 (3.84us elapsed -- pulse width)
	reg [6:0] back_counter; //count up to 95 (1.92us elapsed -- back porch)
	reg [10:0] display_counter; //count up to 1279 (25.6us elapsed -- display time)
	reg [4:0] front_counter; //count up to 31 (0.64 elapsed -- front porch)

	parameter	PULSE_WIDTH = 2'b00,
				BACK_PORCH = 2'b01,
				DISPLAY = 2'b10,
				FRONT_PORCH = 2'b11;

	//change FSM state
	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			state <= PULSE_WIDTH;
		end
		else begin
			state <= next_state;
		end
	end

	//increase counters at their respective states
	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			pulse_counter <= 8'b0;
			back_counter <= 7'b0;
			display_counter <= 11'b0;
			front_counter <= 5'b0;
			pixel_counter <= 4'b0;
		end
		else begin
			case (state)
				PULSE_WIDTH:
				begin
					front_counter <= 5'd0;
					pulse_counter <= pulse_counter + 8'd1;
				end
				BACK_PORCH:
				begin
					pulse_counter <= 8'd0;
					back_counter <= back_counter + 7'd1;
				end
				DISPLAY:
				begin
					back_counter <= 7'd0;
					display_counter <= display_counter + 11'd1;
					if (pixel_counter == 4'd9)
						pixel_counter <= 4'd0;
					else
						pixel_counter <= pixel_counter + 4'd1;
				end
				FRONT_PORCH:
				begin
					display_counter <= 11'd0;
					front_counter <= front_counter + 5'b1; 
				end
			endcase
		end
	end

	//calculate hpixel
	always @(posedge clk) begin
		if (state == DISPLAY) begin
			if (pixel_counter == 4'd9) begin
				hpixel <= hpixel + 1;
			end
			else begin
				hpixel <= hpixel;
			end
		end
		else begin
			hpixel <= 7'b0;
		end
	end

	//FSM: next state and outputs (hsync, enable)
	always @(state or pulse_counter or back_counter or display_counter or front_counter or pixel_counter) begin
		case (state)
			PULSE_WIDTH:
			begin
				hsync = 1'b0;
				en = 0;
				if (pulse_counter == 8'd191)
					next_state = BACK_PORCH;
				else
					next_state = PULSE_WIDTH;
			end
			BACK_PORCH:
			begin
				hsync = 1'b1;
				en = 0;
				if (back_counter == 7'd95)
					next_state = DISPLAY;
				else
					next_state = BACK_PORCH;
			end
			DISPLAY:
			begin
				hsync = 1'b1;
				en = 1;
				if (display_counter == 11'd1279) begin
					next_state = FRONT_PORCH;
				end
				else begin
					next_state = DISPLAY;
				end
			end
			FRONT_PORCH:
			begin
				hsync = 1'b1;
				en = 0;
				if (front_counter == 5'd31)
					next_state = PULSE_WIDTH;
				else
					next_state = FRONT_PORCH;
			end
		endcase
	end
endmodule