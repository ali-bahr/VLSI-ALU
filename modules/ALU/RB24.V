
module RippleCarryAdder24 (
    input signed [24:0] A,
    input signed [24:0] B,
    input Cin, // this must be zero incase of stand-alone RippleCarryAdder
    output signed [24:0] Sum,
    output Cout
);
    wire [24:0] Carry;
    
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
        for (i = 1; i < 25; i = i + 1) begin : FA
            FullAdder FA (
                .A(A[i]),
                .B(B[i]),
                .Cin(Carry[i-1]),
                .Sum(Sum[i]),
                .Cout(Carry[i])
            );
        end
    endgenerate
    
    assign Cout = Carry[24];
endmodule

