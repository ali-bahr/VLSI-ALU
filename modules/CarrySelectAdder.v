// This code defines a 32-bit Carry Select Adder using two Ripple Carry Adders to compute the sum and carry for both possible carry-in values (0 and 1). The appropriate sum and carry are then selected based on the carry-out of the previous stage.

module CarrySelectAdder (
    input [31:0] A,
    input [31:0] B,
    output [31:0] Sum,
    output Cout
);
    wire [31:0] Sum0, Sum1;
    wire [31:0] Carry0, Carry1;
    wire [31:0] CarrySelect;

    // Generate Sum and Carry for Cin = 0
    RippleCarryAdder RCA0 (
        .A(A),
        .B(B),
        .Cin(1'b0),
        .Sum(Sum0),
        .Cout(Carry0)
    );

    // Generate Sum and Carry for Cin = 1
    RippleCarryAdder RCA1 (
        .A(A),
        .B(B),
        .Cin(1'b1),
        .Sum(Sum1),
        .Cout(Carry1)
    );

    // Select the appropriate Sum and Carry based on CarrySelect
    assign CarrySelect = {Carry0[30:0], 1'b0} | {Carry1[30:0], 1'b1};
    assign Sum = (CarrySelect) ? Sum1 : Sum0;
    assign Cout = (CarrySelect) ? Carry1[31] : Carry0[31];

endmodule

