`include "opcodes.v"

module ControlUnit(
   );
    
    assign is_jal = (part_of_inst == `JAL) ? 1'b1 : 1'b0;
    assign is_jalr = (part_of_inst == `JALR)? 1'b1 : 1'b0;
    assign branch = (part_of_inst == `BRANCH)? 1'b1 : 1'b0;
    assign mem_read = ( part_of_inst == `LOAD) ? 1'b1 : 1'b0;
    assign mem_to_reg = ( part_of_inst == `LOAD) ? 1'b1 : 1'b0;
    assign mem_write = ( part_of_inst == `STORE) ? 1'b1 : 1'b0;
    assign alu_src = ( part_of_inst == `ARITHMETIC_IMM ||
                        part_of_inst == `LOAD ||
                        part_of_inst == `STORE ||
                        part_of_inst == `JALR) ? 1'b1 : 1'b0;
    assign write_enable = ( part_of_inst == `LOAD ||
                            part_of_inst == `ARITHMETIC ||
                            part_of_inst == `ARITHMETIC_IMM||
                            part_of_inst == `JAL||
                            part_of_inst == `JALR)
                             ? 1'b1 : 1'b0;  
    assign pc_to_reg = ( part_of_inst == `JAL ||
                         part_of_inst == `JALR)
                             ? 1'b1 : 1'b0;     
endmodule