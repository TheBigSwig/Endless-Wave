

//The randomTickGenerator module.
module randomTickGenerator(input gameTick,
									input resetNumberGenerator, clock, reset_n,
									output randomTick1, randomTick2);
									
	//Wires are declared.
	wire [25:0] w0, w1;
	
	//The naturalNumberCounter26bit submodule, used as a seed generator.
	naturalNumberCounter26bit seedGenerator(.upperBound(26'b11111111111111111111111111),
														 .enable(1'b1), .clock(clock), .reset_n(reset_n),
														 .counterValue(w0));
														 
	//The linearFeedbackShiftRegister26bit submodule, used as a RNG.
	linearFeedbackShiftRegister26bit RNG(.initialFill(w0), .resetNumberGenerator(resetNumberGenerator),
													 .generateNumber(gameTick), .clock(clock), .randomNumber(w1));
													 
													 
	//The first comparator26bit submodule, used to generate randomTick1.
	comparator26bit comparator1(.inputValue(w1), .upperBound(26'b00100110001001011010000000),
										 .lowerBound(26'b00000000000000000000000000), .clock(clock),
										 .withinBounds(randomTick1));
										 
										 
	//The second comparator26bit submodule, used to generate randomTick2.
	comparator26bit comparator2(.inputValue(w1), .upperBound(26'b01001011100001111111000000),
										 .lowerBound(26'b00100101011000100101000000), .clock(clock),
										 .withinBounds(randomTick2));
										 
endmodule
									
				