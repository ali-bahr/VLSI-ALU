#------------------------------------------#
# Design Constraints
#------------------------------------------#

# Define a virtual clock for I/O timing constraints
create_clock -name virtual_clock -period 20 

# Set input delay constraints relative to the virtual clock
set_input_delay 1 [all_inputs] -clock virtual_clock

# Set output delay constraints relative to the virtual clock
set_output_delay 0.5 [all_outputs] -clock virtual_clock

# Define the load for output pins (in terms of capacitance)
set_load 10 [all_outputs]



# Enable usage of all library cells
set_max_area 0


