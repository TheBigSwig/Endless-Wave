

//The screenSlider module.
module screenSlider(input start, 
						  input [7:0] lowerXBound, upperXBound,
						  input [6:0] lowerYBound, upperYBound,
						  input [2:0] readColour,
						  input clock, reset_n,
						  output reg [7:0] x, output reg [6:0] y, output reg [2:0] writeColour, output reg writeEn,
						  output reg done);
							
	//The iteration counters.
	reg [7:0] xIteration;
	reg [6:0] yIteration;
	
	//A reg counter to account for a read delay of 2 clock cycles from the screenMirror.
	reg [1:0] delayCounter;
	
	//The reg flag for keeping track of read vs. write cycles.
	reg isReadCycle;
	
	//The behaviour for the module.
	always@(posedge clock)
	begin
		if (reset_n == 0)
		begin
			isReadCycle <= 1;
			delayCounter <= 2'b10;
			xIteration <= upperXBound + 1;
			yIteration <= upperYBound + 1;
			x <= 8'b00000000;
			y <= 7'b0000000;
			writeColour <= 3'b000;
			writeEn <= 0;
			done <= 1;
		end
		else
		begin
			if (start == 1)
			begin
				isReadCycle <= 1;
				delayCounter <= 2'b10;
				xIteration <= lowerXBound;
				yIteration <= lowerYBound;
				x <= 8'b00000000;
				y <= 7'b0000000;
				writeColour <= 3'b000;
				writeEn <= 0;
				done <= 0;
			end
			else
			begin
				if ( (xIteration <= upperXBound) && (yIteration <= upperYBound) )
				begin
				
					//The case when it is currently a read cycle.
					if (isReadCycle == 1)
					begin
						if (delayCounter == 2'b00)
						begin
							isReadCycle <= 0;
							delayCounter <= 2'b10;
							x <= xIteration + 1;
							y <= yIteration;
							writeColour <= readColour;
							writeEn <= 0;
							done <= 0;
							xIteration = xIteration;
							yIteration = yIteration;
						end
						else
						begin
							isReadCycle <= 1;
							delayCounter <= delayCounter - 1;
							x <= xIteration + 1;
							y <= yIteration;
							writeColour <= readColour;
							writeEn <= 0;
							done <= 0;
							xIteration = xIteration;
							yIteration = yIteration;
						end
					end
					
					//The case when it is a write cycle.
					else
					begin
						isReadCycle <= 1;
						delayCounter <= 2'b10;
						x <= xIteration;
						y <= yIteration;
						writeColour <= writeColour;
						writeEn <= 1;
						done <= 0;
						xIteration = xIteration + 1;
						yIteration = yIteration;
						if (xIteration > upperXBound)
						begin
							xIteration = lowerXBound;
							yIteration = yIteration + 1;
						end
						else
						begin
							xIteration = xIteration;
							yIteration = yIteration;
						end
					end
				end
				else
				begin
					isReadCycle <= 1;
					delayCounter <= 2'b10;
					done <= 1;
					xIteration <= xIteration;
					yIteration <= yIteration;
					x <= 8'b00000000;
					y <= 7'b0000000;
					writeColour <= 3'b000;
					writeEn <= 0;
				end
			end
		end
	end
endmodule
