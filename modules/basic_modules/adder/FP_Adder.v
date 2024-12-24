module RippleCarryAdder(a, b, cin, sum, cout);
    input [31:0] a, b;
    input cin;
    output [31:0] sum;
    output cout;
    wire [31:0] carry;

    assign {cout, sum} = a + b + cin;
endmodule

module FloatingPointAdder(A, B, Sum);
    input [31:0] A, B;
    output [31:0] Sum;

    wire [23:0] mantissa_a, mantissa_b, mantissa_sum;
    wire [7:0] exponent_a, exponent_b, exponent_diff;
    wire sign_a, sign_b, sign_sum;
    wire carry_out;

    assign sign_a = A[31];
    assign sign_b = B[31];
    assign exponent_a = A[30:23];
    assign exponent_b = B[30:23];
    assign mantissa_a = {1'b1, A[22:0]};
    assign mantissa_b = {1'b1, B[22:0]};

    assign exponent_diff = exponent_a - exponent_b;

    wire [31:0] shifted_mantissa_b = mantissa_b >> exponent_diff;

    RippleCarryAdder rca(mantissa_a, shifted_mantissa_b, 1'b0, mantissa_sum, carry_out);

    assign Sum[31] = sign_a;
    assign Sum[30:23] = exponent_a;
    assign Sum[22:0] = mantissa_sum[22:0];
endmodule
