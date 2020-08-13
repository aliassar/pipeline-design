module Control_Unit (
  input[1:0] mode,
  input[3:0] op_code,
  input S,
  output[3:0] EXE_CMD,
  output B, mem_write, mem_read, WB_Enable, S_Out,
);
  case (op_code)
 	  4'b1101:  EXEC_CMD <= 4'b0001;  //MOV
    4'b1111:  EXEC_CMD <= 4'b1001;  //MVN
    4'b0100:  EXEC_CMD <= 4'b0010;  //ADD
    4'b0101:  EXEC_CMD <= 4'b0011;  //ADC
    4'b0010:  EXEC_CMD <= 4'b0100;  //SUB
    4'b0110:  EXEC_CMD <= 4'b0101;  //SBC
    4'b0000:  EXEC_CMD <= 4'b0110;  //AND
    4'b1100:  EXEC_CMD <= 4'b0111;  //ORR
    4'b0001:  EXEC_CMD <= 4'b1000;  //EOR
    4'b1010:  EXEC_CMD <= 4'b0100;  //CMP
    4'b1000:  EXEC_CMD <= 4'b0110;  //TST
    //4'b0100:  EXEC_CMD <= 4'b0010;  //LDR
    //4'b0100:  EXEC_CMD <= 4'b0010;  //STR
		default: EXEC_CMD <= 4'b0;
	endcase 
	
	assign S_Out = S;
	assign B = mode == 10;
	assign mem_read = {mode, op_code, S} == 7'b0101001;
	assign mem_write = {mode, op_code, S} == 7'b0101000;
  assign WB_Enable = {mode, op_code, S} == 7'b0101001;
  
endmodule
