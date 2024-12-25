module FPM (
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