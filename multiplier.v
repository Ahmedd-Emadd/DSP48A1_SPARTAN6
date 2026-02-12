module MULT(in0,in1,out);

    parameter WIDTH = 18;
    localparam WIDTH_OUT = 2 * WIDTH;
    input [WIDTH -1:0]in0;
    input [WIDTH -1:0]in1;
    output [WIDTH_OUT -1:0]out;

    assign out = in0 * in1;
    
endmodule
