# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in addressTranslator.v to working dir
# could also have multiple verilog files
vlog addressTranslator.v

#load simulation using randomTickGenerator as the top level simulation module
vsim addressTranslator

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}



#An x and y of 0 is tested at t = 10ns
force {x} 8'b 00000000 10ns
force {y} 7'b 0000000 10ns


#An x of 159 and a y of 0 is tested at t = 20ns
force {x} 8'b10011111 20ns
force {y} 7'b0000000 20ns


#An x of 1 and a y of 3 is tested at t = 30ns
force {x} 8'b00000001 30ns
force {y} 7'b0000011 30ns


#An x of 159 and a y of 119 is tested at t = 40ns
force {x} 8'b10011111 40ns
force {y} 7'b1110111 40ns



run 50ns