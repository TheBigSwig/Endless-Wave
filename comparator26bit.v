
//The comparator26bit module.
module comparator26bit(input [25:0] inputValue, upperBound, lowerBound,
							  input clock,
							  output reg withinBounds);
							  
							  
	always@(posedge clock)
	begin
		if ( (inputValue >= lowerBound) && (inputValue <= upperBound) )
			withinBounds <= 1;
		else
		 withinBounds <= 0;
	end
endmodule
	