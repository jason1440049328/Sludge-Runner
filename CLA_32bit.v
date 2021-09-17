module CLA_32bit(data_OperandA, data_OperandB, c0, sum_32, ovf);

    input [31:0] data_OperandA, data_OperandB;
    input c0;

    output [31:0] sum_32;
    output ovf;

    wire c1, c2, c3, c4;
    wire P0, P1, P2, P3, G0, G1, G2, G3;
    wire overflow_1, overflow_2, overflow_3, overflow_4;
    wire P0C0;
    wire P1P0C0, P1G0; 
    wire P2P1P0C0, P2P1G0, P2G1; 
    wire P3P2P1P0C0, P3P2P1G0, P3P2G1, P3G2;

    CLA_8bit far_right(data_OperandA[7:0], data_OperandB[7:0], c0, P0, G0, sum_32[7:0], overflow_1);
    CLA_8bit middle_right(data_OperandA[15:8], data_OperandB[15:8], c1, P1, G1, sum_32[15:8], overflow_2);
    CLA_8bit middle_left(data_OperandA[23:16], data_OperandB[23:16], c2, P2, G2, sum_32[23:16], overflow_3);
    CLA_8bit far_left(data_OperandA[31:24], data_OperandB[31:24], c3, P3, G3, sum_32[31:24], overflow_4);

    //Output of c1 Calculation
    and P0C0_gate(P0C0, P0, c0);
    or c1_gate(c1, G0, P0C0);

    //Output of c2 Calculation
    and P1P0C0_gate(P1P0C0, P1, P0, c0);
    and P1G0_gate(P1G0, P1, G0);
    or c2_gate(c2, G1, P1G0, P1P0C0);

    //Outpit of c3 Calculation
    and P2P1P0C0_gate(P2P1P0C0, P2, P1, P0, c0);
    and P2P1G0_gate(P2P1G0, P2, P1, G0);
    and P2G1_gate(P2G1, P2, G1);
    or c3_gate(c3, G2, P2G1, P2P1G0, P2P1P0C0);

    //Output of c4 Calculation
    and P3P2P1P0C0_gate(P3P2P1P0C0, P3, P2, P1, P0, c0);
    and P3P2P1G0_gate(P3P2P1G0, P3, P2, P1, G0);
    and P3P2G1_gate(P3P2G1, P3, P2, G1);
    and P3G2_gate(P3G2, P3, G2);
    or c4_gate(c4, G3, P3G2, P3P2G1, P3P2P1G0, P3P2P1P0C0);

    //Final Overflow Calculation
    xor ovf_gate(ovf, c4, overflow_4);

endmodule