module sequentialMultiplier(
    input clk,
    input rst,
    input start,
    input [31:0] A,
    input [31:0] B,
    output reg [63:0] product,
    output reg done,
    output reg active
);
    reg [64:0] accumulator;
    reg [31:0] unsigned_A, unsigned_B;
    reg sign;
    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers and variables
            accumulator <= 0;
            unsigned_A <= 0;
            unsigned_B <= 0;
            sign <= 0;
            count <= 0;
            product <= 0;
            done <= 0;
            active <= 0;
        end else if (start && !active) begin
            // Start a new multiplication
            if (A[31] == 0 && B[31] == 0) begin
                sign = 0;
                unsigned_A = A;
                unsigned_B = B;
            end else if (A[31] == 1 && B[31] == 1) begin
                sign = 0;
                unsigned_A = ~A + 1;
                unsigned_B = ~B + 1;
            end else if (A[31] == 0 && B[31] == 1) begin
                sign = 1;
                unsigned_A = A;
                unsigned_B = ~B + 1;
            end else begin
                sign = 1;
                unsigned_A = ~A + 1;
                unsigned_B = B;
            end
            accumulator = {32'b0, unsigned_B};
            count = 1;
            done = 0;
            active = 1;
        end else if (active) begin
            // Continue the multiplication
            if (accumulator[0] == 1) begin
                accumulator[64:32] = accumulator[64:32] + unsigned_A;
            end
            accumulator = accumulator >> 1;
            if (count == 32) begin
                if (sign == 1) begin
                    product = ~accumulator[63:0] + 1;
                end else begin
                    product = accumulator[63:0];
                end
                count = 0;
                done = 1;
                active = 0;
            end else begin
                count = count + 1;
            end
        end
    end
endmodule
