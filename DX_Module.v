module DX_Module(pc_fd, pick_instr_fd, pick_readA, pick_readB, stall_dx, rise, reset, instr_dx, is_not_noop_dx,
pc_dx, target_dx, aluop_dx, shamt_dx, immediate_17_dx, rs_dx, rt_dx, rd_dx, read1_dx, read2_dx, rtype_dx, 
addi_dx, sw_dx, lw_dx, j_dx, bne_dx, jal_dx, jr_dx, blt_dx, bex_dx, setx_dx, mult_dx, div_dx);

//Inputs and outputs
input [31:0] pc_fd, pick_instr_fd, pick_readA, pick_readB;
input stall_dx, rise, reset;

output [31:0] instr_dx, pc_dx, read1_dx, read2_dx;
output [26:0] target_dx;
output [16:0] immediate_17_dx;
output [4:0] aluop_dx, shamt_dx, rs_dx, rt_dx, rd_dx;
output is_not_noop_dx, rtype_dx, addi_dx, sw_dx, lw_dx, j_dx, bne_dx, jal_dx, jr_dx, blt_dx, bex_dx, setx_dx, mult_dx, div_dx;

//Registers to hold info
register pc_reg(pc_dx, pc_fd, rise, ~stall_dx, reset);
register instr_reg(instr_dx, pick_instr_fd, rise, ~stall_dx, reset);
register read1_reg(read1_dx, pick_readA, rise, ~stall_dx, reset);
register read2_reg(read2_dx, pick_readB, rise, ~stall_dx, reset);

//Split up instruction to output
assign rd_dx = instr_dx[26:22];
assign rs_dx = instr_dx[21:17];
assign rt_dx = instr_dx[16:12];
assign shamt_dx = instr_dx[11:7];
assign aluop_dx = instr_dx[6:2];
assign immediate_17_dx = instr_dx[16:0];
assign target_dx = instr_dx[26:0];
or or_zero_instr(is_not_noop_dx, instr_dx[31], instr_dx[30], instr_dx[29], instr_dx[28], instr_dx[27], instr_dx[26], instr_dx[25], instr_dx[24], instr_dx[23], instr_dx[22], instr_dx[21], instr_dx[20], instr_dx[19], instr_dx[18], instr_dx[17], instr_dx[16], instr_dx[15], instr_dx[14], instr_dx[13], instr_dx[12], instr_dx[11], instr_dx[10], instr_dx[9], instr_dx[8], instr_dx[7], instr_dx[6], instr_dx[5], instr_dx[4], instr_dx[3], instr_dx[2], instr_dx[1], instr_dx[0]);

//Output invididual instructions, 2 use ALUOp, 11 use Opcode
and and_mult(mult_dx, ~instr_dx[6], ~instr_dx[5], instr_dx[4], instr_dx[3], ~instr_dx[2]);
and and_div(div_dx, ~instr_dx[6], ~instr_dx[5], instr_dx[4], instr_dx[3], instr_dx[2]);

and and_rtype(rtype_dx, ~instr_dx[31], ~instr_dx[30], ~instr_dx[29], ~instr_dx[28], ~instr_dx[27]);
and and_addi(addi_dx, ~instr_dx[31], ~instr_dx[30], instr_dx[29], ~instr_dx[28], instr_dx[27]);
and and_sw(sw_dx, ~instr_dx[31], ~instr_dx[30], instr_dx[29], instr_dx[28], instr_dx[27]);
and and_lw(lw_dx, ~instr_dx[31], instr_dx[30], ~instr_dx[29], ~instr_dx[28], ~instr_dx[27]);
and and_j(j_dx, ~instr_dx[31], ~instr_dx[30], ~instr_dx[29], ~instr_dx[28], instr_dx[27]);
and and_bne(bne_dx, ~instr_dx[31], ~instr_dx[30], ~instr_dx[29], instr_dx[28], ~instr_dx[27]);
and and_jal(jal_dx, ~instr_dx[31], ~instr_dx[30], ~instr_dx[29], instr_dx[28], instr_dx[27]);
and and_jr(jr_dx, ~instr_dx[31], ~instr_dx[30], instr_dx[29], ~instr_dx[28], ~instr_dx[27]);
and and_blt(blt_dx, ~instr_dx[31], ~instr_dx[30], instr_dx[29], instr_dx[28], ~instr_dx[27]);
and and_bex(bex_dx, instr_dx[31], ~instr_dx[30], instr_dx[29], instr_dx[28], ~instr_dx[27]);
and and_setx(setx_dx, instr_dx[31], ~instr_dx[30], instr_dx[29], ~instr_dx[28], instr_dx[27]);

endmodule