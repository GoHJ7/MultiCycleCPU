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
    bcond
   );
   //Appendix C, see state diagram, total 8 state
   //add for ecall, identify it by opcode, then ouput connects to is_halted in cpu
    output is_halted;
    input [6:0] Op;
    input bcond,ALUsrcA,IorD,IRWrite,PCsource,PCwrite,PCWriteNotCond,RegWrite,MemRead,Memwrite,MemtoReg;
    input S3, S2, S1, S0;
    input [1:0] ALUSrcB,ALUOp;
    output N3, N2, N1, N0;

    wire [3:0] Ss;
    assign Ss = {S3,S2,S1,S0}; 
    //ecall
    assign is_halted = (Op == 7'b1110011) ? 1 : 0;
    //ROM design except for the unused part
    assign PCwrite = (Ss == 4'b0110
                        ||Ss == 4'b0111
                        ||Ss == 4'b1000
                        ||Ss == 4'b1010
                        ||Ss == 4'b1011
                        ||Ss == 4'b1100) ? 1 : 0;//6,7,8,10,11,12
    assign PCWriteNotCond = (Ss == 4'b0101 ) ? 1 : 0;//5
    assign IorD = ( Ss == 4'b1001 || Ss == 4'b1010 ) ? 1 : 0;//9,10
    assign MemRead = ( Ss == 4'b0000 || Ss == 4'b1001 ) ? 1 : 0;//0,9
    assign Memwrite = ( Ss == 4'b1010 ) ? 1 : 0;//10
    assign IRWrite = ( Ss == 4'b0000 ) ? 1 : 0;//0
    assign MemtoReg = ( Ss == 4'b1100 ) ? 1 : 0;//12
    assign PCsource = ( Ss == 4'b1000 ) ? 1 : 0;//8
    assign ALUSrcB[1] = ( Ss == 4'b0011 || 
                            Ss == 4'b0100 ||
                            Ss == 4'b0110 ||
                            Ss == 4'b0111 ||
                            Ss == 4'b1011) ? 1 : 0;//3.4.6.7.11
    assign ALUSrcB[0] = ( Ss == 4'b0001 ||
                            Ss == 4'b1000 ||
                            Ss == 4'b1010 ||
                            Ss == 4'b1011) ? 1 : 0;//1,8,10,11
    assign ALUOp[1] = ( Ss == 4'b0101) ? 1 : 0;//5
    assign ALUOp[0] = ( Ss == 4'b0001|| Ss == 4'b0010
                            || Ss == 4'b0011) ? 1 : 0;//1,2,3
    assign AlusrcA = ( Ss == 4'b0010 ||
                       Ss == 4'b0011 ||
                       Ss == 4'b0100 ||
                       Ss == 4'b0101 ||
                       Ss == 4'b0111 ||) ? 1 : 0;//2.3.4.5.7
    assign RegWrite = ( Ss == 4'b0110 
                        || Ss == 4'b0111
                        || Ss == 4'b1000
                        || Ss == 4'b1100) ? 1 : 0;//6,7,8,12

    //N update
    always @(*) begin
        if(Ss == 4'b0000)begin//state 0
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 1;
        end
        else if(Ss == 4'b0001)begin//state 1
            if(op == 7'b0110011)begin//Rtype
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 1;
            assign N0 = 0;
            end
            else if(op == 7'b0000011 || op == 7'b0010011)begin//L or I type
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 1;
            assign N0 = 1;
            end
            else if(op == 7'b0110011)begin//stype
            assign N3 = 0;
            assign N2 = 1;
            assign N1 = 0;
            assign N0 = 0;
            end
            else if(op == 7'b0110011)begin//bxx
            assign N3 = 0;
            assign N2 = 1;
            assign N1 = 0;
            assign N0 = 1;
            end
            else if(op == 7'b0110011)begin//jal
            assign N3 = 0;
            assign N2 = 1;
            assign N1 = 1;
            assign N0 = 0;
            end
            else if(op == 7'b0110011)begin//jalr
            assign N3 = 0;
            assign N2 = 1;
            assign N1 = 1;
            assign N0 = 1;
            end
            else begin
            end
        end
        else if(Ss == 4'b0010)begin//state 2
            assign N3 = 1;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
        end
        else if(Ss == 4'b0011)begin//state 3
           if(op == 7'b001001)begin//Itype
            assign N3 = 1;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
            end
            else if(op == 7'b0000011 1)begin//L 
            assign N3 = 1;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 1;
            end
            else begin
            end
        end
        else if(Ss == 4'b0100)begin//state 4
            assign N3 = 1;
            assign N2 = 0;
            assign N1 = 1;
            assign N0 = 0;
        end
        else if(Ss == 4'b0101)begin//state 5
            if(bcond)begin
            assign N3 = 1;
            assign N2 = 0;
            assign N1 = 1;
            assign N0 = 1;
            end
            else begin
            assign N3 = 0;
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            end
        end
        else if(Ss == 4'b0110)begin//state 6
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
        end
        else if(Ss == 4'b0111)begin//state 7
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
        end
        else if(Ss == 4'b1000)begin//state 8
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
        end
        else if(Ss == 4'b1001)begin//state 9
            assign N3 = 1;
            assign N2 = 1;
            assign N1 = 0;
            assign N0 = 0;
        end
        else if(Ss == 4'b1010)begin//state 10
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
        end
        else if(Ss == 4'b1011)begin//state 11
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 1;
        end
        else if(Ss == 4'b1100)begin//state 12
            assign N3 = 0;
            assign N2 = 0;
            assign N1 = 0;
            assign N0 = 0;
        end
        else begin
        end
    end
endmodule