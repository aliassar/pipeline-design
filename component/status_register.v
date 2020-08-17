module Status_Register (
    input clk, rst, w_en,
    input [3:0] SR_in,
    output reg [3:0] SR
);
	always@(*) 
	begin
		if (rst) begin
            SR <= 3'b0;
        end
		else if (w_en) begin
            SR <= SR_in;
        end 
	end
	
endmodule