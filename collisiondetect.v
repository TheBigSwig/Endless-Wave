//codes for checking if the ship crashes one of the obstacles 

module collisionDetect(check_en, ship_x, ship_y, obstacles_x, obstacles_y, reset_n, clk, height, width, is_crash);
	input check_en;
	input [7:0] ship_x;
	input [6:0] ship_y;
	
	input [7:0] obstacles_x;
	input [6:0] obstacles_y;
	input reset_n;
	input [7:0] height;
	input [4:0] width;
	input clk;
	output reg is_crash;
	
	always@(posedge clk)
	if (!reset_n)
		is_crash <= 1'b0;
	else
	begin
		if (check_en)
		begin
			if (is_crash == 0)
			begin
				if (obstacles_x - 4 <= ship_x && ship_x <= obstacles_x + width && ship_y <=obstacles_y + 1)
					is_crash <= 1'b1;
				else if (obstacles_x - 4 <= ship_x && ship_x <= obstacles_x + width && ship_y >= obstacles_y + height - 4)
					is_crash <= 1'b1;
				else
					is_crash <= 1'b0;
			end
			else
				is_crash <= 1'b1;
		end
	end
	
endmodule