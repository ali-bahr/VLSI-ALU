module ALU (
    input [31:0] A,
    input [31:0] B,
    input selector,

    output reg [63:0] Result,
    output reg carry
);

wire [31:0] add_result;
wire [63:0] mult_result;

wire temp_carry;

// Floating Point Adder for now
fp_adder FPA (
    .A(A),
    .B(B),
    .Sum(add_result),
    .carry(temp_carry)
);


flaoting_point_nult FPM (
    .a(A),
    .b(B),
    .product(mult_result)
);

always @(*) begin 
    if (selector == 1'b0) begin 
        Result = add_result; 
        carry = temp_carry;
    end else begin
        Result = mult_result;
        carry = 1'b0;
    end 
end

    
endmodule