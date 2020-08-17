module TEST_MIPS(
	input CLOCK_50, RST
);
	
	wire[31:0] IF_PC, IF_Instruction;
	wire[31:0] ALU_result_EXE, Br_addr_EXE;
	wire WB_en_MEM_REG, MEM_R_en_MEM_REG;
	wire WB_EN_ID_REG, MEM_R_EN_ID_REG, MEM_W_EN_ID_REG, B_ID_REG, S_ID_REG;
	wire[3:0] Dest_MEM_REG;
	wire[31:0] WB_Value;
	wire SR ;
	wire hazard_detected;
	
	IF_Stage IF (
  .clk(CLOCK_50), .rst(RST), .freeze(hazard_detected), .Branch_token(B_ID_REG),
  .BranchAddr(Br_addr_EXE),
  .PC(IF_PC), .Instruction(IF_Instruction)
  );
  
  wire [31:0] IF_REG_PC, IF_REG_Instruction;
  IF_Stage_Reg IFReg(
  .clk(CLOCK_50), .rst(RST), .freeze(hazard_detected), .flush(B_ID_REG), 
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
    .Instruction(IF_REG_Instruction), 
    .Result_WB(WB_Value),
    .writeBackEn(WB_en_MEM_REG),
    .Dest_wb(Dest_MEM_REG),
    .hazard(hazard_detected),
    .SR(SR),
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
  
  wire[3:0] EXE_CMD_ID_REG;
  wire[31:0] PC_ID_REG;
  wire[31:0] Val_Rn_ID_REG, Val_Rm_ID_REG;
  wire imm_ID_REG;
  wire[11:0] Shift_operand_ID_REG;
  wire[23:0] Signed_imm_24_ID_REG;
  wire[3:0] Dest_ID_REG;
  wire[3:0] SR_ID_REG;
  
  ID_Stage_Reg ID_REG(
  .clk(CLOCK_50), .rst(RST), .flush(B_ID_REG),
  .WB_EN_IN(WB_EN_ID), .MEM_R_EN_IN(MEM_R_EN_ID), .MEM_W_EN_IN(MEM_W_EN_ID), 
  .B_IN(B_ID), .S_IN(S_ID),
  .EXE_CMD_IN(EXE_CMD_ID),
  .PC_IN(IF_REG_PC),
  .Val_Rn_IN(Val_Rn_ID), .Val_Rm_IN(Val_Rm_ID),
  .imm_IN(imm_ID),
  .Shift_operand_IN(Shift_operand_ID),
  .Signed_imm_24_IN(Signed_imm_24_ID),
  .Dest_IN(Dest_ID),
  .SR_IN(SR),
  
  .WB_EN(WB_EN_ID_REG), .MEM_R_EN(MEM_R_EN_ID_REG), .MEM_W_EN(MEM_W_EN_ID_REG), 
  .B(B_ID_REG), .S(S_ID_REG),
  .EXE_CMD(EXE_CMD_ID_REG),
  .PC(PC_ID_REG),
  .Val_Rn(Val_Rn_ID_REG), .Val_Rm(Val_Rm_ID_REG),
  .imm(imm_ID_REG),
  .Shift_operand(Shift_operand_ID_REG),
  .Signed_imm_24(Signed_imm_24_ID_REG),
  .Dest(Dest_ID_REG),
  .SR(SR_ID_REG)
  );

  wire[3:0] status_EXE;
  EXE_Stage EXE(
  .clk(CLOCK_50),
  .EXE_CMD(EXE_CMD_ID_REG),
  .MEM_R_EN(MEM_R_EN_ID_REG), .MEM_W_EN(MEM_W_EN_ID_REG),
  .PC(PC_ID_REG),
  .Val_Rn(Val_Rn_ID_REG), .Val_Rm(Val_Rm_ID_REG),
  .imm(imm_ID_REG),
  .Shift_operand(Shift_operand_ID_REG),
  .Signed_imm_24(Signed_imm_24_ID_REG),
  .SR(SR_ID_REG),
  .ALU_result(ALU_result_EXE), .Br_addr(Br_addr_EXE),
  .status(status_EXE)
  );

  wire WB_en_EXE_REG, MEM_R_EN_EXE_REG, MEM_W_EN_EXE_REG;
  wire[31:0] ALU_result_EXE_REG, ST_val_EXE_REG;
  wire[3:0] Dest_EXE_REG;
  EXE_Stage_Reg EXE_REG(
  .clk(CLOCK_50), .rst(RST), .WB_en_in(WB_EN_ID_REG), .MEM_R_EN_in(MEM_R_EN_ID_REG), .MEM_W_EN_in(MEM_W_EN_ID_REG),
  .ALU_result_in(ALU_result_EXE), .ST_val_in(Val_Rm_ID_REG),
  .Dest_in(Dest_ID_REG),
  .WB_en(WB_en_EXE_REG), .MEM_R_EN(MEM_R_EN_EXE_REG), .MEM_W_EN(MEM_W_EN_EXE_REG),
  .ALU_result(ALU_result_EXE_REG), .ST_val(ST_val_EXE_REG),
  .Dest(Dest_EXE_REG)
  );

  wire[31:0] MEM_result_MEM;
  MEM_Stage MEM(
  .clk(CLOCK_50), .MEMread(MEM_R_EN_EXE_REG), .MEMwrite(MEM_W_EN_EXE_REG),
  .address(ST_val_EXE_REG), .data(ALU_result_EXE_REG),
  .MEM_result(MEM_result_MEM)
  );

  wire[31:0] ALU_result_MEM_REG, MEM_result_MEM_REG;
  MEM_Stage_Reg MEM_REG(
  .clk(CLOCK_50), .rst(RST), 
  .WB_en_in(WB_en_EXE_REG), .MEM_R_en_in(MEM_R_EN_EXE_REG),
  .ALU_result_in(ALU_result_EXE_REG), 
  .Mem_read_value_in(MEM_result_MEM),
  .Dest_in(Dest_EXE_REG),
  .WB_en(WB_en_MEM_REG), 
  .MEM_R_en(MEM_R_en_MEM_REG),
  .ALU_result(ALU_result_MEM_REG), .MEM_read_value(MEM_result_MEM_REG),
  .Dest(Dest_MEM_REG)
  );

  WB_Stage WB(
  .ALU_result(ALU_result_MEM_REG), 
  .MEM_result(MEM_result_MEM_REG),
  .MEM_R_en(MEM_R_en_MEM_REG),
  .out(WB_Value)
  );

  Status_Register ST_REG(
    .clk(CLOCK_50), .rst(RST), .w_en(S_ID_REG),
    .SR_in(status_EXE),
    .SR(SR)
  );

  Hazard_Detection HD_Unit(
    .two_src(Two_src_ID),
    .src1(src1_ID), .src2(src2_ID),
    .Dest_EXE(Dest_ID_REG), .Dest_MEM(Dest_EXE_REG),
    .WB_EN_EXE(WB_EN_ID_REG), .WB_EN_MEM(WB_en_EXE_REG),
    .hazard_Detected(hazard_detected)
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