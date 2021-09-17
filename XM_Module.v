module XM_Module(md_ovf, aluop_dx, pc_dx, read1_dx, aluout_to_pick, instr_dx, target_dx_extended, ovf_to_pick, rise, stall_xm, reset,
xm_rd_is_0, instr_xm, rd_xm, pc_xm, read1_xm, aluop_xm, alu_xm, setx_xm, target_xm_extended, jal_xm, opcode_xm, sw_xm,
lw_xm, modifies_rd_xm);

input [31:0] pc_dx, read1_dx, aluout_to_pick, instr_dx, target_dx_extended;
input ovf_to_pick, rise, stall_xm, reset, md_ovf;
input [4:0] aluop_dx;

output [31:0] instr_xm, pc_xm, read1_xm, alu_xm, target_xm_extended;
output [4:0] aluop_xm, opcode_xm, rd_xm;
output xm_rd_is_0, setx_xm, jal_xm, sw_xm, lw_xm, modifies_rd_xm;

//Registers and dffe to store information
register pc_reg(pc_xm, pc_dx, rise, ~stall_xm, reset);

    //Ovf override for output
wire [31:0] inputIntoALUReg, temp_ovf_mux_wire, temp_ovf_with_addi;
wire isAddi, is_ovf;
assign isAddi = (aluop_dx == 5'b00101);
or or_alumd_ovf(is_ovf, ovf_to_pick, md_ovf);

mux_8_32_bit mux_choose_ovf(temp_ovf_mux_wire, aluop_dx[2:0], 32'b00000000000000000000000000000001, 32'b00000000000000000000000000000011, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000000, 32'b00000000000000000000000000000100, 32'b00000000000000000000000000000101);
mux_2_32_bit mux_choose_addi(temp_ovf_with_addi, isAddi, temp_ovf_mux_wire, 32'b00000000000000000000000000000010);
mux_2_32_bit in_alu_reg(inputIntoALUReg, is_ovf, aluout_to_pick, temp_ovf_with_addi);

register alu_outputreg(alu_xm, inputIntoALUReg, rise, ~stall_xm, reset);
register read1_reg(read1_xm, read1_dx, rise, ~stall_xm, reset);

    //Ovf override for reg 30 in the case of ovf
wire [31:0] tempInstruction;
wire [4:0] tempRegDest;
assign tempInstruction[21:0] = instr_dx[21:0];
mux_2_5_bit pick_reg_30(tempRegDest, is_ovf, instr_dx[26:22], 5'b11110);
assign tempInstruction[26:22] = tempRegDest[4:0];
assign tempInstruction[31:27] = instr_dx[31:27];

register instr_reg(instr_xm, tempInstruction, rise, ~stall_xm, reset);
register target_reg(target_xm_extended, target_dx_extended, rise, ~stall_xm, reset);

//Assign 5 bits for registers and aluop
assign opcode_xm = instr_xm[31:27];
assign rd_xm = instr_xm[26:22];
assign aluop_xm = instr_xm[6:2];
and and_rd_is_zero(xm_rd_is_0, ~instr_xm[26], ~instr_xm[25], ~instr_xm[24], ~instr_xm[23], ~instr_xm[22]);

//Logic for outputs for specific instructions
wire tempJtypexm, tempAddixm;
and and_sw(sw_xm, ~instr_xm[31], ~instr_xm[30], instr_xm[29], instr_xm[28], instr_xm[27]);
and and_lw(lw_xm, ~instr_xm[31], instr_xm[30], ~instr_xm[29], ~instr_xm[28], ~instr_xm[27]);
and and_setx(setx_xm, instr_xm[31], ~instr_xm[30], instr_xm[29], ~instr_xm[28], instr_xm[27]);
and and_jal(jal_xm, ~instr_xm[31], ~instr_xm[30], ~instr_xm[29], instr_xm[28], instr_xm[27]);
and and_jtype(tempJtypexm, ~instr_xm[31], ~instr_xm[30], ~instr_xm[29], ~instr_xm[28], ~instr_xm[27]);
and and_addi(tempAddixm, ~instr_xm[31], ~instr_xm[30], instr_xm[29], ~instr_xm[28], instr_xm[27]);

or or_modifiesRdXm(modifies_rd_xm, lw_xm, tempJtypexm, tempAddixm, setx_xm);

endmodule