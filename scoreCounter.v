
//The scoreCounter module.
module scoreCounter (input gameTick, enable, 
							input clock, reset_n,
							output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

				wire [3:0] counter0, counter1, counter2, counter3, counter4, counter5;
				wire enable_counter1, enable_counter2, enable_counter3, enable_counter4, enable_counter5;
				
				fourBit_Counter C0(clock, reset_n, gameTick, enable, counter0, enable_counter1);
				fourBit_Counter C1(clock, reset_n, enable_counter1, 1, counter1, enable_counter2);
				fourBit_Counter C2(clock, reset_n, enable_counter2, 1, counter2, enable_counter3);
				fourBit_Counter C3(clock, reset_n, enable_counter3, 1, counter3, enable_counter4);
				fourBit_Counter C4(clock, reset_n, enable_counter4, 1, counter4, enable_counter5);
				fourBit_Counter C5(clock, reset_n, enable_counter5, 1, counter5);
				
				
				BCD_to_HEX_Decoder D0 (.C(counter0), .HEX(HEX0));
				BCD_to_HEX_Decoder D1 (.C(counter1), .HEX(HEX1));
				BCD_to_HEX_Decoder D2 (.C(counter2), .HEX(HEX2));
				BCD_to_HEX_Decoder D3 (.C(counter3), .HEX(HEX3));
				BCD_to_HEX_Decoder D4 (.C(counter4), .HEX(HEX4));
				BCD_to_HEX_Decoder D5 (.C(counter5), .HEX(HEX5));
						
endmodule 





/* 4-bit counter to which accepts the downclocked enable */
module fourBit_Counter (input clock, reset, enable1, enable2, output reg [4:0] Q, output reg atMax);

				always @(posedge clock) // triggered on rising edge of clock
				begin
					if (reset == 1'd0) // synch reset active-low
					begin
						Q <= 5'd0;
						atMax <= 0;
					end
					else if (Q == 5'd10) // max vvalll
					begin
						Q <= 5'd0;
						atMax <= 1;
					end
					else if ( (enable1 == 1'd1) && (enable2 == 1)) // increment on enable
					begin
						Q <= Q + 1;
						atMax <= 0;
					end
					else
					begin
						Q <= Q;
						atMax <= 0;
					end	
				end

endmodule // fourBit_Counter

/* BCD to common-anode seven-segment display decoder */
module BCD_to_HEX_Decoder (input [3:0] C, output [6:0] HEX);

				// maxterms for every segment LEDs with common anode
				assign HEX[0] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|!C[0]));
								
				assign HEX[1] = !((C[3]|!C[2]|C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|C[0]) & 
								(!C[3]|C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|!C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]));
								
				assign HEX[2] = !((C[3]|C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|C[1]|C[0]) & 
								(!C[3]|!C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]));
								
				assign HEX[3] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|!C[2]|C[1]|C[0]) & 
								(C[3]|!C[2]|!C[1]|!C[0]) & (!C[3]|C[2]|C[1]|!C[0]) & 
								(!C[3]|C[2]|!C[1]|C[0]) & (!C[3]|!C[2]|!C[1]|!C[0]));
								
				assign HEX[4] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|C[2]|!C[1]|!C[0]) & 
								(C[3]|!C[2]|C[1]|C[0]) & (C[3]|!C[2]|C[1]|C[0]) &
								(C[3]|!C[2]|C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|!C[0]) &
								(!C[3]|C[2]|C[1]|!C[0]));
								
				assign HEX[5] = !((C[3]|C[2]|C[1]|!C[0]) & (C[3]|C[2]|!C[1]|C[0]) & 
								(C[3]|C[2]|!C[1]|!C[0]) & (C[3]|!C[2]|!C[1]|!C[0]) & 
								(!C[3]|!C[2]|C[1]|!C[0]));
								
				assign HEX[6] = !((C[3]|C[2]|C[1]|C[0]) & (C[3]|C[2]|C[1]|!C[0]) & 
								(C[3]|!C[2]|!C[1]|!C[0]) & (!C[3]|!C[2]|C[1]|C[0]));

endmodule // BCD_to_HEX_Decoder