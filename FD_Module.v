module FD_Module(pc, rom_input, stall_fd, rise, reset, pc_fd, branch_fd, rd_fd, rs_fd, rt_fd, addi_fd, bex_fd, rtype_fd, instr_fd, jr_fd);

input [31:0] pc, rom_input;
input stall_fd, rise, reset;

output branch_fd, addi_fd, bex_fd, rtype_fd, jr_fd;
output [4:0] rd_fd, rs_fd, rt_fd;
output [31:0] instr_fd, pc_fd;

//Set up the two registers
register PCRegister(pc_fd, pc, rise, ~stall_fd, reset);
register InstructionRegister(instr_fd, rom_input, rise, ~stall_fd, reset);

//Assign registers to read
assign rd_fd = instr_fd[26:22];
assign rs_fd = instr_fd[21:17];
assign rt_fd = instr_fd[16:12];

//Logic for specific instructions
wire bne_wire, blt_wire;

and and_Rtype(rtype_fd, ~instr_fd[31], ~instr_fd[30], ~instr_fd[29], ~instr_fd[28], ~instr_fd[27]);
and and_Bex(bex_fd, instr_fd[31], ~instr_fd[30], instr_fd[29], instr_fd[28], ~instr_fd[27]);
and and_Addi(addi_fd, ~instr_fd[31], ~instr_fd[30], instr_fd[29], ~instr_fd[28], instr_fd[27]);
and and_BNE(bne_wire, ~instr_fd[31], ~instr_fd[30], ~instr_fd[29], instr_fd[28], ~instr_fd[27]);
and and_BLT(blt_wire, ~instr_fd[31], ~instr_fd[30], instr_fd[29], instr_fd[28], ~instr_fd[27]);
and and_JR(jr_fd, ~instr_fd[31], ~instr_fd[30], instr_fd[29], ~instr_fd[28], ~instr_fd[27]);

or or_BNE_BLT(branch_fd, bne_wire, blt_wire);

endmodule