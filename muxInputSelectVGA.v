

//The muxInputSelectVGA module is defined.
module muxInputSelectVGA(input [7:0] x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12,
								 input [6:0] y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12,
								 input [2:0] colour1, colour2, colour3, colour4, colour5, colour6, colour7, colour8, colour9, colour10, colour11, colour12,
								 input writeEn1, writeEn2, writeEn3, writeEn4, writeEn5, writeEn6, writeEn7, writeEn8, writeEn9, writeEn10, writeEn11, writeEn12,
								 input [3:0] select,
								 output reg [7:0] x, output reg [6:0] y, output reg [2:0] colour, output reg writeEn);
							
	always@(*)
	begin
		case(select)
			4'b0000: begin
						x = x1;
						y = y1;
						colour = colour1;
						writeEn = writeEn1;
				end
			4'b0001: begin
						x = x2;
						y = y2;
						colour = colour2;
						writeEn = writeEn2;
				end
			4'b0010: begin
						x = x3;
						y = y3;
						colour = colour3;
						writeEn = writeEn3;
				end
			4'b0011: begin
						x = x4;
						y = y4;
						colour = colour4;
						writeEn = writeEn4;
				end
			4'b0100: begin
						x = x5;
						y = y5;
						colour = colour5;
						writeEn = writeEn5;
				end
			4'b0101: begin
						x = x6;
						y = y6;
						colour = colour6;
						writeEn = writeEn6;
				end
			4'b0110: begin
						x = x7;
						y = y7;
						colour = colour7;
						writeEn = writeEn7;
				end
				
				//
			4'b0111: begin
						x = x8;
						y = y8;
						colour = colour8;
						writeEn = writeEn8;
				end
			4'b1000: begin
						x = x9;
						y = y9;
						colour = colour9;
						writeEn = writeEn9;
				end
			4'b1001: begin
						x = x10;
						y = y10;
						colour = colour10;
						writeEn = writeEn10;
				end
			4'b1010: begin
						x = x11;
						y = y11;
						colour = colour11;
						writeEn = writeEn11;
				end
			4'b1011: begin
						x = x12;
						y = y12;
						colour = colour12;
						writeEn = writeEn12;
				end
			default: begin
							x = x1;
							y = y1;
							colour = colour1;
							writeEn = writeEn1;
						end
		endcase
	end
endmodule
