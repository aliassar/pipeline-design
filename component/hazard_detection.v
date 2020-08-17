module Hazard_Detection (
    input two_src,
    input [3:0] src1, src2,
    input [3:0] Dest_EXE, Dest_MEM,
    input WB_EN_EXE, WB_EN_MEM,
    output hazard_Detected
);
    assign hazard_Detected = ((src1 == Dest_EXE) && (WB_EN_EXE == 1'b1)) ? 1'b1
            : ((src1 == Dest_MEM) && (WB_EN_MEM == 1'b1)) ? 1'b1
            : ((src2 == Dest_EXE) && (WB_EN_EXE == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : ((src2 == Dest_MEM) && (WB_EN_MEM == 1'b1) && (two_src == 1'b1)) ? 1'b1
            : 1'b0;

endmodule
