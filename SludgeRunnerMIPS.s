addi $30, $0, 1
addi $1, $0, 2
addi $2, $0, 2
addi $3, $0, 2
blt $3, $30, 8
blt $2, $30, 4
bne $1, $0, -3
add $10, $10, $30
addi $1, $0, 2
j 4
add $11, $11, $30
addi $2, $0, 2
j 4
sub $12, $11, $10
addi $3, $0, 2
j 4
add $0, $0, $0
add $0, $0, $0