module ID_Stage (
  input clk, rst,
  input[31:0] PC_in,
  output[31:0] PC
  );
  PC = PC_in;
endmodule
