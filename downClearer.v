

//The downClearer helper module for the graphics FSM.
module downClearer(input start, input [7:0] refX, input [6:0] refY,
					  input clock, reset_n,
					  output reg [7:0] x, output reg [6:0] y, output reg [2:0] colour, output reg writeEn,
					  output reg done);
					  
	//The iteration counters.
	reg [3:0] xIteration, yIteration;
	
	//The behaviour for the module.
	always@(posedge clock)
	begin
		if (reset_n == 0)
		begin
			xIteration <= 4'b1000;
			yIteration <= 4'b1000;
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
				xIteration <= 4'b0000;
				yIteration <= 4'b0000;
				x <= 8'b00000000;
				y <= 7'b0000000;
				colour <= 3'b000;
				writeEn <= 0;
				done <= 0;
			end
			else
			begin
				if ((xIteration < 4'b1000) && (yIteration < 4'b1000))
				begin
					x = refX + xIteration;
					y = refY + yIteration;
					colour <= 3'b000;
					writeEn <= 1;
					done <= 0;
					xIteration = xIteration + 1;
					if (xIteration == 4'b1000)
					begin
						xIteration = 4'b0000;
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