`timescale 1ns / 1ps

module Time_Display(clk, reset_game, pause, clk50, pixel_x, pixel_y, time_on, time_bit_addr, time_rom_addr, second_tick);


//Declare Inputs and Outputs
input clk, reset_game, pause, clk50;
input [9:0] pixel_x, pixel_y;
output time_on;
output [2:0] time_bit_addr;
output [10:0] time_rom_addr;
output reg second_tick;

wire [3:0] row_addr;    
reg [6:0] char_addr;
reg [23:0] time_count;
reg [9:0] runTime;
reg [3:0] milliseconds, seconds, seconds_10s;

//Assign where time should be shown
assign time_on = (pixel_y [9: 5] == 1) && (pixel_x [9: 4] < 9) ;

//Construct ROM address to show
assign row_addr = pixel_y [4:1];
assign time_bit_addr = pixel_x [3:1];
assign time_rom_addr = {char_addr, row_addr};

reg[23:0] tempCount;
reg [9:0] tempRunTime;
reg[3:0] tempSeconds;
always @(posedge clk)
begin
    tempCount <= tempCount + 1;
    if (reset_game)
        tempRunTime <= tempRunTime;
    else if (pause)
        tempRunTime <= tempRunTime;
    else if (tempCount == 10000000)
    begin
        tempCount <= 0;
        tempRunTime <= tempRunTime + 1;
    end
    if (clk50)
        begin
            second_tick <= 1'b0;
            tempSeconds <= (tempRunTime % 100) / 10;
            if (tempSeconds == 1)
                begin
                    second_tick <= 1'b1;
                    tempSeconds <= 1'b0;
                end
        end

end

//Logic for determining milliseconds and seconds
always @(posedge clk)
begin
    time_count <= time_count + 1;
    if (reset_game) //Reset the timer
        runTime <= 0;
    else if (pause)
        runTime <= runTime;
    else if (time_count == 10000000)
        begin
            time_count <= 0;
            runTime <= runTime + 1;
        end
    if (clk50)
        begin
            milliseconds <= runTime % 10;
            seconds <= (runTime % 100) / 10;
            seconds_10s <= (runTime % 1000) / 100;
        end
end

//Display on screen based on mapping from ROM
always @*
    case (pixel_x [7:4])
        4'h0: char_addr = {3'b011, seconds_10s}; //Seconds tens digit
        4'h1: char_addr = {3'b011, seconds};     //Seconds
        4'h2: char_addr = 7'h2e;                 //Colon
        4'h3: char_addr = {3'b011, milliseconds};//Milliseconds
    default: char_addr = 7'h00;
endcase


endmodule

