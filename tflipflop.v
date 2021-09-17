module tflipflop(t, clk, clr, en, q, qnot);

    input t, clk, clr, en;
    output q, qnot;
    wire not_t_wire, and_top_wire, and_bottom_wire, or_wire, qnot_wire;

    not not_t(not_t_wire, t);
    and and_top(and_top_wire, not_t_wire, q);
    and and_bottom(and_bottom_wire, t, qnot_wire);
    or or_and_gates(or_wire, and_top_wire, and_bottom_wire);

    //Connect to flipflop, negate q
    dffe_ref dffe1(q, or_wire, clk, en, clr);
    not qnot_gate(qnot_wire, q);
    assign qnot = qnot_wire;


endmodule