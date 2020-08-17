module SRAM(
    input clk,

    input W_EN, R_EN,
    input[31: 0] address,
    input[31: 0] write_data,

    output[31: 0] read_data
);

    reg[31:0] data[0:64];    //256 byte
    wire[5:0] transfer_address;  //6 bit address
    wire[31:0] new_address;
    assign new_address = address - 32'd1024;
    assign {transfer_address} = new_address[7:2];

    assign read_data = (R_EN == 1'b1)? data[transfer_address] : 32'bz;
    always@(negedge clk) begin
        if (W_EN == 1'b1) begin
            data[transfer_address] <= write_data;
        end
    end
endmodule