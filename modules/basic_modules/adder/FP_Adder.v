module fp_adder (
    input [31:0] A,
    input [31:0] B,
    output [31:0] Sum
);

    wire [7:0] exp_a, exp_b, exp_diff;
    wire [23:0] mant_a, mant_b, mant_sum;
    wire sign_a, sign_b, sign_result;
    wire [31:0] aligned_mant_a, aligned_mant_b;
    wire [31:0] mant_sum_extended;
    wire [7:0] exp_result;
    wire [23:0] mant_result;
    wire carry;

    assign sign_a = A[31];
    assign sign_b = B[31];
    assign exp_a = A[30:23];
    assign exp_b = B[30:23];
    assign mant_a = {1'b1, A[22:0]};
    assign mant_b = {1'b1, B[22:0]};

    assign exp_diff = exp_a - exp_b;

    assign aligned_mant_a = (exp_a >= exp_b) ? mant_a : (mant_a >> exp_diff);
    assign aligned_mant_b = (exp_b >= exp_a) ? mant_b : (mant_b >> exp_diff);

    // assign mant_sum_extended = (sign_a == sign_b) ? (aligned_mant_a + aligned_mant_b) : (aligned_mant_a - aligned_mant_b);

    CarryBypassAdder CBA(
        aligned_mant_a,
        aligned_mant_b,
        mant_sum_extended,
        carry
    );

    assign sign_result = (mant_sum_extended[24]) ? sign_a : sign_b;
    assign mant_result = (mant_sum_extended[24]) ? mant_sum_extended[23:1] : mant_sum_extended[22:0];
    assign exp_result = (mant_sum_extended[24]) ? (exp_a + 1) : exp_a;

    assign Sum = {sign_result, exp_result, mant_result[22:0]};

endmodule

