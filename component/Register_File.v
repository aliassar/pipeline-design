module RegisterFile (
  input clk, rst,
  input[3:0] src1, src2, Dest_wb,
  input[31:0] Result_WB,
  input writeBackEn,
  output[31:0] reg1, reg2
);
  reg[31:0] registers [14:0];
  for(int i = 0; i < 15; i += 1) begin
    registers[i] = i;
  end
  // initial
  assign reg1 = registers[src1];
  assign reg2 = registers[src2];
  
  always @ (posedge clk) begin
    if (writeBackEn) begin
      registers[Dest_wb] <= Result_WB;
    end
  end

endmodule