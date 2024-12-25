module floating_point_adder_tb;

    // Inputs
    reg [31:0] A;
    reg [31:0] B;

    // Outputs
    wire [31:0] sum;
    wire cout;
    wire overflow;

    // Instantiate the Unit Under Test (UUT)
    floating_point_adder uut (
        .A(A),
        .B(B),
        .sum(sum),
        .cout(cout),
        .overflow(overflow)
    );

    // Test Vectors
    initial begin
        // Test 1: Addition of two positive numbers (1.0 + 2.0)
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'h40000000; // 2.0 in IEEE 754
        #10;
        $display("Test 1: 1.0 + 2.0 = %h, cout = %b, overflow = %b", sum, cout, overflow);

        // Test 2: Addition of positive and negative number (1.0 + (-1.0))
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'hBF800000; // -1.0 in IEEE 754
        #10;
        $display("Test 2: 1.0 + (-1.0) = %h, cout = %b, overflow = %b", sum, cout, overflow);

        // Test 3: Addition of zero (1.0 + 0.0)
        A = 32'h3F800000; // 1.0 in IEEE 754
        B = 32'h00000000; // 0.0 in IEEE 754
        #10;
        $display("Test 3: 1.0 + 0.0 = %h, cout = %b, overflow = %b", sum, cout, overflow);

        // Test 4: Overflow Test (large numbers)
        A = 32'h7F800000; // Infinity in IEEE 754
        B = 32'h7F800000; // Infinity in IEEE 754
        #10;
        $display("Test 4: Infinity + Infinity = %h, cout = %b, overflow = %b", sum, cout, overflow);
        
    end

endmodule
