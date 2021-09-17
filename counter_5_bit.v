module counter_5_bit(clk, en, clr, counter_bit0, counter_bit1, counter_bit2, counter_bit3, counter_bit4, counter_bit5);

    input clk, en, clr;
    output counter_bit0, counter_bit1, counter_bit2, counter_bit3, counter_bit4, counter_bit5;
    wire tff_and0, tff_and1, tff_and2, tff_and3, tff_and4;
    wire tff0_qnot, tff1_qnot, tff2_qnot, tff3_qnot, tff4_qnot, tff5_qnot;

    tflipflop tff0(1'b1, clk, clr, 1'b1, counter_bit0, tff0_qnot);
    and tff_and0_gate(tff_and0, 1'b1, counter_bit0);

    tflipflop tff1(tff_and0, clk, clr, 1'b1, counter_bit1, tff1_qnot);
    and tff_and1_gate(tff_and1, tff_and0, counter_bit1);

    tflipflop tff2(tff_and1, clk, clr, 1'b1, counter_bit2, tff2_qnot);
    and tff_and2_gate(tff_and2, tff_and1, counter_bit2);

    tflipflop tff3(tff_and2, clk, clr, 1'b1, counter_bit3, tff3_qnot);
    and tff_and3_gate(tff_and3, tff_and2, counter_bit3);

    tflipflop tff4(tff_and3, clk, clr, 1'b1, counter_bit4, tff4_qnot);
    and tff_and4_gate(tff_and4, tff_and3, counter_bit4);

    tflipflop tff5_gate(tff_and4, clk, clr, 1'b1, counter_bit5, tff5_qnot);

endmodule