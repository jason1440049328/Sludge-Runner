`timescale 1ns / 1ps

module Game_Controller(clk, reset, active, path_on, finish_line, person_on, coin_on, fast_speed, slow_speed, start_en, crash_en, finish_en, pause, reset_game, add_point);

input clk, reset;
input active, path_on, finish_line, person_on, coin_on;
input fast_speed, slow_speed; 
output reg start_en, crash_en, finish_en, pause, reset_game, add_point;

reg [23:0] time_tick;
reg can_add;
reg[2:0] currentState = 3'd0;


//Buffer for adding the score such that once the player gets the point, another one won't
//register for 0.1ms to prevent double counting
always @(posedge clk)
begin
    time_tick <= time_tick + 1;
    if (time_tick==15000000)
        begin
            time_tick <= 0;
            can_add <= 1'b1;
        end
end

//FSM Implemented to test whether or not to stay in paused state or move along and start
//the game, and when to display messages based on collisions that happen on screen.
always @(posedge clk)
    begin
        if (reset)
            currentState <= 3'b0;
            case(currentState)
                3'd0: if(fast_speed || slow_speed)         //Player presses to start the game
                    begin
                        currentState <= 3'd1; 
                        start_en <= 1'b0; 
                        pause <= 1'b0;
                        reset_game <= 1'b0;
                        add_point <= 1'b0;
                        can_add <= 1'b1;
                    end
                    else                                    //Show start page, reset the game, wait for enter key
                        begin
                            start_en <=1'b1; 
                            crash_en <= 1'b0;
                            finish_en <=1'b0; 
                            pause <= 1'b1;
                            reset_game <= 1'b1;
                            add_point <= 1'b0;
                            can_add <= 1'b1;
                        end

                3'd1: 
                    if (active && person_on && coin_on && can_add == 1'b1)    //Player gets a coin
                        begin
                            add_point <= 1'b1;
                            can_add <= 1'b0;
                        end
                    
                    else if(active && person_on && !path_on) //Run until player hits sludge or reaches finish
                        begin
                            crash_en <= 1'b1;
                            if (fast_speed || slow_speed)
                                currentState <= 3'd1;
                            else
                                currentState <= 3'd2;
                                pause <= 1'b1;
                        end

                    else if(active & person_on & finish_line) //Player reaches finish line
                        begin
                          finish_en<=1'b1;  
                          if(fast_speed || slow_speed)
                            currentState<= 3'd1;
                          else
                            currentState <=3'd2;
                            pause <=1'b1;
                        end

                    else if (active && person_on && path_on)        //Player continues playing normally
                        begin
                            add_point <= 1'b0;
                        end
        
                3'd2: if (fast_speed || slow_speed)
                        begin
                            currentState<= 3'd3; 
                        end

                    default: currentState <= 3'd0;
            endcase

        
    end
endmodule