`timescale 1ns / 1ps

module Screen_Controller(clk, reset_game, reg12_out, pause, left, right, fast_speed, slow_speed, active, start_en, crash_en, finish_en, pixel_x, pixel_y, path_on, finish_line, person_on, coin_on, second_tick, RGB_Out);

//Inputs and Output declarations
input clk, reset_game, pause, left, right, fast_speed, slow_speed;
input active, start_en, crash_en, finish_en;
input [31:0] reg12_out;
output second_tick;
input wire [9:0] pixel_x, pixel_y;
output reg [11:0] RGB_Out;
output path_on, finish_line, person_on, coin_on;

//Output of various RGBs from submodules
wire [11:0] RGB_PATH, RGB_Person, RGB_Text, RGB_Coin;
reg clk50;
reg [1:0] state;

//Controller for displaying the path
Path path(clk, reset_game, clk50, pause, fast_speed, slow_speed, pixel_x, pixel_y, path_on, finish_line, RGB_PATH);

//Controller for displaying the coins //COIN_ON MOVE TO CONTROLLER
Coin coins(clk, reset_game, clk50, pause, fast_speed, slow_speed, pixel_x, pixel_y, coin_on, RGB_Coin);

//Controller for displaying the bitmap of the person
Person per(clk, reset_game, clk50, left, right, pause, pixel_x, pixel_y, person_on, RGB_Person);

//Controller for deciding on which text to display
Text texts(clk, reset_game, reg12_out, pause, clk50, start_en, crash_en, finish_en, pixel_x, pixel_y, text_on, second_tick, RGB_Text);

//Logic for picking which RGB to output to the VGA Screen
always @*
    if (~active)
        RGB_Out = 12'b0;            //Display nothing if the video isn't on
    else
        if (text_on)
            RGB_Out = RGB_Text;     //Display the text
        else if (person_on)
            RGB_Out = RGB_Person;   //Display the person
        else if (coin_on)
            RGB_Out = RGB_Coin;     //Display the Coin
        else if (path_on)
            RGB_Out = RGB_PATH;     //Display the path
        else
            RGB_Out = 12'hf0f;      //Display default background (Magenta - Sludge)

//Logic for a slower clock such that it is not always asserted, but instead when the screen pixels refresh.
always @(posedge clk)
    case(state)
        0: if ((pixel_x == 0) && (pixel_y == 481))
            begin
                state <= 2'b1;
                clk50 <= 1'b1;
            end
        1: begin
            state <= 2'b10;
            clk50 <= 1'b0;
        end
        2: state <= 2'b11;
        3: state <= 2'b00;
    endcase



endmodule