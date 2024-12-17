module CarrySelectAdder_tb;

    // Input for DUT
    reg [31:0] first_input;
    reg [31:0] second_input;


    /// Output from DUT
    wire [31:0] sum_output;
    wire carry_output;



    integer success;
    integer failure;


    // DUT

    CarrySelectAdder DUT (
        .A(first_input),
        .B(second_input),
        .Sum(sum_output),
        .Cout(carry_output)
    );

    initial begin

        // Init
        success = 0;
        failure = 0;
        //



        // Testing implementation


        // T1: Overflow of positive numbers.
        first_input = 2147483647;
        second_input = 1;
        #10;

        if((first_input[31] == 0) && (second_input[31] == 0) && (sum_output[31] == 1)) begin
            success = success + 1;
            $display("TestCase#1: success");
        end
        else begin

            $display("TestCase#1: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end




        // T2: Overflow of negative numbers.
        first_input = -2147483648;
        second_input = -1;

        #10;

        if((first_input[31] == 1) && (second_input[31] == 1) && (sum_output[31] == 0)) begin
            success = success + 1;
            $display("TestCase#2: success");
        end
        else begin

            $display("TestCase#2: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end




        // T3: Addition of a positive and a negative number.
        first_input = 100;
        second_input = -90;

        #10;

        if( sum_output == 10)
         begin
            success = success + 1;
            $display("TestCase#3: success");
        end
        else begin

            
            $display("TestCase#3: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end



        // T4: Addition of two positive numbers.
        first_input = 100;
        second_input = 90;

        #10;

        if( sum_output == 190)
         begin
            success = success + 1;
            $display("TestCase#4: success");
        end
        else begin

            
            $display("TestCase#4: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end



        // T5: Addition of two negative numbers.
        first_input = -100;
        second_input = -90;

        #10;

        if( sum_output == -190)
         begin
            success = success + 1;
            $display("TestCase#5: success");
        end
        else begin

            
            $display("TestCase#5: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end




        // T6: additional random test case.
        first_input = 10;
        second_input = -90;

        #10;

        if( sum_output == -80)
         begin
            success = success + 1;
            $display("TestCase#6: success");
        end
        else begin

            
            $display("TestCase#6: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end



        // T7: additional random test case.
        first_input = 10;
        second_input = -10;

        #10;

        if( sum_output == 0)
         begin
            success = success + 1;
            $display("TestCase#7: success");
        end
        else begin

            
            $display("TestCase#7: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end



        // T8: additional random test case.                
        first_input = 3456;
        second_input = -8347;

        #10;

        if( sum_output == -4891)
         begin
            success = success + 1;
            $display("TestCase#8: success");
        end
        else begin

            
            $display("TestCase#8: Failed with Input : A=%b , B=%b | Output :  Sum=%b , Cout=%b",first_input,second_input,sum_output,carry_output);
            failure = failure + 1;
        end


        // Print message
         $display("Succeed Test Cases: %d", success);
         $display("Failed Test Cases: %d", failure);
        //
    end

endmodule;
