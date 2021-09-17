`timescale 1ns / 1ps

module Start_Display(clk, start_en, pixel_x, pixel_y, start_on, start_bit_addr, start_rom_addr);

//Declare Inputs and Outputs
input clk, start_en;
input [9:0] pixel_x, pixel_y;
output start_on;
output [2:0] start_bit_addr;
output [10:0] start_rom_addr;

//Concatenate the bits from the ROM for displaying 
wire [3:0] row_addr;
reg [6:0] char_addr;
assign row_addr = pixel_y[6:3];
assign start_bit_addr = pixel_x[5:3]-3'd4;
assign start_rom_addr = {char_addr, row_addr};
assign start_on = (pixel_y[9:7] == 1) && (pixel_x[9:5] < 15) && (pixel_x[9:5] > 4) && start_en;

//Bitmap for displaying RUN
always @*
case (pixel_x [9:5])
    5'h5,5'h6: char_addr = 7'h52; // Letter R
    5'h7,5'h8: char_addr = 7'h55; // Letter U
    5'h9,5'ha: char_addr = 7'h4e; // Letter N
    default: char_addr = 7'h00; // 
    endcase

endmodule