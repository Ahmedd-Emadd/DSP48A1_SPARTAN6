module DSP48A1(A,B,D,C,clk,CARRYIN,OPMODE,BCIN,
RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,
BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF
);

    parameter A0REG = 0; parameter A1REG = 1;
    parameter B0REG = 0; parameter B1REG = 1;
    parameter CREG = 1; parameter DREG = 1;
    parameter MREG = 1; parameter PREG = 1;
    parameter CARRYINREG = 1; parameter CARRYOUTREG = 1; 
    parameter OPMODEREG = 1; parameter CARRYINSEL = "OPMODE5";
    parameter B_INPUT = "DIRECT"; parameter RSTTYPE = "SYNC";  

    localparam CARRYINSEL_condition = (CARRYINSEL == "OPMODE5")? 1'b1:1'b0;
    localparam B_INPUT_condition = (B_INPUT == "BCIN")? 1'b1:1'b0;

    input [17:0]A,B,D,BCIN;
    input [47:0]C,PCIN;
    input [7:0]OPMODE;
    input clk,CARRYIN,
    RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
    CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
    output [17:0]BCOUT;
    output [47:0]PCOUT,P;
    output [35:0]M;
    output CARRYOUT,CARRYOUTF;

    wire [17:0]A_out,B_out,D_out,b_mux_out,pre_a_s,mux_pre_a_s,B_final,A_final;
    wire [47:0]C_out,MUX_X_OUT,MUX_Z_OUT,M_before_MUX;
    wire [47:0] post_a_s;
    wire [35:0]mult_out,M_out;
    wire [7:0]opmode_out;

////////////////////////////////////////////////////////////////////////////////////////////////
    // OPMODE REGISTERS
    // DFF_with_MUX(D,clk,rst,CLK_EN,out)
////////////////////////////////////////////////////////////////////////////////////////////////

    DFF_with_MUX #(.WIDTH(8),.RSTTYPE(RSTTYPE),.sel(OPMODEREG))
    OPMODE_value(OPMODE,clk,RSTOPMODE,CEOPMODE,opmode_out);

////////////////////////////////////////////////////////////////////////////////////////////////
    // FIRST STAGE
    // DFF_with_MUX(D,clk,rst,CLK_EN,out) -- mux_2_1(in0,in1,sel,out)
////////////////////////////////////////////////////////////////////////////////////////////////
    DFF_with_MUX #(.WIDTH(18),.RSTTYPE(RSTTYPE),.sel(DREG)) D_REG(D,clk,RSTD,CED, );
    mux_2_1 #(.WIDTH(18)) MUX_B(B,BCIN,B_INPUT_condition,b_mux_out);
    DFF_with_MUX #(.WIDTH(18),.RSTTYPE(RSTTYPE),.sel(B0REG)) B0_REG(b_mux_out,clk,RSTB,CEB,B_out);
    DFF_with_MUX #(.WIDTH(18),.RSTTYPE(RSTTYPE),.sel(A0REG)) A0_REG(A,clk,RSTA,CEA,A_out);
    DFF_with_MUX #(.WIDTH(48),.RSTTYPE(RSTTYPE),.sel(CREG)) C_REG(C,clk,RSTC,CEC,C_out);

////////////////////////////////////////////////////////////////////////////////////////////////
    // PRE_ADDER_SUBTRACTER & SECOND STAGE & Multiplier
    // PRE_ADD_SUB(in0,in1,sel,out) -- mux_2_1(in0,in1,sel,out) -- MULT(in0,in1,out)
////////////////////////////////////////////////////////////////////////////////////////////////
    PRE_ADD_SUB #(.WIDTH(18)) pre_add_sub(D_out,B_out,opmode_out[6],pre_a_s);
    mux_2_1 #(.WIDTH(18)) bypass_mux(B_out,pre_a_s,opmode_out[4],mux_pre_a_s);
    DFF_with_MUX #(.WIDTH(18),.RSTTYPE(RSTTYPE),.sel(B1REG)) B1_REG(mux_pre_a_s,clk,RSTB,CEB,B_final);
    assign BCOUT = B_final;
    DFF_with_MUX #(.WIDTH(18),.RSTTYPE(RSTTYPE),.sel(A1REG)) A1_REG(A_out,clk,RSTA,CEA,A_final);
    MULT #(.WIDTH(18)) multi(B_final,A_final,mult_out);
    
////////////////////////////////////////////////////////////////////////////////////////////////
    // THIRD STAGE 
    // mux_4_1(in0,in1,in2,in3,sel,out) -- carry_cascade_MUX(in0,in1,sel,out)
////////////////////////////////////////////////////////////////////////////////////////////////

    DFF_with_MUX #(.WIDTH(36),.RSTTYPE(RSTTYPE),.sel(MREG)) M_REG(mult_out,clk,RSTM,CEM,M_out);
    assign M = M_out;
    mux_4_1 #(.WIDTH(48)) MUX_X(48'd0,{12'd0,M_out},P,{D_out[11:0],A_final,B_final},opmode_out[1:0],MUX_X_OUT);
    mux_2_1 #(.WIDTH(1)) CARRYCAS_MUX(CARRYIN,opmode_out[5],CARRYINSEL,carrycas_out);
    DFF_with_MUX #(.WIDTH(1),.RSTTYPE(RSTTYPE),.sel(CARRYINREG)) CYI(carrycas_out,clk,RSTCARRYIN,CECARRYIN,CYI_out);
    mux_4_1 #(.WIDTH(48)) MUX_Z(48'd0,PCIN,P,C_out,opmode_out[3:2],MUX_Z_OUT);

////////////////////////////////////////////////////////////////////////////////////////////////
    // FOURTH (Last) STAGE & POST_ADDER_SUBTRACTER
    // POST_ADD_SUB(in0,in1,in2,sel,out)
////////////////////////////////////////////////////////////////////////////////////////////////

    POST_ADD_SUB #(.WIDTH(48)) post_add_sub(MUX_Z_OUT,MUX_X_OUT,CYI_out,opmode_out[7],post_a_s,CYO_in);
    DFF_with_MUX #(.WIDTH(1),.RSTTYPE(RSTTYPE),.sel(CARRYOUTREG)) CYO(CYO_in,clk,RSTCARRYIN,CECARRYIN,CARRYOUT);
    assign CARRYOUTF = CARRYOUT; 
    DFF_with_MUX #(.WIDTH(48),.RSTTYPE(RSTTYPE),.sel(PREG)) P_REG(post_a_s,clk,RSTP,CEP,P);
    assign PCOUT = P;

    endmodule
