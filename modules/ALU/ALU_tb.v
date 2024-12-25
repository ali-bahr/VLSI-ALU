`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg selector;

    // Outputs
    wire [31:0] Result;
    wire carry;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .A(A),
        .B(B),
        .selector(selector),
        .Result(Result),
        .carry(carry)
    );

    // Test vectors
    initial begin
        // Test 1: Addition of two positive numbers
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'h40000000; // 2.0 in IEEE 754
        selector = 0; // Select addition
        #10;

        // Test 2: Addition of positive and negative number
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'hBF800000; // -1.0 in IEEE 754
        selector = 0;
        #10;

        // Test 3: Multiplication of two positive numbers
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'h40000000; // 2.0 in IEEE 754
        selector = 1; // Select multiplication
        #10;

        // Test 4: Multiplication of positive and negative number
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'hBF800000; // -1.0 in IEEE 754
        selector = 1;
        #10;

        // Test 5: Addition with zero
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'h00000000; // 0.0 in IEEE 754
        selector = 0;
        #10;

        // Test 6: Multiplication with zero
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'h00000000; // 0.0 in IEEE 754
        selector = 1;
        #10;

        // Test 7: Addition of two large numbers
        A = 32'h4F000000; // Large number in IEEE 754
        B = 32'h4E800000; // Another large number
        selector = 0;
        #10;

        // Test 8: Multiplication of two large numbers
        A = 32'h4F000000; // Large number in IEEE 754
        B = 32'h4E800000; // Another large number
        selector = 1;
        #10;

        // Test 9: Overflow test in addition
        A = 32'h7F800000; // Infinity in IEEE 754
        B = 32'h7F800000; // Infinity in IEEE 754
        selector = 0;
        #10;

        // Test 10: Overflow test in multiplication
        A = 32'h7F800000; // Infinity in IEEE 754
        B = 32'h7F800000; // Infinity in IEEE 754
        selector = 1;
        #10;

        // Finish simulation
        $stop;
    end

endmodule
