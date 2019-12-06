/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 3rd lab assignment (VGA driver)
Description:	VGA driver top level modules
				--debounces and synchronizes reset signal
				--displays a 10FPS animation that consists of 8 42x48 sprites
				--sprites are stored in the vram module, which instantiates block RAMs
*/
module vga_driver(clk, resetbutton, vga_red, vga_green, vga_blue, vga_hsync, vga_vsync);
	
	input clk, resetbutton;
	output vga_red, vga_green, vga_blue, vga_hsync, vga_vsync;

	wire vga_hsync, vga_vsync, hsync_en, vsync_en, reset_sync, reset, source;
	wire vram_red, vram_green, vram_blue, select;
	wire [5:0] frame;
	wire [6:0] hpixel, vpixel;
	wire [13:0] address;

	//handle reset button: synchronize it with 2 flip-flops and de-bounce it
	synchronizer sync_driver_inst(.clk(clk), .original_input(resetbutton), .input_sync(reset_sync));
	debouncer #(.BITS(3)) debouncer_driver_inst(.clk(clk), .btn_input(reset_sync), .state(reset));

	hsync_generator hsync_driver_inst(
		.clk(clk),
		.reset(reset),
		.hpixel(hpixel),
		.hsync(vga_hsync),
		.en(hsync_en)
		);

	vsync_generator vsync_driver_inst(
		.clk(clk),
		.reset(reset),
		.vpixel(vpixel),
		.vsync(vga_vsync),
		.en(vsync_en),
		.frame(frame)
		);

	image_source image_source_inst(
		.hpixel(hpixel),
		.vpixel(vpixel),
		.source(source)
		);

	address_generator address_gen_inst(
		.clk(clk),
		.reset(reset),
		.frame(frame),
		.hpixel(hpixel),
		.vpixel(vpixel),
		.address(address),
		.select(select)
		);

	vram vram_driver_inst(
		.clk(clk),
		.address(address),
		.select(select),
		.red(vram_red),
		.green(vram_green),
		.blue(vram_blue)
		);

	/*
	Display pixels only when hsync_en and vsync_en are high
	which means that DISPLAY and ACTIVE VIDEO overlap

	If source == 0 display white
	else the r,g,b signals are outputted from the vram
	*/
	assign vga_red = (hsync_en && vsync_en) ? ((source) ? vram_red : 1) : 0;
	assign vga_green = (hsync_en && vsync_en) ? ((source) ? vram_green : 1) : 0;
	assign vga_blue = (hsync_en && vsync_en) ? ((source) ? vram_blue : 1) : 0;

endmodule