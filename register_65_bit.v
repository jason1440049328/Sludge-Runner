module register_65_bit(q, d, clock, enable, clr);

    //65 bit register because I'm choosing to always keep track of the last bit that is shifted out so I don't have to use another register
    //to hold onto them.

    input clock, enable, clr;
    input [64:0] d;
    output [64:0] q;
    
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

    //Addding more dffe's from regfile code to extend to a 65 bit register
    dffe_ref d32(q[32], d[32], clock, enable, clr);
    dffe_ref d33(q[33], d[33], clock, enable, clr);
    dffe_ref d34(q[34], d[34], clock, enable, clr);
    dffe_ref d35(q[35], d[35], clock, enable, clr);
    dffe_ref d36(q[36], d[36], clock, enable, clr);
    dffe_ref d37(q[37], d[37], clock, enable, clr);
    dffe_ref d38(q[38], d[38], clock, enable, clr);
    dffe_ref d39(q[39], d[39], clock, enable, clr);
    dffe_ref d40(q[40], d[40], clock, enable, clr);
    dffe_ref d41(q[41], d[41], clock, enable, clr);
    dffe_ref d42(q[42], d[42], clock, enable, clr);
    dffe_ref d43(q[43], d[43], clock, enable, clr);
    dffe_ref d44(q[44], d[44], clock, enable, clr);
    dffe_ref d45(q[45], d[45], clock, enable, clr);
    dffe_ref d46(q[46], d[46], clock, enable, clr);
    dffe_ref d47(q[47], d[47], clock, enable, clr);
    dffe_ref d48(q[48], d[48], clock, enable, clr);
    dffe_ref d49(q[49], d[49], clock, enable, clr);
    dffe_ref d50(q[50], d[50], clock, enable, clr);
    dffe_ref d51(q[51], d[51], clock, enable, clr);
    dffe_ref d52(q[52], d[52], clock, enable, clr);
    dffe_ref d53(q[53], d[53], clock, enable, clr);
    dffe_ref d54(q[54], d[54], clock, enable, clr);
    dffe_ref d55(q[55], d[55], clock, enable, clr);
    dffe_ref d56(q[56], d[56], clock, enable, clr);
    dffe_ref d57(q[57], d[57], clock, enable, clr);
    dffe_ref d58(q[58], d[58], clock, enable, clr);
    dffe_ref d59(q[59], d[59], clock, enable, clr);
    dffe_ref d60(q[60], d[60], clock, enable, clr);
    dffe_ref d61(q[61], d[61], clock, enable, clr);
    dffe_ref d62(q[62], d[62], clock, enable, clr);
    dffe_ref d63(q[63], d[63], clock, enable, clr);
    dffe_ref d64(q[64], d[64], clock, enable, clr);

endmodule