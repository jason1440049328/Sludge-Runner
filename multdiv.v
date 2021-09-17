module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    //dataOperandA = Multiplicand (top), dataOperandB = Multiplier (bottom)

    //All wires for multiplication
    wire addM_wire, add2M_wire, subM_wire, sub2M_wire, doNothing_wire;
    wire or_add2M_sub2M_wire, or_sub_for_NOT_wire;
    wire or_cin_wire, ovf_from_cla, ovf_bits_mult, mult_exception;

    //All wires for division and any shared wires for extra register
    wire [31:0] not_data_operandB, not_data_operandA, output_from_divisor_CLA, output_from_dividend_CLA, mux_divisor_out, mux_dividend_out, not_mux_divisor_out, output_from_main_sub_CLA, output_from_main_add_CLA;
    wire [31:0] sub_or_add_wire, not_input_div_register, output_from_final_CLA, div_quotient_wire, mult_div_mux_wire;
    wire [63:0] full_dividend_bits, full_add_sub_combined_wire, input_div_register, output_div_register, shifted_output_from_div_reg;
    wire dummy_ovf_wire1, dummy_ovf_wire2, dummy_ovf_wire3, dummy_ovf_wire4, dummy_ovf_wire5, divisor_zero_wire;

    wire zero_or_one_wire, thirtytwo, notthirtytwo, xor_wire, or_ctrlmd_wire, ctrl_reg_out_wire, thirtythree, eighteen, notthirtythree, noteighteen, wire_or_not_seventeen_eighteen, wire_or_not_thirtytwo_thirtythree;
    wire not_counter_0, not_counter_1, not_counter_2, not_counter_3, not_counter_4, not_counter_5, first, notfirst, seventeen, notseventeen, ovf_bits_mult_inv, or_ovf_wire_top, boundary_bits_wire, or_ovf_wire1, or_ovf_wire2, or_ovf_wire3, nor_ovf_wire1, and_ovf_wire1, and_ovf_wire2;

    //Decoder 
    decoder_mult boothe_decoder(output_from_register[2:0], addM_wire, add2M_wire, subM_wire, sub2M_wire, doNothing_wire);

    //dataOperandA flow from top down to before going into adder
    //Shift or not for Multiplicand
    or or_2M_for_shift(or_add2M_sub2M_wire, add2M_wire, sub2M_wire);
    mux_2_32_bit mux_for_shift(shiftA_wire, or_add2M_sub2M_wire, data_operandA, data_operandA << 1);

    //Take NOT of Multiplicand or not
    or or_sub_for_NOT(or_sub_for_NOT_wire, subM_wire, sub2M_wire);
    bitwise_not not_dataA(shiftA_wire, shiftA_notA_wire);
    mux_2_32_bit mux_for_not(shift_and_NOT_output, or_sub_for_NOT_wire, shiftA_wire, shiftA_notA_wire);

    //Check doNothing, if on, add 32 bits of 0s instead of operand
    mux_2_32_bit doNothing_mux(output_OperandA_before_CLA, doNothing_wire, shift_and_NOT_output, 32'b0);

    //32-bit CLA Declaration with Cin logic and inputs
    or or_cin(or_cin_wire, subM_wire, sub2M_wire);
    CLA_32bit cla(output_from_register[64:33], output_OperandA_before_CLA, or_cin_wire, cla_output_wire, ovf_from_cla);

    //Make wire from multiplier, then merge CLA's result with multiplier
    assign full_multiplier_wire[32:1] = data_operandB[31:0];
    assign full_multiplier_wire[0] = 1'b0;
    mux_2_33_bit mux_multi(mux_multi_wire, notfirst, full_multiplier_wire, output_from_register[32:0]);

    assign combined_CLA_and_multiplier[64:33] = cla_output_wire[31:0];
    assign combined_CLA_and_multiplier[32:0] = mux_multi_wire[32:0];

    //Flow into register, arithmetic right shift or don't shift first
    sra sra_shifter(combined_CLA_and_multiplier, output_from_shifter);
    mux_2_65_bit mux_65(input_into_register, notfirst, combined_CLA_and_multiplier, output_from_shifter);

    register_65_bit main_reg(output_from_register, input_into_register, clock, notseventeen, ctrl_MULT); 

    //Clock logic for 1st time, and last time (16cycles + 1 for input to output into data_Result = 17 Cycles before result is ready)
    counter_5_bit mult_counter(clock, 1'b1, or_ctrlmd_wire, counter_bit0_wire, counter_bit1_wire, counter_bit2_wire, counter_bit3_wire, counter_bit4_wire, counter_bit5_wire);

    //Calculation for first clock cycle
    not not_0(not_counter_0, counter_bit0_wire);
    not not_1(not_counter_1, counter_bit1_wire);
    not not_5(not_counter_5, counter_bit5_wire);
    and and_first(first, not_counter_0, not_counter_1, not_counter_2, not_counter_3, not_counter_4, not_counter_5);
    not not_first_gate(notfirst, first);

    //Calculation for last mult cycle
    and and_last(seventeen, counter_bit0_wire, not_counter_1, not_counter_2, not_counter_3, counter_bit4_wire, not_counter_5);
    not not_seventeen_gate(notseventeen, seventeen);

    //and and_eighteen(eighteen, not_counter_0, counter_bit1_wire, not_counter_2, not_counter_3, counter_bit4_wire, not_counter_5);
    //not not_eighteen_gate(noteighteen, eighteen);

    //or last_mult_cycle_stall(wire_or_not_seventeen_eighteen, notseventeen, noteighteen);

    //Calculation for last div clock cycle
    and and_thirtytwo(thirtytwo, not_counter_0, not_counter_1, not_counter_2, not_counter_3, not_counter_4, counter_bit5_wire);
    not not_thirty_two_gate(notthirtytwo, thirtytwo);

    //and and_thirtythree(thirtythree, counter_bit0_wire, not_counter_1, not_counter_2, not_counter_3, not_counter_4, counter_bit5_wire);
    //not not_thirty_three_gate(notthirtythree, thirtythree);

    //or last_div_cycle_stall(wire_or_not_thirtytwo_thirtythree, notthirtytwo, notthirtythree);

    /** Overflow Calculation for mainly mult, also case when divisor is all 0 for Div ONLY -**/
    and and_ovf(ovf_bits_mult, output_from_register[64], output_from_register[63], output_from_register[62], output_from_register[61], output_from_register[60], output_from_register[59], output_from_register[58], output_from_register[57], output_from_register[56], output_from_register[55], output_from_register[54], output_from_register[53], output_from_register[52], output_from_register[51], output_from_register[50], output_from_register[49], output_from_register[48], output_from_register[47], output_from_register[46], output_from_register[45], output_from_register[44], output_from_register[43], output_from_register[42], output_from_register[41], output_from_register[40], output_from_register[39], output_from_register[38], output_from_register[37], output_from_register[36], output_from_register[35], output_from_register[34], output_from_register[33]);
    or or_ovf(or_ovf_wire_top, ovf_bits_mult, ovf_bits_mult_inv);

    //Are the boundary bits the same?
    xnor xnor_gate2(boundary_bits_wire, output_from_register[32], output_from_register[33]);

    //Check for super negative number that doesn't cause overflow
    or or_ovf1(or_ovf_wire1, output_from_register[1], output_from_register[2], output_from_register[3], output_from_register[4], output_from_register[4], output_from_register[5], output_from_register[6], output_from_register[7], output_from_register[8], output_from_register[9], output_from_register[10], output_from_register[11], output_from_register[12], output_from_register[13], output_from_register[14], output_from_register[15], output_from_register[16], output_from_register[17], output_from_register[18], output_from_register[19], output_from_register[20], output_from_register[21], output_from_register[22], output_from_register[23], output_from_register[24], output_from_register[25], output_from_register[26], output_from_register[27], output_from_register[28], output_from_register[29], output_from_register[30], output_from_register[31]);
    and and_ovf1(and_ovf_wire1, output_from_register[32], or_ovf_wire1);

    nor nor_ovf1(nor_ovf_wire1, output_from_register[1], output_from_register[2], output_from_register[3], output_from_register[4], output_from_register[4], output_from_register[5], output_from_register[6], output_from_register[7], output_from_register[8], output_from_register[9], output_from_register[10], output_from_register[11], output_from_register[12], output_from_register[13], output_from_register[14], output_from_register[15], output_from_register[16], output_from_register[17], output_from_register[18], output_from_register[19], output_from_register[20], output_from_register[21], output_from_register[22], output_from_register[23], output_from_register[24], output_from_register[25], output_from_register[26], output_from_register[27], output_from_register[28], output_from_register[29], output_from_register[30], output_from_register[31]);
    and and_ovf2(and_ovf_wire2, output_from_register[32], nor_ovf_wire1);

    or or_ovf_for_bottom_bits(or_ovf_wire2, and_ovf_wire1, and_ovf_wire2);

    //Combine bottom bits checker for super negative number with the boundary bits checker
    or or_ovf_for_boundary_and_bottom(or_ovf_wire3, boundary_bits_wire, or_ovf_wire2);

    //Compare Top32 bits with boundary bits and bottom bits that could result in a non-overflow negative number
    nand nand_gate(mult_exception, or_ovf_wire3, or_ovf_wire_top);

    //See if Divisor is zero, finally combine for full exception
    and and_divisor_not_0(divisor_zero_wire, ~data_operandB[31], ~data_operandB[30], ~data_operandB[29], ~data_operandB[28], ~data_operandB[27], ~data_operandB[26], ~data_operandB[25], ~data_operandB[24], ~data_operandB[23], ~data_operandB[23], ~data_operandB[22], ~data_operandB[21], ~data_operandB[20], ~data_operandB[19], ~data_operandB[18], ~data_operandB[17], ~data_operandB[16], ~data_operandB[15], ~data_operandB[14], ~data_operandB[13], ~data_operandB[12], ~data_operandB[11], ~data_operandB[10], ~data_operandB[9], ~data_operandB[8], ~data_operandB[7], ~data_operandB[6], ~data_operandB[5], ~data_operandB[4], ~data_operandB[3], ~data_operandB[2], ~data_operandB[1], ~data_operandB[0]);
    
    //dataOperandB = Divisor (outside)
    bitwise_not not_dataB_gate(data_operandB, not_data_operandB);

    //Feed divisor into 2 main CLA's for sub and add
    CLA_32bit CLA_main_sub(shifted_output_from_div_reg[63:32], not_mux_divisor_out, 1'b1, output_from_main_sub_CLA, dummy_ovf_wire3);
    CLA_32bit CLA_main_add(shifted_output_from_div_reg[63:32], mux_divisor_out, 1'b0, output_from_main_add_CLA, dummy_ovf_wire4); 

    //****** dataOperandA = Dividend (inside)  ********
    bitwise_not not_dataA_gate(data_operandA, not_data_operandA);
    CLA_32bit CLA_for_dividend(not_data_operandA, 32'b00000000000000000000000000000001, 1'b0, output_from_dividend_CLA, dummy_ovf_wire2);
    mux_2_32_bit mux_for_signed_dividend(mux_dividend_out, data_operandA[31], data_operandA, output_from_dividend_CLA);

    //Combine dividend with high zeros
    assign full_dividend_bits[31:0] = mux_dividend_out;
    assign full_dividend_bits[63:32] = 32'b00000000000000000000000000000000;

    //Combine both CLA outputs and then choose between that and the full bits from dividend
    mux_2_32_bit mux_for_choosing_subadd(sub_or_add_wire, output_div_register[63], output_from_main_sub_CLA, output_from_main_add_CLA);
    mux_2 choose_zero_or_one_for_last_bit(zero_or_one_wire, sub_or_add_wire[31], 1'b1, 1'b0);
    assign full_add_sub_combined_wire[0] = zero_or_one_wire;
    assign full_add_sub_combined_wire[31:1] = shifted_output_from_div_reg[31:1];
    mux_2_64_bit choose_before_register(input_div_register, notfirst, full_dividend_bits, full_add_sub_combined_wire);

    //Initialize register, logic into and out of shifter
    register_64_bit main_div_register(output_div_register, input_div_register, clock, notthirtytwo, ctrl_DIV);
    sll_1_bit shift_left_1(output_div_register, shifted_output_from_div_reg);

    //During last clock cycle, take the output and either convert it back to negative or not
    bitwise_not final_not(input_div_register[31:0], not_input_div_register);
    CLA_32bit final_CLA(not_input_div_register, 32'b00000000000000000000000000000001, 1'b0, output_from_final_CLA, dummy_ovf_wire5);
    xor xor_for_quotient(xor_wire, data_operandB[31], data_operandA[31]);
    mux_2_32_bit final_mux_to_choose_quotient(div_quotient_wire, xor_wire, input_div_register[31:0], output_from_final_CLA);


    /** Logic for register to store mult or div then output the result **/
    or or_mult_div(or_ctrlmd_wire, ctrl_MULT, ctrl_DIV);
    dffe_ref dffe_for_ctrl(ctrl_reg_out_wire, 1'b1, clock, ctrl_DIV, ctrl_MULT);
    mux_2_32_bit mux_for_almost_final_result(mult_div_mux_wire, ctrl_reg_out_wire, output_from_register[32:1], div_quotient_wire[31:0]);
    mux_2_32_bit mux_for_final_result(data_result, divisor_zero_wire, mult_div_mux_wire, 32'b0);

    //Logic for when result is ready for mult and div
    mux_2 mux_for_result_rdy(data_resultRDY, ctrl_reg_out_wire, seventeen, thirtytwo);

endmodule
