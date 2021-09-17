`timescale 1 ns / 100 ps
module Wrapper_tb();

    reg clock, reset;

    Wrapper pipelined_processor(.clock(clock), .reset(reset));

    initial begin
        clock = 0;
        reset = 0;

	    // Set a time delay, in nanoseconds
        #10000;

	    // Ends the testbench
        $finish;
    end

    always
        #20 clock = ~clock;

    initial begin
        //Output filename
        $dumpfile("Wrapper.vcd");

        //Module to capture and what level, 0 means all wires
        $dumpvars(0, Wrapper_tb);
    end

endmodule