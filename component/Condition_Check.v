module Condition_Check (
  input Z, C, N, V,
  input[3:0] Cond,
  output Condition
);
  assign Condition = Cond == 4'b0000 & (Z == 1'b1) |
                     Cond == 4'b0001 & (Z == 1'b0) |
                     Cond == 4'b0010 & (C == 1'b1) |
                     Cond == 4'b0011 & (C == 1'b0) |
                     Cond == 4'b0100 & (N == 1'b1) |
                     Cond == 4'b0101 & (N == 1'b0) |
                     Cond == 4'b0110 & (V == 1'b1) |
                     Cond == 4'b0111 & (V == 1'b0) |
                     Cond == 4'b1000 & (C == 1'b1 & Z == 1'b0) |
                     Cond == 4'b1001 & (C == 1'b0 | Z == 1'b1) |
                     Cond == 4'b1010 & (N == V) |
                     Cond == 4'b1011 & (N != V) |
                     Cond == 4'b1100 & (Z == 1'b0 & N == V) |
                     Cond == 4'b1101 & (Z == 1'b1 | N != V) |
                     Cond == 4'b1110 & (1'b1) ;
endmodule