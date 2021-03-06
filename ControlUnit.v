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
    is_halted,
    bcond,
    is_fhalted
   );
   //Appendix C, see state diagram, total 8 state
   //add for ecall, identify it by opcode, then ouput connects to is_halted in cpu
    output is_halted, is_fhalted;
    input [6:0] Op;
    input bcond,ALUsrcA,IorD,IRWrite,PCsource,PCWrite,PCWriteNotCond,RegWrite,MemRead,Memwrite,MemtoReg;
    input S3, S2, S1, S0;
    input [1:0] ALUSrcB,ALUOp;
    output reg N3, N2, N1, N0;

    wire [3:0] Ss;
    assign Ss = {S3,S2,S1,S0}; 
    //ecall
    assign is_halted = (Op == 7'b1110011) ? 1 : 0;
    assign is_fhalted = (Ss == 4'b1111) ? 1 : 0;
    //ROM design except for the unused part
    assign PCWrite = (Ss == 4'b0110
                        ||Ss == 4'b0111
                        ||Ss == 4'b1000
                        ||Ss == 4'b1010
                        ||Ss == 4'b1011
                        ||Ss == 4'b1100) ? 1 : 0;//6,7,8,10,11,12
    assign PCWriteNotCond = (Ss == 4'b0101|| Ss == 4'b1110 ) ? 1 : 0;//5.14
    assign IorD = ( Ss == 4'b1001 || Ss == 4'b1010 ) ? 1 : 0;//9,10
    assign MemRead = ( Ss == 4'b0000 || Ss == 4'b1001 ) ? 1 : 0;//0,9
    assign Memwrite = ( Ss == 4'b1010 ) ? 1 : 0;//10
    assign IRWrite = ( Ss == 4'b0000 ) ? 1 : 0;//0
    assign MemtoReg = ( Ss == 4'b1100 ) ? 1 : 0;//12
    assign PCsource = ( Ss == 4'b0101|| Ss == 4'b1110 ) ? 1 : 0;//5.14
    assign ALUSrcB[1] = ( Ss == 4'b0011 || 
                            Ss == 4'b0100 ||
                            Ss == 4'b0110 ||
                            Ss == 4'b0111 ||
                            Ss == 4'b1011 ||
                            Ss == 4'b1101|| Ss == 4'b1110) ? 1 : 0;//3.4.6.7.11.13.14
    assign ALUSrcB[0] = ( Ss == 4'b0001 ||
                            Ss == 4'b1000 ||
                            Ss == 4'b1010 ||
                            Ss == 4'b1100|| Ss == 4'b1110) ? 1 : 0;//1,8,10,12.14
    assign ALUOp[1] = ( Ss == 4'b0101|| Ss == 4'b1101|| Ss == 4'b1110) ? 1 : 0;//5,13.14
    assign ALUOp[0] = ( Ss == 4'b0010|| Ss == 4'b1101) ? 1 : 0;//2,13
    assign ALUsrcA = ( Ss == 4'b0010 ||
                       Ss == 4'b0011 ||
                       Ss == 4'b0100 ||
                       Ss == 4'b0101 ||
                       Ss == 4'b0111 ||
                        Ss == 4'b1101|| Ss == 4'b1110) ? 1 : 0;//2.3.4.5.7.13.14
    assign RegWrite = ( Ss == 4'b0110 
                        || Ss == 4'b0111
                        || Ss == 4'b1000
                        || Ss == 4'b1100) ? 1 : 0;//6,7,8,12

    //N update
    always @ (*) begin
        if(Ss == 4'b0000)begin//state 0
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 1;
        end
        else if(Ss == 4'b0001)begin//state 1
            if(Op == `ARITHMETIC)begin//Rtype
            N3 <= 0;
            N2 <= 0;
            N1 <= 1;
            N0 <= 0;
            end
            else if(Op == `LOAD )begin//L 
            N3 <= 0;
            N2 <= 0;
            N1 <= 1;
            N0 <= 1;
            end
            else if(Op == `ARITHMETIC_IMM)begin// I type
            N3 <= 1;
            N2 <= 1;
            N1 <= 0;
            N0 <= 1;
            end
            else if(Op == `STORE)begin//stype
            N3 <= 0;
            N2 <= 1;
            N1 <= 0;
            N0 <= 0;
            end
            else if(Op == `BRANCH)begin//bxx
            N3 <= 0;
            N2 <= 1;
            N1 <= 0;
            N0 <= 1;
            end
            else if(Op == `JAL)begin//jal
            N3 <= 0;
            N2 <= 1;
            N1 <= 1;
            N0 <= 0;
            end
            else if(Op == `JALR)begin//jalr
            N3 <= 0;
            N2 <= 1;
            N1 <= 1;
            N0 <= 1;
            end
            else if(Op == 7'b1110011)begin//ecall
            N3 <= 1;
            N2 <= 1;
            N1 <= 1;
            N0 <= 0;
            end
            else begin
            end
        end
        else if(Ss == 4'b0010)begin//state 2
            N3 <= 1;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b0011)begin//state 3
            N3 <= 1;
            N2 <= 0;
            N1 <= 0;
            N0 <= 1;
        end
        else if(Ss == 4'b0100)begin//state 4
            N3 <= 1;
            N2 <= 0;
            N1 <= 1;
            N0 <= 0;
        end
        else if(Ss == 4'b0101)begin//state 5
            if(bcond)begin
            N3 <= 1;
            N2 <= 0;
            N1 <= 1;
            N0 <= 1;
            end
            else begin
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
            end
        end
        else if(Ss == 4'b0110)begin//state 6
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b0111)begin//state 7
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1000)begin//state 8
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1001)begin//state 9
            N3 <= 1;
            N2 <= 1;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1010)begin//state 10
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1011)begin//state 11
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1100)begin//state 12
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1101)begin//state 13
            N3 <= 1;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
        end
        else if(Ss == 4'b1110)begin//state 14
            if(bcond)begin
            N3 <= 1;
            N2 <= 1;
            N1 <= 1;
            N0 <= 1;
            end
            else begin
            N3 <= 0;
            N2 <= 0;
            N1 <= 0;
            N0 <= 0;
            end
        end
        else if(Ss == 4'b1111)begin//state 15

        end
        else begin
        end
    end
endmodule