# TCL File Generated by Component Editor 18.1
# Sun Aug 16 00:03:01 CEST 2020
# DO NOT MODIFY


# 
# PWM4 "Four line PWM with editable prescaler and fill" v1.0
# Norbert Ligas 2020.08.16.00:03:01
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module PWM4
# 
set_module_property DESCRIPTION ""
set_module_property NAME PWM4
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP PWM
set_module_property AUTHOR "Norbert Ligas"
set_module_property DISPLAY_NAME "Four line PWM with editable prescaler and fill"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL PWM4
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file PWM4.vhd VHDL PATH ../PWM4/PWM4.vhd TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL PWM4
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file PWM4.vhd VHDL PATH ../PWM4/PWM4.vhd

add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL PWM4
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file PWM4.vhd VHDL PATH ../PWM4/PWM4.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point PWM4
# 
add_interface PWM4 avalon end
set_interface_property PWM4 addressUnits WORDS
set_interface_property PWM4 associatedClock clock
set_interface_property PWM4 associatedReset reset
set_interface_property PWM4 bitsPerSymbol 8
set_interface_property PWM4 burstOnBurstBoundariesOnly true
set_interface_property PWM4 burstcountUnits WORDS
set_interface_property PWM4 explicitAddressSpan 0
set_interface_property PWM4 holdTime 0
set_interface_property PWM4 linewrapBursts true
set_interface_property PWM4 maximumPendingReadTransactions 0
set_interface_property PWM4 maximumPendingWriteTransactions 0
set_interface_property PWM4 readLatency 1
set_interface_property PWM4 readWaitStates 0
set_interface_property PWM4 readWaitTime 0
set_interface_property PWM4 setupTime 0
set_interface_property PWM4 timingUnits Cycles
set_interface_property PWM4 writeWaitTime 0
set_interface_property PWM4 ENABLED true
set_interface_property PWM4 EXPORT_OF ""
set_interface_property PWM4 PORT_NAME_MAP ""
set_interface_property PWM4 CMSIS_SVD_VARIABLES ""
set_interface_property PWM4 SVD_ADDRESS_GROUP ""

add_interface_port PWM4 address address Input 3
add_interface_port PWM4 byteenable byteenable Input 4
add_interface_port PWM4 read read Input 1
add_interface_port PWM4 readdata readdata Output 32
add_interface_port PWM4 write write Input 1
add_interface_port PWM4 writedata writedata Input 32
set_interface_assignment PWM4 embeddedsw.configuration.isFlash 0
set_interface_assignment PWM4 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment PWM4 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment PWM4 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point pwm
# 
add_interface pwm conduit end
set_interface_property pwm associatedClock clock
set_interface_property pwm associatedReset ""
set_interface_property pwm ENABLED true
set_interface_property pwm EXPORT_OF ""
set_interface_property pwm PORT_NAME_MAP ""
set_interface_property pwm CMSIS_SVD_VARIABLES ""
set_interface_property pwm SVD_ADDRESS_GROUP ""

add_interface_port pwm pwm pwm Output 4

