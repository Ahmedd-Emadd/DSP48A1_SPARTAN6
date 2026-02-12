module DSP48A1_tb();


    reg [17:0]A_tb,B_tb,D_tb,BCIN_tb,BCOUT_expected;
    reg [47:0]C_tb,PCIN_tb,PCOUT_expected,P_expected;
    reg [7:0]OPMODE_tb;
    reg [35:0]M_expected;
    reg clk,CARRYIN_tb,RSTA_tb,RSTB_tb,RSTM_tb,RSTP_tb,RSTC_tb,
RSTD_tb,RSTCARRYIN_tb,RSTOPMODE_tb,CEA_tb,CEB_tb,CEM_tb,CEP_tb,CEC_tb,
CED_tb,CECARRYIN_tb,CEOPMODE_tb,CARRYOUT_expected,CARRYOUTF_expected;
    wire [17:0]BCOUT;
    wire [47:0]PCOUT,P;
    wire [35:0]M;
    wire CARRYOUT,CARRYOUTF;

    DSP48A1 #(.A0REG(0),.A1REG(1),.B0REG(0),.B1REG(1),.CREG(1),.DREG(1), 
    .MREG(1),.PREG(1),.CARRYINREG(1),.CARRYOUTREG(1),.OPMODEREG(1), 
    .CARRYINSEL("OPMODE5"),.B_INPUT("DIRECT"),.RSTTYPE("SYNC")) TEST(A_tb,B_tb,D_tb,C_tb,clk,CARRYIN_tb,OPMODE_tb,BCIN_tb,
RSTA_tb,RSTB_tb,RSTM_tb,RSTP_tb,RSTC_tb,RSTD_tb,RSTCARRYIN_tb,
RSTOPMODE_tb,CEA_tb,CEB_tb,CEM_tb,CEP_tb,CEC_tb,CED_tb,CECARRYIN_tb,
CEOPMODE_tb,PCIN_tb,BCOUT,PCOUT,P,
M,CARRYOUT,CARRYOUTF);

////////////////////////////////////////////////////////////////////////////////////////////////
    // 2.1 Verify Reset Operation
////////////////////////////////////////////////////////////////////////////////////////////////

    initial begin
        clk =0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        RSTA_tb = 1;
        RSTB_tb = 1;
        RSTM_tb = 1;
        RSTP_tb = 1;
        RSTC_tb = 1; 
        RSTD_tb = 1;
        RSTCARRYIN_tb = 1;
        RSTOPMODE_tb = 1; 
        A_tb = $random;
        B_tb = $random; 
        D_tb = $random; 
        C_tb = $random; 
        CARRYIN_tb = $random; 
        OPMODE_tb = $random; 
        BCIN_tb = $random; 
        CEA_tb = $random;
        CEB_tb = $random; 
        CEM_tb = $random; 
        CEP_tb = $random;
        CEC_tb = $random; 
        CED_tb = $random; 
        CECARRYIN_tb = $random;
        CEOPMODE_tb = $random; 
        PCIN_tb = $random;
        @(negedge clk);
        if (BCOUT || PCOUT || P || M || CARRYOUT || CARRYOUTF) begin
            $display("ERROR, Reset Verification is incorrect");
            $stop;
        end

        RSTA_tb = 0;
        RSTB_tb = 0;
        RSTM_tb = 0;
        RSTP_tb = 0;
        RSTC_tb = 0; 
        RSTD_tb = 0;
        RSTCARRYIN_tb = 0;
        RSTOPMODE_tb = 0; 
        CEA_tb = 1;
        CEB_tb = 1; 
        CEM_tb = 1; 
        CEP_tb = 1;
        CEC_tb = 1; 
        CED_tb = 1; 
        CECARRYIN_tb = 1;
        CEOPMODE_tb = 1; 

////////////////////////////////////////////////////////////////////////////////////////////////
    // 2.2 Verify DSP path 1
