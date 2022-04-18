`include "opcodes.v"
module ImmediateGenerator(part_of_inst,
 imm_gen_out);
input [31:0] part_of_inst;
output reg [31:0] imm_gen_out;

//arithimm
//load 
//store 
always @(*) begin
case (part_of_inst[6:0])
    `ARITHMETIC_IMM: begin
        imm_gen_out[11:0] <= part_of_inst[31:20];
        imm_gen_out[31:12] <= (part_of_inst[31])?
                                        20'hfffff:
                                        20'h00000;
    end
    `LOAD: begin
        imm_gen_out[11:0] <= part_of_inst[31:20];
        imm_gen_out[31:12] <= (part_of_inst[31])?
                                        20'hfffff:
                                        20'h00000;
    end
    `STORE: begin
         imm_gen_out[4:0] <= part_of_inst[11:7];
         imm_gen_out[11:5] <= part_of_inst[31:25];
        imm_gen_out[31:12] <= (part_of_inst[31])?
                                        20'hfffff:
                                        20'h00000;
    end
    `JAL: begin
        imm_gen_out[0] <= 0;
         imm_gen_out[10:1] <= part_of_inst[30:21];
         imm_gen_out[11] <= part_of_inst[20];
         imm_gen_out[19:12] <= part_of_inst[19:12];
         imm_gen_out[20] <= part_of_inst[31];
        imm_gen_out[31:21] <= (part_of_inst[31])?
                                        20'h7ff:
                                        20'h000;
    end
    `JALR: begin
         imm_gen_out[11:0] <= part_of_inst[31:20];
        imm_gen_out[31:12] <= (part_of_inst[31])?
                                        20'hfffff:
                                        20'h00000;
    end
    `BRANCH: begin
         imm_gen_out[0] <= 0;
         imm_gen_out[10:5] <= part_of_inst[30:25];
         imm_gen_out[12] <= part_of_inst[31];
         imm_gen_out[4:1] <= part_of_inst[11:8];
         imm_gen_out[11] <= part_of_inst[7];
        imm_gen_out[31:13] <= (part_of_inst[31])?
                                        20'h7ffff:
                                        20'h00000;
    end
endcase
end
endmodule