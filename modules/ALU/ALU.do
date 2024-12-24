vsim -gui work.ALU

radix hex;

add wave -position end  sim:/ALU/A
add wave -position end  sim:/ALU/B
add wave -position end  sim:/ALU/selector
add wave -position end  sim:/ALU/Result
add wave -position end  sim:/ALU/carry
add wave -position end  sim:/ALU/add_result
add wave -position end  sim:/ALU/mult_result
add wave -position end  sim:/ALU/temp_carry

-- Floating Point 
-- ADD (3 + 2)
force -freeze sim:/ALU/A 40400000 0 
force -freeze sim:/ALU/B 40000000 0
force -freeze sim:/ALU/selector 0 0

-- ADD with overflow (carry)
-- force -freeze sim:/ALU/A 4294967295 20
-- force -freeze sim:/ALU/B 5 20

-- ADD with Floating Point (20.5 + 12.6)
force -freeze sim:/ALU/A 41A40000 40
force -freeze sim:/ALU/B 4149999A 40


-- Multiplication 
-- force -freeze sim:/ALU/A 500 60
-- force -freeze sim:/ALU/B 5 60
-- force -freeze sim:/ALU/selector 1 60

-- Multiplication with negative
-- force -freeze sim:/ALU/A -1 80
-- force -freeze sim:/ALU/B 500 80

run 80ps