

//The gameOverScreenDrawer module.
module gameOverScreenDrawer(input start, 
							input [7:0] lowerXBound, upperXBound,
							input [6:0] lowerYBound, upperYBound,
							input clock, reset_n,
							output reg [7:0] x, output reg [6:0] y, output reg [2:0] colour, output reg writeEn,
							output reg done);
							
							
	//The 3 wide, 19200 deep reg arry used to store the gameOverScreen is declared and initialized
	//from a .mif file.
	
	/*
	reg [2:0] gameOverScreenMem [19199:0];
	initial begin
		$readmemh("gameOverScreen.mem", gameOverScreenMem);
	end
	*/
							
	
	//The iteration counters.
	reg [7:0] xIteration;
	reg [6:0] yIteration;
	
	//The behaviour for the module.
	always@(posedge clock)
	begin
		if (reset_n == 0)
		begin
			xIteration <= upperXBound + 1;
			yIteration <= upperYBound + 1;
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
				xIteration <= lowerXBound;
				yIteration <= lowerYBound;
				x <= 8'b00000000;
				y <= 7'b0000000;
				colour <= 3'b000;
				writeEn <= 0;
				done <= 0;
			end
			else
			begin
				if ( (xIteration <= upperXBound) && (yIteration <= upperYBound) )
				begin
					x = xIteration;
					y = yIteration;
					//colour <= gameOverScreenMem[(yIteration * 160) + xIteration];
					colour <= 3'b000;
					writeEn <= 1;
					done <= 0;
					xIteration = xIteration + 1;
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
				else
				begin
					done <= 1;
					xIteration <= xIteration;
					yIteration <= yIteration;
					x <= 8'b00000000;
					y <= 7'b0000000;
					colour <= 3'b000;
					writeEn <= 0;
				end
			end
		end
	end
endmodule
