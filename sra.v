module sra(operandA, result);

    input [64:0] operandA;
    output [64:0] result;

    assign result[64] = operandA[64];
    assign result[63] = operandA[64];
    assign result[62:0] = operandA[64:2];

endmodule