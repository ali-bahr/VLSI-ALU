`timescale 1 ns / 100 ps

module WallanceTreeMulti_tb;


    reg [31:0] A;
    reg [31:0] B;

    wire [63:0] Result;

    WallaceTreeMulti dut (
        .A(A),
        .B(B),
        .Result(Result)
    );


    integer success = 0;

    // Test case stimuli
    initial begin
   

    // Test case 1: Multiplication of positive and negative number
    A = 1;
    B = -90;

    #10;

    if (Result === -90) begin
      $display("TestCase#1: success");
      success = success + 1;
    end else begin
      $display("TestCase#1: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 2: Multiplication of positive and positive number
    A = 5;
    B = 5;

    #10;

    if (Result === 25) begin // 25
      $display("TestCase#2: success");
      success = success + 1;
    end else begin
      $display("TestCase#2: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 3: Multiplication of negative and negative number
    A = -5;
    B = -7;

    #10000;

    if (Result === 35) begin
      $display("TestCase#3: success");
      success = success + 1;
    end else begin
      $display("TestCase#3: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 4: Multiplication of negative and positive number
    A = -5;
    B = 7;

    #10;

    if (Result === -35) begin // -25
      $display("TestCase#4: success");
      success = success + 1;
    end else begin
      $display("TestCase#4: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 5: Multiplication by zero
    A = 0;
    B = -24;

    #10;

    if (Result === 0) begin
      $display("TestCase#5: success");
      success = success + 1;
    end else begin
      $display("TestCase#5: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 6: Multiplication by 1
    A = 1;
    B = -2432;

    #10;

    if (Result === -2432) begin // -5
      $display("TestCase#6: success");
      success = success + 1;
    end else begin
      $display("TestCase#6: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 7: Random test case 1
    A = 234;
    B = 345;

    #10;

    if (Result === 80730) begin
      $display("TestCase#7: success");
      success = success + 1;
    end else begin
      $display("TestCase#7: failed with input %d and %d and Output %d", A, B, Result);
    end

    // Test case 8: Random test case 2
    A = 13;
    B = 10;

    #10;

    if (Result === 130) begin
      $display("TestCase#8: success");
      success = success + 1;
    end else begin
      $display("TestCase#8: failed with input %d and %d and Output %d", A, B, Result);
    end

    $display("Total number of success test cases: %d", success);
  end

endmodule
