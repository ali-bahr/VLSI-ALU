// This code defines a 32-bit signed Ripple Carry Adder using a series of full adders. Each full adder computes the sum and carry-out for each bit, and the carry-out of one full adder is fed into the carry-in of the next.

module RippleCarryAdder (
    input signed [31:0] A,
    input signed [31:0] B,
    input Cin, // this must be zero incase of stand-alone RippleCarryAdder
    output signed [31:0] Sum,
    output Cout
);
    wire [31:0] Carry;
    
    // Full Adder for the least significant bit
    FullAdder FA0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Sum(Sum[0]),
        .Cout(Carry[0])
    );
    
    // Full Adders for the remaining bits
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : FA
            FullAdder FA (
                .A(A[i]),
                .B(B[i]),
                .Cin(Carry[i-1]),
                .Sum(Sum[i]),
                .Cout(Carry[i])
            );
        end
    endgenerate
    
    assign Cout = Carry[31];
endmodule

