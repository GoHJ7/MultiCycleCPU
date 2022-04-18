`include "opcodes.v"
module ALU(alu_op,
alu_in_1,
alu_in_2,
alu_result,
alu_bcond
);


parameter data_width = 32;
input [data_width - 1 : 0] alu_in_1;
input [data_width - 1 : 0] alu_in_2;
input [3:0] alu_op;
output reg [data_width - 1 : 0] alu_result;
output alu_bcond;

assign alu_bcond = (alu_result == 0);

always @ (*) begin
    
    case (alu_op)
        `FUNC_ADD:begin
            //$display ("add");
            alu_result <= alu_in_1 + alu_in_2;
        end
        `FUNC_SUB:begin
           // $display ("sub");
            alu_result <= alu_in_1 - alu_in_2;
        end
        `FUNC_LLS:begin
           // $display ("lls");
            alu_result <= alu_in_1 << alu_in_2;
        end
        `FUNC_XOR:begin
           // $display ("xor");
            alu_result <= alu_in_1 ^ alu_in_2;
        end
         `FUNC_XNOR:begin
           // $display( ("xnor");
            alu_result <= (alu_in_1 == alu_in_2) ? 32'b1 : 32'b1;
        end
        `FUNC_OR:begin
           // $display ("or");
            alu_result <= alu_in_1 | alu_in_2;
        end
        `FUNC_AND:begin
           // $display ("and");
            alu_result <= alu_in_1 & alu_in_2;
        end
        `FUNC_LRS:begin
           // $display ("lrs");
            alu_result <= alu_in_1 >> alu_in_2;
        end
        `FUNC_GREAT:begin
           // $display ("lrs");
            alu_result <= (alu_in_1 >= alu_in_2)? 32'b0:32'b1;
        end
        `FUNC_NGREAT:begin
           // $display ("lrs");
            alu_result <= (alu_in_1 < alu_in_2)? 32'b0:32'b1;
        end
        `FUNC_ZERO:begin
            //$display ("load, store, jal, jalr,branch, ecall");
            alu_result <= 32'b0;
        end
        default:begin
        end
    endcase
   // $display ("alu_in_1: %d, ",alu_in_1);
   // $display ("alu_in_2: %d, ",alu_in_2);

end


endmodule
