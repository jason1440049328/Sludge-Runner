module target_27_extender(dataIn, dataOut);

    input [26:0] dataIn;
    output [31:0] dataOut;

    assign dataOut[31] = 1'b0;
    assign dataOut[30] = 1'b0;
    assign dataOut[29] = 1'b0;
    assign dataOut[28] = 1'b0;
    assign dataOut[27] = 1'b0;
    assign dataOut[26:0] = dataIn[26:0];

endmodule