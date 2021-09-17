/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
    //Clock rising and negative edge
    wire rise_wire, fall_wire;
    assign rise_wire = clock;
    not not_clock(fall_wire, clock);

    //Stall wire declarations (calculated below in bypass, declared here for use in modules), same with lw_sw_bypass and noop, and alu inputs, and ovf calcs
    wire stall_pc_wire, stall_fd_wire, stall_dx_wire, stall_xm_wire, stall_mw_wire;
    wire [31:0] real_alu_in1_wire, real_alu_in2_wire;


    //PC Register, load into ROM
    wire [31:0] input_into_pc_wire, pc_out_wire, pc_plus_one_wire;
    wire pc_cla_ovf;
    register processor_pc_reg(pc_out_wire, input_into_pc_wire, rise_wire, ~stall_pc_wire, reset);
    assign address_imem = pc_out_wire;
    CLA_32bit pc_cla(pc_out_wire, 32'b00000000000000000000000000000001, 1'b0, pc_plus_one_wire, pc_cla_ovf);
        /* Rest of PC logic down after all modules*/

    //Make mux for noop, and then hook up inputs/outputs to FD Module
    wire [31:0] rom_input_wire;
    mux_2_32_bit mux_for_fd_noop(rom_input_wire, noop_wire, q_imem, 32'b00000000000000000000000000000000);
	
    //FD Module
    wire [31:0] program_counter_wire, pc_fd_wire, instr_fd_wire;
    wire branch_fd_wire, addi_fd_wire, bex_fd_wire, rtype_fd_wire, jr_fd_wire;
    wire [4:0] rd_fd_wire, rs_fd_wire, rt_fd_wire;
    FD_Module fd(pc_out_wire, rom_input_wire, stall_fd_wire, rise_wire, reset, pc_fd_wire, branch_fd_wire, rd_fd_wire, rs_fd_wire, rt_fd_wire, addi_fd_wire, bex_fd_wire, rtype_fd_wire, instr_fd_wire, jr_fd_wire);

    //RegFile Inputs and outputs
    wire [4:0] mux_choose_rd_or_30_wire; 
    mux_2_5_bit mux_choose_readB(ctrl_readRegB, rtype_fd_wire, rs_fd_wire, rt_fd_wire);

      //Choose register to write to
    wire setx_mw_wire, jal_mw_wire;
    wire [4:0] final_reg_dest_or_1f_wire, final_reg_dest_or_1e_wire; 
    wire [4:0] final_reg_dest_wire;
    assign ctrl_writeEnable = wen_mw_wire;
    mux_2_5_bit mux_choose_reg_31_or_dest(final_reg_dest_or_1f_wire, jal_mw_wire, final_reg_dest_wire, 5'b11111);
    mux_2_5_bit mux_choose_reg_30_or_dest(ctrl_writeReg, setx_mw_wire, final_reg_dest_or_1f_wire, 5'b11110);
      
      //Choose register value to write
    wire [31:0] choose_data_or_jal_pc, final_data_out_wire, pc_mw_plus_one_wire;
    wire [31:0] target_mw_wire;
    mux_2_32_bit mux_choose_jal_pc(choose_data_or_jal_pc, jal_mw_wire,final_data_out_wire, pc_mw_plus_one_wire);
    mux_2_32_bit mux_choose_data_or_target(data_writeReg, setx_mw_wire, choose_data_or_jal_pc, target_mw_wire);

    //DX Module
    wire [31:0] instr_dx_final_input_wire, readA_dx_final_input_wire, readB_dx_final_input_wire;
    wire [26:0] target_dx_wire;
    wire [16:0] immediate_17_dx_wire;
    wire [4:0] aluop_dx_wire, shamt_dx_wire, rs_dx_wire, rt_dx_wire, rd_dx_wire;
    wire is_not_noop_dx_wire, rtype_dx_wire, addi_dx_wire, sw_dx_wire, lw_dx_wire, j_dx_wire, bne_dx_wire, jal_dx_wire, jr_dx_wire, blt_dx_wire, bex_dx_wire, setx_dx_wire, mult_dx_wire, div_dx_wire;
    mux_2_32_bit choose_instr_fd_or_noop(instr_dx_final_input_wire, noop_dx_wire, instr_fd_wire, 32'b00000000000000000000000000000000);
    mux_2_32_bit choose_readA_or_noop(readA_dx_final_input_wire, noop_dx_wire, data_readRegA, 32'b00000000000000000000000000000000);
    mux_2_32_bit choose_readB_or_noop(readB_dx_final_input_wire, noop_dx_wire, data_readRegB, 32'b00000000000000000000000000000000);
    DX_Module dx(pc_fd_wire, instr_dx_final_input_wire, readA_dx_final_input_wire, readB_dx_final_input_wire, stall_dx_wire, rise_wire, reset, instr_dx_wire, is_not_noop_dx_wire,
    pc_dx_wire, target_dx_wire, aluop_dx_wire, shamt_dx_wire, immediate_17_dx_wire, rs_dx_wire, rt_dx_wire, rd_dx_wire, read1_dx_wire, read2_dx_wire, rtype_dx_wire,
    addi_dx_wire, sw_dx_wire, lw_dx_wire, j_dx_wire, bne_dx_wire, jal_dx_wire, jr_dx_wire, blt_dx_wire, bex_dx_wire, setx_dx_wire, mult_dx_wire, div_dx_wire);

    //AlU Inputs and Outputs
    wire [4:0] mux1_choose_aluop_wire, mux2_choose_aluop_wire;
    wire second_alu_mux_select_wire, alu_ovf_wire, alu_ine_wire, alu_ilt_wire;
    wire bne_blt_dx_wire;
    wire [31:0] alu_out_wire;
    mux_2_5_bit mux1_alu_op(mux1_choose_aluop_wire, bne_blt_dx_wire, aluop_dx_wire, 5'b00001);
    alu main_alu(real_alu_in1_wire, real_alu_in2_wire, mux2_choose_aluop_wire, shamt_dx_wire, alu_out_wire, alu_ine_wire, alu_ilt_wire, alu_ovf_wire);

    //Immediate 17 bit extender to 32
    wire [31:0] immediate_32_dx_wire;
    immediate_17_extender extend_imm(immediate_17_dx_wire, immediate_32_dx_wire);

    //Target extender to 32
    wire [31:0] target_dx_extended_wire;
    target_27_extender target_ex(target_dx_wire, target_dx_extended_wire);

    //Mult Module along with timing
        wire multdiv_rdy_wire, multdiv_ovf_wire;
        wire and_mult_rtype_wire, dffe_mult_out, mult_start_wire, mult_ongoing_wire;
        wire and_div_rtype_wire, dffe_div_out, div_start_wire, div_ongoing_wire;

        wire [31:0] multdiv_result_wire;
        multdiv md_module(real_alu_in1_wire, real_alu_in2_wire, mult_start_wire, div_start_wire, rise_wire, multdiv_result_wire, multdiv_ovf_wire, multdiv_rdy_wire);


        //Mult logic for asserting/not asserting
        and and_mult_rtype(and_mult_rtype_wire, mult_dx_wire, rtype_dx_wire);
        and and_mult_start(mult_start_wire, and_mult_rtype_wire, ~dffe_mult_out, ~multdiv_rdy_wire);
        or or_mult_ongoing(mult_ongoing_wire, mult_start_wire, dffe_mult_out);

        //Div logic for asserting/not asserting
        and and_div_rtype(and_div_rtype_wire, div_dx_wire, rtype_dx_wire);
        dffe_ref dffe_for_div(dffe_div_out, and_div_rtype_wire, rise_wire, 1'b1, 1'b0);
        and and_div_start(div_start_wire, and_div_rtype_wire, ~dffe_div_out, ~multdiv_rdy_wire);
        or or_div_ongoing(div_ongoing_wire, div_start_wire, dffe_div_out);

    //XM Module
    wire [31:0] mux_choose_alu_input_xm_wire, real_read1_dx_wire;
    wire isMultorDiv_wire, isMultorDivAndIsAtDX_wire;
    wire [31:0] instr_xm_wire, pc_xm_wire, read1_xm_wire, alu_xm_wire, target_xm_extended_wire;
    wire [4:0] rd_xm_wire, aluop_xm_wire, opcode_xm_wire;
    wire xm_rd_is_0_wire, setx_xm_wire, jal_xm_wire, sw_xm_wire, lw_xm_wire, modifies_rd_xm_wire, md_ovf_in_xm_wire;

        //Make sure it's a mult or div instruction for the clock within mult to not be asserted randomly
        or or_gate_112(isMultorDiv_wire, and_mult_rtype_wire, and_div_rtype_wire);
        and and_md(isMultorDivAndIsAtDX_wire, isMultorDiv_wire, multdiv_rdy_wire);

    mux_2_32_bit mux_choose_alu_input(mux_choose_alu_input_xm_wire, isMultorDivAndIsAtDX_wire, alu_out_wire, multdiv_result_wire);
    mux_2 mux_allow_md_ovf(md_ovf_in_xm_wire, isMultorDivAndIsAtDX_wire, 1'b0, multdiv_ovf_wire);
    
    XM_Module xm(md_ovf_in_xm_wire, aluop_dx_wire, pc_dx_wire, real_read1_dx_wire, mux_choose_alu_input_xm_wire, instr_dx_wire, target_dx_extended_wire, alu_ovf_wire, rise_wire, stall_xm_wire, reset,
    xm_rd_is_0_wire, instr_xm_wire, target_xm_extended_wire, jal_xm_wire, opcode_xm_wire, sw_xm_wire,
    lw_xm_wire, modifies_rd_xm_wire);

    //RAM Access
    wire [31:0] data_to_write_to_mw_wire;
    assign address_dmem = alu_xm_wire;
    assign wren = sw_xm_wire;
    mux_2_32_bit mux_choose_for_ram(data, lw_sw_bypass_wire, read1_xm_wire, final_data_out_wire);
    mux_2_32_bit mux_choose_ram_output(data_to_write_to_mw_wire, lw_xm_wire, alu_xm_wire, q_dmem);
	
    //MW Module
    wire [31:0] pc_mw_wire, data_out_mw_wire;
    wire [4:0] alu_op_mw_wire, opcode_mw_wire, rd_mw_wire;
    wire mw_rd_is_0_wire, modifies_rd_mw_wire, lw_mw_wire, wen_mw_wire;
    MW_Module mw(pc_xm_wire, instr_xm_wire, target_xm_extended_wire, data_to_write_to_mw_wire, rise_wire, stall_mw_wire, reset, mw_rd_is_0_wire, pc_mw_wire,
    alu_op_mw_wire, target_mw_wire, opcode_mw_wire, modifies_rd_mw_wire, data_out_mw_wire, setx_mw_wire, lw_mw_wire, jal_mw_wire, wen_mw_wire, rd_mw_wire);

    //Pick final destination register
    assign final_reg_dest_wire = rd_mw_wire;

    //Pick final data to write
    assign final_data_out_wire = data_out_mw_wire;

    //Jal PC Calculation
    wire jal1_ovf_wire, jal2_ovf_wire;
    CLA_32bit cla_for_mw_pc_calc(pc_mw_wire, 32'b00000000000000000000000000000001, 1'b0, pc_mw_plus_one_wire, jal1_ovf_wire);

    //Rest of PC Logic accounting for jumps and branches
    wire [31:0] pc_dx_plus_one_wire, pc_dx_immediate_wire;
    wire pc_dummy_ovf, pc2_dummy_ovf;
    CLA_32bit pc_for_bne_blt(pc_dx_wire, 32'b00000000000000000000000000000001, 1'b0, pc_dx_plus_one_wire, pc_dummy_ovf);
    CLA_32bit pc_dx_with_immediate_32(pc_dx_plus_one_wire, immediate_32_dx_wire, 1'b0, pc_dx_immediate_wire, pc2_dummy_ovf);

    wire [31:0] tgt_dx_ex_or_pc_wire;
    wire bexNE_bexDX_wire, tgt_dx_select_wire;
    wire bex_ne_wire; //Calculated below in stall logic
    and and_bexNE_bexDX(bexNE_bexDX_wire, bex_ne_wire, bex_dx_wire);
    or or_tgt_select(tgt_dx_select_wire, j_dx_wire, jal_dx_wire, bexNE_bexDX_wire);
    mux_2_32_bit mux_tgt_dx_ex(tgt_dx_ex_or_pc_wire, tgt_dx_select_wire, pc_plus_one_wire, target_dx_extended_wire);

    wire [31:0] bne_blt_pc_wire;
    and and_bne_dx_alu_ine(bne_and_alu_ine_wire, bne_dx_wire, alu_ine_wire);
    or or_branch_select(or_branch_select_wire, bne_and_alu_ine_wire, blt_and_alu_ilt_wire);
    mux_2_32_bit mux_immediate_CLA(bne_blt_pc_wire, or_branch_select_wire, tgt_dx_ex_or_pc_wire, pc_dx_immediate_wire);

    //BYPASS FOR JR FOR PC CALCULATION BELOW

    /********************************************** ByPass and Stall Logic **********************************************/

    //LW followed by SW Bypass
    wire rd_xm_equals_rd_mw_wire;
    assign rd_xm_equals_rd_mw_wire = (rd_xm_wire == rd_mw_wire);
    and andlwsw(lw_sw_bypass_wire, rd_xm_equals_rd_mw_wire, lw_mw_wire, sw_xm_wire);

    //STALL for LW Followed Immediately by Rtype/Addi/Branch/Jr/Bex that uses the same destination reg
    wire rtype_branch_addi_wire, rd_dx_equals_rs_fd_wire, lw_stall_choice1_wire, lw_r1_stall_wire;
    assign rd_dx_equals_rs_fd_wire = (rd_dx_wire == rs_fd_wire);
    and and_gate1(lw_stall_choice1_wire, rtype_branch_addi_wire, rd_dx_equals_rs_fd_wire, lw_dx_wire);

    wire rd_dx_equals_rt_fd_wire, lw_stall_choice2_wire;
    assign rd_dx_equals_rt_fd_wire = (rd_dx_wire == rt_fd_wire);
    and and_gate2(lw_stall_choice2_wire, rtype_fd_wire, rd_dx_equals_rt_fd_wire, lw_dx_wire);

    wire branch_and_jr_fd_wire, rd_dx_equals_rd_fd_wire, lw_stall_choice3_wire;
    or or_gate3(branch_and_jr_fd_wire, branch_fd_wire, jr_fd_wire);
    assign rd_dx_equals_rd_fd_wire = (rd_dx_wire == rd_fd_wire);
    and and_gate4(lw_stall_choice3_wire, branch_and_jr_fd_wire, rd_dx_equals_rd_fd_wire, lw_dx_wire);

    wire lw_stall_choice4_wire, rd_dx_equals_30_wire;
    and and_gate200(lw_stall_choice4_wire, bex_fd_wire, rd_dx_equals_30_wire, lw_dx_wire);
    
    or or_gate5(lw_r1_stall_wire, lw_stall_choice1_wire, lw_stall_choice2_wire, lw_stall_choice3_wire, lw_stall_choice4_wire);

    //Stall Logic for Mult/Div and JAL
    wire div_or_mult_ongoing_wire, multdiv_ongoing_and_not_rdy_wire, lw_r1_stall_or_md_stall;
    or or_gate6(div_or_mult_ongoing_wire, div_ongoing_wire, mult_ongoing_wire);
    assign stall_xm_wire = multdiv_ongoing_and_not_rdy_wire;
    assign stall_mw_wire = multdiv_ongoing_and_not_rdy_wire;

    //Logic for NOOP for Program Counter and NOOP for DX Module
    wire bex_ne_and_bex_dx_wire;
    and and_gate9(bex_ne_and_bex_dx_wire, bex_dx_wire, bex_ne_wire);
    or or_gate10(noop_dx_wire, lw_r1_stall_wire,  bne_and_alu_ine_wire, j_dx_wire, blt_and_alu_ilt_wire, jr_dx_wire, jal_dx_wire, bex_ne_and_bex_dx_wire);
    or or_gate11(noop_wire, j_dx_wire, bne_and_alu_ine_wire, blt_and_alu_ilt_wire, jr_dx_wire, jal_dx_wire, bex_ne_and_bex_dx_wire);

    //Bex ByPass for getting new Rstatus, also BEX following a SetX instruction
    wire bex_xm_bypass_wire, bex_mw_bypass_wire, bex_setx_bypass_xm_wire, bex_setx_bypass_mw_wire;
    wire rd_xm_equals_30_wire, rd_mw_equals_30_wire;
    assign rd_xm_equals_30_wire = (rd_xm_wire == 5'b11110);
    assign rd_mw_equals_30_wire = (rd_mw_wire == 5'b11110);

    and and_gate12(bex_xm_bypass_wire, rd_xm_equals_30_wire, modifies_rd_xm_wire, bex_dx_wire);
    and and_gate13(bex_mw_bypass_wire, bex_dx_wire, modifies_rd_mw_wire, rd_mw_equals_30_wire);

    and and_gate14(bex_setx_bypass_xm_wire, setx_xm_wire, bex_dx_wire);
    and and_gate15(bex_setx_bypass_mw_wire, setx_mw_wire, bex_dx_wire);

    //BEX_NE Calculation
    wire [31:0] mux_bex_mw_wire, mux_bex_xm_wire, mux_bex_setx_mw_wire, mux_bex_setx_xm_wire;
    mux_2_32_bit bexMux1(mux_bex_mw_wire, bex_mw_bypass_wire, read1_dx_wire, data_out_mw_wire);
    mux_2_32_bit bexMux4(mux_bex_setx_xm_wire, bex_setx_bypass_xm_wire, mux_bex_setx_mw_wire, target_xm_extended_wire);
    assign bex_ne_wire = ~(mux_bex_setx_xm_wire == 32'b00000000000000000000000000000000);

    //Bypass for SetX followed by instructions that was to use it
    wire rtype_addi_sw_lw_bundle, bne_jr_blt_bundle, setx_and_wire1, setx_and_wire2, setx_and_wire3, setx_and_wire4, setx_and_wire5, setx_and_wire6, setx_and_wire7, setx_and_wire8;
    wire rs_dx_equals_30_wire, rt_dx_equals_30_wire;
    or or_gate18(rtype_addi_sw_lw_bundle, rtype_dx_wire, sw_dx_wire, addi_dx_wire, lw_dx_wire);
    or or_gate24(bne_jr_blt_bundle, bne_dx_wire, jr_dx_wire, blt_dx_wire);
    or or_gate25(bne_blt_dx_wire, bne_dx_wire, blt_dx_wire);

    assign rs_dx_equals_30_wire = (rs_dx_wire == 5'b11110);
    and and_gate19(setx_and_wire1, rs_dx_equals_30_wire, rtype_addi_sw_lw_bundle, setx_xm_wire);
    and and_gate20(setx_and_wire2, rs_dx_equals_30_wire, rtype_addi_sw_lw_bundle, setx_mw_wire);

    assign rt_dx_equals_30_wire = (rt_dx_wire == 5'b11110);
    and and_gate21(setx_and_wire3, rtype_dx_wire, rt_dx_equals_30_wire, setx_xm_wire);
    and and_gate22(setx_and_wire4, rtype_dx_wire, rt_dx_equals_30_wire, setx_mw_wire);

    assign rd_dx_equals_30_wire = (rd_dx_wire == 5'b11110);
    and and_gate23(setx_and_wire5, rd_dx_equals_30_wire, setx_xm_wire, bne_jr_blt_bundle);
    
    and and_gate26(setx_and_wire6, bne_jr_blt_bundle, setx_mw_wire, rd_dx_equals_30_wire);
    and and_gate27(setx_and_wire7, rs_dx_equals_30_wire, setx_xm_wire, bne_blt_dx_wire);
    and and_gate28(setx_and_wire8, bne_blt_dx_wire, setx_mw_wire, rs_dx_equals_30_wire);

    wire setx_xm_r1_bypass_wire, setx_mw_r1_bypass_wire, setx_xm_r2_bypass_wire, setx_mw_r2_bypass_wire;
    or or_gate31(setx_xm_r2_bypass_wire, setx_and_wire3, setx_and_wire7);
    or or_gate32(setx_mw_r2_bypass_wire, setx_and_wire4, setx_and_wire8);

    //ByPass for RType, LW, SW, Addi Instructions and Branches for normal registers
    wire rs_dx_equals_rd_xm_wire, rs_dx_equals_rd_mw_wire, rt_dx_equals_rd_xm_wire, rt_dx_equals_rd_mw_wire, rd_dx_equals_rd_xm_wire, rd_dx_equals_rd_mw_wire;
    wire master_bypass_1_wire, master_bypass_2_wire, master_bypass_3_wire, master_bypass_4_wire, master_bypass_5_wire, master_bypass_6_wire, master_bypass_7_wire, master_bypass_8_wire;

    assign rs_dx_equals_rd_xm_wire = (rs_dx_wire == rd_xm_wire);
    and and_gate33(master_bypass_1_wire, rs_dx_equals_rd_xm_wire, is_not_noop_dx_wire, modifies_rd_xm_wire, rtype_addi_sw_lw_bundle, ~xm_rd_is_0_wire);

    assign rs_dx_equals_rd_mw_wire = (rs_dx_wire == rd_mw_wire);
    and and_gate34(master_bypass_2_wire, rtype_addi_sw_lw_bundle, is_not_noop_dx_wire, modifies_rd_mw_wire, rs_dx_equals_rd_mw_wire, ~mw_rd_is_0_wire);

    assign rt_dx_equals_rd_xm_wire = (rt_dx_wire == rd_xm_wire);
    and and_gate35(master_bypass_3_wire, rt_dx_equals_rd_xm_wire, is_not_noop_dx_wire, rtype_dx_wire, ~xm_rd_is_0_wire, ~addi_dx_wire, modifies_rd_xm_wire);

    assign rd_dx_equals_rd_mw_wire = (rd_dx_wire == rd_mw_wire);
    and and_gate38(master_bypass_6_wire, bne_jr_blt_bundle, modifies_rd_mw_wire, rd_dx_equals_rd_mw_wire);

    and and_gate39(master_bypass_7_wire, rs_dx_equals_rd_xm_wire, modifies_rd_xm_wire, bne_blt_dx_wire);
    and and_gate40(master_bypass_8_wire, rs_dx_equals_rd_mw_wire, modifies_rd_mw_wire, bne_blt_dx_wire);

    wire xm_r1_bypass_wire, mw_r1_bypass_wire, xm_r2_bypass_wire, mw_r2_bypass_wire;
    or or_gate41(xm_r1_bypass_wire, master_bypass_1_wire, master_bypass_5_wire);
    or or_gate42(mw_r1_bypass_wire, master_bypass_2_wire, master_bypass_6_wire);
    or or_gate43(xm_r2_bypass_wire, master_bypass_3_wire, master_bypass_7_wire);
    or or_gate44(mw_r2_bypass_wire, master_bypass_4_wire, master_bypass_8_wire);

    //Account for all previous overflow logic in determining Inputs to send to ALU
    wire [31:0] in1_mux_wire1, in1_mux_wire2, in1_mux_wire3, in1_mux_wire4, in1_mux_wire7;
    mux_2_32_bit muxin1_1(in1_mux_wire1, bne_blt_dx_wire, read2_dx_wire, read1_dx_wire);
    mux_2_32_bit muxin1_2(in1_mux_wire2, rtype_dx_wire, in1_mux_wire1, read1_dx_wire);
    mux_2_32_bit muxin1_3(in1_mux_wire3, mw_r1_bypass_wire, in1_mux_wire2, data_out_mw_wire);
    mux_2_32_bit muxin1_4(in1_mux_wire4, xm_r1_bypass_wire, in1_mux_wire3, data_to_write_to_mw_wire);
    mux_2_32_bit muxin1_7(in1_mux_wire7, setx_mw_r1_bypass_wire, in1_mux_wire4, target_mw_wire);
    mux_2_32_bit muxin1_8(real_alu_in1_wire, setx_xm_r1_bypass_wire, in1_mux_wire7, target_xm_extended_wire);

    wire [31:0] in2_mux_wire1, in2_mux_wire2, in2_mux_wire3, in2_mux_wire6, in2_mux_wire7;
    wire addi_sw_lw_dx_bundle;
    or or_gate100(addi_sw_lw_dx_bundle, addi_dx_wire, sw_dx_wire, lw_dx_wire);
    mux_2_32_bit muxin2_1(in2_mux_wire1, addi_sw_lw_dx_bundle, read2_dx_wire, immediate_32_dx_wire);
    mux_2_32_bit muxin2_2(in2_mux_wire2, mw_r2_bypass_wire, in2_mux_wire1, data_out_mw_wire);
    mux_2_32_bit muxin2_7(real_alu_in2_wire, setx_xm_r2_bypass_wire, in2_mux_wire6, target_xm_extended_wire);

    //Bypassing for SW RD following an instruction that hasn't written yet
    wire sw_bypass_xm, sw_bypass_mw;
    wire [31:0] sw_mux_wire1;
    and and_gate80(sw_bypass_xm, sw_dx_wire, rd_dx_equals_rd_xm_wire, modifies_rd_xm_wire);
    and and_gate81(sw_bypass_mw, sw_dx_wire, rd_dx_equals_rd_mw_wire, modifies_rd_mw_wire);

    mux_2_32_bit sw_mx1(sw_mux_wire1, sw_bypass_mw, read1_dx_wire, data_out_mw_wire);
    mux_2_32_bit sw_mx2(real_read1_dx_wire, sw_bypass_xm, sw_mux_wire1, alu_xm_wire);

    //Accounting for all JR Bypass needed for next PC Calculation (continued from above)
    wire [31:0] jr_out1, jr_out2, jr_out3, jr_out4, jr_out5, jr_out8;
    wire jr_dx_and_mw_r1_bypass, jr_dx_and_xm_r1_bypass, jr_dx_and_setx_mw_r1_bypass, jr_dx_and_setx_xm_r1_bypass, jr_dx_and_jal_mw_r1_bypass, jr_dx_and_jal_xm_r1_bypass;

    mux_2_32_bit jr_mux1(jr_out1, jr_dx_wire, bne_blt_pc_wire, read1_dx_wire);

    and and_gate72(jr_dx_and_mw_r1_bypass, jr_dx_wire, mw_r1_bypass_wire);
    mux_2_32_bit jr_mux4(jr_out4, jr_dx_and_mw_r1_bypass, jr_out1, data_out_mw_wire);

    and and_gate73(jr_dx_and_xm_r1_bypass, jr_dx_wire, xm_r1_bypass_wire);
    mux_2_32_bit jr_mux5(jr_out5, jr_dx_and_xm_r1_bypass, jr_out4, data_to_write_to_mw_wire);

    and and_gate76(jr_dx_and_setx_mw_r1_bypass, jr_dx_wire, setx_mw_r1_bypass_wire);
    mux_2_32_bit jr_mux8(jr_out8, jr_dx_and_setx_mw_r1_bypass, jr_out5, target_mw_wire);

    and and_gate77(jr_dx_and_setx_xm_r1_bypass, jr_dx_wire, setx_xm_r1_bypass_wire);
    mux_2_32_bit jr_mux9(input_into_pc_wire, jr_dx_and_setx_xm_r1_bypass, jr_out8, target_xm_extended_wire);

endmodule

