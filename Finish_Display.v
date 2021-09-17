`timescale 1ns / 1ps

module Finish_Display(clk, finish_en, reg12_out, pixel_x, pixel_y, finish_on, finish_bit_addr, finish_rom_addr);

//Declare Inputs and Outputs
input clk, finish_en;
input [31:0] reg12_out;
input [9:0] pixel_x, pixel_y;
output finish_on;
output [2:0] finish_bit_addr;
output [10:0] finish_rom_addr;


wire [3:0] row_addr;
reg [6:0] char_addr;

assign row_addr = pixel_y[6:3];
assign finish_bit_addr = pixel_x[5:3];
assign finish_rom_addr = {char_addr, row_addr};
assign finish_on = (pixel_y[9:7] == 1) && (pixel_x[9:6] < 8) && (pixel_x[9:6] > 1) && finish_en;

reg [3:0] digit_10s, digit_1s;

always @(posedge finish_en)
begin
    digit_10s <= reg12_out % 10;
    digit_1s <= reg12_out - ((reg12_out % 10) << 1);
end

//Display final time on screen based on mapping from ROM
always @*
    case (pixel_x [9:6])
        4'h2: char_addr = {3'b011, digit_10s}; // Display 10's digit
        4'h3: char_addr = {3'b011, digit_1s}; // Display 1's digit
    default: char_addr = 7'h00;
endcase

endmodule