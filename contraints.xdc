## Contraints file, most package pins are assigned during Implementation stage, clocking is from Lab5
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets testing_wire_IBUF]

##Reset
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports reset]

##RGBOutputs
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[11]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[10]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[9]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[8]}]

set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[7]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[6]}]
set_property -dict {PACKAGE_PIN B6 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[5]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[4]}]

set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[3]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[2]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[1]}]
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS33} [get_ports {RGB_Out[0]}]

set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports hSync]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports vSync]

##Ports for Controls
set_property IOSTANDARD LVCMOS33 [get_ports left]
set_property PACKAGE_PIN P17 [get_ports left]
set_property IOSTANDARD LVCMOS33 [get_ports right]
set_property PACKAGE_PIN M17 [get_ports right]
set_property IOSTANDARD LVCMOS33 [get_ports fast_speed]
set_property PACKAGE_PIN N17 [get_ports fast_speed]
set_property IOSTANDARD LVCMOS33 [get_ports turbo_speed]
set_property PACKAGE_PIN M18 [get_ports turbo_speed]

set_property IOSTANDARD LVCMOS33 [get_ports add_point]
set_property PACKAGE_PIN V11 [get_ports add_point]

set_property PACKAGE_PIN T10 [get_ports segA]
set_property PACKAGE_PIN R10 [get_ports segB]
set_property PACKAGE_PIN K16 [get_ports segC]
set_property PACKAGE_PIN K13 [get_ports segD]
set_property PACKAGE_PIN P15 [get_ports segE]
set_property PACKAGE_PIN T11 [get_ports segF]
set_property PACKAGE_PIN L18 [get_ports segG]
set_property PACKAGE_PIN J17 [get_ports an0]
set_property PACKAGE_PIN H15 [get_ports dp0]
set_property IOSTANDARD LVCMOS33 [get_ports an0]
set_property IOSTANDARD LVCMOS33 [get_ports dp0]
set_property IOSTANDARD LVCMOS33 [get_ports segA]
set_property IOSTANDARD LVCMOS33 [get_ports segB]
set_property IOSTANDARD LVCMOS33 [get_ports segC]
set_property IOSTANDARD LVCMOS33 [get_ports segD]
set_property IOSTANDARD LVCMOS33 [get_ports segE]
set_property IOSTANDARD LVCMOS33 [get_ports segF]
set_property IOSTANDARD LVCMOS33 [get_ports segG]


set_property PACKAGE_PIN P18 [get_ports testing_wire]
set_property IOSTANDARD LVCMOS33 [get_ports testing_wire]
