module PC(reset,
clk, 
next_pc,
current_pc,
pc_sig
);
    input clk,reset,pc_sig;
    input [31:0] next_pc;
    output reg [31:0] current_pc;
    always @(posedge reset or posedge clk) begin
		if (reset)
			current_pc <= 32'h00000000;//start address
		else if(pc_sig)begin
			current_pc <= next_pc;
        end
        else begin
        end

    end
endmodule  