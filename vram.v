/*
Designer:		Lazaros Athanasiadis
Designed in:	Fall Semester 2019-20
Designed for:	Digital Systems Lab, 3rd lab assignment (VGA driver)
Description:	6 16KBx1 block rams are used to display stuff at the screen.
				The two groups (MAIN and AUX) consist of 3 block rams,
				one for each basic color.
				Each group can store 16KB for each color, although 12KB are needed in order
				to completely map the video ram components to an 192x96 display.
				The second group is barely used by my current vga driver; it only stores 2x42x48 bits of
				valuable data (2 42x48 sprites). I could fit them in the MAIN group if I divided them
				correctely, but I wanted to keep the address calculations (in the address_gen module) simple
*/
module vram(clk, address, select, red, green, blue);
	
	input clk,select;
	input [13:0] address;

	output red, green, blue;

	wire red_main, blue_main, green_main, red_aux, blue_aux, green_aux;

	assign red = (select) ? red_aux : red_main;
	assign green = (select) ? green_aux : green_main;
	assign blue = (select) ? blue_aux : blue_main;

	RAMB16_S1 #(
		.INIT(1'b0),  // Value of output RAM registers at startup
		.SRVAL(1'b0), // Output value upon SSR assertion
		.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

		// The forllowing INIT_xx declarations specify the initial contents of the RAM
		// Address 0 to 4095
		.INIT_00(256'hfffff07fffffffffffffffffffffffff_fffff8ffffffffffffffffffffffffff),
		.INIT_01(256'hfffff77fffffffffffffffffffffffff_fffff07fffffffffffffffffffffffff),
		.INIT_02(256'hffffef1ffffffffe3fffffffffffffff_ffffef7fffffffffffffffffffffffff),
		.INIT_03(256'hffff8f9ffffffffc1fffffffffffffff_ffffef1ffffffffe1fffffffffffffff),
		.INIT_04(256'he0ff9fdffc1ffff1dfffffffff07ffff_ffff9f9ffffffffddfffffffff8fffff),
		.INIT_05(256'hdc7f3cf7f8efffe7dfffffffff77ffff_dc7f830ff8effff1dfffffffff07ffff),
		.INIT_06(256'hdc7f2497f8efff8fdffffffffdf7ffff_df7f2497fbefff8fdffffffffc77ffff),
		.INIT_07(256'he07f410ff81fff1e03fffffff3f7ffff_dc7f3cf7f8efff9fdffffffff9f7ffff),
		.INIT_08(256'hfe070fefe3ffff7d81ffffffe7f7ffff_fe3f1fefe3ffff7dedfffffff7f7ffff),
		.INIT_09(256'hfff16fe83fffff7dedffffffdf7b7fff_ff87100f0fffff7d81ffffffc780ffff),
		.INIT_0A(256'hfff87781ffffff6fefffffffdf607fff_fff87781ffffff6e03ffffffdf607fff),
		.INIT_0B(256'hffff7fefffffff6e0fffffffdb80ffff_ffff786fffffff61efffffffdf7b7fff),
		.INIT_0C(256'hffff7fefffffff77dfffffffd87bffff_ffff7fefffffff6f8fffffffdbfbffff),
		.INIT_0D(256'hffff9fefffffff7f0fffffffddf7ffff_ffff1fefffffff78dfffffffdb83ffff),
		.INIT_0E(256'hffff9feffffdc77fefc77fffdf37ffff_ffff9feffffe0f7f0fe0ffffdef7ffff),
		.INIT_0F(256'hffffcfeffffdf79fe3df7ff047fbe0ff_ffff8feffffdc71fefc77fffdfc3ffff),
		.INIT_10(256'hffffc7effffdc78ff3c77fee37f8c77f_ffffcfeffffdc79fe3c77fee07fbc77f),
		.INIT_11(256'hfffff00ffffff863f03fffee3bfcc77f_fffff10ffffe010ff100ffefb3fcdf7f),
		.INIT_12(256'hffffe79ffffffff1fdfffff039fc40ff_fffff01ffffff863f03fffee3bfcc77f),
		.INIT_13(256'hffffc78ffffffff0307fffffdb7f5fff_ffffc78ffffffff830ffffff987f5fff),
		.INIT_14(256'hffffdfeffffffff3ff3ffffff00007ff_ffffdfeffffffff1003fffffc31c0fff),
		.INIT_15(256'hffff07e0ffffff07fe0fffffc3ffc3ff_ffff87e1ffffff0fff0fffffc3ffc3ff),
		.INIT_16(256'hfffbfbdfdffffefef7f7ffffbfbdfdff_fff8fbdf1ffffef8f1f7ffffbc3c3dff),
		.INIT_17(256'hfff80ff01fffff01f80fffffc03c03ff_fffbf3cfdffffefef7f7ffffbfbdfdff),
		.INIT_18(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_19(256'hfffffffffffffffffffffffffff1ffff_ffffffffffffffffffffffffffffffff),
		.INIT_1A(256'hffffff3fffffffffffffffffffe0ffff_ffffffffffffffffffffffffffe0ffff),
		.INIT_1B(256'hfffffe0fffffffffffffffffffee7fff_ffffff1fffffffffffffffffffeeffff),
		.INIT_1C(256'hfffffee7ffffffff83ffffffffbf3fff_fffffeefffffffffc7ffffffff8f7fff),
		.INIT_1D(256'hfffffef1ffffffffbbffffffffbfdfff_fffffee7ffffffff83ffffffffbf1fff),
		.INIT_1E(256'hfffffefeffffffffbdffffffff085fff_fffffefcffffffffb9ffffffff7fdfff),
		.INIT_1F(256'hfffff01e7fffffffbf3ffffffe94afff_fffffefeffffffffbc7ffffffef7afff),
		.INIT_20(256'hffffe0df7fffffffbfbfffee3ef7af8e_ffffebdf7fffffffbfbffff07e94afc1),
		.INIT_21(256'hffffebdf7ffffffaf7dfffefbf7f8fbe_ffffe0df7ffffffc079fffee3f086f8e),
		.INIT_22(256'hfffff03d7ffffff837dfffee3f00cf8e_fffff01d7ffffff837dfffee3f004f8e),
		.INIT_23(256'hfffff81d7ffffffc075fffff8f3eef3f_fffffbe17ffffffaf7dffff03f7f2f81),
		.INIT_24(256'hfffffef77ffffffef85fffffc761ee3f_fffffefb7ffffffe7e5fffff875eee3f),
		.INIT_25(256'hfffff87f7fffffffbcdfffffff7fcfff_fffffe8f7ffffffe075ffffff07fe0ff),
		.INIT_26(256'hffb8fbff71dfffffa3dfffffff7fdfff_ffc1f9ff783fffffbddfffffff7fcfff),
		.INIT_27(256'hffbef3fef7dff83eff983fffff7f1fff_ffb8fbfe71dffffe1fdfffffff7fdfff),
		.INIT_28(256'hffb8f7f8f1dff71cffb1dfffff7f7fff_ffb8f3fef1dff71eff91dfffff7f1fff),
		.INIT_29(256'hffff47f92ffff71dff71dfffff7effff_ffc067f8603ff7ddff37dfffff7e7fff),
		.INIT_2A(256'hffffefe7fffff819fc703fffff00ffff_ffff07f10ffff71dfe71dfffff08ffff),
		.INIT_2B(256'hffff876fffffffdbfa5fffffff7effff_ffff870fffffffdbf847ffffff7effff),
		.INIT_2C(256'hffff7ff7ffffffc0003ffffffeff7fff_ffff0067ffffffc1c21ffffffe7e7fff),
		.INIT_2D(256'hfffe1ff87fffff87fe1fffffe1ff87ff_fffe1ff87fffff87fe1fffffe1ff87ff),
		.INIT_2E(256'hfffbfbdfdffffefef7f7ffffbfbdfdff_fffde3c7bfffff70f0efffff9e3c79ff),
		.INIT_2F(256'hfffc07e03fffff00f00fffff807e01ff_fffbfbdfdffffefef7f7ffffbfbdfdff),
		// Address 12288 to 16383
		.INIT_30(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_31(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_32(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_33(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_34(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_35(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_36(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_37(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_38(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_39(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
		) RED_RAM (
			.DO(red_main),		// 1-bit Data Output
			.ADDR(address),	// 14-bit Address Input
			.CLK(clk),		// Clock
			.DI(DI),		// 1-bit Data Input
			.EN(1'b1),		// RAM Enable Input
			.SSR(1'b0),		// Synchronous Set/Reset Input
			.WE(1'b0)		// Write Enable Input
			);

	RAMB16_S1 #(
		.INIT(1'b0),  // Value of output RAM registers at startup
		.SRVAL(1'b0), // Output value upon SSR assertion
		.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

		// The forllowing INIT_xx declarations specify the initial contents of the RAM
		// Address 0 to 4095
		.INIT_00(256'hfffff07fffffffffffffffffffffffff_fffff8ffffffffffffffffffffffffff),
		.INIT_01(256'hfffff77fffffffffffffffffffffffff_fffff07fffffffffffffffffffffffff),
		.INIT_02(256'hffffef1ffffffffe3fffffffffffffff_ffffef7fffffffffffffffffffffffff),
		.INIT_03(256'hffff8f9ffffffffc1fffffffffffffff_ffffef1ffffffffe1fffffffffffffff),
		.INIT_04(256'he0ff9fdffc1ffff1dfffffffff07ffff_ffff9f9ffffffffddfffffffff8fffff),
		.INIT_05(256'hdc7f3cf7f8efffe7dfffffffff77ffff_dc7f830ff8effff1dfffffffff07ffff),
		.INIT_06(256'hdc7f2497f8efff8fdffffffffdf7ffff_df7f2497fbefff8fdffffffffc77ffff),
		.INIT_07(256'he07f410ff81fff1e03fffffff3f7ffff_dc7f3cf7f8efff9fdffffffff9f7ffff),
		.INIT_08(256'hfe070fefe3ffff7d81ffffffe7f7ffff_fe3f1fefe3ffff7dedfffffff7f7ffff),
		.INIT_09(256'hfff160083fffff7dedffffffdf7b7fff_ff87000f0fffff7d81ffffffc780ffff),
		.INIT_0A(256'hfff87001ffffff6fefffffffdf607fff_fff87001ffffff6e03ffffffdf607fff),
		.INIT_0B(256'hffff7fefffffff600fffffffdb80ffff_ffff786fffffff61efffffffdf7b7fff),
		.INIT_0C(256'hffff7fefffffff701fffffffd87bffff_ffff7fefffffff600fffffffdbfbffff),
		.INIT_0D(256'hffff9fefffffff7f0fffffffdc07ffff_ffff1fefffffff781fffffffd803ffff),
		.INIT_0E(256'hffff9feffffdc77fefc77fffdf07ffff_ffff9feffffe0f7f0fe0ffffde07ffff),
		.INIT_0F(256'hffffcfeffffdf79fe3df7ff047fbe0ff_ffff8feffffdc71fefc77fffdfc3ffff),
		.INIT_10(256'hffffc7effffdc78ff3c77fee37f8c77f_ffffcfeffffdc79fe3c77fee07fbc77f),
		.INIT_11(256'hfffff00ffffff863f03fffee3bfcc77f_fffff10ffffe010ff100ffefb3fcdf7f),
		.INIT_12(256'hffffe79ffffffff1fdfffff039fc40ff_fffff01ffffff863f03fffee3bfcc77f),
		.INIT_13(256'hffffc78ffffffff0307fffffdb7f5fff_ffffc78ffffffff830ffffff987f5fff),
		.INIT_14(256'hffffdfeffffffff3ff3ffffff00007ff_ffffdfeffffffff1003fffffc31c0fff),
		.INIT_15(256'hffff07e0ffffff07fe0fffffc3ffc3ff_ffff87e1ffffff0fff0fffffc3ffc3ff),
		.INIT_16(256'hfffbfbdfdffffefef7f7ffffbfbdfdff_fff8fbdf1ffffef8f1f7ffffbc3c3dff),
		.INIT_17(256'hfff80ff01fffff01f80fffffc03c03ff_fffbf3cfdffffefef7f7ffffbfbdfdff),
		.INIT_18(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_19(256'hfffffffffffffffffffffffffff1ffff_ffffffffffffffffffffffffffffffff),
		.INIT_1A(256'hffffff3fffffffffffffffffffe0ffff_ffffffffffffffffffffffffffe0ffff),
		.INIT_1B(256'hfffffe0fffffffffffffffffffee7fff_ffffff1fffffffffffffffffffeeffff),
		.INIT_1C(256'hfffffee7ffffffff83ffffffffbf3fff_fffffeefffffffffc7ffffffff8f7fff),
		.INIT_1D(256'hfffffef1ffffffffbbffffffffbfdfff_fffffee7ffffffff83ffffffffbf1fff),
		.INIT_1E(256'hfffffefeffffffffbdffffffff085fff_fffffefcffffffffb9ffffffff7fdfff),
		.INIT_1F(256'hfffff01e7fffffffbf3ffffffe94afff_fffffefeffffffffbc7ffffffef7afff),
		.INIT_20(256'hffffe0df7fffffffbfbfffee3ef7af8e_ffffebdf7fffffffbfbffff07e94afc1),
		.INIT_21(256'hffffebdf7ffffffaf7dfffefbf7f8fbe_ffffe0df7ffffffc079fffee3f086f8e),
		.INIT_22(256'hfffff03d7ffffff837dfffee3f000f8e_fffff01d7ffffff837dfffee3f000f8e),
		.INIT_23(256'hfffff8017ffffffc075fffff8f00ef3f_fffffbe17ffffffaf7dffff03f002f81),
		.INIT_24(256'hfffffe077ffffffef85fffffc761ee3f_fffffe037ffffffe7e5fffff8740ee3f),
		.INIT_25(256'hfffff87f7fffffff80dfffffff7fcfff_fffffe0f7ffffffe005ffffff07fe0ff),
		.INIT_26(256'hffb8fbff71dfffff83dfffffff7fdfff_ffc1f9ff783fffff81dfffffff7fcfff),
		.INIT_27(256'hffbef3fef7dff83eff983fffff7f1fff_ffb8fbfe71dffffe1fdfffffff7fdfff),
		.INIT_28(256'hffb8f7f8f1dff71cffb1dfffff7f7fff_ffb8f3fef1dff71eff91dfffff7f1fff),
		.INIT_29(256'hffff47f92ffff71dff71dfffff7effff_ffc067f8603ff7ddff37dfffff7e7fff),
		.INIT_2A(256'hffffefe7fffff819fc703fffff00ffff_ffff07f10ffff71dfe71dfffff08ffff),
		.INIT_2B(256'hffff876fffffffdbfa5fffffff7effff_ffff870fffffffdbf847ffffff7effff),
		.INIT_2C(256'hffff7ff7ffffffc0003ffffffeff7fff_ffff0067ffffffc1c21ffffffe7e7fff),
		.INIT_2D(256'hfffe1ff87fffff87fe1fffffe1ff87ff_fffe1ff87fffff87fe1fffffe1ff87ff),
		.INIT_2E(256'hfffbfbdfdffffefef7f7ffffbfbdfdff_fffde3c7bfffff70f0efffff9e3c79ff),
		.INIT_2F(256'hfffc07e03fffff00f00fffff807e01ff_fffbfbdfdffffefef7f7ffffbfbdfdff),
		// Address 12288 to 16383
		.INIT_30(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_31(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_32(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_33(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_34(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_35(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_36(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_37(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_38(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_39(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
	) GREEN_RAM (
		.DO(green_main),// 1-bit Data Output
		.ADDR(address),	// 14-bit Address Input
		.CLK(clk),		// Clock
		.DI(DI),		// 1-bit Data Input
		.EN(1'b1),		// RAM Enable Input
		.SSR(1'b0),		// Synchronous Set/Reset Input
		.WE(1'b0)		// Write Enable Input
	);

	RAMB16_S1 #(
		.INIT(1'b0),  // Value of output RAM registers at startup
		.SRVAL(1'b0), // Output value upon SSR assertion
		.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

		// The forllowing INIT_xx declarations specify the initial contents of the RAM
		// Address 0 to 4095
		.INIT_00(256'hfffff07fffffffffffffffffffffffff_fffff8ffffffffffffffffffffffffff),
		.INIT_01(256'hfffff07fffffffffffffffffffffffff_fffff07fffffffffffffffffffffffff),
		.INIT_02(256'hffffe01ffffffffe3fffffffffffffff_ffffe07fffffffffffffffffffffffff),
		.INIT_03(256'hffff801ffffffffc1fffffffffffffff_ffffe01ffffffffe1fffffffffffffff),
		.INIT_04(256'he0ff801ffc1ffff01fffffffff07ffff_ffff801ffffffffc1fffffffff8fffff),
		.INIT_05(256'hdc7f3cf7f8efffe01fffffffff07ffff_dc7f800ff8effff01fffffffff07ffff),
		.INIT_06(256'hdc7f2497f8efff801ffffffffc07ffff_df7f2497fbefff801ffffffffc07ffff),
		.INIT_07(256'he07f000ff81fff0003fffffff007ffff_dc7f3cf7f8efff801ffffffff807ffff),
		.INIT_08(256'hfe07000fe3ffff0181ffffffe007ffff_fe3f000fe3ffff01edfffffff007ffff),
		.INIT_09(256'hfff100083fffff01edffffffc07b7fff_ff87000f0fffff0181ffffffc000ffff),
		.INIT_0A(256'hfff80001ffffff000fffffffc0607fff_fff80001ffffff0003ffffffc0607fff),
		.INIT_0B(256'hffff000fffffff000fffffffc000ffff_ffff000fffffff000fffffffc07b7fff),
		.INIT_0C(256'hffff000fffffff001fffffffc003ffff_ffff000fffffff000fffffffc003ffff),
		.INIT_0D(256'hffff800fffffff000fffffffc007ffff_ffff000fffffff001fffffffc003ffff),
		.INIT_0E(256'hffff800ffffdc7000fc77fffc007ffff_ffff800ffffe0f000fe0ffffc007ffff),
		.INIT_0F(256'hffffc00ffffdf78003df7ff04003e0ff_ffff800ffffdc7000fc77fffc003ffff),
		.INIT_10(256'hffffc00ffffdc78003c77fee3000c77f_ffffc00ffffdc78003c77fee0003c77f),
		.INIT_11(256'hfffff00ffffff860003fffee3800c77f_fffff00ffffe01000100ffefb000df7f),
		.INIT_12(256'hffffe79ffffffff001fffff0380040ff_fffff01ffffff860003fffee3800c77f),
		.INIT_13(256'hffffc78ffffffff0007fffffdb005fff_ffffc78ffffffff800ffffff98005fff),
		.INIT_14(256'hffffdfeffffffff3ff3ffffff00007ff_ffffdfeffffffff1003fffffc3000fff),
		.INIT_15(256'hffff07e0ffffff07fe0fffffc3ffc3ff_ffff87e1ffffff0fff0fffffc3ffc3ff),
		.INIT_16(256'hfffbfbdfdffffefef7f7ffffbfbdfdff_fff8fbdf1ffffef8f1f7ffffbc3c3dff),
		.INIT_17(256'hfff80ff01fffff01f80fffffc03c03ff_fffbf3cfdffffefef7f7ffffbfbdfdff),
		.INIT_18(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_19(256'hfffffffffffffffffffffffffff1ffff_ffffffffffffffffffffffffffffffff),
		.INIT_1A(256'hffffff3fffffffffffffffffffe0ffff_ffffffffffffffffffffffffffe0ffff),
		.INIT_1B(256'hfffffe0fffffffffffffffffffe07fff_ffffff1fffffffffffffffffffe0ffff),
		.INIT_1C(256'hfffffe07ffffffff83ffffffff803fff_fffffe0fffffffffc7ffffffff807fff),
		.INIT_1D(256'hfffffe01ffffffff83ffffffff801fff_fffffe07ffffffff83ffffffff801fff),
		.INIT_1E(256'hfffffe00ffffffff81ffffffff001fff_fffffe00ffffffff81ffffffff001fff),
		.INIT_1F(256'hfffff0007fffffff803ffffffe948fff_fffffe00ffffffff807ffffffef78fff),
		.INIT_20(256'hffffe0c07fffffff803fffee3ef78f8e_ffffebc07fffffff803ffff07e948fc1),
		.INIT_21(256'hffffebc07ffffffaf01fffefbf000fbe_ffffe0c07ffffffc001fffee3f000f8e),
		.INIT_22(256'hfffff0007ffffff8301fffee3f000f8e_fffff0007ffffff8301fffee3f000f8e),
		.INIT_23(256'hfffff8007ffffffc001fffff8f000f3f_fffff8007ffffffaf01ffff03f000f81),
		.INIT_24(256'hfffffe007ffffffe001fffffc7000e3f_fffffe007ffffffe001fffff87000e3f),
		.INIT_25(256'hfffff8007fffffff801fffffff000fff_fffffe007ffffffe001ffffff00000ff),
		.INIT_26(256'hffb8f80071dfffff801fffffff001fff_ffc1f800783fffff801fffffff000fff),
		.INIT_27(256'hffbef000f7dff83e00183fffff001fff_ffb8f80071dffffe001fffffff001fff),
		.INIT_28(256'hffb8f000f1dff71c0031dfffff007fff_ffb8f000f1dff71e0011dfffff001fff),
		.INIT_29(256'hffff40012ffff71c0071dfffff00ffff_ffc06000603ff7dc0037dfffff007fff),
		.INIT_2A(256'hffffe007fffff81800703fffff00ffff_ffff00010ffff71c0071dfffff00ffff),
		.INIT_2B(256'hffff806fffffffd8025fffffff7effff_ffff800fffffffd80047ffffff7effff),
		.INIT_2C(256'hffff7ff7ffffffc0003ffffffeff7fff_ffff0067ffffffc0021ffffffe7e7fff),
		.INIT_2D(256'hfffe1ff87fffff87fe1fffffe1ff87ff_fffe1ff87fffff87fe1fffffe1ff87ff),
		.INIT_2E(256'hfffbfbdfdffffefef7f7ffffbfbdfdff_fffde3c7bfffff70f0efffff9e3c79ff),
		.INIT_2F(256'hfffc07e03fffff00f00fffff807e01ff_fffbfbdfdffffefef7f7ffffbfbdfdff),
		// Address 12288 to 16383
		.INIT_30(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_31(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_32(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_33(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_34(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_35(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_36(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_37(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_38(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_39(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
	) BLUE_RAM (
		.DO(blue_main), // 1-bit Data Output
		.ADDR(address),	// 14-bit Address Input
		.CLK(clk),		// Clock
		.DI(DI),		// 1-bit Data Input
		.EN(1'b1),		// RAM Enable Input
		.SSR(1'b0),		// Synchronous Set/Reset Input
		.WE(1'b0)		// Write Enable Input
	); 

	RAMB16_S1 #(
		.INIT(1'b0),  // Value of output RAM registers at startup
		.SRVAL(1'b0), // Output value upon SSR assertion
		.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

		// The forllowing INIT_xx declarations specify the initial contents of the RAM
		// Address 0 to 4095
		.INIT_00(256'hffffffffffffffffffffffffff07ffff_ffffffffffffffffffffffffff8fffff),
		.INIT_01(256'hfffffffffffffffc7fffffffff73ffff_fffffffffffffffc7fffffffff03ffff),
		.INIT_02(256'hfffffffffffffff3bffffffffe7dffff_fffffffffffffff3bfffffffff79ffff),
		.INIT_03(256'hffffffffffffffe3bffffffffefcffff_fffffffffffffff3bffffffffe7dffff),
		.INIT_04(256'hffffffffffffffcfdffffe0ffcfeffc1_ffffffffffffffef9ffffffffefeffff),
		.INIT_05(256'hffffffffffffffdfdffffdc7f79e3f8e_ffffffffffffffcfdffffdc7f860ff8e),
		.INIT_06(256'hffffffffffffff9e7bfffdc7f492bf8e_ffffffffffffffc107fffdf7f492bfbe),
		.INIT_07(256'hffffffffffffff924bfffe07f861bf81_ffffffffffffff924bfffdc7f79ebf8e),
		.INIT_08(256'hfffffffffff71f8183c77ff9fdfebe7f_fffffffffff83f9e7be0fff3fdfebe3f),
		.INIT_09(256'hfffffffffff7df9ff7df7fff0dfda3ff_fffffffffff71fbff7c77ff87c00b8ff),
		.INIT_0A(256'hfffffffffff71f9807c77fffe0f78fff_fffffffffff71f87f7c77fffe0fb8fff),
		.INIT_0B(256'hffffffffffffc7b3c79ffffffdffbfff_fffffffffff81fafe7c0fffffd0fbfff),
		.INIT_0C(256'hffffffffffffe3bc373ffffffdff3fff_ffffffffffffe3bbd7bffffffdffbfff),
		.INIT_0D(256'hffffffffffffff9ff7fffffffdfeffff_fffffffffffff03ff07ffffffdfe3fff),
		.INIT_0E(256'hffffffffffffffdff7fffffffdfeffff_ffffffffffffffdff7fffffffdfeffff),
		.INIT_0F(256'hffffffffffffffcff7fffffffdfdffff_ffffffffffffffdff7fffffffdfcffff),
		.INIT_10(256'hffffffffffffffeff7fffffffdf1ffff_ffffffffffffffcff7fffffffdfdffff),
		.INIT_11(256'hfffffffffffffffbf7fffffffc23ffff_ffffffffffffffe3f7fffffffc63ffff),
		.INIT_12(256'hfffffffffffffff807fffffffefbffff_fffffffffffffff987fffffffe03ffff),
		.INIT_13(256'hfffffffffffffffbe7fffffffcf9ffff_fffffffffffffffbe7fffffffcfbffff),
		.INIT_14(256'hffffffffffffffe7fbfffffffdff7fff_ffffffffffffffe3e3fffffffdf87fff),
		.INIT_15(256'hffffffffffffffc1f83ffffff07e0fff_ffffffffffffffc1f83ffffff07e0fff),
		.INIT_16(256'hfffffffffffffefef7f7ffffbf3cfdff_fffffffffffffe3cf3c7ffff8fbdf1ff),
		.INIT_17(256'hfffffffffffffe01f807ffff80ff01ff_fffffffffffffefef7f7ffffbf3cfdff),
		.INIT_18(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_19(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1A(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1B(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1C(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1D(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1E(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1F(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_20(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_21(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_22(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_23(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_24(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_25(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_26(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_27(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_28(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_29(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2A(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2B(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2C(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2D(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2E(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2F(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		// Address 12288 to 16383
		.INIT_30(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_31(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_32(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_33(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_34(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_35(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_36(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_37(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_38(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_39(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
		) RED_RAM_AUX (
			.DO(red_aux),	// 1-bit Data Output
			.ADDR(address),	// 14-bit Address Input
			.CLK(clk),		// Clock
			.DI(DI),		// 1-bit Data Input
			.EN(1'b1),		// RAM Enable Input
			.SSR(1'b0),		// Synchronous Set/Reset Input
			.WE(1'b0)		// Write Enable Input
			);

	RAMB16_S1 #(
		.INIT(1'b0),  // Value of output RAM registers at startup
		.SRVAL(1'b0), // Output value upon SSR assertion
		.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

		// The forllowing INIT_xx declarations specify the initial contents of the RAM
		// Address 0 to 4095
		.INIT_00(256'hffffffffffffffffffffffffff07ffff_ffffffffffffffffffffffffff8fffff),
		.INIT_01(256'hfffffffffffffffc7fffffffff73ffff_fffffffffffffffc7fffffffff03ffff),
		.INIT_02(256'hfffffffffffffff3bffffffffe7dffff_fffffffffffffff3bfffffffff79ffff),
		.INIT_03(256'hffffffffffffffe3bffffffffefcffff_fffffffffffffff3bffffffffe7dffff),
		.INIT_04(256'hffffffffffffffcfdffffe0ffcfeffc1_ffffffffffffffef9ffffffffefeffff),
		.INIT_05(256'hffffffffffffffdfdffffdc7f79e3f8e_ffffffffffffffcfdffffdc7f860ff8e),
		.INIT_06(256'hffffffffffffff9e7bfffdc7f492bf8e_ffffffffffffffc107fffdf7f492bfbe),
		.INIT_07(256'hffffffffffffff924bfffe07f861bf81_ffffffffffffff924bfffdc7f79ebf8e),
		.INIT_08(256'hfffffffffff71f8183c77ff9fdfebe7f_fffffffffff83f9e7be0fff3fdfebe3f),
		.INIT_09(256'hfffffffffff7df9ff7df7fff0c01a3ff_fffffffffff71fbff7c77ff87c00b8ff),
		.INIT_0A(256'hfffffffffff71f8007c77fffe0078fff_fffffffffff71f87f7c77fffe0038fff),
		.INIT_0B(256'hffffffffffffc7b0079ffffffdffbfff_fffffffffff81fa007c0fffffd0fbfff),
		.INIT_0C(256'hffffffffffffe3bc373ffffffdff3fff_ffffffffffffe3b817bffffffdffbfff),
		.INIT_0D(256'hffffffffffffff9ff7fffffffdfeffff_fffffffffffff03ff07ffffffdfe3fff),
		.INIT_0E(256'hffffffffffffffdff7fffffffdfeffff_ffffffffffffffdff7fffffffdfeffff),
		.INIT_0F(256'hffffffffffffffcff7fffffffdfdffff_ffffffffffffffdff7fffffffdfcffff),
		.INIT_10(256'hffffffffffffffeff7fffffffdf1ffff_ffffffffffffffcff7fffffffdfdffff),
		.INIT_11(256'hfffffffffffffffbf7fffffffc23ffff_ffffffffffffffe3f7fffffffc63ffff),
		.INIT_12(256'hfffffffffffffff807fffffffefbffff_fffffffffffffff987fffffffe03ffff),
		.INIT_13(256'hfffffffffffffffbe7fffffffcf9ffff_fffffffffffffffbe7fffffffcfbffff),
		.INIT_14(256'hffffffffffffffe7fbfffffffdff7fff_ffffffffffffffe3e3fffffffdf87fff),
		.INIT_15(256'hffffffffffffffc1f83ffffff07e0fff_ffffffffffffffc1f83ffffff07e0fff),
		.INIT_16(256'hfffffffffffffefef7f7ffffbf3cfdff_fffffffffffffe3cf3c7ffff8fbdf1ff),
		.INIT_17(256'hfffffffffffffe01f807ffff80ff01ff_fffffffffffffefef7f7ffffbf3cfdff),
		.INIT_18(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_19(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1A(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1B(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1C(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1D(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1E(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1F(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_20(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_21(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_22(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_23(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_24(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_25(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_26(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_27(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_28(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_29(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2A(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2B(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2C(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2D(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2E(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2F(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		// Address 12288 to 16383
		.INIT_30(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_31(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_32(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_33(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_34(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_35(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_36(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_37(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_38(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_39(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
	) GREEN_RAM_AUX (
		.DO(green_aux),// 1-bit Data Output
		.ADDR(address),	// 14-bit Address Input
		.CLK(clk),		// Clock
		.DI(DI),		// 1-bit Data Input
		.EN(1'b1),		// RAM Enable Input
		.SSR(1'b0),		// Synchronous Set/Reset Input
		.WE(1'b0)		// Write Enable Input
	);

	RAMB16_S1 #(
		.INIT(1'b0),  // Value of output RAM registers at startup
		.SRVAL(1'b0), // Output value upon SSR assertion
		.WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

		// The forllowing INIT_xx declarations specify the initial contents of the RAM
		// Address 0 to 4095
		.INIT_00(256'hffffffffffffffffffffffffff07ffff_ffffffffffffffffffffffffff8fffff),
		.INIT_01(256'hfffffffffffffffc7fffffffff03ffff_fffffffffffffffc7fffffffff03ffff),
		.INIT_02(256'hfffffffffffffff03ffffffffe01ffff_fffffffffffffff03fffffffff01ffff),
		.INIT_03(256'hffffffffffffffe03ffffffffe00ffff_fffffffffffffff03ffffffffe01ffff),
		.INIT_04(256'hffffffffffffffc01ffffe0ffc00ffc1_ffffffffffffffe01ffffffffe00ffff),
		.INIT_05(256'hffffffffffffffc01ffffdc7f79e3f8e_ffffffffffffffc01ffffdc7f800ff8e),
		.INIT_06(256'hffffffffffffff9e7bfffdc7f4923f8e_ffffffffffffffc007fffdf7f4923fbe),
		.INIT_07(256'hffffffffffffff924bfffe07f8003f81_ffffffffffffff924bfffdc7f79e3f8e),
		.INIT_08(256'hfffffffffff71f8003c77ff9fc003e7f_fffffffffff83f9e7be0fff3fc003e3f),
		.INIT_09(256'hfffffffffff7df8007df7fff0c0023ff_fffffffffff71f8007c77ff87c0038ff),
		.INIT_0A(256'hfffffffffff71f8007c77fffe0000fff_fffffffffff71f8007c77fffe0000fff),
		.INIT_0B(256'hffffffffffffc780079ffffffc003fff_fffffffffff81f8007c0fffffc003fff),
		.INIT_0C(256'hffffffffffffe380073ffffffc003fff_ffffffffffffe38007bffffffc003fff),
		.INIT_0D(256'hffffffffffffff8007fffffffc00ffff_fffffffffffff000007ffffffc003fff),
		.INIT_0E(256'hffffffffffffffc007fffffffc00ffff_ffffffffffffffc007fffffffc00ffff),
		.INIT_0F(256'hffffffffffffffc007fffffffc01ffff_ffffffffffffffc007fffffffc00ffff),
		.INIT_10(256'hffffffffffffffe007fffffffc01ffff_ffffffffffffffc007fffffffc01ffff),
		.INIT_11(256'hfffffffffffffff807fffffffc03ffff_ffffffffffffffe007fffffffc03ffff),
		.INIT_12(256'hfffffffffffffff807fffffffefbffff_fffffffffffffff807fffffffe03ffff),
		.INIT_13(256'hfffffffffffffffbe7fffffffcf9ffff_fffffffffffffffbe7fffffffcfbffff),
		.INIT_14(256'hffffffffffffffe7fbfffffffdff7fff_ffffffffffffffe3e3fffffffdf87fff),
		.INIT_15(256'hffffffffffffffc1f83ffffff07e0fff_ffffffffffffffc1f83ffffff07e0fff),
		.INIT_16(256'hfffffffffffffefef7f7ffffbf3cfdff_fffffffffffffe3cf3c7ffff8fbdf1ff),
		.INIT_17(256'hfffffffffffffe01f807ffff80ff01ff_fffffffffffffefef7f7ffffbf3cfdff),
		.INIT_18(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_19(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1A(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1B(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1C(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1D(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1E(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_1F(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_20(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_21(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_22(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_23(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_24(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_25(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_26(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_27(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_28(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_29(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2A(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2B(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2C(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2D(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2E(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		.INIT_2F(256'hffffffffffffffffffffffffffffffff_ffffffffffffffffffffffffffffffff),
		// Address 12288 to 16383
		.INIT_30(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_31(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_32(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_33(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_34(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_35(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_36(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_37(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_38(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_39(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3A(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3B(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3C(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3D(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3E(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),
		.INIT_3F(256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
	) BLUE_RAM_AUX (
		.DO(blue_aux), // 1-bit Data Output
		.ADDR(address),	// 14-bit Address Input
		.CLK(clk),		// Clock
		.DI(DI),		// 1-bit Data Input
		.EN(1'b1),		// RAM Enable Input
		.SSR(1'b0),		// Synchronous Set/Reset Input
		.WE(1'b0)		// Write Enable Input
	); 

endmodule