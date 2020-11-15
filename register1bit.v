

//The register1bit module is defined.
module register1bit(input D, input enable, force_0, clock, reset_n,
						  output reg Q);
						  
	always@(posedge clock)
	begin
		if (reset_n == 1'b0)
			Q <= 1'b0;
		else
		begin
			if (enable == 1'b1)
				Q <= D;
			else
			begin
				
				//This additional behavour only happens if enable is off.
				if (force_0 == 1'b1)
					Q <= 1'b0;
				else
					Q <= Q;
			end
		end
	end
endmodule
