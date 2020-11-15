

//The TflipFlop module.
module TflipFlop(input T, clock, reset_n,
					  output reg Q);
					  
	always@(posedge clock)
	begin
		if (reset_n == 0)
			Q <= 0;
		else
		begin
			if (T == 1)
				Q <= ~Q;
			else
				Q <= Q;
		end
	end
endmodule
