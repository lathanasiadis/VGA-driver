from PIL import Image
import sys

input_str = input("file: ")

im = Image.open(input_str)
rgb_im = im.convert('RGB')

px = rgb_im.load();

red_line = ""
blue_line = ""
green_line = ""
red_two_lines = ""
line_count = 0
line_str = ""

#output files
red_file = open("red_file.txt", "w+")
green_file = open("green_file.txt", "w+")
blue_file = open("blue_file.txt", "w+")

for i in range (96):
	for j in range (128):
		red = px[j,i][0]
		green = px[j,i][1]
		blue = px[j,i][2]
		if (red == 255):
			red_line += '1'
		else:
			if (red != 0):
				print("Non binary color detected at pixel [x,y] = ", j, i)
			else:
				red_line += '0'

		if (green == 255):
			green_line += '1'
		else:
			if (green != 0):
				print("Non binary color detected at pixel [x,y] = ", j, i)
			else:
				green_line += '0'

		if (blue == 255):
			blue_line += '1'
		else:
			if (blue != 0):
				print("Non binary color detected at pixel [x,y] = ", j, i)
			else:
				blue_line += '0'
	
	#calculate current init number and save " .INIT_{NO}(256'h " to line_str
	#pad with a zero if necessary, because {NO} must be two --hex-- digits
	#call .upper() because the hex digits a...f must be in uppercase
	#increase line_count every two lines, since one line of memory has the data for two lines of the image
	if (i % 2 == 1):
		line_str = hex(line_count)[2:].upper()
		if (len(line_str) != 2):
			line_str = "0" + line_str
		line_str = ".INIT_" + line_str + "(256\'h"
		line_count += 1

	#reverse the strings (memory is stored in big-endian style)
	red_line = red_line[::-1]
	green_line = green_line[::-1]
	blue_line = blue_line[::-1]
	
	#convert the number from binary representation to hexadecimal 
	red_line = hex(int(red_line,2))
	green_line = hex(int(green_line,2))
	blue_line = hex(int(blue_line,2))
	#remove the "0x" part
	red_line = red_line[2:]
	green_line = green_line[2:]
	blue_line = blue_line[2:]

	#pad with zeroes if necessary
	if (len(red_line) != 32):
		for k in range(32 - len(red_line)):
			red_line = "0" + red_line
	if (len(green_line) != 32):
		for k in range(32 - len(green_line)):
			green_line = "0" + green_line
	if (len(blue_line) != 32):
		for k in range(32 - len(blue_line)):
			blue_line = "0" + blue_line


	if (i % 2 == 0):
		#add current line to second half of address line
		red_addr_line = "_" + red_line
		green_addr_line = "_" + green_line
		blue_addr_line = "_" + blue_line
	else:
		#add current line to first half of adress line
		#also add
		#	two tabs
		#	the .INIT_{LINE_NO}(256'h string
		#	the closing parentheses
		#	a comma
		#	a newline 
		red_addr_line = "\t\t" + line_str + red_line + red_addr_line + "),\n"
		green_addr_line = "\t\t" + line_str + green_line + green_addr_line + "),\n"
		blue_addr_line = "\t\t" + line_str + blue_line + blue_addr_line + "),\n"
		#write the address lines to their respective files
		red_file.write(red_addr_line)
		green_file.write(green_addr_line)
		blue_file.write(blue_addr_line)

		#clear strings
		red_addr_line = ""
		green_addr_line = ""
		blue_addr_line = ""

	#clear strings
	red_line = ""
	green_line = ""
	blue_line = ""


red_file.close()
green_file.close()
blue_file.close()