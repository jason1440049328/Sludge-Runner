#Starting loop, initialize status reg and also 3 initial registers
addi $30, $0, 1
addi $1, $0, 2
addi $2, $0, 2
addi $3, $0, 2

#Stay in loop until signal is detected for either finish, time,
#or add. BNE not triggered when a point is added, allowed to
#flow to point_loop
main_loop:
add $0, $0, $0
add $0, $0, $0
blt $3, $30, finish_loop
blt $2, $30, time_loop
bne $1, $0, main_loop

#Loop for adding a point, then going back to main_loop
point_loop:
add $10, $10, $30
addi $1, $0, 2
j main_loop

#Loop for adding a point every second, then back to main_loop
time_loop:
add $11, $11, $30
addi $2, $0, 2
j main_loop

#Loop for the end; subtract time reg with point reg to
#display the final time
finish_loop:
sub $12, $11, $10
addi $3, $0, 2
j main_loop
add $0, $0, $0
add $0, $0, $0