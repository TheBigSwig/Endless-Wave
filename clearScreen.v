
//This module is used to clear the screen once the game is over 



module clear_go(clr_go, x_clear_in, y_clear_in, clear_color, x_go_in, y_go_in, go_color, x_out, y_out, color_out);
	input clr_go;
	input [7:0] x_clear_in;
	input [6:0] y_clear_in;
	input [2:0] clear_color;
	input [7:0] x_go_in;
	input [6:0] y_go_in;
	input [2:0] go_color;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	output reg [2:0] color_out;
	
	always @(*)
	begin
		case (clr_go)
			1'b0:
			begin
				x_out = x_clear_in;
				y_out = y_clear_in;
				color_out = clear_color;
			end
			1'b1:
			begin
				x_out = x_go_in;
				y_out = y_go_in;
				color_out = go_color;
			end
		endcase
	end
	
endmodule

module datapath_clear(color_input, load_en, x_out, y_out, clk, reset_n, color_output, end_signal);

	input load_en;
	input clk;
	input reset_n;
	input [2:0] color_input;
	
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	output reg [2:0] color_output;
	output reg end_signal;
	
	reg [7:0] x;
	reg [6:0] y;
	reg [7:0] count_x;
	reg [6:0] count_y;
	
	always @(posedge clk)
	begin
		// Reset, low active
		if (reset_n == 1'b0)
		begin
			x <= 8'd0;
			y <= 7'd0;
		end
		// Loading value for x and y, and set count to 0.
		else if (load_en == 1'b1)
		begin
			x_out <= x;
			y_out <= y;
			count_x <= 8'd0;
			count_y <= 7'd0;
			end_signal <= 1'b0;
		end
		// Count all 160 X 120 pixels
		else	
		begin
			if (count_y != 7'd120)
			begin
				if (count_x != 8'd160)
				begin
					x_out <= x + count_x;
					y_out <= y + count_y;
					count_x <= count_x + 1'd1;
					color_output <= color_input;
					
				end
				//end up printing current line, move to next line
				else if (count_x == 8'd160)
				begin
					count_x <= 8'd0;
					x_out <= x + count_x;
					y_out <= y + count_y;
					count_y <= count_y + 1'd1;
					color_output <= color_input;
				end
			end
			//reaching the button line.
			else
			begin
				x_out <= x + count_x;
				y_out <= y + count_y;
				color_output <= color_output;
				end_signal <= 1'b1;
			end
		end
	end

endmodule
