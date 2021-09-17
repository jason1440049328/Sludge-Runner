`timescale 1ns / 1ps

module Die_Display(clk, crash_en, pixel_x, pixel_y, crash_on, crash_bit_addr, crash_rom_addr);


//Declare Inputs and Outputs
input clk, crash_en;
input [9:0] pixel_x, pixel_y;
output crash_on;
output [2:0] crash_bit_addr;
output [10:0] crash_rom_addr;


wire [3:0] row_addr;
reg [6:0] char_addr;

assign row_addr = pixel_y[6:3];
assign crash_bit_addr = pixel_x[5:3] - 3'd4;
assign crash_rom_addr = {char_addr, row_addr};
assign crash_on = (pixel_y[9:7]==1 && pixel_x[9:5]<15) && (pixel_x[9:5]>4) && crash_en;

always @*
    case (pixel_x [9:5])
        5'h5,5'h6: char_addr = 7'h44; // Letter D
        5'h7,5'h8: char_addr = 7'h49; // Letter I
        5'h9,5'ha: char_addr = 7'h45; // Letter E
        5'hb,5'hc: char_addr = 7'h44; // Letter D
        5'hd,5'he: char_addr = 7'h21; // Letter !
    default: char_addr = 7'h00; // 
endcase

endmodule

