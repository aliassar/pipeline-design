module SRAM(
    input clk,

    input W_EN, R_EN,
    input [31: 0] address,
    input [31: 0] write_data,

    output reg [31: 0] read_data,
);

    reg[31:0] data[0:64]    //256 byte
    wire transfer_address[5:0]  //6 bit address
    assign {transfer_address} = address[7:2];

    assign read_data <= R_EN == 1'b1? data[transfer_address] : 32'bz;
    always@(*) begin
        if (W_EN == 1'b1) begin
            data[transfer_address] <= write_data;
        end
    end
endmodule