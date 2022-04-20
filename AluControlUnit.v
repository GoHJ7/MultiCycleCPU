`include "opcodes.v"

module ALUControlUnit(part_of_inst,
alu_op,
ALUOp);
input [3:0] part_of_inst;
input [1:0] ALUOp;
output reg [3:0] alu_op;
//wire
wire [2:0]func3;
wire sign;
assign func3 = part_of_inst[2:0];
assign sign = part_of_inst[3];

//control
always @ (*) begin
    case (ALUOp)
        2'b00: begin
            alu_op <= `FUNC_ADD;
        end
        2'b01: begin//arithmetic
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
            else
                alu_op <= `FUNC_ADD;
        end
        2'b10: begin//branch
            if(func3==`FUNCT3_BEQ)//if equal result zero
                alu_op <= `FUNC_XOR;
            else if(func3 == `FUNCT3_BNE)//
                alu_op <= `FUNC_XNOR;//can make xnor on my own cuz no xnor instruction defined.
            else if(func3 == `FUNCT3_BLT)//
                alu_op <= `FUNC_NGREAT;
            else if(func3 == `FUNCT3_BGE)//
                alu_op <= `FUNC_GREAT;
        end
        2'b11: begin//arithmeticIMM
            if(func3==`FUNCT3_ADD && sign == 1'b0 )//add
                alu_op <= `FUNC_ADD;
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
            else
                alu_op <= `FUNC_ADD;
        end
        default:begin
        end
    endcase
end
endmodule