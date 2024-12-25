module msb (
    input  [31:0] a, 
    output wire [4:0] msb
);
    integer i;
    reg [4:0] temp;
    always @* begin : loop
    temp = 5'd0;
        for (i = 0; i < 32; i = i + 1) begin
            if (a[i] == 1'b1) begin
                temp = i;
            end
        end
    end
    assign msb = temp;
endmodule