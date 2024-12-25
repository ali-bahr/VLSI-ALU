module ALU (
    input [31:0] A,
    input [31:0] B,
    input selector,

    output reg [31:0] Result,
    output reg carry,
    output reg overflow
);

wire [31:0] add_result;
wire [31:0] mult_result;

wire temp_carry;
wire temp_overflow;


// Floating Point Adder for now
floating_point_adder FPA (
    .A(A),
    .B(B),
    .sum(add_result),
    .cout(temp_carry),
    .overflow(temp_overflow)
);


floating_point_multplier FPM (
    .a(A),
    .b(B),
    .product(mult_result),
    .overflow(temp_overflow)
);

always @(*) begin 
    if (selector == 1'b0) begin 
        Result = add_result; 
        carry = temp_carry;
    end else begin
        Result = mult_result;
        overflow = temp_overflow;
    end 
end

    
endmodule