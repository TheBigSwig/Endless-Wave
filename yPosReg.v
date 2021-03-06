

//The yPosReg module.
module yPosReg(input [6:0] initialValue, lowerBound, upperBound,
				input inc, dec, clock, reset_n,
				output reg [6:0] yPos);
				
	always@(posedge clock)
	begin
		if (reset_n == 0)
			yPos <= initialValue;
		else
		begin
			if ( (inc == 1) && (yPos < upperBound) )
				yPos <= yPos + 1;
			else if ( (dec == 1) && (yPos > lowerBound) )
				yPos <= yPos - 1;
			else
				yPos <= yPos;
		end
	end
endmodule
	