# Endless-Wave
A Verilog implementation of Geometry Dash's "Wave Mode" for the Altera SoC FPGA.


This was the final project for a course on Verilog and logic circuits. It was completed with a partner over a three-week period between November and December of 2019.

Geometry Dash, a popular timing/rhythm game for mobile and PC, contains several gamemodes within it involving precision timing. One of the most popular (and notoriously difficult) is the "Wave Mode." In "Wave Mode", the player must navigate through a series of side-scrolling hallways and obstacles. The catch is that the player can only move diagonally up or diagonally down, and can toggle between the two (movement cannot be stopped). The game ends if the player successfully navigates to the end of the level, or if they collide with a wall or obstacle.

This implementation of "Wave Mode" is for the Altera SoC FPGA (it was programmed specifically for the DE1-SoC), and as such contains notable differences from the real "Wave Mode." These are as follows:

* Rather than traversing through pre-made levels, in this implementation the levels are endless and are generated procedurally (using a random seed selected from a countdown timer value, which is loaded into the level generator when the game is reset)

* Instead of navigating through hallways and around obstacles, in this version the player must only navigate through hallways. This was done to simplify the game design, given the time constraints of the project. It is the shape of these hallways that is procedurally generated as the game runs, thus creating the levels at run-time.

* In this version, given it is endless there is a score associated with how far a player makes it into the level, rather than the binary "success" or "failure" for passing a level present in the real "Wave Mode."

In order to run the game, you must have a DE1-SoC Hardware Board (FPGA), as well as a computer running the Quartus Prime software. The game files must be programmed onto the FPGA within Quartus Prime. This can be done by opening up the Quartus Prime project file "waveGameFinal.qpf", selecting "Tools" from the top menu, and then choosing "Programmer" in the drop-down list that appears (make sure the FPGA is plugged into the computer running Quartus Prime). Also, you must have a VGA-compatible monitor to connect to the board, as the game's graphics are displayed using the board's VGA output.

Once the game is loaded onto the board, it will begin running immediately. It can be played as follows:

1. Toggle KEY[3] (the leftmost push-button on the board) to reset the game. Get ready, as the game will commence immediately following the toggling.

2. Control the direction the ship (the large diagonal arrow) moves using KEY[0] (the rightmost push-button on the board). When the button is not being pressed, the ship will move down and to the right on a diagonal. By holding the button down, the ship will move up and to the right on a diagonal.

3. Try to keep the ship from colliding with the edges of the hallway (drawn in white). As you make your way through the level, notice the incrementing counter value shown on the board's HEX displays. This is your current score.

4. When you eventually collide with the hallway edges, note your score and then hit the reset button (KEY[3]) to play again.


Have fun!!!
