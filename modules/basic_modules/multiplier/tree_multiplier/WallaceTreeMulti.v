module WallaceTreeMulti(
    input [31:0] A, B,
    output [63:0] Result
);


wire signA, signB;
wire [31:0] absA, absB;
wire [63:0] unsignedProduct;
wire resultSign;
wire [63:0] negProduct;


// Sign logic
assign signA = A[31];
assign signB = B[31];

assign resultSign = signA ^ signB;

assign absA = (signA) ? (~A + 1) : A;
assign absB = (signB) ? (~B + 1) : B;

wire [31:0]add_saver[31:0];


// Calculate the AND between each Bi and A[:] for each i with 31 to 0
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : loop
        AND a (absA, absB[i], add_saver[i]);
    end
endgenerate

// Now we have the data in that form
//   *************
//   *************
//   *************
//   *************









// for helping in calculating, we transform the form of the data within a matrix

wire [63:0]matrix[31:0];

assign matrix[0][31:0] = add_saver[0];
assign matrix[0][63:32] = 0;

generate
    for (i = 1; i < 32; i = i + 1) begin : transform_loop

        assign matrix[i][0+i-1:0] = 0;
        assign matrix[i][31+i:0+i] = add_saver[i];
        assign matrix[i][63:32+i] = 0;

    end
endgenerate


// Now we have the data in that form
//     *************
//    *************
//   *************
//  *************




// Levels of addition


wire [63:0]level_1[21:0];
wire [63:0]level_2[14:0];
wire [63:0]level_3[9:0];
wire [63:0]level_4[6:0];
wire [63:0]level_5[4:0];
wire [63:0]level_6[3:0];
wire [63:0]level_7[2:0];
wire [63:0]level_8[1:0];
wire [63:0]final_level_9;

// 1 : 32 >>> 22

genvar looper;
generate
    for (looper = 0; looper < 10; looper = looper + 1) begin: level_1_loop
        Adder64bit add(matrix[looper*3],matrix[looper*3 +1],matrix[looper*3+2],
        level_1[looper*2],level_1[looper*2+1]);
    end
endgenerate

assign level_1[20] = matrix[30];
assign level_1[21] = matrix[31];

// 2 : 22 >>> 15
generate
    for (looper = 0; looper < 7; looper = looper + 1) begin: level_2_loop
        Adder64bit add(level_1[looper*3],level_1[looper*3 +1],level_1[looper*3+2],
        level_2[looper*2],level_2[looper*2+1]);
    end
endgenerate

assign level_2[14] = level_1[21];


// 3 : 15 >> 10   :::: last digit here is 14,9
generate
    for (looper = 0; looper < 5; looper = looper + 1) begin: level_3_loop
        Adder64bit add(level_2[looper*3],level_2[looper*3 +1],level_2[looper*3+2],
        level_3[looper*2],level_3[looper*2+1]);
    end
endgenerate

// 4 : 10 >>> 7   : last digit here is 8,5
generate
    for (looper = 0; looper < 3; looper = looper + 1) begin: level_4_loop
        Adder64bit add(level_3[looper*3],level_3[looper*3 +1],level_3[looper*3+2],
        level_4[looper*2],level_4[looper*2+1]);
    end
endgenerate
assign level_4[6] = level_3[9];


// 5 : 7 >>> 5 :last digit here is 5,3
generate
    for (looper = 0; looper < 2; looper = looper + 1) begin: level_5_loop
        Adder64bit add(level_4[looper*3],level_4[looper*3 +1],level_4[looper*3+2],
        level_5[looper*2],level_5[looper*2+1]);
    end
endgenerate

assign level_5[4] = level_4[6];

// 6 : 5 >>> 4 :last digit here is 2,1


Adder64bit add_level_6(level_5[0],level_5[1],level_5[2],level_6[0],level_6[1]);
assign level_6[2] = level_5[3];
assign level_6[3] = level_5[4];


// 7 : 4 >>> 3

Adder64bit add_level_7(level_6[0],level_6[1],level_6[2],level_7[0],level_7[1]);
assign level_7[2] = level_6[3];


// 8 : 3 >>> 2

Adder64bit add_level_8(level_7[0],level_7[1],level_7[2],level_8[0],level_8[1]);

// 9 : 2 >>> 1

wire [63:0] not_needed_carry;
Adder64bit final_adder(level_8[0],level_8[1],64'b0,final_level_9,not_needed_carry);


// Final calculations

assign unsignedProduct = final_level_9;
assign negProduct = ~unsignedProduct + 1;
assign Result = (resultSign) ? negProduct : unsignedProduct;



endmodule

module AND(a, b, c);
    input [31:0] a;
    input b;
    output [31:0] c;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : and_loop
            assign c[i] = a[i] & b;
        end
    endgenerate
endmodule

module Adder64bit(
    // This Addar is of type CSA Carray-Save Addar "Ahmed Kamal"
    input [63:0] A,B,C,
    output [63:0] Sum,Carry
);

assign Carry[0] = 0;
assign Sum[63] = 0;

assign Sum[62:0]=A ^ B ^ C;
assign Carry[63:1]= ((A&B) | (B&C) | (C&A));

endmodule