////////////////////////////////////////////////////////////////////////////////////////////////

        repeat(2) @(negedge clk);
        A_tb = 20 ;
        B_tb = 10 ; 
        D_tb = 25 ; 
        C_tb = 350 ; 
        OPMODE_tb = 8'b11011101; 
        CARRYIN_tb = $random; 
        BCIN_tb = $random; 
        PCIN_tb = $random;
        BCOUT_expected = 18'hf;
        M_expected = 36'h12c;
        P_expected = 48'h32;
        PCOUT_expected = 48'h32;
        CARRYOUT_expected = 0;
        CARRYOUTF_expected = 0;
        repeat(4) @(negedge clk);
        if ((BCOUT_expected != BCOUT) || (M_expected != M) || (P_expected != P) || (PCOUT_expected != PCOUT) || 
         (CARRYOUT_expected != CARRYOUT) || (CARRYOUTF_expected != CARRYOUTF) ) begin
            $display("ERROR, PATH1 verification is incorrect");
            $stop; 
        end
    
////////////////////////////////////////////////////////////////////////////////////////////////
    // 2.3 Verify DSP path 2
////////////////////////////////////////////////////////////////////////////////////////////////

        @(negedge clk);
        A_tb = 20 ;
        B_tb = 10 ; 
        D_tb = 25 ; 
        C_tb = 350 ; 
        OPMODE_tb = 8'b00010000; 
        CARRYIN_tb = $random; 
        BCIN_tb = $random; 
        PCIN_tb = $random;
        BCOUT_expected = 18'h23;
        M_expected = 36'h2bc;
        P_expected = 0;
        PCOUT_expected = 0;
        CARRYOUT_expected = 0;
        CARRYOUTF_expected = 0;
        repeat(3) @(negedge clk);
        if ((BCOUT_expected != BCOUT) || (M_expected != M) || (P_expected != P) || (PCOUT_expected != PCOUT) || 
         (CARRYOUT_expected != CARRYOUT) || (CARRYOUTF_expected != CARRYOUTF) ) begin
            $display("ERROR, PATH2 verification is incorrect");
            $stop; 
        end

////////////////////////////////////////////////////////////////////////////////////////////////
    // 2.4 Verify DSP path 3
////////////////////////////////////////////////////////////////////////////////////////////////

        A_tb = 20 ;
        B_tb = 10 ; 
        D_tb = 25 ; 
        C_tb = 350 ; 
        OPMODE_tb = 8'b00001010; 
        CARRYIN_tb = $random; 
        BCIN_tb = $random; 
        PCIN_tb = $random;
        BCOUT_expected = 18'ha;
        M_expected = 36'hc8;
        P_expected = 0;
        PCOUT_expected = 0;
        CARRYOUT_expected = 0;
        CARRYOUTF_expected = 0;
        repeat(3) @(negedge clk);
        if ((BCOUT_expected != BCOUT) || (M_expected != M) || (P_expected != P) || (PCOUT_expected != PCOUT) || 
         (CARRYOUT_expected != CARRYOUT) || (CARRYOUTF_expected != CARRYOUTF) ) begin
            $display("ERROR, PATH3 verification is incorrect");
            $stop; 
        end
    
////////////////////////////////////////////////////////////////////////////////////////////////
     // 2.5 Verify DSP path 4
////////////////////////////////////////////////////////////////////////////////////////////////

        A_tb = 5 ;
        B_tb = 6 ; 
        D_tb = 25 ; 
        C_tb = 350 ; 
        OPMODE_tb = 8'b10100111; 
        CARRYIN_tb = $random; 
        BCIN_tb = $random; 
        PCIN_tb = 3000;
        BCOUT_expected = 18'h6;
        M_expected = 36'h1e;
        P_expected = 48'hfe6fffec0bb1;
        PCOUT_expected = 48'hfe6fffec0bb1;
        CARRYOUT_expected = 1;
        CARRYOUTF_expected = 1;
        repeat(3) @(negedge clk);
        if ((BCOUT_expected != BCOUT) || (M_expected != M) || (P_expected != P) || (PCOUT_expected != PCOUT) || 
         (CARRYOUT_expected != CARRYOUT) || (CARRYOUTF_expected != CARRYOUTF) ) begin
            $display("ERROR, PATH4 verification is incorrect");
            $stop; 
        end
        $stop;
    end
    
endmodule