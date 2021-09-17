module immediate_17_extender(dataIn, dataOut);

    input [16:0] dataIn;
    output [31:0] dataOut;

    assign dataOut[31] = dataIn[16];
    assign dataOut[30] = dataIn[16];
    assign dataOut[29] = dataIn[16];
    assign dataOut[28] = dataIn[16];
    assign dataOut[27] = dataIn[16];
    assign dataOut[26] = dataIn[16];
    assign dataOut[25] = dataIn[16];
    assign dataOut[24] = dataIn[16];
    assign dataOut[23] = dataIn[16];
    assign dataOut[22] = dataIn[16];
    assign dataOut[21] = dataIn[16];
    assign dataOut[20] = dataIn[16];
    assign dataOut[19] = dataIn[16];
    assign dataOut[18] = dataIn[16];
    assign dataOut[17] = dataIn[16];
    assign dataOut[16:0] = dataIn[16:0];

endmodule