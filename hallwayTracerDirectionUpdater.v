

//The hallwayTracerDirectionUpdater module.
module hallwayTracerDirectionUpdater(input randomTick1, randomTick2,
									 input [6:0] lowerTracerPos, upperTracerPos,
									 input lowerTracerDir, upperTracerDir,
									 input enable, clock, reset_n,
									 output reg toggleUpperTracerDir, toggleLowerTracerDir);
									 
	reg whoFlips;  //Helps to randomize hallway pattern in "toss-up" scenarios.		
				
	always@(posedge clock)
	begin
		if (reset_n == 0)
		begin
			whoFlips <= 0;
			toggleUpperTracerDir <= 0;
			toggleLowerTracerDir <= 0;
		end
		else
		begin
			if (enable == 1)
			begin
				if ( (lowerTracerPos - upperTracerPos) <= 26)
				begin
					if ( (lowerTracerPos >= 119) && (upperTracerDir == 0) )  //Pinching at bottom.
					begin
						toggleUpperTracerDir <= 1;
						toggleLowerTracerDir <= randomTick2;
						whoFlips <= whoFlips;
					end
					else if ( (upperTracerPos == 0) && (lowerTracerDir == 1) )  //Pinching at top.
					begin
						toggleLowerTracerDir <= 1;
						toggleUpperTracerDir <= randomTick1;
						whoFlips <= whoFlips;
					end
					else  //Pinching elsewhere.
					begin
						if (upperTracerDir != lowerTracerDir)  //Pinching together.
						begin
							if (whoFlips == 0)
							begin
								toggleUpperTracerDir <= 1;
								toggleLowerTracerDir <= randomTick2;
								whoFlips = ~whoFlips;
							end
							else
							begin
								toggleLowerTracerDir <= 1;
								toggleUpperTracerDir <= randomTick1;
								whoFlips = ~whoFlips;
							end
						end
						else  //Parallel but at minimum distance.
						begin
							if (upperTracerDir == 0)
							begin
								toggleUpperTracerDir <= randomTick1;
								toggleLowerTracerDir <= 0;
								whoFlips <= whoFlips;
							end
							else
							begin
								toggleLowerTracerDir <= randomTick2;
								toggleUpperTracerDir <= 0;
								whoFlips <= whoFlips;
							end
						end
					end
				end  //End of pinching cases.
				else
				begin
					toggleUpperTracerDir <= randomTick1;
					toggleLowerTracerDir <= randomTick2;
					whoFlips <= whoFlips;
				end
			end
			else
			begin
				toggleUpperTracerDir <= 0;
				toggleLowerTracerDir <= 0;
				whoFlips <= whoFlips;
			end
		end
	end
endmodule
	