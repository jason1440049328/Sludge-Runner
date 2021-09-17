module decoder_mult(select, addM, add2M, subM, sub2M, doNothing);

    input [2:0] select;
    output addM, add2M, subM, sub2M, doNothing;

    wire not_select0, not_select1, not_select2;
    wire bit0_out, bit1_out, bit2_out, bit3_out, bit4_out, bit5_out, bit6_out, bit7_out;

    //Make complements of the inputs
    not not0(not_select0, select[0]);
    not not1(not_select1, select[1]);
    not not2(not_select2, select[2]);

    //Logic to calculate each bit out of the decoder
    and bit0(bit0_out, not_select2, not_select1, not_select0);
    and bit1(bit1_out, not_select2, not_select1, select[0]);
    and bit2(bit2_out, not_select2, select[1], not_select0);
    and bit3(bit3_out, not_select2, select[1], select[0]);
    and bit4(bit4_out, select[2], not_select1, not_select0);
    and bit5(bit5_out, select[2], not_select1, select[0]);
    and bit6(bit6_out, select[2], select[1], not_select0);
    and bit7(bit7_out, select[2], select[1], select[0]);

    //Condense addM, subM, and doNothing before the final output
    or or_doNothing(doNothing, bit0_out, bit7_out);
    or or_addM(addM, bit1_out, bit2_out);
    or or_subM(subM, bit5_out, bit6_out);
    assign add2M = bit3_out;
    assign sub2M = bit4_out;

endmodule