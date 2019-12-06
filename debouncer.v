/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 1st lab assignment
Usage:			Debounces button inputs by waiting for 2^(BITS) cycles before
				registering the button press -- that is, output state becomes
				high for as long as the button is still pressed, and btn_posedge
				becomes 1 for one cycle.
<----------------------------------------------------------------------------->
For the default parameter value of 13 and a clock period of 320ns,
the button (btn_input) must be high for 2^13 * 320ns = 2.62142ms
*/
module debouncer #(parameter BITS=13)(clk, btn_input, state, btn_posedge);
	input clk, btn_input; //button input must be synchronized
	output state, btn_posedge;

	reg [BITS-1:0] counter;
	reg state;

	always @(posedge clk) begin
		if (btn_input == 1'b0) begin
			//button is not being pressed, so reset the counter and output
			counter <= 13'b0;
			state <= 1'b0;
		end
		else begin
			//button is being pressed
			counter <= counter + 1;
			if (&counter)
				/* All of the counter's bits have reached 1, so the button 
				press must be registered*/
				state <= 1'b1;
		end
    end

    /* btn_posedge becomes high for one circle when the button press is registered.
    This happens when	a)state != btn_input, because it will register in the next
    					cycle
    					b)counter is at its max value
						c)state is not 1, which means that the button press hasn't
						registered yet -- if this is omitted, btn_posedge can
						also become 1 at the button's negative edge */
    assign btn_posedge = (~(state == btn_input)) & (&counter) & (~state);

endmodule