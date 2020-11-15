# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in screenSlider.v to working dir
# could also have multiple verilog files
vlog screenSlider.v

#load simulation using randomTickGenerator as the top level simulation module
vsim screenSlider

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}


#The 50 MHz clock is started.
force {clock} 1 0ns, 0 {10ns} -r 20ns


#For simulation, readColour will be kept at 3'b111.
force {readColour} 3'b111 0ns


#Signals are set to initial values.
force {upperYBound} 7'h77 0ns
force {lowerYBound} 7'h0 0ns

force {upperXBound} 8'h9e 0ns
force {lowerXBound} 8'h0 0ns

force {reset_n} 1 0ns

force {start} 0 0ns


#A reset is performed at t = 0ns
force {reset_n} 0 0ns, 1 5ns


#At t = 20ns, start is set to 1
force {start} 1 18ns


#At t = 60ns, start is set to 0
force {start} 0 58ns




run 10000ns