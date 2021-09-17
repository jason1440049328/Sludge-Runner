`timescale 1ns / 1ps

module Person(clk, reset_game, clk50, left, right, pause, pixel_x, pixel_y, person_on, RGB_Person);


//Declare inputs and outputs
input clk, reset_game, clk50;
input left, right, pause;
input [9:0] pixel_x, pixel_y;
output person_on;
output [11:0] RGB_Person;

//Dimensions of the path
localparam
    MAX_X = 640,
    MAX_Y = 480,
    PERSON_MAX_X = 32,
    PERSON_MAX_Y = 64,
    person_y_t = 410,
    person_y_b = person_y_t + PERSON_MAX_Y-1,
    PERSON_HORIZONTAL_V = 3'd02;

//Black color for the person sprite
assign RGB_Person = 12'h000; 
reg [9:0] person_x_left = 304;
wire [9:0] person_x_right;

// Canvas should be on and person bitmap has to be on to display
wire canvas_on;
wire person_rom_bit;
assign canvas_on = (person_x_left <= pixel_x) && (pixel_x <= person_x_right) && (person_y_t <= pixel_y) && (pixel_y <= person_y_b);
assign person_on = canvas_on & person_rom_bit;

//Address to store the bitmap of the person
wire [3:0] person_rom_address;
wire [2:0] person_rom_column;
reg [0:7] person_rom_data;

//Enlarge person bitmap by 2
assign person_rom_address = pixel_y[5:2] - person_y_t[5:2];
assign person_rom_column = (pixel_x - person_x_left)>>2; 
assign person_rom_bit = person_rom_data[person_rom_column];
assign person_x_right = person_x_left + PERSON_MAX_X-1;

reg [35:0] time_tick;
reg spriteState;

//Alternate between sprites to show that the person is running
always @(posedge clk)
begin
    time_tick <= time_tick + 1;
    if (time_tick == 100000000)
        begin
            time_tick <= 0;
        end
    else if (time_tick < 50000000)
        begin
            spriteState <= 1;
        end
    else if (time_tick > 50000000)
        begin
            spriteState <= 0;
        end
end

always @*
    if (spriteState == 1)
        begin
        case (person_rom_address)
            4'h0: person_rom_data = 8'b00000000; 
            4'h1: person_rom_data = 8'b00000000; 
            4'h2: person_rom_data = 8'b00000000; 
            4'h3: person_rom_data = 8'b00011000; 
            4'h4: person_rom_data = 8'b00100100; 
            4'h5: person_rom_data = 8'b00100100; 
            4'h6: person_rom_data = 8'b00011000; 
            4'h7: person_rom_data = 8'b00111100; 
            4'h8: person_rom_data = 8'b01011010; 
            4'h9: person_rom_data = 8'b01011010; 
            4'ha: person_rom_data = 8'b00011000; 
            4'hc: person_rom_data = 8'b00100100; 
            4'hd: person_rom_data = 8'b00100100; 
            4'he: person_rom_data = 8'b00100100; 
            4'hf: person_rom_data = 8'b01100110; 
        endcase
        end
    else if (spriteState == 0)

        begin
        case (person_rom_address)
            4'h0: person_rom_data = 8'b00000000; 
            4'h1: person_rom_data = 8'b00000000; 
            4'h2: person_rom_data = 8'b00000000; 
            4'h3: person_rom_data = 8'b00011000; 
            4'h4: person_rom_data = 8'b00100100; 
            4'h5: person_rom_data = 8'b00100100; 
            4'h6: person_rom_data = 8'b01011010; 
            4'h7: person_rom_data = 8'b01111110; 
            4'h8: person_rom_data = 8'b00011000; 
            4'h9: person_rom_data = 8'b00011000; 
            4'ha: person_rom_data = 8'b00111100; 
            4'hc: person_rom_data = 8'b00100100; 
            4'hd: person_rom_data = 8'b00100100; 
            4'he: person_rom_data = 8'b01100110; 
            4'hf: person_rom_data = 8'b00000000; 
        endcase
            
        end

//Logic for moving the person
always @(posedge clk)
begin
    //Reset button clicked, reset person back to middle of screen
    if (reset_game)
        begin
            person_x_left <=300;
        end
    else if (clk50 & !pause)
        begin
            if (right & (person_x_right < (MAX_X-1-PERSON_HORIZONTAL_V)))
            begin
                person_x_left <= person_x_left + PERSON_HORIZONTAL_V; //Right movement
            end
            else if (left & (person_x_left > PERSON_HORIZONTAL_V)) 
            begin
                person_x_left <= person_x_left - PERSON_HORIZONTAL_V; //Left Movement
            end
        end
end


endmodule