module Addar64bit(
    // This Addar is of type CSA Carray-Save Addar "Ahmed Kamal"
    input [63:0] A,B,C,
    output [63:0] Sum,Carry
);

assign Carry[0] = 0;
assign Sum[63] = 0;

assign Sum[62:0]=A ^ B ^ C;
assign Carry[63:1]= ((A&B) | (B&C) | (C&A));

endmodule
