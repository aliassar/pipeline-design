module TEST_MIPS(
	input CLOCK_50, RST
);
	
	wire freeze = 1'b0;
	wire branch_token = 1'b0;
	wire[31:0] branch_addr = 32'b0;
	wire[31:0] IF_PC, IF_Instruction;
	
	IF_Stage IF (
  .clk(CLOCK_50), .rst(RST), .freeze(freeze), .Branch_token(branch_token),
  .BranchAddr(branch_token),
  .PC(IF_PC), .Instruction(IF_Instruction)
  );
  
  wire [31:0] IF_REG_PC, IF_REG_Instruction;
  IF_Stage_Reg IFReg(
  .clk(CLOCK_50), .rst(RST), .freeze(freeze), .flush(1'b0), 
  .PCIn(IF_PC), .Instruction_in(IF_Instruction), 
  .PC(IF_REG_PC), .Instruction(IF_REG_Instruction)
  );
  
  wire WB_EN_ID, MEM_R_EN_ID, MEM_W_EN_ID, B_ID, S_ID;
  wire[3:0] EXE_CMD_ID;
  wire[31:0] Val_Rn_ID, Val_Rm_ID;
  wire imm_ID;
  wire[11:0] Shift_operand_ID;
  wire[23:0] Signed_imm_24_ID;
  wire[3:0] Dest_ID;
  wire[3:0] src1_ID, src2_ID;
  wire Two_src_ID;
  ID_Stage ID(
    .clk(CLOCK_50), .rst(RST),
    .Instruction(IF_REG_Instruction), .Result_WB(32'b0),
    .writeBackEn(1'b0),
    .Dest_wb(4'b0),
    .hazard(1'b0),
    .SR(4'b0),
    .WB_EN(WB_EN_ID), .MEM_R_EN(MEM_R_EN_ID), .MEM_W_EN(MEM_W_EN_ID), 
    .B(B_ID), .S(S_ID),
    .EXE_CMD(EXE_CMD_ID),
    .Val_Rn(Val_Rn_ID), .Val_Rm(Val_Rm_ID),
    .imm(imm_ID),
    .Shift_operand(Shift_operand_ID),
    .Signed_imm_24(Signed_imm_24_ID),
    .Dest(Dest_ID),
    .src1(src1_ID), .src2(src2_ID),
    .Two_src(Two_src_ID)
  );
  
  wire WB_EN_ID_REG, MEM_R_EN_ID_REG, MEM_W_EN_ID_REG, B_ID_REG, S_ID_REG;
  wire[3:0] EXE_CMD_ID_REG;
  wire[31:0] PC_ID_REG;
  wire[31:0] Val_Rn_ID_REG, Val_Rm_ID_REG;
  wire imm_ID_REG;
  wire[11:0] Shift_operand_ID_REG;
  wire[23:0] Signed_imm_24_ID_REG;
  wire[3:0] Dest_ID_REG;
  
  ID_Stage_Reg ID_REG(
  .clk(CLOCK_50), .rst(RST), .flush(1'b0),
  .WB_EN_IN(WB_EN_ID), .MEM_R_EN_IN(MEM_R_EN_ID), .MEM_W_EN_IN(MEM_W_EN_ID), 
  .B_IN(B_ID), .S_IN(S_ID),
  .EXE_CMD_IN(EXE_CMD_ID),
  .PC_IN(IF_REG_PC),
  .Val_Rn_IN(Val_Rn_ID), .Val_Rm_IN(Val_Rm_ID),
  .imm_IN(imm_ID),
  .Shift_operand_IN(Shift_operand_ID),
  .Signed_imm_24_IN(Signed_imm_24_ID),
  .Dest_IN(Dest_ID),
  
  .WB_EN(WB_EN_ID_REG), .MEM_R_EN(MEM_R_EN_ID_REG), .MEM_W_EN(MEM_W_EN_ID_REG), 
  .B(B_ID_REG), .S(S_ID_REG),
  .EXE_CMD(EXE_CMD_ID_REG),
  .PC(PC_ID_REG),
  .Val_Rn(Val_Rn_ID_REG), .Val_Rm(Val_Rm_ID_REG),
  .imm(imm_ID_REG),
  .Shift_operand(Shift_operand_ID_REG),
  .Signed_imm_24(Signed_imm_24_ID_REG),
  .Dest(Dest_ID_REG)
  );

  wire[31:0] EXE_PC;
  EXE_Stage EXE(
  .clk(CLOCK_50), .rst(RST),
  .PC_in(PC_ID_REG),
  .PC(EXE_PC)
  );
  
  wire[31:0] EXE_REG_PC;
  EXE_Stage_Reg EXE_REG(
  .clk(CLOCK_50), .rst(RST),
  .PCIn(EXE_PC),
  .PC(EXE_REG_PC)
  );
  
  wire[31:0] MEM_PC;
  MEM_Stage MEM(
  .clk(CLOCK_50), .rst(RST),
  .PC_in(EXE_REG_PC),
  .PC(MEM_PC)
  );
  
  wire[31:0] MEM_REG_PC;
  MEM_Stage_Reg MEM_REG(
  .clk(CLOCK_50), .rst(RST),
  .PCIn(MEM_PC),
  .PC(MEM_REG_PC)
  );
  
  wire[31:0] WB_PC;
  WB_Stage WB(
  .clk(CLOCK_50), .rst(RST),
  .PC_in(MEM_REG_PC),
  .PC(WB_PC)
  );
endmodule

module Testing();
  reg clk, rst;
  initial begin
    rst = 1'b1;
    clk = 1'b0;
    #5
    rst = 1'b0;
    clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
    #5  clk = !clk;
  end

  TEST_MIPS mips(
    .CLOCK_50(clk), .RST(rst)
  );
endmodule