

//The gameClock module.
module gameClock(input clock, reset_n, output gameTick);

	//Wires.
	wire w0;

	//The RateDivider submodules are instantiated.
	RateDivider DelayCounter(.D(27'b000000011001011011100110100), .clock(clock), .reset_n(reset_n), 
									 .enable(1'b1), .outputTick(w0));
										 
	RateDivider FrameCounter(.D(27'b000000000000000000000000001), .clock(clock), .reset_n(reset_n), 
									 .enable(w0), .outputTick(gameTick));

endmodule



//The RateDivider submodule is defined.
module RateDivider(input [26:0] D, input clock, reset_n, enable, output reg outputTick);

	//The internal reg that stores the counter value of the RateDivider.
	reg [26:0] internalCounter;
	
	always@(posedge clock)
	begin
		if (reset_n == 1'b0)
		begin
			internalCounter <= D;
			outputTick <= 0;
		end
		else
		begin
			if (enable == 1'b1)
			begin
				if (internalCounter == 27'b000000000000000000000000000)
				begin
					outputTick <= 1;
					internalCounter <= D;
				end
				else
				begin
					outputTick <= 0;
					internalCounter <= internalCounter - 27'b000000000000000000000000001;
				end
			end
			else
			begin
				internalCounter <= internalCounter;
				outputTick <= 0;
			end
		end
	end
endmodule
