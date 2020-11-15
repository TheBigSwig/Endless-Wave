

module waveGameFinal (KEY, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,//General inputs and outputs.
									// The ports below are for the VGA output.  Do not change.
									VGA_CLK,   						//	VGA Clock
									VGA_HS,							//	VGA H_SYNC
									VGA_VS,							//	VGA V_SYNC
									VGA_BLANK_N,						//	VGA BLANK
									VGA_SYNC_N,						//	VGA SYNC
									VGA_R,   						//	VGA Red[9:0]
									VGA_G,	 						//	VGA Green[9:0]
									VGA_B,   						//	VGA Blue[9:0]
									LEDR
								  );
								  
	input [3:0] KEY;
	input CLOCK_50;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	output [9:0] LEDR;
	assign LEDR[0] = newDir;
	assign LEDR[1] = ~KEY[0];
	assign LEDR[9:2] = 8'b00000000;
	
	//Wires connected to FPGA inputs.
	wire reset_n = KEY[3];
	wire resetNumberGenerator = ~KEY[3];
	wire clock = CLOCK_50;
	wire selectedDirection = ~KEY[0];

	//-----------------------VGA STUFF-------------------//
	
	//VGA Outputs
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	
	// Create the colour, x, y, and writeEn wires that connect to the VGA controller.
	wire [2:0] inputColour;
	wire[2:0] outputColour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter_new VGA(
			.resetn(reset_n),
			.clock(clock),
			.inputColour(inputColour),
			.outputColour(outputColour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
		
	//-------------------End VGA STUFF-------------------//
	
	
	
	
	//Wires connecting game datapath to graphics and game FSMs.
	wire load_old_dir_reg, load_new_dir_reg;  //Control signals for ship direction.
	wire force_old_dir_0, force_new_dir_0;  //Control signals for ship direction.
	wire inc_yShip, dec_yShip;  //Control signals for ship position.
	wire inc_upperHallTracerPos, dec_upperHallTracerPos;  //Control signals for upper hall tracer pos.
	wire inc_lowerHallTracerPos, dec_lowerHallTracerPos;  //Control signals for lower hall tarcer pos.
	
	wire oldDir, newDir;  //Ship direction data signals.
	wire [6:0] shipYPos;  //Ship position data signal.
	wire [6:0] upperTracerPos, lowerTracerPos;  //Hall tracer position data signals.
	wire upperTracerDir, lowerTracerDir;  //Hall tracer direction data signals.
	wire gameTick;  //General data signal.
	
	//Wires connecting graphics datapath to graphics FSM.
	wire start_upShip_clearer, start_downShip_clearer;
	wire upClearer_done, downClearer_done;
	wire start_hallwayDrawer;
	wire hallwayDrawer_done;
	wire start_screenSlider;
	wire screenSlider_done;
	wire start_collisionDetector;
	wire shipCollision, collisionDetector_done;
	wire start_gameOverScreenDrawer;
	wire gameOverScreenDrawer_done;
	
	wire start_upShip_drawer, start_downShip_drawer;
	wire upDrawer_done, downDrawer_done;
	
	wire [3:0] input_select_VGA;
	
	//Wires connecting the game FSM to the graphics FSM.
	wire _clearShip, _shipCleared;
	wire _updateGraphics, _graphicsDone;
	
	//Wires connecting graphics FSM to rest of game datapath.
	wire gameOver;
	
	
	
	//The waveGameDatapath module is instantiated.
	waveGameDatapath gameDatapath(.selectedDirection(selectedDirection), 
									  .load_old_dir_reg(load_old_dir_reg), .load_new_dir_reg(load_new_dir_reg),
									  .force_old_dir_0(force_old_dir_0), .force_new_dir_0(force_new_dir_0),
									  .inc_yShip(inc_yShip), .dec_yShip(dec_yShip),
									  .resetNumberGenerator(resetNumberGenerator),
									  .inc_upperHallTracerPos(inc_upperHallTracerPos),
									  .dec_upperHallTracerPos(dec_upperHallTracerPos),
									  .inc_lowerHallTracerPos(inc_lowerHallTracerPos),
									  .dec_lowerHallTracerPos(dec_lowerHallTracerPos),
									  .gameOver(gameOver),
									  .clock(clock), .reset_n(reset_n),
									  .oldDir(oldDir), .newDir(newDir), .shipYPos(shipYPos),
									  .upperTracerPos(upperTracerPos), .lowerTracerPos(lowerTracerPos),
									  .upperTracerDir(upperTracerDir), .lowerTracerDir(lowerTracerDir),
									  .gameTick(gameTick),
									  .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
									  .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
									  
									  
	//The waveGraphicsDatapath module is instantiated.
	waveGraphicsDatapath graphicsDatapath(.refX(8'b00101000), .refY(shipYPos), .newShipDir(newDir),
													  .start_upShip_clearer(start_upShip_clearer),
													  .start_upShip_drawer(start_upShip_drawer),
													  .start_downShip_clearer(start_downShip_clearer),
													  .start_downShip_drawer(start_downShip_drawer),
													  .upperTracerPos(upperTracerPos), .lowerTracerPos(lowerTracerPos),
													  .start_hallwayDrawer(start_hallwayDrawer),
													  .start_screenSlider(start_screenSlider),
													  .start_collisionDetector(start_collisionDetector),
													  .start_gameOverScreenDrawer(start_gameOverScreenDrawer),
													  .readColour(outputColour),
													  .input_select_VGA(input_select_VGA),
													  .clock(clock), .reset_n(reset_n),
													  .x(x), .y(y), .colour(inputColour), .writeEn(writeEn),
													  .upClearer_done(upClearer_done), .upDrawer_done(upDrawer_done),
													  .downClearer_done(downClearer_done), .downDrawer_done(downDrawer_done),
													  .hallwayDrawer_done(hallwayDrawer_done),
													  .screenSlider_done(screenSlider_done),
													  .shipCollision(shipCollision),
													  .collisionDetector_done(collisionDetector_done),
													  .gameOverScreenDrawer_done(gameOverScreenDrawer_done));
									  
									  
	//The waveGameController module is instantiated.
	waveGameController gameController(.newDir(newDir), .gameTick(gameTick),
												 .upperTracerDir(upperTracerDir), .lowerTracerDir(lowerTracerDir),
												 .clock(clock), .reset_n(reset_n),
												 ._shipCleared(_shipCleared), ._graphicsDone(_graphicsDone),
												 .load_old_dir_reg(load_old_dir_reg), .load_new_dir_reg(load_new_dir_reg),
												 .force_old_dir_0(force_old_dir_0), .force_new_dir_0(force_new_dir_0),
												 .inc_yShip(inc_yShip), .dec_yShip(dec_yShip),
												 .inc_upperHallTracerPos(inc_upperHallTracerPos), .dec_upperHallTracerPos(dec_upperHallTracerPos),
												 .inc_lowerHallTracerPos(inc_lowerHallTracerPos), .dec_lowerHallTracerPos(dec_lowerHallTracerPos),
												 ._clearShip(_clearShip), ._updateGraphics(_updateGraphics));
												 
												 
	//The waveGraphicsController module is instantiated.
	waveGraphicsController graphicsController(.newDir(newDir), .oldDir(oldDir), 
															.upClearer_done(upClearer_done), .upDrawer_done(upDrawer_done),
															.downClearer_done(downClearer_done), .downDrawer_done(downDrawer_done),
															.hallwayDrawer_done(hallwayDrawer_done),
															.screenSlider_done(screenSlider_done),
															.shipCollision(shipCollision), 
															.collisionDetector_done(collisionDetector_done),
															.gameOverScreenDrawer_done(gameOverScreenDrawer_done),
															.clock(clock), .reset_n(reset_n),
															._clearShip(_clearShip), ._updateGraphics(_updateGraphics),
															.start_upShip_clearer(start_upShip_clearer),
															.start_upShip_drawer(start_upShip_drawer), 
															.start_downShip_clearer(start_downShip_clearer),
															.start_downShip_drawer(start_downShip_drawer),
															.start_hallwayDrawer(start_hallwayDrawer),
															.start_screenSlider(start_screenSlider),
															.start_collisionDetector(start_collisionDetector),
															.start_gameOverScreenDrawer(start_gameOverScreenDrawer),
															.input_select_VGA(input_select_VGA),
															._shipCleared(_shipCleared), ._graphicsDone(_graphicsDone),
															.gameOver(gameOver));







endmodule


//The waveGameDatapath module.
module waveGameDatapath(input selectedDirection,  //External FPGA inputs.
								input load_old_dir_reg, load_new_dir_reg,  //FSM control inputs.
								input force_old_dir_0, force_new_dir_0,  //FSM control inputs. 
								input inc_yShip, dec_yShip,	//FSM Control inputs.
								input resetNumberGenerator,  //For the internal hallwayTracerDatapath module.
								input inc_upperHallTracerPos, dec_upperHallTracerPos,  //FSM Controls for upper hallway tracer pos reg.
								input inc_lowerHallTracerPos, dec_lowerHallTracerPos,  //FSM controls for lower hallway tracer pos reg.
								input gameOver,  //Input from graphics FSM.
								input clock, reset_n,  //General inputs.
								output oldDir, newDir,  //Ship direction outputs.
								output [6:0] shipYPos,  //Ship position output.
								output [6:0] upperTracerPos, lowerTracerPos,  //Hallway tracer position outputs.
								output upperTracerDir, lowerTracerDir,  //Hallway tracer direction outputs.
								output gameTick,
								output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); //General outputs.
								
	
	//The wire connecting the data input of oldDirReg to the output of newDirReg.
	wire w0;
	assign w0 = newDir;
	
	//The wire connecting the gameTick from the gameClock internally within the module.
	wire gameTick_internal;
	assign gameTick = gameTick_internal;
								
	//The gameClock module is instantiated.
	gameClock GC(.clock(clock), .reset_n(reset_n), .gameTick(gameTick_internal));
	

	//reg1bit modules are instantiated to store the current and previous directions of the ship.
	register1bit oldDirReg(.D(w0), .enable(load_old_dir_reg),
							.force_0(force_old_dir_0), .clock(clock), .reset_n(reset_n),
							.Q(oldDir));
							
	register1bit newDirReg(.D(selectedDirection), .enable(load_new_dir_reg),
							.force_0(force_new_dir_0), .clock(clock), .reset_n(reset_n),
							.Q(newDir));
							
							
							
							
	//The yPosReg module storing the ship's position.
	yPosReg shipPosition(.initialValue(7'b0111100), .lowerBound(7'b0000111), .upperBound(7'b1110000),
								.inc(inc_yShip), .dec(dec_yShip), .clock(clock), .reset_n(reset_n),
								.yPos(shipYPos));
								
								
	//The hallwayTracerDatapath module containing the pos and dir registers for the hallway tracers,
	//as well as logic for randomly updating the hallway tracer directions.
	hallwayTracerDatapath hallTracerDatapath(.gameTick(gameTick_internal), .resetNumberGenerator(resetNumberGenerator),
														  .inc_upperHallTracerPos(inc_upperHallTracerPos),
														  .dec_upperHallTracerPos(dec_upperHallTracerPos),
														  .inc_lowerHallTracerPos(inc_lowerHallTracerPos),
														  .dec_lowerHallTracerPos(dec_lowerHallTracerPos),
														  .clock(clock), .reset_n(reset_n),
														  .upperTracerPos(upperTracerPos), .lowerTracerPos(lowerTracerPos),
														  .upperTracerDir(upperTracerDir), .lowerTracerDir(lowerTracerDir));
														  
														  
														  
	//The scoreCounter module used to keep track of the score.
	scoreCounter waveGameScoreCounter(.gameTick(gameTick), .enable(~gameOver), 
												 .clock(clock), .reset_n(reset_n),
												 .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), 
												 .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
														  
														  
									
														
endmodule


//The waveGraphicsDatapath module.
module waveGraphicsDatapath(input [7:0] refX, input [6:0] refY, input newShipDir,
									 input start_upShip_clearer, start_upShip_drawer,
									 input start_downShip_clearer, start_downShip_drawer,
									 input [6:0] upperTracerPos, lowerTracerPos,
									 input start_hallwayDrawer,
									 input start_screenSlider,
									 input start_collisionDetector,
									 input start_gameOverScreenDrawer,
									 input [2:0] readColour,
									 input [3:0] input_select_VGA,
									 input clock, reset_n,
									 output [7:0] x, output [6:0] y, output [2:0] colour, output writeEn,
									 output upClearer_done, upDrawer_done,
									 output downClearer_done, downDrawer_done,
									 output hallwayDrawer_done,
									 output screenSlider_done,
									 output shipCollision, collisionDetector_done,
									 output gameOverScreenDrawer_done);
									 
									 
	//Wires to connect the various graphic helper modules to the VGA input select multiplexor.
	wire [7:0] x1, x2, x3, x4, x5, x6, x7, x8;
	wire [6:0] y1, y2, y3, y4, y5, y6, y7, y8;
	wire [2:0] colour1, colour2, colour3, colour4, colour5, colour6, colour7, colour8;
	wire writeEn1, writeEn2, writeEn3, writeEn4, writeEn5 ,writeEn6, writeEn7, writeEn8;
	
	//Wires used to connect the local version of the frame buffer (the screenMirror) to the
	//rest of the module.
	wire [7:0] x_internal;
	wire [6:0] y_internal;
	wire [2:0] colour_internal;
	wire writeEn_internal;
	
	wire [2:0] screenMirrorColourOutput;
	wire [14:0] screenMirrorAddress;
	
	//assign statements to hook up external outputs to their internal versions.
	assign x = x_internal;
	assign y = y_internal;
	assign colour = colour_internal;
	assign writeEn = writeEn_internal;
	
	//The upClearer module is instantiated.
	upClearer shipUpTextureClearer(.start(start_upShip_clearer), .refX(refX), .refY(refY), 
											 .clock(clock), .reset_n(reset_n),
											 .x(x1), .y(y1), .colour(colour1), .writeEn(writeEn1), 
											 .done(upClearer_done));
	//The downClearer module is instantiated.
	downClearer shipDownTextureClearer(.start(start_downShip_clearer), .refX(refX), .refY(refY), 
											 .clock(clock), .reset_n(reset_n),
											 .x(x2), .y(y2), .colour(colour2), .writeEn(writeEn2), 
											 .done(downClearer_done));
																		 
	//The upDrawer module is instantiated.
	upDrawer shipUpTextureDrawer(.start(start_upShip_drawer), .refX(refX), .refY(refY), 
										  .clock(clock), .reset_n(reset_n),
										  .x(x3), .y(y3), .colour(colour3), .writeEn(writeEn3), 
										  .done(upDrawer_done));
										  
	//The downDrawer module is instantiated.
	downDrawer shipDownTextureDrawer(.start(start_downShip_drawer), .refX(refX), .refY(refY), 
										  .clock(clock), .reset_n(reset_n),
										  .x(x4), .y(y4), .colour(colour4), .writeEn(writeEn4), 
										  .done(downDrawer_done));
										  
										  
	//The hallwayDrawer module is instantiated.
	hallwayDrawer waveGameHallwayDrawer(.start(start_hallwayDrawer), .columnSpecifier(8'b10011111),
													.upperTracerPos(upperTracerPos), .lowerTracerPos(lowerTracerPos),
													.clock(clock), .reset_n(reset_n),
													.x(x5), .y(y5), .colour(colour5), .writeEn(writeEn5),
													.done(hallwayDrawer_done));
													
	
	//The screenSlider module is instantiated.
	screenSlider waveGameScreenSlider(.start(start_screenSlider), .lowerXBound(8'b00000000), .upperXBound(8'b10011110),
												 .lowerYBound(7'b0000000), .upperYBound(7'b1110111),
												 .readColour(screenMirrorColourOutput),
												 .clock(clock), .reset_n(reset_n),
												 .x(x6), .y(y6), .writeColour(colour6), .writeEn(writeEn6),
												 .done(screenSlider_done));
												 
												 
	//The collisionChecker module is instantiated.
	collisionChecker waveGameCollisionChecker(.start(start_collisionDetector), .refX(refX), .refY(refY), .newShipDir(newShipDir),
															.readColour(screenMirrorColourOutput), 
															.clock(clock), .reset_n(reset_n), 
															.x(x7), .y(y7), .colour(colour7), .writeEn(writeEn7),
															.collision(shipCollision), .done(collisionDetector_done));
															
															
	//The gameOverScreenDrawer module is instantiated.
	gameOverScreenDrawer waveGameGameOverScreenDrawer(.start(start_gameOverScreenDrawer), .lowerXBound(8'b00000000), .upperXBound(8'b10011111),
																	  .lowerYBound(7'b0000000), .upperYBound(7'b1110111),
																	  .clock(clock), .reset_n(reset_n),
																	  .x(x8), .y(y8), .colour(colour8), .writeEn(writeEn8),
																	  .done(gameOverScreenDrawer_done));
											 
											 
	//The muxInputSelectVGA is instantiated.
	muxInputSelectVGA VGA_inputMux(.x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7), .x8(x8),
											 .y1(y1), .y2(y2), .y3(y3), .y4(y4), .y5(y5), .y6(y6), .y7(y7), .y8(y8),
											 .colour1(colour1), .colour2(colour2), .colour3(colour3), .colour4(colour4), 
											 .colour5(colour5), .colour6(colour6), .colour7(colour7), .colour8(colour8),
											 .writeEn1(writeEn1), .writeEn2(writeEn2), .writeEn3(writeEn3), .writeEn4(writeEn4), 
											 .writeEn5(writeEn5), .writeEn6(writeEn6), .writeEn7(writeEn7), .writeEn8(writeEn8),
											 .select(input_select_VGA), 
											 .x(x_internal), .y(y_internal), .colour(colour_internal), .writeEn(writeEn_internal));
					
					
	//The addressTranslator module is instantiated.
	addressTranslator screenMirrorAddressTranslator(.x(x_internal), .y(y_internal), .address(screenMirrorAddress));
	
	
	//The ram19200x3 module used as the screenMirror is instantiated.
	ram19200x3 screenMirror(.address(screenMirrorAddress), .clock(clock), .data(colour_internal), .wren(writeEn_internal), .q(screenMirrorColourOutput));
											 
endmodule


//The waveGameController module.
module waveGameController(input newDir, gameTick,  //Datapath general inputs.
								  input upperTracerDir, lowerTracerDir,  //Hall tracer direction datapath inputs.
								  input clock, reset_n,  //General inputs.
								  input _shipCleared, _graphicsDone,  //Handshake inputs from graphics FSM.
								  output reg load_old_dir_reg, load_new_dir_reg,  //datapath control
								  output reg force_old_dir_0, force_new_dir_0,  //datapath control
								  output reg inc_yShip, dec_yShip,  //datapath control for ship position.
								  output reg inc_upperHallTracerPos, dec_upperHallTracerPos, //Datapath control for upper hall tracer pos.
								  output reg inc_lowerHallTracerPos, dec_lowerHallTracerPos,  //Datapath control for lower hall tracer pos.
								  output reg _clearShip, _updateGraphics);  //Handshake outputs to graphics FSM.
							 
							 
	//State registers.
	reg [2:0] current_state, next_state;
	
	//State values are given names to make them easier to identify.
	localparam S_IDLE = 3'b000,
				  S_CLEAR_SHIP = 3'b001,
				  S_UPDATE_POS_SHIP = 3'b010,
				  S_UPDATE_POS_HALL_TRACERS = 3'b011,
				  S_UPDATE_GRAPHICS = 3'b100,
				  S_UPDATE_OLD_DIR = 3'b101;
				  
	//Next state logic (state table).
	always@(*)
	begin
		case (current_state)
			S_IDLE: next_state = (gameTick == 0) ? S_IDLE : S_CLEAR_SHIP;
			S_CLEAR_SHIP: next_state = (_shipCleared == 0) ? S_CLEAR_SHIP : S_UPDATE_POS_SHIP;
			S_UPDATE_POS_SHIP: next_state = S_UPDATE_POS_HALL_TRACERS;
			S_UPDATE_POS_HALL_TRACERS: next_state = S_UPDATE_GRAPHICS;
			S_UPDATE_GRAPHICS: next_state = (_graphicsDone == 0) ? S_UPDATE_GRAPHICS : S_UPDATE_OLD_DIR;
			S_UPDATE_OLD_DIR: next_state = S_IDLE;
			default: next_state = S_IDLE;
		endcase
	end
	
	//Output logic
	always@(*)
	begin
		
		//All output signals are made 0 by default.
		load_old_dir_reg = 0;
		load_new_dir_reg = 0;
		force_old_dir_0 = 0;
		force_new_dir_0 = 0;
		inc_yShip = 0;
		dec_yShip = 0;
		inc_upperHallTracerPos = 0;
		dec_upperHallTracerPos = 0;
		inc_lowerHallTracerPos = 0;
		dec_lowerHallTracerPos = 0;
		_clearShip = 0;
		_updateGraphics = 0;
		
		
		case (current_state)
			S_IDLE: load_new_dir_reg = 1;
			S_CLEAR_SHIP: _clearShip = 1;
			S_UPDATE_POS_SHIP: begin
									   if (newDir == 0)
								        inc_yShip = 1;
								      else
									     dec_yShip = 1;
							       end
			S_UPDATE_POS_HALL_TRACERS: begin
													if (upperTracerDir == 0)
														inc_upperHallTracerPos = 1;
													else
														dec_upperHallTracerPos = 1;
													if (lowerTracerDir == 0)
														inc_lowerHallTracerPos = 1;
													else
														dec_lowerHallTracerPos = 1; 
												end
			S_UPDATE_GRAPHICS: _updateGraphics = 1;
			S_UPDATE_OLD_DIR: load_old_dir_reg = 1;
			//default: //No default needed as all outputs are assigned a default output of 0 
						  //before the case statement.	
		endcase
	end
	
	//Current state register is set to update at positive clock edge.
	always@(posedge clock)
	begin
		if (reset_n == 0)
			current_state <= S_IDLE;
		else
			current_state <= next_state;
	end
endmodule



//The waveGraphicsController module.
module waveGraphicsController(input newDir, oldDir,	//Game Datapath general inputs.
										input upClearer_done, upDrawer_done,	//Graphics Datapath inputs.
										input downClearer_done, downDrawer_done, //Graphics Datapath inputs.
										input hallwayDrawer_done,  //Graphics Datapath input.
										input screenSlider_done,  //Graphics Datapath input.
										input shipCollision, collisionDetector_done,  //Graphics Datapath inputs.
										input gameOverScreenDrawer_done,  //Graphics datapath input.
										input clock, reset_n,	//General inputs.
										input _clearShip, _updateGraphics,	//Handshake inputs from game FSM.
										output reg start_upShip_clearer, start_upShip_drawer,  //Control to upShip graphics modules in graphics datapath.
										output reg start_downShip_clearer, start_downShip_drawer,  //Control to downShip graphics modules in graphics datapath.
										output reg start_hallwayDrawer,  //Control to hallwayDrawer graphics module in graphics datapath.
										output reg start_screenSlider,  //Control to the screenSlider graphics module in graphics datapath.
										output reg start_collisionDetector,  //Control to the collisionDetector graphics-based module in graphics datapath.
										output reg start_gameOverScreenDrawer,  //Control to the gameOverScreenDrawer module in graphics datapath.
										output reg [3:0] input_select_VGA, //Which drawing module in the graphics datapath affects the screen.
										output reg _shipCleared, _graphicsDone, //Handshake outputs to game FSM.
										output reg gameOver);	
										
	//State registers.
	reg [4:0] current_state, next_state;
	
	//State values are given names to make them easier to identify.
	localparam S_IDLE = 5'b00000,
				  S_START_CLEAR_SHIP = 5'b00001,
				  S_WAIT_UPCLEARER = 5'b00010,
				  S_WAIT_DOWNCLEARER = 5'b00011,
				  S_WAIT_GRAPHICS_UPDATE = 5'b00100,
				  S_START_SLIDE_SCREEN = 5'b00101,
				  S_WAIT_SCREENSLIDER = 5'b00110,
				  S_START_DRAW_HALLWAY = 5'b00111,
				  S_WAIT_HALLWAYDRAWER = 5'b01000,
				  S_START_CHECK_COLLISION = 5'b01001,
				  S_WAIT_COLLISION_CHECKER = 5'b01010,
				  S_COLLISION_OCCURRED = 5'b01011,
				  //
				  S_START_DRAW_GAME_OVER_SCREEN = 5'b01100,
				  S_WAIT_GAME_OVER_SCREEN_DRAWER = 5'b01101,
				  //
				  S_START_DRAW_SHIP = 5'b01110,
				  S_WAIT_UPDRAWER = 5'b01111,
				  S_WAIT_DOWNDRAWER = 5'b10000,
				  S_INFORM_DONE = 5'b10001;
				  
				  
	//Next state logic (state table).
	always@(*)
	begin
		case (current_state)
			S_IDLE: next_state = (_clearShip == 0) ? S_IDLE : S_START_CLEAR_SHIP;
			S_START_CLEAR_SHIP: next_state = (oldDir == 0) ? S_WAIT_DOWNCLEARER : S_WAIT_UPCLEARER;
			S_WAIT_UPCLEARER: next_state = (upClearer_done == 0) ? S_WAIT_UPCLEARER : S_WAIT_GRAPHICS_UPDATE;
			S_WAIT_DOWNCLEARER: next_state = (downClearer_done == 0) ? S_WAIT_DOWNCLEARER : S_WAIT_GRAPHICS_UPDATE;
			S_WAIT_GRAPHICS_UPDATE: next_state = (_updateGraphics == 0) ? S_WAIT_GRAPHICS_UPDATE : S_START_SLIDE_SCREEN;
			S_START_SLIDE_SCREEN: next_state = S_WAIT_SCREENSLIDER;
			S_WAIT_SCREENSLIDER: next_state = (screenSlider_done == 0) ? S_WAIT_SCREENSLIDER: S_START_DRAW_HALLWAY;
			S_START_DRAW_HALLWAY: next_state = S_WAIT_HALLWAYDRAWER;
			S_WAIT_HALLWAYDRAWER: next_state = (hallwayDrawer_done == 0) ? S_WAIT_HALLWAYDRAWER : S_START_CHECK_COLLISION;
			S_START_CHECK_COLLISION: next_state = S_WAIT_COLLISION_CHECKER;
			S_WAIT_COLLISION_CHECKER: begin
											    if (shipCollision == 1)
													next_state = S_COLLISION_OCCURRED;
												 else
													next_state = (collisionDetector_done == 0) ? S_WAIT_COLLISION_CHECKER : S_START_DRAW_SHIP;
											  end
			S_COLLISION_OCCURRED: next_state = S_START_DRAW_GAME_OVER_SCREEN;
			//
			S_START_DRAW_GAME_OVER_SCREEN: next_state = S_WAIT_GAME_OVER_SCREEN_DRAWER;
			S_WAIT_GAME_OVER_SCREEN_DRAWER: next_state = S_WAIT_GAME_OVER_SCREEN_DRAWER;
			
			
			
			//
			S_START_DRAW_SHIP: next_state = (newDir == 0) ? S_WAIT_DOWNDRAWER : S_WAIT_UPDRAWER;
			S_WAIT_UPDRAWER: next_state = (upDrawer_done == 0) ? S_WAIT_UPDRAWER : S_INFORM_DONE;
			S_WAIT_DOWNDRAWER: next_state = (downDrawer_done == 0) ? S_WAIT_DOWNDRAWER : S_INFORM_DONE;
			S_INFORM_DONE: next_state = S_IDLE;
			default: next_state = S_IDLE;
		endcase
	end
	
	//Output logic
	always@(*)
	begin
		
		//All output signals are made 0 by default.
		start_upShip_clearer = 0;
		start_upShip_drawer = 0;
		start_downShip_clearer = 0;
		start_downShip_drawer = 0;
		start_hallwayDrawer = 0;
		start_screenSlider = 0;
		start_collisionDetector = 0;
		start_gameOverScreenDrawer = 0;
		input_select_VGA = 4'b0000;
		_shipCleared = 0;
		_graphicsDone = 0;
		gameOver = 0;
		
		
		case (current_state)
			S_IDLE:	;  //No output signals are used when idling.
			S_START_CLEAR_SHIP: begin
									    if (oldDir == 1)
										    start_upShip_clearer = 1;
										 else
										    start_downShip_clearer = 1;
									  end
			S_WAIT_UPCLEARER: input_select_VGA = 4'b0000;
			S_WAIT_DOWNCLEARER: input_select_VGA = 4'b0001;
			S_WAIT_GRAPHICS_UPDATE: _shipCleared = 1;
			S_START_SLIDE_SCREEN: start_screenSlider = 1;
			S_WAIT_SCREENSLIDER: input_select_VGA = 4'b0101;
	 	   S_START_DRAW_HALLWAY: start_hallwayDrawer = 1;
		   S_WAIT_HALLWAYDRAWER: input_select_VGA = 4'b0100;
			S_START_CHECK_COLLISION: start_collisionDetector = 1;
			S_WAIT_COLLISION_CHECKER: input_select_VGA = 4'b0110;
			S_COLLISION_OCCURRED: gameOver = 1;
			//
			
			
			S_START_DRAW_GAME_OVER_SCREEN: begin
														start_gameOverScreenDrawer = 1;
														gameOver = 1;
													 end
			S_WAIT_GAME_OVER_SCREEN_DRAWER: begin
														 input_select_VGA = 4'b0111;
														 gameOver = 1;
													  end
			//
			S_START_DRAW_SHIP: begin
									   if (newDir == 1)
											start_upShip_drawer = 1;
										else
											start_downShip_drawer = 1;
									 end
			S_WAIT_UPDRAWER: input_select_VGA = 4'b0010;
			S_WAIT_DOWNDRAWER: input_select_VGA = 4'b0011;
			S_INFORM_DONE: _graphicsDone = 1; 
			//default: //No default needed as all outputs are assigned a default output of 0 
						  //before the case statement.	
		endcase
	end
	
	//Current state register is set to update at positive clock edge.
	always@(posedge clock)
	begin
		if (reset_n == 0)
			current_state <= S_IDLE;
		else
			current_state <= next_state;
	end
endmodule


























