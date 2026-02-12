module DFF_with_MUX(D,clk,rst,CLK_EN,out);

    parameter WIDTH = 18;
    parameter RSTTYPE = "SYNC";
    parameter sel = 0;
    input clk,rst,CLK_EN;
    input [WIDTH - 1: 0]D;
    output [WIDTH - 1: 0]out;
    reg [WIDTH - 1: 0]Q;

    generate
       if (RSTTYPE == "ASYNC") begin 
        always @(posedge clk or posedge rst) begin
                if (rst) begin
                    Q <= 0;
                end else if (CLK_EN) begin
                    Q <= D;
                end
        end 
       end else begin   
        always @(posedge clk) begin
                if (rst) begin
                    Q <= 0;
                end else if (CLK_EN) begin
                    Q <= D;
                end
        end
       end
        assign out = (sel == 1)? Q : D;

    endgenerate

endmodule
