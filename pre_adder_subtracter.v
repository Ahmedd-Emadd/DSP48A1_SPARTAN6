module PRE_ADD_SUB(in0,in1,sel,out);

    parameter WIDTH = 18;
    input [WIDTH -1:0]in0;
    input [WIDTH -1:0]in1;
    input sel;
    output reg [WIDTH -1:0]out;

    always @(*) begin
        if (sel) begin
            out = in0 - in1;
        end else begin
            out = in0 + in1;
        end
    end

endmodule

