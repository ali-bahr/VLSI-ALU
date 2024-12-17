// implements a 32-bit signed multiplier using the `*` operator. 

module multiplier_simple (
    input signed [31:0] a,
    input signed [31:0] b,
    output reg signed [63:0] product
);

    always @(*) begin
        product <= a * b;
    end

endmodule

//
// pros: simple , synthesizer optimized.
// cons: limited control over  hardware.
// 