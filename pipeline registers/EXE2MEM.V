module EXE_Stage_Reg (
  input clk, rst,
  input[31:0] PCIn,
  output reg[31:0] PC,
  );
  always @ (posedge clk) begin
    if (rst) begin
      {PC} <= 0;
    end
    else begin
      PC <= PCIn;
    end
  end
endmodule