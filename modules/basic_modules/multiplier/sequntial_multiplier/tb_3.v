module tb;
    // Inputs
    reg [31:0] a, b;
    wire [63:0] product;

    // Instantiate the Unit Under Test (UUT)
    sequential_multiplier uut (
        .a(a),
        .b(b),
        .product(product)
    );

    // Test cases
    initial begin
        $display("Starting Testbench");

        // Test Case 1: Positive x Positive
        test_case(32'd10, 32'd20, 64'd200);

        // Test Case 2: Negative x Positive
        test_case(-32'd10, 32'd20, -64'd200);

        // Test Case 3: Positive x Negative
        test_case(32'd10, -32'd20, -64'd200);

        // Test Case 4: Negative x Negative
        test_case(-32'd10, -32'd20, 64'd200);

        // Test Case 5: Multiplication by Zero
        test_case(32'd10, 32'd0, 64'd0);

        // Test Case 6: Zero x Positive
        test_case(32'd0, 32'd10, 64'd0);

        // Test Case 7: Large Numbers
        test_case(32'h7FFFFFFF, 32'h7FFFFFFF, 64'h3FFFFFFF00000001);

        // Test Case 8: Random Values
        test_case($random, $random, 64'bx);
        test_case($random, $random, 64'bx);

        $display("All test cases completed");
        $finish;
    end

    // Task for running a test case
    task test_case(input signed [31:0] A, input signed [31:0] B, input signed [63:0] expected);
        begin
            a = A;
            b = B;
            #10; // Wait for results

            if (product !== expected) begin
                $display("Test Failed: A = %d, B = %d, Expected = %d, Got = %d", A, B, expected, product);
            end else begin
                $display("Test Passed: A = %d, B = %d, Result = %d", A, B, product);
            end
        end
    endtask
endmodule
