

//The collisionChecker module.
module collisionChecker(input start, input [7:0] refX, input [6:0] refY, input newShipDir,
								input [2:0] readColour,
								input clock, reset_n, 
								output reg [7:0] x, output reg [6:0] y, output reg [2:0] colour, output reg writeEn,
								output reg collision, done);
								
								
	//The iteration counters.
	reg [3:0] xIteration, yIteration;
	
	//A reg counter to account for a read delay of 2 clock cycles from the screenMirror.
	reg [1:0] delayCounter;
	
	//The behaviour for the module.
	always@(posedge clock)
	begin
		if (reset_n == 0)
		begin
			delayCounter <= 2'b10;
			xIteration <= 4'b1000;
			yIteration <= 4'b1000;
			x <= 8'b00000000;
			y <= 7'b0000000;
			colour <= 3'b000;
			writeEn <= 0;
			collision <= 0;
			done <= 1;
		end
		else
		begin
			if (start == 1)
			begin
				delayCounter <= 2'b10;
				xIteration <= 4'b0000;
				yIteration <= 4'b0000;
				x <= 8'b00000000;
				y <= 7'b0000000;
				colour <= 3'b000;
				writeEn <= 0;
				collision <= 0;
				done <= 0;
			end
			else
			begin
				if ((xIteration < 4'b1000) && (yIteration < 4'b1000))
				begin
				
					//Collision detection for when ship is moving down.
					if (newShipDir == 0)
					begin
						
						//The case when the screenMirror memory can be properly read from.
						if (delayCounter == 2'b00)
						begin
							delayCounter <= 2'b10;
							x <= refX + xIteration;
							y <= refY + yIteration;
							colour <= 3'b000;
							writeEn <= 0;
							done <= 0;
							if (readColour == 3'b111)
							begin
								collision <= 1;
								xIteration = 4'b1000;
								yIteration = 4'b1000;
							end
							else
							begin
								collision <= 0;
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
						end
						
						
						//The case when the screenMirror memory cannot be properly read from because of delays.
						//This is essentially a waiting stage.
						else
						begin
							delayCounter <= delayCounter - 1;
							x <= refX + xIteration;
							y <= refY + yIteration;
							colour <= 3'b000;
							writeEn <= 0;
							done <= 0;
							collision <= 0;
							xIteration = xIteration;
							yIteration = yIteration;
						end
					end
					
					//Collision detection for when ship is moving up.
					else
					begin
						//The case when the screenMirror memory can be properly read from.
						if (delayCounter == 2'b00)
						begin
							delayCounter <= 2'b10;
							x = refX + xIteration;
							y = refY - yIteration;
							colour <= 3'b000;
							writeEn <= 0;
							done <= 0;
							if (readColour == 3'b111)
							begin
								collision <= 1;
								xIteration = 4'b1000;
								yIteration = 4'b1000;
							end
							else
							begin
								collision <= 0;
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
						end
						
						
						//The case when the screenMirror memory cannot be properly read from because of delays.
						//This is essentially a waiting stage.
						else
						begin
							delayCounter <= delayCounter - 1;
							x = refX + xIteration;
							y = refY - yIteration;
							colour <= 3'b000;
							writeEn <= 0;
							done <= 0;
							collision <= 0;
							xIteration = xIteration;
							yIteration = yIteration;
						end
					end
				end
				else
				begin
					delayCounter <= 2'b10;
					xIteration <= 4'b1000;
					yIteration <= 4'b1000;
					x <= 8'b00000000;
					y <= 7'b0000000;
					colour <= 3'b000;
					writeEn <= 0;
					collision <= 0;
					done <= 1;
				end
			end
		end
	end
endmodule
