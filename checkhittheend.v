//This module will check whether or not if ship moves to the end 
//of the frame buffer and the frame buffer is needed to update 

/*

module checkShipEnterEnd(check_en, ship_y, reset_n, clk, is_enter);
	input check_en;
	input [7:0] ship_y;

	input reset_n;
	input clk;
	output reg is_enter;
	
	always@(posedge clk)
	if (!reset_n)
		is_enter <= 1'b0;
	else
	begin
		if (check_en)
		begin
			if (is_crash == 0)
			begin
				if (craft_y >= 7'd119)
					is_crash <= 1'b1;
				else
					is_crash <= 1'b0;
			end
			else
				is_crash <= 1'b1;
		end
	end
	
endmodule

*/