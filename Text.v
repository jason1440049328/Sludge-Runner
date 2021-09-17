`timescale 1ns / 1ps

module Text(clk, reset_game, reg12_out, pause, clk50, start_en, crash_en, finish_en, pixel_x, pixel_y, text_on, second_tick, RGB_Text);

//Declare inputs and outputs
input clk, reset_game;
input [31:0] reg12_out;
input clk50, pause;
input start_en, crash_en, finish_en;
input [9:0] pixel_x, pixel_y;
output second_tick;
output text_on;
output reg [11:0] RGB_Text;

//ROM and bit addresses for all text
wire [10:0] time_rom_addr, start_rom_addr, crash_rom_addr, finish_rom_addr;
wire [2:0] time_bit_addr, start_bit_addr, crash_bit_addr, finish_bit_addr;

//Determine when the rom is active to display letters/numbers for splash messages
reg [2:0] bit_addr;
wire font_rom_bit;
wire [7:0] data;
assign font_rom_bit = data[~bit_addr];

//Determine when the text should be on
wire time_on, start_on, crash_on, finish_on;
assign text_on = time_on | (finish_on & font_rom_bit) | (start_on & font_rom_bit) | (crash_on & font_rom_bit);

//Display to show the start screen
Start_Display start(clk, start_en, pixel_x, pixel_y, start_on, start_bit_addr, start_rom_addr);

//Display to show the time
Time_Display timedis(clk, reset_game, pause, clk50, pixel_x, pixel_y, time_on, time_bit_addr, time_rom_addr, second_tick);

//Display to show the finish time
Finish_Display finish(clk, finish_en, reg12_out, pixel_x, pixel_y, finish_on, finish_bit_addr, finish_rom_addr);

//Display to show when the person dies
Die_Display die(clk, crash_en, pixel_x, pixel_y, crash_on, crash_bit_addr, crash_rom_addr);

//Font ROM that stores characters
reg [10:0] rom_address;
Font_ROM fonts(clk, rom_address, data);

//Logic for what colors to display on each pixel
always @*
begin
    if(time_on)
        begin
            bit_addr <= time_bit_addr;
            rom_address <= time_rom_addr;
            RGB_Text <= 12'hfff; //White background for timer
        if (font_rom_bit)
            RGB_Text <= 12'h000; //Black background for text
        end
    else if(start_on)
        begin
            bit_addr <= start_bit_addr;
            rom_address <= start_rom_addr;
            RGB_Text <= 12'h000; //Black background for text
        end  
    else if(crash_on)
        begin
            bit_addr <= crash_bit_addr;
            rom_address <= crash_rom_addr;
            RGB_Text <= 12'h000; //Black background for text
        end
    else if(finish_on)
        begin
            bit_addr <= finish_bit_addr;
            rom_address <= finish_rom_addr;
            RGB_Text <= 12'h000; //Black background for text
        end

end

endmodule
