module ALU (
    input [31:0] A,     
    input [31:0] B,     
    input ALU_Sel, 
    output reg [63:0] ALU_Out 
    output carry;
);

    wire [31:0] add_result;
    wire [63:0] mult_result;
    wire add_carry;
    wire start;


    WallaceTreeMulti WTM(
        .A(A), 
        .B(B),
        .Result(mult_result)
    );

    RippleCarryAdder RCA(
        .A(A),
        .B(B),
        .Cin('0'), // this must be zero incase of stand-alone RippleCarryAdder
        .Sum(add_result),
        .Cout(add_carry)
    );

    always @(*) begin
        case (ALU_Sel)
            1'b000: 
                // extend to 64 ???????
                ALU_Out = add_result;    // Addition
                carry = add_carry;
            1'b001: 
                ALU_Out = mult_result;        // Multiplication
                carry = 0;
            default: ALU_Out = 0;    // Default case
        endcase
    end

endmodule