module PCMux (
  input sel,
  input[31:0] pc_in, jmp_in,
  output[31:0] pc
  );
endmodule

module PCAdder (
  input[31:0] pc_in, number,
  output[31:0] pc,
  );
  wire carry;
  assign {carry, pc} = pc_in + number;
endmodule

module InstructionMemory (
  input[31:0] pc,
  output[31:0] instruction,
  );
  case (pc)
 	  32'd0:  instruction <= 32'b000000_00001_00010_00000_00000000000;
    32'd4:  instruction <= 32'b000000_00011_00010_00000_00000000000;
    32'd8:  instruction <= 32'b000000_00101_00010_00000_00000000000;
    32'd12:  instruction <= 32'b000000_00111_00010_00000_00000000000;
    32'd16:  instruction <= 32'b000000_01001_00010_00000_00000000000;
    32'd20:  instruction <= 32'b000000_01011_00010_00000_00000000000;
    32'd24:  instruction <= 32'b000000_01101_00010_00000_00000000000;
		default: instruction <= 32'b000000_01111_00010_00000_00000000000;
	endcase 
endmodule

module PCReg (
  input clk, rst, freeze,
  input[31:0] pc_in,
  output reg[31:0] pc
  );
  pc <= 1'b0
  always @ (posedge clk) begin
    if (rst) begin
      pc <= 32'b0;
    end
    else if !(freeze) begin
      pc <= pc_in;
    end
  end
endmodule

module IF_Stage (
  input clk,rst, freeze, Branch_token,
  input[31:0] BranchAddr,
  output[31:0] PC, Instruction
  );
  
  wire[31:0] selected_pc;
  wire[31:0] current_pc;
  
  PCReg PC(
  .clk(clk), .rst(rst), .freeze(freeze),
  .pc_in(selected_pc),
  .pc(current_pc),
  );
  
  PCMux Mux(
  .sel(Branch_token),
  .pc_in(current_pc), .jmp_in(BranchAddr),
  .pc(selected_pc),
  );
  
  wire[31:0] next_pc;
  PCAdder Adder(
		.pc_in(current_pc), .number(32'd4),
    .pc(next_pc),
	);
	
	InstructionMemory InsMem(
		.pc(current_pc),
    .instruction(Instruction),
	);
	
	assign PC = current_pc;
	
endmodule
