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

// let's take CarryByPassAdder for now

CarryBypassAdder CBA (
    .A(A),
    .B(B),
    .Sum(add_result),
    .Cout(temp_carry)
);

// let's take multiplier_simple for now

multiplier_simple MS (
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