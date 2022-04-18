`include "opcodes.v"

module ControlUnit(
    Op,  // input
    ALUsrcA, //output
    IorD, //output
    IRWrite ,     // output
    PCsource ,     // output 
    PCWrite , // output
    PCWriteNotCond,   // output
    ALUSrcB,     // output [1:0]
    RegWrite,     // output
    MemRead,   // output
    Memwrite,    // output 
    MemtoReg,//output
    ALUOp,// output [1,0]
    S3,// state input
    S2,
    S1,
    S0,
    N3,
    N2,
    N1,
    N0,
    is_halted
   );
   //Appendix C, see state diagram, total 8 state
   //add for ecall, identify it by opcode, then ouput connects to is_halted in cpu
    output is_halted;
    input [6:0] Op;
    input AlusrcA,IorD,IRWrite,PCsource,PCwrite,PCWriteNotCond,RegWrite,MemRead,Memwrite,MemtoReg;
    input S3, S2, S1, S0;
    input [1:0] AlUSrcB,ALUOp;
    output N3, N2, N1, N0;

    wire [3:0] Ss;
    assign Ss = {S3,S2,S1,S0}; 
    //ecall
    assign is_halted = (Op == 7'b1110011) ? 1 : 0;
    //ROM design except for the unused part
    assign PCwrite = (Ss == 4'b0000||Ss == 4'b1001) ? 1 : 0;
    assign PCWriteNotCond = (Ss == 4'b1000 ) ? 1 : 0;
    assign IorD = ( Ss == 4'b0011 || Ss == 4'b0101 ) ? 1 : 0;
    assign MemRead = ( Ss == 4'b0000 || Ss == 4'b0011 ) ? 1 : 0;
    assign Memwrite = ( Ss == 4'b0101 ) ? 1 : 0;
    assign IRWrite = ( Ss == 4'b0000 ) ? 1 : 0;
    assign MemtoReg = ( Ss == 4'b0100 ) ? 1 : 0;
    assign PCsource = ( Ss == 4'b1000 ) ? 1 : 0;
    assign ALUOp[1] = ( Ss == 4'b0110 ) ? 1 : 0;
    assign ALUOp[0] = ( Ss == 4'b1000) ? 1 : 0;
    assign AlUSrcB[1] = ( Ss == 4'b0001 || Ss == 4b'0010) ? 1 : 0;
    assign AlUSrcB[0] = ( Ss == 4'b0000|| Ss == 4'b0001) ? 1 : 0;
    assign AlusrcA = ( Ss == 4'b0010 ||
                       Ss == 4'b0110 ||
                       Ss == 4'b1000) ? 1 : 0;
    assign RegWrite = ( Ss == 4'b0100 || Ss == 4'b0111) ? 1 : 0;

    //N update
    wire [9:0] ops;
    assign ops = {Op,Ss}; 
    assign N3 = ( ops == 10'b0000100001 || 
                    ops == 10'b0001000001 ) ? 1 : 0;
    assign N2 = ( ops == 10'b0000000001 ||
                    ops == 10'b1010110010 ||
                    Ss == 4'b0011 ||
                    Ss == 4'b0110 ) ? 1 : 0;
    assign N1 = ( ops == 10'b0000000001 ||
                    ops == 10'b1000110001 ||
                    ops == 10'b1010110001 ||
                    ops == 10'b1000110010 ||
                    Ss == 4'b0110 ) ? 1 : 0;
    assign N0 = ( ops == 10'b1000110010 ||
                    ops == 10'b1010110010 ||
                    ops == 10'b0000100001 ||
                    Ss == 4'b0000 ||
                    Ss == 4'b0110 ) ? 1 : 0;
endmodule