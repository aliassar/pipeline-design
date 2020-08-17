
module MEM_Stage (
  input clk, MEMread, MEMwrite,
  input[31:0] address, data,
  output[31:0] MEM_result
  );
  SRAM sram(
    .clk(clk),
    .W_EN(MEMwrite), .R_EN(MEMread),
    .address(address),
    .write_data(data),
    .read_data(MEM_result)
  );

endmodule