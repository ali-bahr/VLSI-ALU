module tb;
    reg innerClk, clk, reset, start;
    reg signed [31:0] A, B;
    wire signed [63:0] result;
    wire done, active;

    sequentialMultiplier uut (
        .clk(clk),
        .rst(reset),
        .start(start),
        .A(A),
        .B(B),
        .product(result),
        .done(done),
        .active(active)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        innerClk = 0;
        forever #2 innerClk = ~innerClk;
    end

    // Test cases
    initial begin
        // Initialize
        reset = 1;
        start = 0;
        #10;
        reset = 0;

        // Test Case 1: Positive x Positive
        test_case(10, 20, 200);

        // Test Case 2: Negative x Positive
        test_case(-10, 20, -200);

        // Test Case 3: Positive x Negative
        test_case(10, -20, -200);

        // Test Case 4: Negative x Negative
        test_case(-10, -20, 200);

        // Test Case 5: Multiplication by Zero
        test_case(10, 0, 0);

        // Test Case 6: Zero x Positive
        test_case(0, 10, 0);

        // Random Test Case 1
        test_case($random, $random, 64'bx);

        // Random Test Case 2
        test_case($random, $random, 64'bx);

        $finish;
    end

    task test_case(input signed [31:0] a, input signed [31:0] b, input signed [63:0] expected);
        begin
            A = a;
            B = b;
            start = 1;
            #10;
            start = 0;
            wait(done); // Wait for the multiplication to complete
            #10;
            if (result !== expected) begin
                $display("Test failed: A = %d, B = %d, Expected = %d, Got = %d", A, B, expected, result);
            end else begin
                $display("Test passed: A = %d, B = %d, Result = %d", A, B, result);
            end
        end
    endtask
endmodule
