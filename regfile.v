module regfile(clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB, reg10_out, reg12_out, reg1_reset, reg2_reset, reg3_reset);
    
    //Custom inputs and outputs
    input reg1_reset, reg2_reset, reg3_reset;
    output [31:0] reg10_out, reg12_out;
    
    input clock, ctrl_writeEnable, ctrl_reset;
    input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    input [31:0] data_writeReg;
    output [31:0] data_readRegA, data_readRegB;
    wire [31:0] decode_1_out, decode_2_out, decode_3_out;
    wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31;
    wire [31:0] reg0_out, reg1_out, reg2_out, reg3_out, reg4_out, reg5_out, reg6_out, reg7_out, reg8_out, reg9_out;
    wire [31:0] reg11_out, reg13_out, reg14_out, reg15_out, reg16_out, reg17_out, reg18_out, reg19_out, reg20_out;
    wire [31:0] reg21_out, reg22_out, reg23_out, reg24_out, reg25_out, reg26_out, reg27_out, reg28_out, reg29_out, reg30_out, reg31_out;

    //Code here for constructing register file

    //Declare inputs/outputs for decoders
    decoder decode_writeReg(ctrl_writeReg, decode_1_out);
    decoder decode_readRegA(ctrl_readRegA, decode_2_out);
    decoder decide_readRegB(ctrl_readRegB, decode_3_out);

    //Make AND gates for computing first decoder and enable
    and and0(w0, decode_1_out[0], ctrl_writeEnable);
    and and1(w1, decode_1_out[1], ctrl_writeEnable);
    and and2(w2, decode_1_out[2], ctrl_writeEnable);
    and and3(w3, decode_1_out[3], ctrl_writeEnable);
    and and4(w4, decode_1_out[4], ctrl_writeEnable);
    and and5(w5, decode_1_out[5], ctrl_writeEnable);
    and and6(w6, decode_1_out[6], ctrl_writeEnable);
    and and7(w7, decode_1_out[7], ctrl_writeEnable);
    and and8(w8, decode_1_out[8], ctrl_writeEnable);
    and and9(w9, decode_1_out[9], ctrl_writeEnable);
    and and10(w10, decode_1_out[10], ctrl_writeEnable);
    and and11(w11, decode_1_out[11], ctrl_writeEnable);
    and and12(w12, decode_1_out[12], ctrl_writeEnable);
    and and13(w13, decode_1_out[13], ctrl_writeEnable);
    and and14(w14, decode_1_out[14], ctrl_writeEnable);
    and and15(w15, decode_1_out[15], ctrl_writeEnable);
    and and16(w16, decode_1_out[16], ctrl_writeEnable);
    and and17(w17, decode_1_out[17], ctrl_writeEnable);
    and and18(w18, decode_1_out[18], ctrl_writeEnable);
    and and19(w19, decode_1_out[19], ctrl_writeEnable);
    and and20(w20, decode_1_out[20], ctrl_writeEnable);
    and and21(w21, decode_1_out[21], ctrl_writeEnable);
    and and22(w22, decode_1_out[22], ctrl_writeEnable);
    and and23(w23, decode_1_out[23], ctrl_writeEnable);
    and and24(w24, decode_1_out[24], ctrl_writeEnable);
    and and25(w25, decode_1_out[25], ctrl_writeEnable);
    and and26(w26, decode_1_out[26], ctrl_writeEnable);
    and and27(w27, decode_1_out[27], ctrl_writeEnable);
    and and28(w28, decode_1_out[28], ctrl_writeEnable);
    and and29(w29, decode_1_out[29], ctrl_writeEnable);
    and and30(w30, decode_1_out[30], ctrl_writeEnable);
    and and31(w31, decode_1_out[31], ctrl_writeEnable);


    //Instantiate all 32 registers
    register reg0(reg0_out, 32'b0, ~clock, ctrl_writeEnable, ctrl_reset); //Special case for reg0 where you can't write data in
    register reg1(reg1_out, data_writeReg, ~clock, w1, ctrl_reset || reg1_reset);
    register reg2(reg2_out, data_writeReg, ~clock, w2, ctrl_reset || reg2_reset);
    register reg3(reg3_out, data_writeReg, ~clock, w3, ctrl_reset || reg3_reset);
    register reg4(reg4_out, data_writeReg, ~clock, w4, ctrl_reset);
    register reg5(reg5_out, data_writeReg, ~clock, w5, ctrl_reset);
    register reg6(reg6_out, data_writeReg, ~clock, w6, ctrl_reset);
    register reg7(reg7_out, data_writeReg, ~clock, w7, ctrl_reset);
    register reg8(reg8_out, data_writeReg, ~clock, w8, ctrl_reset);
    register reg9(reg9_out, data_writeReg, ~clock, w9, ctrl_reset);
    register reg10(reg10_out, data_writeReg, ~clock, w10, ctrl_reset);
    register reg11(reg11_out, data_writeReg, ~clock, w11, ctrl_reset);
    register reg12(reg12_out, data_writeReg, ~clock, w12, ctrl_reset);
    register reg13(reg13_out, data_writeReg, ~clock, w13, ctrl_reset);
    register reg14(reg14_out, data_writeReg, ~clock, w14, ctrl_reset);
    register reg15(reg15_out, data_writeReg, ~clock, w15, ctrl_reset);
    register reg16(reg16_out, data_writeReg, ~clock, w16, ctrl_reset);
    register reg17(reg17_out, data_writeReg, ~clock, w17, ctrl_reset);
    register reg18(reg18_out, data_writeReg, ~clock, w18, ctrl_reset);
    register reg19(reg19_out, data_writeReg, ~clock, w19, ctrl_reset);
    register reg20(reg20_out, data_writeReg, ~clock, w20, ctrl_reset);
    register reg21(reg21_out, data_writeReg, ~clock, w21, ctrl_reset);
    register reg22(reg22_out, data_writeReg, ~clock, w22, ctrl_reset);
    register reg23(reg23_out, data_writeReg, ~clock, w23, ctrl_reset);
    register reg24(reg24_out, data_writeReg, ~clock, w24, ctrl_reset);
    register reg25(reg25_out, data_writeReg, ~clock, w25, ctrl_reset);
    register reg26(reg26_out, data_writeReg, ~clock, w26, ctrl_reset);
    register reg27(reg27_out, data_writeReg, ~clock, w27, ctrl_reset);
    register reg28(reg28_out, data_writeReg, ~clock, w28, ctrl_reset);
    register reg29(reg29_out, data_writeReg, ~clock, w29, ctrl_reset);
    register reg30(reg30_out, data_writeReg, ~clock, w30, ctrl_reset);
    register reg31(reg31_out, data_writeReg, ~clock, w31, ctrl_reset);

    //Instantiate Tri-State Buffers for data_readRegA
    tri_buffer tri_A0(reg0_out, decode_2_out[0], data_readRegA);
    tri_buffer tri_A1(reg1_out, decode_2_out[1], data_readRegA);
    tri_buffer tri_A2(reg2_out, decode_2_out[2], data_readRegA);
    tri_buffer tri_A3(reg3_out, decode_2_out[3], data_readRegA);
    tri_buffer tri_A4(reg4_out, decode_2_out[4], data_readRegA);
    tri_buffer tri_A5(reg5_out, decode_2_out[5], data_readRegA);
    tri_buffer tri_A6(reg6_out, decode_2_out[6], data_readRegA);
    tri_buffer tri_A7(reg7_out, decode_2_out[7], data_readRegA);
    tri_buffer tri_A8(reg8_out, decode_2_out[8], data_readRegA);
    tri_buffer tri_A9(reg9_out, decode_2_out[9], data_readRegA);
    tri_buffer tri_A10(reg10_out, decode_2_out[10], data_readRegA);
    tri_buffer tri_A11(reg11_out, decode_2_out[11], data_readRegA);
    tri_buffer tri_A12(reg12_out, decode_2_out[12], data_readRegA);
    tri_buffer tri_A13(reg13_out, decode_2_out[13], data_readRegA);
    tri_buffer tri_A14(reg14_out, decode_2_out[14], data_readRegA);
    tri_buffer tri_A15(reg15_out, decode_2_out[15], data_readRegA);
    tri_buffer tri_A16(reg16_out, decode_2_out[16], data_readRegA);
    tri_buffer tri_A17(reg17_out, decode_2_out[17], data_readRegA);
    tri_buffer tri_A18(reg18_out, decode_2_out[18], data_readRegA);
    tri_buffer tri_A19(reg19_out, decode_2_out[19], data_readRegA);
    tri_buffer tri_A20(reg20_out, decode_2_out[20], data_readRegA);
    tri_buffer tri_A21(reg21_out, decode_2_out[21], data_readRegA);
    tri_buffer tri_A22(reg22_out, decode_2_out[22], data_readRegA);
    tri_buffer tri_A23(reg23_out, decode_2_out[23], data_readRegA);
    tri_buffer tri_A24(reg24_out, decode_2_out[24], data_readRegA);
    tri_buffer tri_A25(reg25_out, decode_2_out[25], data_readRegA);
    tri_buffer tri_A26(reg26_out, decode_2_out[26], data_readRegA);
    tri_buffer tri_A27(reg27_out, decode_2_out[27], data_readRegA);
    tri_buffer tri_A28(reg28_out, decode_2_out[28], data_readRegA);
    tri_buffer tri_A29(reg29_out, decode_2_out[29], data_readRegA);
    tri_buffer tri_A30(reg30_out, decode_2_out[30], data_readRegA);
    tri_buffer tri_A31(reg31_out, decode_2_out[31], data_readRegA);

    //Instantiate Tri-State Buffers for data_readRegB
    tri_buffer tri_B0(reg0_out, decode_3_out[0], data_readRegB);
    tri_buffer tri_B1(reg1_out, decode_3_out[1], data_readRegB);
    tri_buffer tri_B2(reg2_out, decode_3_out[2], data_readRegB);
    tri_buffer tri_B3(reg3_out, decode_3_out[3], data_readRegB);
    tri_buffer tri_B4(reg4_out, decode_3_out[4], data_readRegB);
    tri_buffer tri_B5(reg5_out, decode_3_out[5], data_readRegB);
    tri_buffer tri_B6(reg6_out, decode_3_out[6], data_readRegB);
    tri_buffer tri_B7(reg7_out, decode_3_out[7], data_readRegB);
    tri_buffer tri_B8(reg8_out, decode_3_out[8], data_readRegB);
    tri_buffer tri_B9(reg9_out, decode_3_out[9], data_readRegB);
    tri_buffer tri_B10(reg10_out, decode_3_out[10], data_readRegB);
    tri_buffer tri_B11(reg11_out, decode_3_out[11], data_readRegB);
    tri_buffer tri_B12(reg12_out, decode_3_out[12], data_readRegB);
    tri_buffer tri_B13(reg13_out, decode_3_out[13], data_readRegB);
    tri_buffer tri_B14(reg14_out, decode_3_out[14], data_readRegB);
    tri_buffer tri_B15(reg15_out, decode_3_out[15], data_readRegB);
    tri_buffer tri_B16(reg16_out, decode_3_out[16], data_readRegB);
    tri_buffer tri_B17(reg17_out, decode_3_out[17], data_readRegB);
    tri_buffer tri_B18(reg18_out, decode_3_out[18], data_readRegB);
    tri_buffer tri_B19(reg19_out, decode_3_out[19], data_readRegB);
    tri_buffer tri_B20(reg20_out, decode_3_out[20], data_readRegB);
    tri_buffer tri_B21(reg21_out, decode_3_out[21], data_readRegB);
    tri_buffer tri_B22(reg22_out, decode_3_out[22], data_readRegB);
    tri_buffer tri_B23(reg23_out, decode_3_out[23], data_readRegB);
    tri_buffer tri_B24(reg24_out, decode_3_out[24], data_readRegB);
    tri_buffer tri_B25(reg25_out, decode_3_out[25], data_readRegB);
    tri_buffer tri_B26(reg26_out, decode_3_out[26], data_readRegB);
    tri_buffer tri_B27(reg27_out, decode_3_out[27], data_readRegB);
    tri_buffer tri_B28(reg28_out, decode_3_out[28], data_readRegB);
    tri_buffer tri_B29(reg29_out, decode_3_out[29], data_readRegB);
    tri_buffer tri_B30(reg30_out, decode_3_out[30], data_readRegB);
    tri_buffer tri_B31(reg31_out, decode_3_out[31], data_readRegB);

endmodule
