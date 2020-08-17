
module WB_Stage (
  input[31:0] ALU_result, MEM_result,
  input MEM_R_en,
  output[31:0] out
  );
  MUX32 mux(
  .sel(MEM_R_en),
  .a(MEM_result), .b(ALU_result),
  .o(out)
  );
endmodule