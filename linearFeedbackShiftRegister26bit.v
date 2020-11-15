

//The linearFeedbackShiftRegister26bit, which is used to generate pseudo-random numbers.
//Note: this code is based heavily on the following source: https://zipcpu.com/dsp/2017/10/27/lfsr.html
module linearFeedbackShiftRegister26bit(input [25:0] initialFill, 
													 input resetNumberGenerator, generateNumber, clock,
													 output reg [25:0] randomNumber);
													 

	//The taps (1's in the bit-string) used to make the LFSR cycle through all values.
	//Value determined from : http://courses.cse.tamu.edu/walker/csce680/lfsr_table.pdf
	parameter taps = 26'b11100010000000000000000000;
	
	always@(posedge clock)
	begin
		
		//On a generator reset, the value in the reg is set to the initial fill value.
		if (resetNumberGenerator == 1)
			randomNumber <= initialFill;
		else
		begin
		
			//This will only run if generateNumber is set to true.
			if (generateNumber == 1)
			begin
			
				//The bits of ranmdomNumber are shifted to the right.
				//Depending on the LSB of the current number, different behaviour is followed.
				//If the LSB is 1, the randomNumber value is XOR'ed (added) to the taps.
				//Otherwise, nothing happens. This essentially implements the multiply in the LFSM.
				if (randomNumber[0] == 1'b1)
					randomNumber <= {1'b0, randomNumber[25:1]} ^ taps;
				else
					randomNumber <= {1'b0, randomNumber[25:1]};
			end
			else
				randomNumber <= randomNumber;
		end
	end
	
endmodule
