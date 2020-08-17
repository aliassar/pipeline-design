module ALU(
		input [31:0] alu_in1, alu_in2,
        input [3:0] alu_command,
        input cin,

        output reg [31:0] alu_out,
        output wire [3:0] statusRegister
		);
    
    wire z, n;
    reg v, cout;
    assign statusRegister = {n, z, cout, v};

    assign z = (alu_out == 0 ? 1 : 0);
    assign n = alu_out[31];
	
	
	always @(*) begin
	    cout = 1'b0;
        v = 1'b0;
	
		case(alu_command)
            4'b0001:    //MOV
                alu_out = alu_in2;
            4'b1001:    //MOVN
                alu_out = ~alu_in2; 
			4'b0010:    //ADD
                begin
                    {cout, alu_out} = alu_in1 + alu_in2;
                    v = ((alu_in1[31] == alu_in2[31]) & (alu_out[31] != alu_in1[31]));
                end

			4'b0011:    //ADDC
                begin
                    {cout, alu_out} = alu_in1 + alu_in2 + cin;
                    v = ((alu_in1[31] == alu_in2[31]) & (alu_out[31] != alu_in1[31]));
                end
			4'b0100:    //SUB
                begin
                    {cout, alu_out} = alu_in1 - alu_in2[31];
                    v = ((alu_in1[31] == ~alu_in2[31]) & (alu_out[31] != alu_in1[31]));
                end

			4'b0101:    //SUBC
                begin
                    {cout, alu_out} = alu_in1 - alu_in2[31];
                    v = ((alu_in1[31] == ~alu_in2[31]) & (alu_out[31] != alu_in1[31]));
                end
                
			4'b0110:    //AND
                alu_out	 = 	alu_in1 & alu_in2;
			4'b0111:    //OR
                alu_out	 = 	alu_in1 | alu_in2;
			4'b1000:    //XOR
                alu_out	 = 	alu_in1 ^ alu_in2;
		endcase
	end

endmodule
