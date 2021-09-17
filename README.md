# Sludge Runner Final Project

This was my final project for my Digital Systems class. I implemented a obstacle-avoidance game with the goal of racing to the finish line as fast as possible. Controls are interfaced through a NexysA7 FPGA and visual components output through a VGA screen. Logic is controlled through in game collision logic as well as MIPS assembly code for execution during certain conditions. **Certain parts of the processor have been removed/broken on purpose due to ongoing coursework that I TA for that involve students building their own implementation of a multi-cycle pipelined processor.**


### Processor Implementation

My implementation is a multi-cycle pipelined processor. All instructions in the ROM move through the pipeline and take 5 cycles to settle. There is standard bypassing from instructions in the X/M and M/W latch for instructions in the D/X latch to use if the D/X instruction uses the same destination regsiter for its RS and RT fields. All branches and jumps are taken at the D/X stage. 

For the modules within:

* Carry-lookahead adder used within the ALU, and used throughout for PC+1 calculations

* Mult/Div Module uses advanced boothe's algorithm for Mult and non-restoring algorithm for the division module. 

* Register files are standard. Register $0 is always 0 and never write enabled, as well as $30 being the status register written to for an overflow or a SetX instruction. Register $31 is the PC register for PC+1 storage on a JAL instruction. 

**Clocking**

The clocking for all modules are:

* RegFile: falling edge
* ROM Module: falling edge
* RAM Module: falling edge
* PC Register: rising edge
* F/D Latch, D/X Latch, X/M Latch, M/W Latch: rising edge

**How to Use**

The top level module is Wrapper.v, with an accompanying Wrapper_tb.v testbench for , and is responsible for interfacing with ROM.v, RAM.v, and Processor.v. Load instructions to the ROM module, modify ROM.v's depth as well as put the direct path of the .mem instruction file into Wrapper.v to interface with the ROM. Clock the testbench accordingly to test. 