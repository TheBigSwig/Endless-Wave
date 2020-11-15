

//The naturalNumberCounter26bit module.
module naturalNumberCounter26bit(input [25:0] upperBound, input enable,
											input clock, reset_n,
											output reg [25:0] counterValue);
											
	always@(posedge clock)
	begin
		if (reset_n == 0)
			counterValue <= upperBound;
		else
		begin
			if (enable == 1)
			begin
				if ((counterValue - 1) == 0)
					counterValue <= upperBound;
				else
					counterValue <= counterValue - 1;
			end
			else
				counterValue <= counterValue;
		end
	end
endmodule
	