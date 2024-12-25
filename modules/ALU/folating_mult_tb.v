module floating_point_multiplier_sequential_tb;
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] product;
    wire overflow;

  reg clk;            
  reg rst;            

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end


    FPM inst (
        .a(a),
        .b(b),
        .product(product),
        .overflow(overflow)
    );
    integer passed = 0;
    initial begin


        rst = 0;
        #10;
        rst = 1;
        #10;
        rst = 0;
        #50; 

        a = 32'h408a2000;
        b = 32'hc08a2000;
        #50;
        if (product !== 32'hc1950d08  || overflow !== 0) begin
            $display("TestCase#1: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#1: success");
        end
        a = 32'h408aa000;
        b = 32'h408a2000;
        #50;
        if (product !== 32'h41959728  || overflow !== 0) begin
            $display("TestCase#2: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#2: success");
        end
        a = 32'hc28aa000;
        b = 32'hc10a2000;
        #50;
        if (product !== 32'h44159728  || overflow !== 0) begin
            $display("TestCase#3: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#3: success");
        end
        a = 32'hc28aa000;
        b = 32'h418aa000;
        #50;
        if (product !== 32'hc49621c8  || overflow !== 0) begin
            $display("TestCase#4: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#4: success");
        end
        a = 32'h00000000;
        b = 32'h418aa000;
        #50;
        if (product !== 32'h00000000  || overflow !== 0) begin
            $display("TestCase#5: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#5: success");
        end
        a = 32'h3f800000;
        b = 32'h418aa000;
        #50;
        if (product !== 32'h418aa000  || overflow !== 0) begin
            $display("TestCase#6: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#6: success");
        end
        a = 32'hb9807000;
        b = 32'h418aa000;
        #50;

        if (product !== 32'hbb8b194c  || overflow !== 0) begin
            $display("TestCase#7: failed with input a=%d, b=%d, output product=%d, overflow=%d", a, b, product, overflow);
        end else begin
            passed = passed + 1;
            $display("TestCase#7: success");
        end
        $display("Passed %d out of 7 test cases", passed);
        #1000;
    end
endmodule