

//The hallwayDrawer module.
module hallwayDrawer(input start,
							input [7:0] columnSpecifier,
							input [6:0] upperTracerPos, lowerTracerPos,
							input clock, reset_n,
							output reg [7:0] x, output reg [6:0] y,
							output reg [2:0] colour, output reg writeEn,
							output reg done);
							
	//The yIteration counter, used to iterate through every pixel in a specified column.
	reg [6:0] yIteration;
	
	//The "firstTime" flag, used to specify slightly different behaviour when drawing the first column.
	reg firstTime;
	
	//The behaviour of the module.
	always@(posedge clock)
	begin
		if (reset_n == 0)
		begin
			yIteration <= 7'b1111000;
			firstTime <= 1;
			x <= 8'b00000000;
			y <= 7'b0000000;
			colour <= 3'b000;
			writeEn <= 0;
			done <= 1;
		end
		else
		begin
			if (start == 1)
			begin
				yIteration <= 7'b0000000;
				firstTime <= firstTime;
				x <= 8'b00000000;
				y <= 7'b0000000;
				colour <= 3'b000;
				writeEn <= 0;
				done <= 0;
			end
			else
			begin
				if (yIteration < 7'b1111000)
				begin
					if (firstTime == 1)
					begin
						if ( (yIteration <= upperTracerPos) || (yIteration >= lowerTracerPos) )
						begin
							x = columnSpecifier;
							y = yIteration;
							colour <= 3'b111;
							writeEn <= 1;
							done <= 0;
							yIteration = yIteration + 1;
							firstTime = (yIteration < 7'b1111000) ? firstTime : 0;
						end
						else
						begin
							x = columnSpecifier;
							y = yIteration;
							colour <= 3'b000;
							writeEn <= 1;
							done <= 0;
							yIteration = yIteration + 1;
							firstTime = (yIteration < 7'b1111000) ? firstTime : 0;
						end
					end
					else
					begin
						if ( (yIteration == upperTracerPos) || (yIteration == lowerTracerPos) )
						begin
							x = columnSpecifier;
							y = yIteration;
							colour <= 3'b111;
							writeEn <= 1;
							done <= 0;
							firstTime <= firstTime;
							yIteration = yIteration + 1;
						end
						else
						begin
							x = columnSpecifier;
							y = yIteration;
							colour <= 3'b000;
							writeEn <= 1;
							done <= 0;
							firstTime <= firstTime;
							yIteration = yIteration + 1;
						end
					end
				end
				else
				begin
					done <= 1;
					yIteration <= yIteration;
					x <= 8'b00000000;
					y <= 7'b0000000;
					colour <= 3'b000;
					writeEn <= 0;
					firstTime <= firstTime;
				end
			end
		end
	end
endmodule
