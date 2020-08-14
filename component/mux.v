module MUX8(
  input sel,
  input[8:0] a, b,
  output[8:0] o
);
  assign o = sel? a: b;
endmodule

module MUX4(
  input sel,
  input[3:0] a, b,
  output[3:0] o
);
  assign o = sel? a: b;
endmodule

module MUX32(
  input sel,
  input[31:0] a, b,
  output[31:0] o
);
  assign o = sel? a: b;
endmodule