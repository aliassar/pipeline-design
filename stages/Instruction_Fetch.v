module PCMux (
  input sel,
  input[31:0] pc_in, jmp_in,
  output[31:0] pc
  );
  assign pc = sel ? jmp_in: pc_in;
endmodule

module PCAdder (
  input[31:0] pc_in, number,
  output[31:0] pc
  );
  wire carry;
  assign {carry, pc} = pc_in + number;
endmodule

module InstructionMemory (
  input clk,
  input[31:0] pc,
  output reg[31:0] instruction
  );
  always @(*) begin
    case (pc)
      32'd0:  instruction <= 32'b1110_00_1_1101_0_0000_0000_000000010100;
      32'd4:  instruction <= 32'b1110_00_1_1101_0_0000_0001_101000000001;
      32'd8:  instruction <= 32'b1110_00_1_1101_0_0000_0010_000100000011;
      32'd12:  instruction <= 32'b1110_00_0_0100_1_0010_0011_000000000010;
      32'd16:  instruction <= 32'b1110_00_0_0101_0_0000_0100_000000000000;
      32'd20:  instruction <= 32'b1110_00_0_0010_0_0100_0101_000100000100;
      32'd24:  instruction <= 32'b1110_00_0_0110_0_0000_0110_000010100000;
      32'd28:  instruction <= 32'b1110_00_0_1100_0_0101_0111_000101000010;
      32'd32:  instruction <= 32'b1110_00_0_0000_0_0111_1000_000000000011;
      32'd36:  instruction <= 32'b1110_00_0_1111_0_0000_1001_000000000110;
      32'd40:  instruction <= 32'b1110_00_0_0001_0_0100_1010_000000000101;
      32'd44:  instruction <= 32'b1110_00_0_1010_1_1000_0000_000000000110;
      32'd48:  instruction <= 32'b0001_00_0_0100_0_0001_0001_000000000001;
      32'd52:  instruction <= 32'b1110_00_0_1000_1_1001_0000_000000001000;
      32'd56:  instruction <= 32'b0000_00_0_0100_0_0010_0010_000000000010;
      32'd60:  instruction <= 32'b1110_00_1_1101_0_0000_0000_101100000001;
      32'd64:  instruction <= 32'b1110_01_0_0100_0_0000_0001_000000000000;
      32'd68:  instruction <= 32'b1110_01_0_0100_1_0000_1011_000000000000;
      32'd72:  instruction <= 32'b1110_01_0_0100_0_0000_0010_000000000100;
      32'd76:  instruction <= 32'b1110_01_0_0100_0_0000_0011_000000001000;
      32'd80:  instruction <= 32'b1110_01_0_0100_0_0000_0100_000000001101;
      32'd84:  instruction <= 32'b1110_01_0_0100_0_0000_0101_000000010000;
      32'd88:  instruction <= 32'b1110_01_0_0100_0_0000_0110_000000010100;
      32'd92:  instruction <= 32'b1110_01_0_0100_1_0000_1010_000000000100;
      32'd96:  instruction <= 32'b1110_01_0_0100_0_0000_0111_000000011000;
      32'd100:  instruction <= 32'b1110_00_1_1101_0_0000_0001_000000000100;
      32'd104:  instruction <= 32'b1110_00_1_1101_0_0000_0010_000000000000;
      32'd108:  instruction <= 32'b1110_00_1_1101_0_0000_0011_000000000000; //28
      default: instruction <= 32'b00000001111000100000000000000000;
    endcase 
  end
endmodule

module PCReg (
  input clk, rst, freeze,
  input[31:0] pc_in,
  output reg[31:0] pc
  );
  
  always @ (posedge clk, posedge rst) begin
    if (rst) begin
      pc <= 32'b0;
    end
    else if (freeze == 1'b0) begin
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
  
  PCReg PC_Reg(
  .clk(clk), .rst(rst), .freeze(freeze),
  .pc_in(selected_pc),
  .pc(current_pc)
  );
  
  wire[31:0] next_pc;
  PCAdder Adder(
		.pc_in(current_pc), .number(32'd4),
    .pc(next_pc)
	);
	
  PCMux Mux(
  .sel(Branch_token),
  .pc_in(next_pc), .jmp_in(BranchAddr),
  .pc(selected_pc)
  );
	
	InstructionMemory InsMem(
    .clk(clk),
		.pc(current_pc),
    .instruction(Instruction)
	);
	
	assign PC = next_pc;
	
endmodule
