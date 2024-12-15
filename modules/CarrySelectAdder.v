// This code defines a 32-bit Carry Select Adder using two Ripple Carry Adders to compute the sum and carry for both possible carry-in values (0 and 1). The appropriate sum and carry are then selected based on the carry-out of the previous stage.


module CarrySelectAdder(
    input [31:0] A, B,
    output [31:0] Sum,
    output Cout
);
    wire [3:0] c;


    ripple_carry_8_bit rca1( .a(A[7:0]), .b(B[7:0]), .cin(1'b0), .sum(Sum[7:0]), .cout(c[0])); // first 8-bit by ripple_carry_adder
    carry_select_adder_8bit_slice csa_slice1( .a(A[15:8]), .b(B[15:8]), .cin(c[0]), .sum(Sum[15:8]), .cout(c[1]));
    carry_select_adder_8bit_slice csa_slice2( .a(A[23:16]), .b(B[23:16]), .cin(c[1]), .sum(Sum[23:16]), .cout(c[2]));
    carry_select_adder_8bit_slice csa_slice3( .a(A[31:24]), .b(B[31:24]), .cin(c[2]), .sum(Sum[31:24]), .cout(Cout));
endmodule

//////////////////////////////////////
// 8-bit Carry Select Adder Slice
//////////////////////////////////////
module carry_select_adder_8bit_slice(a, b, cin, sum, cout);
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output cout;
    wire [7:0] s0, s1;
    wire c0, c1;

    ripple_carry_8_bit rca1( .a(a[7:0]), .b(b[7:0]), .cin(1'b0), .sum(s0[7:0]), .cout(c0));
    ripple_carry_8_bit rca2( .a(a[7:0]), .b(b[7:0]), .cin(1'b1), .sum(s1[7:0]), .cout(c1));
    mux2X1 #(8) ms0( .in0(s0[7:0]), .in1(s1[7:0]), .sel(cin), .out(sum[7:0]));
    mux2X1 #(1) mc0( .in0(c0), .in1(c1), .sel(cin), .out(cout));
endmodule

/////////////////////
// 2X1 Mux
/////////////////////
module mux2X1(in0, in1, sel, out);
    parameter width = 16;
    input [width-1:0] in0, in1;
    input sel;
    output [width-1:0] out;
    assign out = (sel) ? in1 : in0;
endmodule

/////////////////////////////////
// 8-bit Ripple Carry Adder
/////////////////////////////////
module ripple_carry_8_bit(a, b, cin, sum, cout);
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output cout;
    wire c1, c2, c3, c4, c5, c6, c7;

    FullAdder fa0( .A(a[0]), .B(b[0]), .Cin(cin), .Sum(sum[0]), .Cout(c1));
    FullAdder fa1( .A(a[1]), .B(b[1]), .Cin(c1), .Sum(sum[1]), .Cout(c2));
    FullAdder fa2( .A(a[2]), .B(b[2]), .Cin(c2), .Sum(sum[2]), .Cout(c3));
    FullAdder fa3( .A(a[3]), .B(b[3]), .Cin(c3), .Sum(sum[3]), .Cout(c4));
    FullAdder fa4( .A(a[4]), .B(b[4]), .Cin(c4), .Sum(sum[4]), .Cout(c5));
    FullAdder fa5( .A(a[5]), .B(b[5]), .Cin(c5), .Sum(sum[5]), .Cout(c6));
    FullAdder fa6( .A(a[6]), .B(b[6]), .Cin(c6), .Sum(sum[6]), .Cout(c7));
    FullAdder fa7( .A(a[7]), .B(b[7]), .Cin(c7), .Sum(sum[7]), .Cout(cout));
endmodule




// module CarrySelectAdder (
//     input [31:0] A,
//     input [31:0] B,
//     output [31:0] Sum,
//     output Cout
// );
//     wire [31:0] Sum0, Sum1;
//     wire [31:0] Carry0, Carry1;
//     wire [31:0] CarrySelect;

//     // Generate Sum and Carry for Cin = 0
//     RippleCarryAdder RCA0 (
//         .A(A),
//         .B(B),
//         .Cin(1'b0),
//         .Sum(Sum0),
//         .Cout(Carry0)
//     );

//     // Generate Sum and Carry for Cin = 1
//     RippleCarryAdder RCA1 (
//         .A(A),
//         .B(B),
//         .Cin(1'b1),
//         .Sum(Sum1),
//         .Cout(Carry1)
//     );

//     // Select the appropriate Sum and Carry based on CarrySelect
//     assign CarrySelect = {Carry0[30:0], 1'b0} | {Carry1[30:0], 1'b1};
//     assign Sum = (CarrySelect) ? Sum1 : Sum0;
//     assign Cout = (CarrySelect) ? Carry1[31] : Carry0[31];

// endmodule

