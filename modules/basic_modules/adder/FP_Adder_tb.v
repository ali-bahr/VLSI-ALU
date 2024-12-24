module FP_Add_tb;

    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Sum;

    fp_adder uut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );

    initial begin
        // Test case 
        A = 32'h40400000; // 3.0 in IEEE 754 format
        B = 32'h40000000; // 2.0 in IEEE 754 format
        #10;
        $display("A = %h, B = %h, Sum = %h", A, B, Sum);

        // // Test case 2
        // A = 32'h40400000; // 3.0 in IEEE 754 format
        // B = 32'hC0000000; // -2.0 in IEEE 754 format
        // #10;
        // $display("A = %h, B = %h, Sum = %h", A, B, Sum);

        // // Test case 3
        // A = 32'h3F800000; // 1.0 in IEEE 754 format
        // B = 32'hBF800000; // -1.0 in IEEE 754 format
        // #10;
        // $display("A = %h, B = %h, Sum = %h", A, B, Sum);

        // Test case 
        A = 32'h3F800000; // 1.0 in IEEE 754 format
        B = 32'h3F800000; // 1.0 in IEEE 754 format
        #10;
        $display("A = %h, B = %h, Sum = %h", A, B, Sum);

        
        // Test case 
        A = 32'h41A40000; // 20.5 in IEEE 754 format
        B = 32'h4149999A; // 12.6 in IEEE 754 format
        #10;
        $display("A = %h, B = %h, Sum = %h", A, B, Sum);

        // Test case Overflow
        A = 32'h7F7FC99E; // 20.5 in IEEE 754 format
        B = 32'h7F7FC99E; // 12.6 in IEEE 754 format
        #10;
        $display("A = %h, B = %h, Sum = %h", A, B, Sum);

        $stop;
    end

endmodule
