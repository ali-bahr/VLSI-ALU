// This code defines a 32-bit Carry Look-Ahead Adder. The G and P signals represent the generate and propagate signals, respectively. The carry look-ahead logic calculates the carry signals in parallel, which speeds up the addition process compared to a Ripple Carry Adder.

module CarryLookAheadAdder (
    input [31:0] A,
    input [31:0] B,
    output [31:0] Sum,
    output Cout
);
    wire [31:0] G, P, C;

    // Generate and Propagate signals
    assign G = A & B; // Generate
    assign P = A ^ B; // Propagate


    // Carry Look-Ahead Logic
    assign C[0] = 1'b0;
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : carry_gen
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate

    // Sum and Carry Out
    assign Sum = P ^ C;
    assign Cout = G[31] | (P[31] & C[31]);

endmodule
