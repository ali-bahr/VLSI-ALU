module floating_point_adder (
    input [31:0] A,
    input [31:0] B,
    output [31:0] sum,
    output cout,
    output overflow

);
        reg [7:0] difference, exponent;
        reg [24:0] mantissa_a, mantissa_b, mantissa_sum;
        reg sign;
        reg [31:0] mantissa_padded;
        wire [4:0] shift_cnt;
        wire [24:0] adder_output;
        wire adder_cout, adder_overflow;
        reg [4:0] shift_amount;
        reg mantissa_overflow;
        reg mantissa_cin;
        msb msb0(mantissa_padded, shift_cnt);
        RippleCarryAdder24 fpadder(mantissa_a, mantissa_b, mantissa_cin, adder_output, adder_cout );

        always @(*) begin
            mantissa_a = {2'b01, A[22:0]};
            mantissa_b = {2'b01, B[22:0]};
            mantissa_padded = 1'd0;
            mantissa_cin = 1'b0;
            mantissa_overflow = 1'b0;
            shift_amount = 1'd0;

                if (A == 1'd0 | B == 1'd0) begin 
                    if (A == 1'd0) begin
                        mantissa_sum = mantissa_b;
                        exponent = B[30:23];
                        sign = B[31];
                    end
                    else begin
                        mantissa_sum = mantissa_a;
                        exponent = A[30:23];
                        sign = A[31];
                    end

                    if (mantissa_sum == 25'h0800000 & exponent == 1'd0) begin
                        sign = 1'b0;
                    end

                end
                else begin
                    difference = A[30:23] - B[30:23];
                    if(difference[7] == 1'b0) begin
                        mantissa_b = mantissa_b >> difference; // shift B to make B exponent greater
                        exponent = A[30:23];
                        sign = A[31];

                    end 
                    else begin
                        difference = (~difference) + 1;
                        mantissa_a = mantissa_a >> difference; // shift A to make A exponent greater
                        exponent = B[30:23];
                        sign = B[31];
                    end

                    if ((A[31]^B[31]) == 1'b1) begin 
                        mantissa_cin = 1'b1;
                        if (A[31] == 1'b1) begin
                            mantissa_a = ~mantissa_a;
                        end
                        else begin 
                            mantissa_b = ~mantissa_b;                    
                        end

                        mantissa_sum = adder_output;

                        if (difference == 1'd0) begin
                            sign = mantissa_sum[24];
                        end

                        if (sign == 1'b1) begin
                            mantissa_sum = ~mantissa_sum +1;
                        end

                        if (mantissa_sum[23] == 1'b0) begin
                            mantissa_padded = {mantissa_sum[23:0], 8'b00000000};
                            shift_amount = ~(shift_cnt);
                            exponent = exponent - shift_amount;
                            mantissa_sum = mantissa_sum << shift_amount;
                        end
                    end
                    else begin
                        mantissa_sum = adder_output;
                        sign = A[31];
                        if (mantissa_sum[24] == 1'b1) begin
                            exponent = exponent + 1'b1;
                            mantissa_sum = mantissa_sum >> 1; 
                        end
                    end
                    if (mantissa_sum == 25'h0ffffff & exponent == 8'hfe) begin
                         mantissa_overflow = 1'b1;
                    end
                end
            end

        assign cout = mantissa_sum[24];
        assign sum[31] = sign;
        assign sum[22:0] = mantissa_sum[22:0];
        assign sum[30:23] = exponent;
        assign overflow = mantissa_overflow;
endmodule