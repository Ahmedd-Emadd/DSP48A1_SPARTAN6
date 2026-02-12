module POST_ADD_SUB(in0,in1,in2,sel,out,CARRYOUT);

    parameter WIDTH = 48;
    input [WIDTH -1:0]in0;
    input [WIDTH -1:0]in1;
    input sel,in2;
    output reg [WIDTH -1:0]out;
    output reg CARRYOUT;

    always @(*) begin
        if (sel) begin
            {CARRYOUT,out} = in0 - (in1 + in2);
        end else begin
            {CARRYOUT,out} = in0 + in1 + in2;
        end
    end

endmodule
