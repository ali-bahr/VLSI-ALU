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





module RippleCarryAdder24 (
    input signed [24:0] A,
    input signed [24:0] B,
    input Cin, // this must be zero incase of stand-alone RippleCarryAdder
    output signed [24:0] Sum,
    output Cout
);
    wire [24:0] Carry;
    
    // Full Adder for the least significant bit
    FullAdder FA0 (
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Sum(Sum[0]),
        .Cout(Carry[0])
    );
    
    // Full Adders for the remaining bits
    genvar i;
    generate
        for (i = 1; i < 25; i = i + 1) begin : FA
            FullAdder FA (
                .A(A[i]),
                .B(B[i]),
                .Cin(Carry[i-1]),
                .Sum(Sum[i]),
                .Cout(Carry[i])
            );
        end
    endgenerate
    
    assign Cout = Carry[24];
endmodule



module msb (
    input  [31:0] a, 
    output wire [4:0] msb
);
    integer i;
    reg [4:0] temp;
    always @* begin : loop
    temp = 5'd0;
        for (i = 0; i < 32; i = i + 1) begin
            if (a[i] == 1'b1) begin
                temp = i;
            end
        end
    end
    assign msb = temp;
endmodule


module FullAdder (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (Cin & (A ^ B));
endmodule


module floating_point_adder (
    input [31:0] A,
    input [31:0] B,
    output [31:0] sum,
    output cout,
    output overflow

);
        reg [7:0] difference, exponent;
        reg [24:0] mantissa_a, mantissa_b, mantissa_sum;
        reg sign;
        reg [31:0] mantissa_padded;
        wire [4:0] shift_cnt;
        wire [24:0] adder_output;
        wire adder_cout, adder_overflow;
        reg [4:0] shift_amount;
        reg mantissa_overflow;
        reg mantissa_cin;
        msb msb0(mantissa_padded, shift_cnt);
        RippleCarryAdder24 fpadder(mantissa_a, mantissa_b, mantissa_cin, adder_output, adder_cout );

        always @(*) begin
            mantissa_a = {2'b01, A[22:0]};
            mantissa_b = {2'b01, B[22:0]};
            mantissa_padded = 1'd0;
            mantissa_cin = 1'b0;
            mantissa_overflow = 1'b0;
            shift_amount = 1'd0;

                if (A == 1'd0 | B == 1'd0) begin 
                    if (A == 1'd0) begin
                        mantissa_sum = mantissa_b;
                        exponent = B[30:23];
                        sign = B[31];
                    end
                    else begin
                        mantissa_sum = mantissa_a;
                        exponent = A[30:23];
                        sign = A[31];
                    end

                    if (mantissa_sum == 25'h0800000 & exponent == 1'd0) begin
                        sign = 1'b0;
                    end

                end
                else begin
                    difference = A[30:23] - B[30:23];
                    if(difference[7] == 1'b0) begin
                        mantissa_b = mantissa_b >> difference; // shift B to make B exponent greater
                        exponent = A[30:23];
                        sign = A[31];

                    end 
                    else begin
                        difference = (~difference) + 1;
                        mantissa_a = mantissa_a >> difference; // shift A to make A exponent greater
                        exponent = B[30:23];
                        sign = B[31];
                    end

                    if ((A[31]^B[31]) == 1'b1) begin 
                        mantissa_cin = 1'b1;
                        if (A[31] == 1'b1) begin
                            mantissa_a = ~mantissa_a;
                        end
                        else begin 
                            mantissa_b = ~mantissa_b;                    
                        end

                        mantissa_sum = adder_output;

                        if (difference == 1'd0) begin
                            sign = mantissa_sum[24];
                        end

                        if (sign == 1'b1) begin
                            mantissa_sum = ~mantissa_sum +1;
                        end

                        if (mantissa_sum[23] == 1'b0) begin
                            mantissa_padded = {mantissa_sum[23:0], 8'b00000000};
                            shift_amount = ~(shift_cnt);
                            exponent = exponent - shift_amount;
                            mantissa_sum = mantissa_sum << shift_amount;
                        end
                    end
                    else begin
                        mantissa_sum = adder_output;
                        sign = A[31];
                        if (mantissa_sum[24] == 1'b1) begin
                            exponent = exponent + 1'b1;
                            mantissa_sum = mantissa_sum >> 1; 
                        end
                    end
                    if (mantissa_sum == 25'h0ffffff & exponent == 8'hfe) begin
                         mantissa_overflow = 1'b1;
                    end
                end
            end

        assign cout = mantissa_sum[24];
        assign sum[31] = sign;
        assign sum[22:0] = mantissa_sum[22:0];
        assign sum[30:23] = exponent;
        assign overflow = mantissa_overflow;
endmodule





module floating_point_multplier (
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] product,
    output reg overflow
);

    reg sign;
    reg [22:0] mantissa_result;
    reg [23:0] mantissa_a, mantissa_b;
    reg [47:0] mantissa;
    reg [8:0] exponent;

    always @* begin
        if (a == 0 || b == 0) begin
            product = 0;
            overflow = 0;
        end else begin
            sign = a[31] ^ b[31];
            exponent = a[30:23] + b[30:23] - 8'd127;
            
            mantissa_a = {1'b1, a[22:0]};
            mantissa_b = {1'b1, b[22:0]};
            mantissa = mantissa_a * mantissa_b;
            
            if (mantissa[47]) begin
                mantissa_result = mantissa[46:24] + mantissa[23];
                exponent = exponent + 1;
            end else begin
                mantissa_result = mantissa[45:23] + mantissa[22];
            end

            if (exponent >= 9'd255) begin
                overflow = 1;
                product = {sign, 8'hFF, 23'h0};
            end else if (exponent <= 9'd0) begin
                overflow = 0;
                product = 0;
            end else begin
                overflow = 0;
                product = {sign, exponent[7:0], mantissa_result};
            end
        end
    end

endmodule



