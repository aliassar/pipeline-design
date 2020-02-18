
module MEM2WB (clk, rst, PCIn, PC);
  input clk, rst;
  input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN;
  input [31:0] PCIn;
  output reg [31:0] PC;

  always @ (posedge clk) begin
    if (rst) begin
      {PC} <= 0;
    end
    else begin
      PC <= PCIn;
    end
  end
endmodule