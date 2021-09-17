module sll_1_bit(data, result);

    input [63:0] data;
    output [63:0] result;

    assign result[0] = 1'b0;
    assign result[63:1] = data[62:0];

endmodule