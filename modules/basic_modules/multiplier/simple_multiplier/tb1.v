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

    // Testbench variables
    integer num_tests;
    integer num_successes;
    integer num_failures;

    // Test cases
    initial begin
        // Initialize
        reset = 1;
        start = 0;
        num_tests = 0;
        num_successes = 0;
        num_failures = 0;
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
        random_test_case();

        // Random Test Case 2
        random_test_case();

        $display("\nTotal Tests: %d, Successes: %d, Failures: %d", num_tests, num_successes, num_failures);
        $finish; // End the simulation
    end

    // Task to run a single test case
    task test_case(input signed [31:0] a, input signed [31:0] b, input signed [63:0] expected);
        begin
            A = a;
            B = b;
            start = 1;
            #10;
            start = 0;
            wait(done); // Wait for the multiplication to complete
            #10;
            num_tests = num_tests + 1;
            if (result === expected) begin
                $display("TestCase #%d: success", num_tests);
                num_successes = num_successes + 1;
            end else begin
                $display("TestCase #%d: failed with input A=%d, B=%d, Expected=%d, Got=%d", num_tests, a, b, expected, result);
                num_failures = num_failures + 1;
            end
        end
    endtask

    // Task to run a random test case
    task random_test_case;
        reg signed [31:0] rand_a, rand_b;
        reg signed [63:0] expected_product;
        begin
            rand_a = $random;
            rand_b = $random;
            expected_product = rand_a * rand_b;
            test_case(rand_a, rand_b, expected_product);
        end
    endtask

    // Monitor outputs (optional)
    always @(posedge clk) begin
        if (!rst) begin
            // $display("Time: %0t, a: %d, b: %d, product: %d", $time, a, b, product);
        end
    end

endmodule
