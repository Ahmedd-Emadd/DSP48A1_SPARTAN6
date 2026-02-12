module mux_4_1(in0,in1,in2,in3,sel,out);

    parameter WIDTH = 48;
    input [WIDTH -1:0]in0;
    input [WIDTH -1:0]in1;
    input [WIDTH -1:0]in2;
    input [WIDTH -1:0]in3;
    input [1:0]sel;
    output reg [WIDTH -1:0]out;

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2; 
            2'b11: out = in3;
            default: out = 0;
        endcase
    end
endmodule
