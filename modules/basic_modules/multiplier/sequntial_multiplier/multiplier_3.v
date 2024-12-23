module sequential_multiplier (
    input wire [31:0] a, 
    input wire [31:0] b, 
    output reg [63:0] product
);
    reg [63:0] acc;
    reg [63:0] temp_b;

    integer i;        
    always @(*) begin
        acc = 64'b0; 
        temp_b = { {32{b[31]}}, b }; // sign extended 

        for (i = 0; i < 32; i = i + 1) begin
            if (a[i] == 1'b1) begin
                if (i == 31 && a[i] == 1'b1) 
                    acc = acc - (temp_b << i); // subtract for negative MSB
                else
                    acc = acc + (temp_b << i); // add for positive bits
            end
        end
    end

    always @(*) begin
        product = acc;
    end
endmodule
