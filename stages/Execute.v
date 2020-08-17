
module EXE_Stage (
  input clk,
  input[3:0] EXE_CMD,
  input MEM_R_EN, MEM_W_EN,
  input[31:0] PC,
  input[31:0] Val_Rn, Val_Rm,
  input imm,
  input[11:0] Shift_operand,
  input[23:0] Signed_imm_24,
  input[3:0] SR,
  output[31:0] ALU_result, Br_addr,
  output[3:0] status
);
  	wire is_mem_command;
	wire [31:0] val2;

	assign is_mem_command = MEM_R_EN | MEM_W_EN;

	wire[31:0] imm_24_extended;
  	ExtendImm24 extender(
    	.in(Signed_imm_24),
    	.out(imm_24_extended)
	);
	assign branch_address = PC + imm_24_extended;	
	
	Val2Generator val2_generator(.Rm(Val_Rm), .shift_operand(shift_operand), .imm(imm),
			.is_mem_command(is_mem_command), .val2_out(val2)
	);

	ALU alu(.alu_in1(Val_Rn), .alu_in2(val2), .alu_command(EXE_CMD), .cin(SR[2]),
			.alu_out(alu_res), .statusRegister(status)
	);
  
endmodule