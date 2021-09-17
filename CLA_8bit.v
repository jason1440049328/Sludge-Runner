module CLA_8bit(data_A, data_B, c0, P0_BIG, G0_BIG, sum, cout7_ovf);
    
    input [7:0] data_A, data_B;
    input c0; 

    output [7:0] sum;
    output cout7_ovf, P0_BIG, G0_BIG;

    wire p0, p1, p2, p3, p4, p5, p6, p7, g0, g1, g2, g3, g4, g5, g6, g7;
    wire cout1, cout2, cout3, cout4, cout5, cout6, cout7;
    wire p0c0;
    wire p1p0c0, p1g0;
    wire p2p1p0c0, p2p1g0, p2g1; 
    wire p3p2p1p0c0, p3p2p1g0, p3p2g1, p3p2;
    wire p4p3p2p1p0c0, p4p3p2p1g0, p4p3p2g1, p4p3g2, p4g3;
    wire p5p4p3p2p1p0c0, p5p4p3p2p1g0, p5p4p3p2g1, p5p4p3g2, p5p4g3, p5g4;
    wire p6p5p4p3p2p1p0c0, p6p5p4p3p2p1g0, p6p5p4p3p2g1, p6p5p4p3g2, p6p5p4g3, p6p5g4, p6g5;
    wire p7p6p5p4p3p2p1p0c0, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2g1, p7p6p5p4p3g2, p7p6p5p4g3, p7p6p5g4, p7p6g5, p7g6;

    //Declaration of little p and little g gates
    xor p0_gate(p0, data_A[0], data_B[0]);
    xor p1_gate(p1, data_A[1], data_B[1]);
    xor p2_gate(p2, data_A[2], data_B[2]);
    xor p3_gate(p3, data_A[3], data_B[3]);
    xor p4_gate(p4, data_A[4], data_B[4]);
    xor p5_gate(p5, data_A[5], data_B[5]);
    xor p6_gate(p6, data_A[6], data_B[6]);
    xor p7_gate(p7, data_A[7], data_B[7]);

    and g0_gate(g0, data_A[0], data_B[0]);
    and g1_gate(g1, data_A[1], data_B[1]);
    and g2_gate(g2, data_A[2], data_B[2]);
    and g3_gate(g3, data_A[3], data_B[3]);
    and g4_gate(g4, data_A[4], data_B[4]);
    and g5_gate(g5, data_A[5], data_B[5]);
    and g6_gate(g6, data_A[6], data_B[6]);
    and g7_gate(g7, data_A[7], data_B[7]);

    //Bit 0
    xor sum0(sum[0], p0, c0);

    //Bit 1
    and p0c0_gate(p0c0, p0, c0);
    or cout1_gate(cout1, g0, p0c0);

    xor sum1(sum[1], p1, cout1);

    //Bit 2
    and p1p0c0_gate(p1p0c0, p1, p0, c0);
    and p1g0_gate(p1g0, p1, g0);
    or cout2_gate(cout2, g1, p1g0, p1p0c0);

    xor sum2(sum[2], p2, cout2);

    //Bit 3
    and p2p1p0c0_gate(p2p1p0c0, p2, p1, p0, c0);
    and p2p1g0_gate(p2p1g0, p2, p1, g0);
    and p2g1_gate(p2g1, p2, g1);
    or cout3_gate(cout3, g2, p2g1, p2p1g0, p2p1p0c0);

    xor sum3(sum[3], p3, cout3);

    //Bit 4
    and p3p2p1p0c0_gate(p3p2p1p0c0, p3, p2, p1, p0, c0);
    and p3p2p1g0_gate(p3p2p1g0, p3, p2, p1, g0);
    and p3p2g1_gate(p3p2g1, p3, p2, g1);
    and p3g2_gate(p3g2, p3, g2);
    or cout4_gate(cout4, g3, p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0);

    xor sum4(sum[4], p4, cout4);

    //Bit 5
    and p4p3p2p1p0c0_gate(p4p3p2p1p0c0, p4, p3, p2, p1, p0, c0);
    and p4p3p2p1g0_gate(p4p3p2p1g0, p4, p3, p2, p1, g0);
    and p4p3p2g1_gate(p4p3p2g1, p4, p3, p2, g1);
    and p4p3g2_gate(p4p3g2, p4, p3, g2);
    and p4g3_gate(p4g3, p4, g3);
    or cout5_gate(cout5, g4, p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0);

    xor sum5(sum[5], p5, cout5);

    //Bit 6
    and p5p4p3p2p1p0c0_gate(p5p4p3p2p1p0c0, p5, p4, p3, p2, p1, p0, c0);
    and p5p4p3p2p1g0_gate(p5p4p3p2p1g0, p5, p4, p3, p2, p1, g0);
    and p5p4p3p2g1_gate(p5p4p3p2g1, p5, p4, p3, p2, g1);
    and p5p4p3g2_gate(p5p4p3g2, p5, p4, p3, g2);
    and p5p4g3_gate(p5p4g3, p5, p4, g3);
    and p5g4_gate(p5g4, p5, g4);
    or cout6_gate(cout6, g5, p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0);

    xor sum6(sum[6], p6, cout6);

    //Bit 7
    and p6p5p4p3p2p1p0c0_gate(p6p5p4p3p2p1p0c0, p6, p5, p4, p3, p2, p1, p0, c0);
    and p6p5p4p3p2p1g0_gate(p6p5p4p3p2p1g0, p6, p5, p4, p3, p2, p1, g0);
    and p6p5p4p3p2g1_gate(p6p5p4p3p2g1, p6, p5, p4, p3, p2, g1);
    and p6p5p4p3g2_gate(p6p5p4p3g2, p6, p5, p4, p3, g2);
    and p6p5p4g3_gate(p6p5p4g3, p6, p5, p4, g3);
    and p6p5g4_gate(p6p5g4, p6, p5, g4);
    and p6g5_gate(p6g5, p6, g5);
    or cout7_gate(cout7, g6, p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0);


    xor sum7(sum[7], p7, cout7);

    //cout7_ovf output
    and ovf(cout7_ovf, cout7, cout7);

    //Big G0 Calculation
    and p7p6p5p4p3p2p1p0c0_gate(p7p6p5p4p3p2p1p0c0, p7, p6, p5, p4, p3, p2, p1, p0, c0);
    and p7p6p5p4p3p2p1g0_gate(p7p6p5p4p3p2p1g0, p7, p6, p5, p4, p3, p2, p1, g0);
    and p7p6p5p4p3p2g1_gate(p7p6p5p4p3p2g1, p7, p6, p5, p4, p3, p2, g1);
    and p7p6p5p4p3g2_gate(p7p6p5p4p3g2, p7, p6, p5, p4, p3, g2);
    and p7p6p5p4g3_gate(p7p6p5p4g3, p7, p6, p5, p4, g3);
    and p7p6p5g4_gate(p7p6p5g4, p7, p6, p5, g4);
    and p7p6g5_gate(p7p6g5, p7, p6, g5);
    and p7g6_gate(p7g6, p7, g6);
    or big_g0_gate(G0_BIG, g7, p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2, p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2p1p0c0);

    //Big P0 Calculation
    and big_p0_gate(P0_BIG, p7, p6, p5, p4, p3, p2, p1, p0);

endmodule