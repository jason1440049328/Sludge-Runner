`timescale 1ns / 1ps

/**

Top Level module for Sludge Runner, a game based around avoiding
obstacles while running through the course, trying to finish it as soon
as possible. There are bonus points for collecting coins along the way
to decrease your final time. 

**/

module Sludge_Runner(clk, reset, testing_wire, left, right, fast_speed, slow_speed, hSync, vSync, add_point, RGB_Out, segA, segB, segC, segD, segE, segF, segG, an0, dp0, chSel, audioOut, audioEn);

//Input and Output declarations
//left and right for controlling from the FPGA
//fast_speed and slow_speed from buttons on FPGA for speeding up the game by 2 or by 4

wire [31:0] reg10_out, reg12_out;
wire second_tick;
input clk, reset, testing_wire;                                 
input left, right, fast_speed, slow_speed;
output hSync, vSync;           
output add_point;
output [11:0] RGB_Out;                               
output segA, segB, segC, segD, segE, segF, segG, an0, dp0;
output chSel, audioOut, audioEn;

wire active, modclk, path_on, finish_line, person_on, start_en, crash_en, finish_en;
wire rwe, mwe;
wire[4:0] rd, rs1, rs2;
wire[31:0] instAddr, instData, 
            rData, regA, regB,
            memAddr, memDataIn, memDataOut;

///// Main Processing Unit
processor CPU(.clock(clock), .reset(reset), 
                
        ///// ROM
                .address_imem(instAddr), .q_imem(instData),
                
        ///// Regfile
                .ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
                .ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
                .data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
                
        ///// RAM
                .wren(mwe), .address_dmem(memAddr), 
                .data(memDataIn), .q_dmem(memDataOut)); 

///// Instruction Memory (ROM)
ROM #(.MEMFILE("C:/Users/Jason Dong/Desktop/350Submission/SludgeRunnerMIPS.mem")) // Add your memory file here
InstMem(.clk(clock), 
        .wEn(1'b0), 
        .addr(instAddr[11:0]), 
        .dataIn(32'b0), 
        .dataOut(instData));

///// Register File
regfile RegisterFile(.clock(clock), 
            .ctrl_writeEnable(rwe), .ctrl_reset(reset), 
            .ctrl_writeReg(rd),
            .ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
            .data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
            .reg10_out(reg10_out), .reg12_out(reg12_out), .reg1_reset(add_point), .reg2_reset(second_tick), .reg3_reset(finish_en));

///// Processor Memory (RAM)
RAM ProcMem(.clk(clock), 
        .wEn(mwe), 
        .addr(memAddr[11:0]), 
        .dataIn(memDataIn), 
        .dataOut(memDataOut));

//Wires interfacing with VGATimingGenerator
wire reset_game;

//Wires for knowing what pixel the screen is currently on
wire [9:0] pixel_x, pixel_y;

//Display the points that the player has acquired on the LCD Screen
LCD_Controller lcd_control(reg10_out, segA, segB, segC, segD, segE, segF, segG, an0, dp0);

//Controller to display text on the screen
Screen_Controller screen_ctrl(clk, reset_game, reg12_out, pause, left, right,
fast_speed, slow_speed, active, start_en, crash_en, finish_en,
pixel_x, pixel_y, path_on, finish_line, person_on, coin_on, second_tick, RGB_Out);

//Control the different states the game should be in based on what signals are on
Game_Controller game_ctrl(clk, reset, active, path_on, finish_line,
person_on, coin_on, fast_speed, slow_speed, start_en, crash_en, finish_en, pause, reset_game, add_point);

//VGA Timing used to control what pixels are currently being displayed
VGATimingGenerator vga(clk, reset, active, hSync, vSync, screenEnd, pixel_x, pixel_y);

//Audio Interface
wire [3:0] switches;
assign switches = 4'b0000;
AudioController audio(clk, switches, crash_en, chSel, audioOut, audioEn);

endmodule