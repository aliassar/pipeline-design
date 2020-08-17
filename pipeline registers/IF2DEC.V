module IF_Stage_Reg (
  input clk, rst, freeze, flush, 
  input[31:0] PCIn, Instruction_in, 
  output reg[31:0] PC, Instruction
  );
  always @ (posedge clk, posedge rst) begin
    if (rst | flush) begin
      {PC} <= 0;
      {Instruction} <= 32'b0;
    end
    else if (freeze == 1'b0) begin
      PC <= PCIn;
      Instruction <= Instruction_in;
    end
  end
endmodule