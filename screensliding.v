//This module is to make the screen sliding from left to right 


/*

module swapColumns(input [7:0] outPutColour,
							input clock,Enable,
							output reg[118:0]updatedColour,
							integer i,j);
always@(posedge clock)
begin 
	if(Enable == 1)
	begin
		for(i=0 ; i<=118 ; i=i+1)     //rows
			begin                      	//rows loop begin 
				for(j=0 ; j<=118; j=j+1)  		//columns
					begin   
						outputColour[i][j]=outputColour[i][j+1]//columns loop begin 
						end  //columns loop ends
							end //rows loop ends
								end 
									else
										outputColour[i][j]=ouputColour[i][j] // no changes made if there is no need to change 
										end
											end 
endmodule 

// This module is to make outputcolor=inputcolor 
module screenSliding( input reg[118:0] outPutColour,
							input clock,Enable,
							output reg[118:0]updatedColour,
							integer i,j);
									
always@(posedge clock)
begin 
	
	if(Enable == 0)
	begin
		updatedColour[i][j]=0
			end
	else	
	begin
		for(i=0 ; i<=118 ; i=i+1)     //rows
			begin                      	//rows loop begin 
				for(j=0 ; j<=118; j=j+1)  		//columns
					begin                  			//columns loop begin 
						updatedColour[i][j]=outputColour[i][j]  //copy outcolour with inputcolour 
							end //row loop ends
								end //column loop ends
									end // 
											
endmodule 
*/