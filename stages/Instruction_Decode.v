module ID_Stage (
  input clk, rst,
  input[31:0] Instruction, Result_WB,
  input writeBackEn,
  input[3:0] Dest_wb,
  input hazard,
  input[3:0] SR,
  output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output[3:0] EXE_CMD,
  output[31:0] Val_Rn, Val_Rm,
  output imm,
  output[11:0] Shift_operand,
  output[23:0] Signed_imm_24,
  output[3:0] Dest,
  output[3:0] src1, src2,
  output Two_src
  );
  wire[3:0] EXE_CMD_CU;
  wire B_CU, mem_write_CU, mem_read_CU, WB_Enable_CU, S_CU; 
  Control_Unit CU(
    .mode(Instruction[27:26]),
    .op_code(Instruction[24:21]),
    .S(Instruction[20]),
    .EXE_CMD(EXE_CMD_CU),
    .B(B_CU), 
    .mem_write(mem_write_CU), 
    .mem_read(mem_read_CU), 
    .WB_Enable(WB_Enable_CU), 
    .S_Out(S_CU)
  );
  wire condition_check;
  Condition_Check CC(
    .N(SR[0]), 
    .Z(SR[1]),
    .C(SR[2]), 
    .V(SR[3]),
    .Cond(Instruction[31:28]),
    .Condition(condition_check)
  );
  wire not_condition;
  assign not_condition = !condition_check;
  wire continue;
  assign continue = hazard & not_condition;
  
  wire[8:0] final_cu;
  MUX8 mux_command(
    .sel(continue),
    .a(9'b0), 
    .b({S_CU,B_CU,EXE_CMD_CU,mem_write_CU,mem_read_CU,WB_Enable_CU}),
    .o(final_cu)
  );
  assign S = final_cu[8]; 
  assign B = final_cu[7];
  assign EXE_CMD = final_cu[6:3];
  assign MEM_W_EN = final_cu[2];
  assign MEM_R_EN = final_cu[1];
  assign WB_EN = final_cu[0];
  
  RegisterFile RF(
    .clk(clk),
    .rst(rst),
    .src1(Instruction[19:16]), 
    .src2(Instruction[3:0]),
    .Dest_wb(Dest_wb),
    .Result_WB(Result_WB),
    .writeBackEn(writeBackEn),
    .reg1(Val_Rn),
    .reg2(Val_Rm)
  );
  
  assign imm = Instruction[25];
  assign Shift_operand = Instruction[11:0];
  assign Signed_imm_24 = Instruction[23:0];
  assign Dest = Instruction[15:12];
  assign src1 = Instruction[19:16];
  assign src2 = Instruction[3:0];
  assign Two_src = (!imm) | MEM_W_EN;
  
endmodule