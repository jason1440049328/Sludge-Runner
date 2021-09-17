module MW_Module(pc_xm, instr_xm, target_xm_extended, data_to_write, rise, stall_mw, reset, mw_rd_is_0, pc_mw, 
alu_op_mw, target_mw, opcode_mw, modifies_rd_mw, data_out_mw, setx_mw, lw_mw, jal_mw, wen_mw, rd_mw);

// Inputs/Outputs of MW Module
input [31:0] pc_xm, instr_xm, target_xm_extended, data_to_write;
input rise, stall_mw, reset;

output [31:0] pc_mw, target_mw, data_out_mw;
output [4:0] alu_op_mw, opcode_mw, rd_mw;
output mw_rd_is_0, modifies_rd_mw, setx_mw, lw_mw, jal_mw, wen_mw;

//PC, Instruction, Target, and Data Registers
register PCReg(pc_mw, pc_xm, rise, ~stall_mw, reset);
wire [31:0] holdLastInstruction;
register InstrReg(holdLastInstruction, instr_xm, rise, ~stall_mw, reset);
register data_reg(data_out_mw, data_to_write, rise, ~stall_mw, reset);
register target_reg(target_mw, target_xm_extended, rise, ~stall_mw, reset);
//dffe_ref dffe_for_ovf(alu_ovf_mw, alu_ovf_xm, rise, ~stall_mw, reset);

//Assign bit fields from output instruction
assign opcode_mw = holdLastInstruction[31:27];
and and_mw_rd_is_0(mw_rd_is_0, ~holdLastInstruction[26], ~holdLastInstruction[25], ~holdLastInstruction[24], ~holdLastInstruction[23], ~holdLastInstruction[22]);
assign rd_mw = holdLastInstruction[26:22];
assign alu_op_mw = holdLastInstruction[6:2];

//Output specific instructions
wire mw_rtype_wire, mw_addi_wire, mw_lw_wire, mw_jal_wire, mw_setx_wire;
and and_rtype(mw_rtype_wire, ~holdLastInstruction[31], ~holdLastInstruction[30], ~holdLastInstruction[29], ~holdLastInstruction[28], ~holdLastInstruction[27]);
and and_addi(mw_addi_wire, ~holdLastInstruction[31], ~holdLastInstruction[30], holdLastInstruction[29], ~holdLastInstruction[28], holdLastInstruction[27]);
and and_lw(mw_lw_wire, ~holdLastInstruction[31], holdLastInstruction[30], ~holdLastInstruction[29], ~holdLastInstruction[28], ~holdLastInstruction[27]);
and and_jal(mw_jal_wire, ~holdLastInstruction[31], ~holdLastInstruction[30], ~holdLastInstruction[29], holdLastInstruction[28], holdLastInstruction[27]);
and and_setx(mw_setx_wire, holdLastInstruction[31], ~holdLastInstruction[30], holdLastInstruction[29], ~holdLastInstruction[28], holdLastInstruction[27]);
or or_wen(wen_mw, mw_rtype_wire, mw_addi_wire, mw_lw_wire, mw_jal_wire, mw_setx_wire);
assign setx_mw = mw_setx_wire;
assign lw_mw = mw_lw_wire;
assign jal_mw = mw_jal_wire;

or or_modifies_rd(modifies_rd_mw, mw_rtype_wire, mw_addi_wire, mw_lw_wire, mw_setx_wire);


endmodule
