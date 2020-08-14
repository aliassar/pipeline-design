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
  
  wire[31:0] ID_PC;
  ID_Stage ID(
  .clk(CLOCK_50), .rst(RST),
  .PC_in(IF_REG_PC),
  .PC(ID_PC)
  );
  
  wire[31:0] ID_REG_PC;
  ID_Stage_Reg ID_REG(
  .clk(CLOCK_50), .rst(RST),
  .PCIn(ID_PC),
  .PC(ID_REG_PC)
  );

  wire[31:0] EXE_PC;
  EXE_Stage EXE(
  .clk(CLOCK_50), .rst(RST),
  .PC_in(ID_REG_PC),
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