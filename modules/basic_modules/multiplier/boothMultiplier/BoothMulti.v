module Adder (
    input  [31:0] A,
    input  [31:0] B,
    output  [31:0] Result
);
    assign Result = A + B;
endmodule

module Subtractor (
    input   [31:0] A,
    input   [31:0] B,
    output  [31:0] Result
);
    assign Result = A - B;
endmodule



module Level(

    input   [31:0]A,Q,M,
    input  Q_minus_one,
    output  [31:0] A_next,Q_next,
    output  Q_minus_one_next

    );

	wire  [31:0]add_A_M,sub_A_M;
    wire  [31:0]new_A;


    Adder add(A,M,add_A_M);
    Subtractor sub(A,M,sub_A_M);
	

    assign new_A = (Q[0] == 0 && Q_minus_one == 1) ? add_A_M :
                (Q[0] == 1 && Q_minus_one == 0) ? sub_A_M : A;


    // Final Stage Shifting
    assign Q_minus_one_next = Q[0];
    assign Q_next = {new_A[0], Q[31:1]};
    assign A_next = {new_A[31], new_A[31:1]};  
endmodule 





 
module BoothMulti(
    input   [31:0]A,B,
    output  [63:0] Result
);
    wire  [31:0] Q_wire [32:0];
    wire  [31:0] A_wire [32:0];
    wire Q_minus_one_wire [32:0];

    wire signA, signB;
    wire [31:0] absA, absB;
    wire [63:0] unsignedProduct;
    wire resultSign;
    wire [63:0] negProduct,shifted_product;

    // Sign logic
    assign signA = A[31];
    assign signB = B[31];

    assign resultSign = signA ^ signB;

    assign absA = (signA) ? (~A + 1) : A;
    assign absB = (signB) ? (~B + 1) : B;
    //

    assign A_wire[0] = 32'b00000000000000000000000000000000;
    assign Q_wire[0] = absA;
    assign Q_minus_one_wire[0] = 1'b0;

    genvar looper;
    generate
        for (looper = 0; looper < 32; looper = looper + 1) begin: main_loop
            Level l(A_wire[looper],Q_wire[looper],absB,Q_minus_one_wire[looper],
            A_wire[looper+1],Q_wire[looper+1],Q_minus_one_wire[looper+1]);
        end
    endgenerate

    assign shifted_product = {A_wire[31], Q_wire[31]};
    assign unsignedProduct = shifted_product >> 1;
    assign negProduct = ~unsignedProduct + 1;
    assign Result = (resultSign) ? negProduct : unsignedProduct;
	 
endmodule

