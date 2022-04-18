`include "opcodes.v"

module ALUControlUnit(part_of_inst,
alu_op,
ALUOp);
input [10:0] part_of_inst;
input [6:0] ALUop;
output reg [3:0] alu_op;
//wire
wire [6:0]opcode;
wire [2:0]func3;
wire sign;
assign opcode = ALUOp;
assign func3 = part_of_inst[2:0];
assign sign = part_of_inst[3];

//control
always @ (*) begin
    case (opcode)
        `ARITHMETIC: begin
            if(func3==`FUNCT3_ADD && sign == 1'b0 )//add
                alu_op <= `FUNC_ADD;
            else if(func3 == `FUNCT3_SUB && sign == 1'b1)//sub
                alu_op <= `FUNC_SUB;
            else if(func3 == `FUNCT3_SLL)//sll
                alu_op <= `FUNC_LLS;
            else if(func3 == `FUNCT3_XOR)//xor
                alu_op <= `FUNC_XOR;
            else if(func3 == `FUNCT3_OR)//or
                alu_op <= `FUNC_OR;
            else if(func3 == `FUNCT3_AND)//and
                alu_op <= `FUNC_AND;
            else if(func3 == `FUNCT3_SRL)//srl
                alu_op <= `FUNC_LRS;
        end
        `ARITHMETIC_IMM: begin
            if(func3==`FUNCT3_ADD)//addi
                alu_op <= `FUNC_ADD;
            else if(func3 == `FUNCT3_SLL)//slli
                alu_op <= `FUNC_LLS;
            else if(func3 == `FUNCT3_XOR)//xori
                alu_op <= `FUNC_XOR;
            else if(func3 == `FUNCT3_OR)//ori
                alu_op <= `FUNC_OR;
            else if(func3 == `FUNCT3_AND)//andi
                alu_op <= `FUNC_AND;
            else if(func3 == `FUNCT3_SRL)//srli
                alu_op <= `FUNC_LRS;
        end
        `LOAD: begin
            alu_op <= `FUNC_ADD;
        end
        `JALR: begin
            alu_op <= `FUNC_ADD;
        end
        `STORE: begin
            alu_op <= `FUNC_ADD;
        end
        `BRANCH: begin
            if(func3==`FUNCT3_BEQ)//if equal result zero
                alu_op <= `FUNC_XOR;
            else if(func3 == `FUNCT3_BNE)//
                alu_op <= `FUNC_XNOR;//can make xnor on my own cuz no xnor instruction defined.
            else if(func3 == `FUNCT3_BLT)//
                alu_op <= `FUNC_NGREAT;
            else if(func3 == `FUNCT3_BGE)//
                alu_op <= `FUNC_GREAT;
        end 
        `JAL: begin
            alu_op <= `FUNC_ZERO;
        end
        `ECALL: begin
            alu_op <= `FUNC_ZERO; //not perfectly definded. 
        end
        default:begin
        end
    endcase
end
endmodule