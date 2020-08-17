module ExtendImm24(
    input[23:0] in,
    output[31:0] out
);

    assign out = {in[23], in[23], in[23], in[23], in[23], in[23], in, 2'b0};
endmodule