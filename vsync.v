/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 3rd lab assignment (VGA driver)
Description:	Vertical timings for the vga driver. Outputs vsync, a signal
				that goes straight to the VGA, and enable, a signal that I use
				to determine whether I should display pixels,
				meaning the FSM is at its ACTIVE VIDEO state, or not.
*/
module vsync_generator(clk, reset, vpixel, vsync, en, frame);

	input clk, reset;
	output vsync, en;
	output [5:0] frame;
	output [6:0] vpixel;

	reg vsync, en;
	reg [1:0] state, next_state;
	reg [5:0] frame;
	reg [6:0] vpixel;
	
	//Assuming a 20ns clock...
	/*
	pixel_counter: counts up to 7999 (160us elapsed) to change vpixel value
	On a 640*480 display , the 15.36ms of active video time are enough
	to scan each one of the 480 vertical lines one time
	With my 128*96 VRAM, each line must get displayed 5 times to get displayed properly.
	Thus, the pixel counter for generating the vpixel signal must count for 32us(scanlight time)*5 = 160us,
	or 8000 clock (T = 20ns) cycles
	*/
	reg [12:0] pixel_counter;
	reg [11:0] pulse_counter; //count up to 3199 (64us elapsed -- pulse width)
	reg [15:0] back_counter; //count up to 46399 (928us elapsed -- back porch)
	reg [19:0] active_counter; //count up to 767999 (15.36ms elapsed -- active video time)
	reg [13:0] front_counter; //count up to 15999 (320us elapsed -- front porch)

	parameter	PULSE_WIDTH = 2'b00,
				BACK_PORCH = 2'b01,
				DISPLAY = 2'b10,
				FRONT_PORCH = 2'b11;

	//FSM: next state
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
			pulse_counter <= 12'b0;
			back_counter <= 16'b0;
			active_counter <= 20'b0;
			front_counter <= 14'b0;
			pixel_counter <= 13'b0;
		end
		else begin
			case (state)
				PULSE_WIDTH:
				begin
					front_counter <= 14'd0;
					pulse_counter <= pulse_counter + 12'd1;
				end
				BACK_PORCH:
				begin
					pulse_counter <= 12'd0;
					back_counter <= back_counter + 16'd1;
				end
				DISPLAY:
				begin
					back_counter <= 16'd0;
					active_counter <= active_counter + 20'd1;
					if (pixel_counter == 13'd7999)
						pixel_counter <= 13'd0;
					else
						pixel_counter <= pixel_counter + 13'd1;
				end
				FRONT_PORCH:
				begin
					active_counter <= 20'd0;
					front_counter <= front_counter + 14'b1; 
				end
			endcase
		end
	end

	//calculate vpixel and frame
	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			frame <= 6'd0;
			vpixel <= 7'b0;
		end
		else begin
			//frame
			if (state == FRONT_PORCH) begin
				if (front_counter == 14'd15999) begin
					if (frame == 6'd59) begin
						frame <= 0;
					end
					else begin
						frame <= frame + 6'd1;
					end
				end
			end
			//vpixel
			if (state == DISPLAY) begin
				if (pixel_counter == 13'd7999) begin
					vpixel <= vpixel + 1;
				end
				else begin
					vpixel <= vpixel;
				end
			end
			else begin
				vpixel <= 7'b0;
			end
		end
	end

	//FSM: next state and outputs (vsync, enable)
	always @(state or pulse_counter or back_counter or active_counter or front_counter or pixel_counter) begin
		case (state)
			PULSE_WIDTH:
			begin
				vsync = 1'b0;
				en = 0;
				if (pulse_counter == 12'd3199)
					next_state = BACK_PORCH;
				else
					next_state = PULSE_WIDTH;
			end
			BACK_PORCH:
			begin
				vsync = 1'b1;
				en = 0;
				if (back_counter == 16'd46399)
					next_state = DISPLAY;
				else
					next_state = BACK_PORCH;
			end
			DISPLAY:
			begin
				vsync = 1'b1;
				en = 1;
				if (active_counter == 20'd767999) begin
					next_state = FRONT_PORCH;
				end
				else begin
					next_state = DISPLAY;
				end
			end
			FRONT_PORCH:
			begin
				vsync = 1'b1;
				en = 0;
				if (front_counter == 14'd15999)
					next_state = PULSE_WIDTH;
				else
					next_state = FRONT_PORCH;
			end
		endcase
	end
endmodule