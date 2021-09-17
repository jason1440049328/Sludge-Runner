module decoder(select, out);

    input [4:0] select;
    output [31:0] out;
    wire not_select0, not_select1, not_select2, not_select3, not_select4;

    not not0(not_select0, select[0]);
    not not1(not_select1, select[1]);
    not not2(not_select2, select[2]);
    not not3(not_select3, select[3]);
    not not4(not_select4, select[4]);

    and and_0(out[0], not_select4, not_select3, not_select2, not_select1, not_select0);
    and and_1(out[1], not_select4, not_select3, not_select2, not_select1, select[0]);
    and and_2(out[2], not_select4, not_select3, not_select2, select[1], not_select0);
    and and_3(out[3], not_select4, not_select3, not_select2, select[1], select[0]);
    and and_4(out[4], not_select4, not_select3, select[2], not_select1, not_select0);
    and and_5(out[5], not_select4, not_select3, select[2], not_select1, select[0]);
    and and_6(out[6], not_select4, not_select3, select[2], select[1], not_select0);
    and and_7(out[7], not_select4, not_select3, select[2], select[1], select[0]);
    and and_8(out[8], not_select4, select[3], not_select2, not_select1, not_select0);
    and and_9(out[9], not_select4, select[3], not_select2, not_select1, select[0]);
    and and_10(out[10], not_select4, select[3], not_select2, select[1], not_select0);

    and and_11(out[11], not_select4, select[3], not_select2, select[1], select[0]);
    and and_12(out[12], not_select4, select[3], select[2], not_select1, not_select0);
    and and_13(out[13], not_select4, select[3], select[2], not_select1, select[0]);
    and and_14(out[14], not_select4, select[3], select[2], select[1], not_select0);
    and and_15(out[15], not_select4, select[3], select[2], select[1], select[0]);
    and and_16(out[16], select[4], not_select3, not_select2, not_select1, not_select0);
    and and_17(out[17], select[4], not_select3, not_select2, not_select1, select[0]);
    and and_18(out[18], select[4], not_select3, not_select2, select[1], not_select0);
    and and_19(out[19], select[4], not_select3, not_select2, select[1], select[0]);
    and and_20(out[20], select[4], not_select3, select[2], not_select1, not_select0);

    and and_21(out[21], select[4], not_select3, select[2], not_select1, select[0]);
    and and_22(out[22], select[4], not_select3, select[2], select[1], not_select0);
    and and_23(out[23], select[4], not_select3, select[2], select[1], select[0]);
    and and_24(out[24], select[4], select[3], not_select2, not_select1, not_select0);
    and and_25(out[25], select[4], select[3], not_select2, not_select1, select[0]);
    and and_26(out[26], select[4], select[3], not_select2, select[1], not_select0);
    and and_27(out[27], select[4], select[3], not_select2, select[1], select[0]);
    and and_28(out[28], select[4], select[3], select[2], not_select1, not_select0);
    and and_29(out[29], select[4], select[3], select[2], not_select1, select[0]);
    and and_30(out[30], select[4], select[3], select[2], select[1], not_select0);
    and and_31(out[31], select[4], select[3], select[2], select[1], select[0]);

endmodule