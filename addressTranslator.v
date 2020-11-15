
//The addressTranslator module.
module addressTranslator(input [7:0] x, input [6:0] y, output reg [14:0] address);
		
		always@(*)
		begin
			address = (y * 160) + x;
		end
	
endmodule
