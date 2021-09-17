module register(q, d, clock, enable, clr);

    input clock, enable, clr;
    input [31:0] d;
    output [31:0] q;
    
    //String Flip Flops Together
    dffe_ref d0(q[0], d[0], clock, enable, clr);
    dffe_ref d1(q[1], d[1], clock, enable, clr);
    dffe_ref d2(q[2], d[2], clock, enable, clr);
    dffe_ref d3(q[3], d[3], clock, enable, clr);
    dffe_ref d4(q[4], d[4], clock, enable, clr);
    dffe_ref d5(q[5], d[5], clock, enable, clr);
    dffe_ref d6(q[6], d[6], clock, enable, clr);
    dffe_ref d7(q[7], d[7], clock, enable, clr);
    dffe_ref d8(q[8], d[8], clock, enable, clr);
    dffe_ref d9(q[9], d[9], clock, enable, clr);
    dffe_ref d10(q[10], d[10], clock, enable, clr);
    dffe_ref d11(q[11], d[11], clock, enable, clr);
    dffe_ref d12(q[12], d[12], clock, enable, clr);
    dffe_ref d13(q[13], d[13], clock, enable, clr);
    dffe_ref d14(q[14], d[14], clock, enable, clr);
    dffe_ref d15(q[15], d[15], clock, enable, clr);
    dffe_ref d16(q[16], d[16], clock, enable, clr);
    dffe_ref d17(q[17], d[17], clock, enable, clr);
    dffe_ref d18(q[18], d[18], clock, enable, clr);
    dffe_ref d19(q[19], d[19], clock, enable, clr);
    dffe_ref d20(q[20], d[20], clock, enable, clr);
    dffe_ref d21(q[21], d[21], clock, enable, clr);
    dffe_ref d22(q[22], d[22], clock, enable, clr);
    dffe_ref d23(q[23], d[23], clock, enable, clr);
    dffe_ref d24(q[24], d[24], clock, enable, clr);
    dffe_ref d25(q[25], d[25], clock, enable, clr);
    dffe_ref d26(q[26], d[26], clock, enable, clr);
    dffe_ref d27(q[27], d[27], clock, enable, clr);
    dffe_ref d28(q[28], d[28], clock, enable, clr);
    dffe_ref d29(q[29], d[29], clock, enable, clr);
    dffe_ref d30(q[30], d[30], clock, enable, clr);
    dffe_ref d31(q[31], d[31], clock, enable, clr);

endmodule
