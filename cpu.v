// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify the module.
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required
`include "Alu.v"
`include "AluControlUnit.v"
`include "ImmediateGenerator.v"
`include "Memory.v"
`include "Mux2.v"
`include "Mux4.v"
`include "opcodes.v"
`include "Pc.v"
`include "RegisterFile.v"
`include "Muxecall.v"
module CPU(input reset,       // positive reset signal
           input clk,         // clock signal
           output is_halted); // Whehther to finish simulation
  /***** Wire declarations *****/
  wire [31:0] next_pc;
  wire [31:0] current_pc;
  wire ALUsrcA;
  wire IorD;
  wire IRWrite;
  wire PCsource;
  wire PCWrite;
  wire PCWriteNotCond;
  wire [1:0] ALUSrcB;
  wire RegWrite;
  wire MemRead;
  wire Memwrite;
  wire MemtoReg;
  wire [1:0] ALUOp;
  reg [3:0] statereg;
  wire S3, S2, S1, S0, N3, N2, N1, N0;
  wire [31:0] rs1_dout,rs2_dout;
  wire [31:0] MemData;
  wire [31:0] alu_result;
  wire [31:0] imm_gen_out;
  wire bcond;
  wire is_ecall;
  /***** Register declarations *****/
  reg [31:0] IR; // instruction register
  reg [31:0] MDR; // memory data register
  reg [31:0] A; // Read 1 data register
  reg [31:0] B; // Read 2 data register
  reg [31:0] ALUOut; // ALU output register
  // Do not modify and use registers declared above.
  //reg update
  always @(posedge clk) begin
    if(reset)begin
    IR<=32'b0;
    MDR<=32'b0;
    A<=32'b0;
    B<=32'b0;
    ALUOut<=32'b0;
    end
    //IR
    else begin
    if(IRWrite)begin
      IR <= MemData;
      //$display("instruction fetch: %h",IR);
    end
    else begin
    end
    //MDR
    MDR <= MemData;
    //A
    A <= rs1_dout;
    //B
    B <= rs2_dout;
    //ALUOUT
    ALUOut <= alu_result;
    end
  end
  //mux
  wire [31:0] mux1out;
  Mux2 mux1(
    .signal(IorD),
    .sig1(ALUOut),
    .sig0(current_pc),
    .out(mux1out)
  );
  wire [31:0] mux2out;
  Mux2 mux2(
    .signal(ALUsrcA),
    .sig1(A),
    .sig0(current_pc),
    .out(mux2out)
  );
  wire[31:0] mux3out;
  Mux2 mux3(
    .signal(MemtoReg),
    .sig1(MDR),
    .sig0(ALUOut),
    .out(mux3out)
  );
  wire [31:0] mux4out;
  Mux4 mux4(
    .signal(ALUSrcB),
    .sig3(32'b1010),
    .sig2(imm_gen_out),
    .sig1(32'b100),
    .sig0(B),
    .out(mux4out)
  );
  Mux2 mux5(
    .signal(PCsource),
    .sig1(ALUOut),
    .sig0(alu_result),
    .out(next_pc)
  );
  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  wire bcond_and_PCWNC,PCW_or_BAPCWNC;
  assign bcond_and_PCWNC = (bcond? 0: 1) & PCWriteNotCond;
  assign PCW_or_BAPCWNC = PCWrite | bcond_and_PCWNC;
  PC pc(
    .reset(reset),       // input (Use reset to initialize PC. Initial value must be 0)
    .clk(clk),         // input
    .next_pc(next_pc),     // input
    .current_pc(current_pc),   // output
    .pc_sig(PCW_or_BAPCWNC)
  );

  // ---------- Register File ----------
  wire [4:0] readreg1;
  Muxecall muxecall(
    .signal(is_ecall),
    .sig1(5'b10001),
    .sig0(IR[19:15]),
    .out(readreg1)
  );
 
  RegisterFile reg_file(
    .reset(reset),        // input
    .clk(clk),          // input
    .rs1(readreg1),          // input
    .rs2(IR[24:20]),          // input
    .rd(IR[11:7]),           // input
    .rd_din(mux3out),       // input
    .write_enable(RegWrite),    // input
    .rs1_dout(rs1_dout),     // output
    .rs2_dout(rs2_dout)   // output
  );

  // ---------- Memory ----------
  
  Memory memory(
    .reset(reset),        // input
    .clk(clk),          // input
    .addr(mux1out),         // input
    .din(B),          // input write data
    .mem_read(MemRead),     // input
    .mem_write(Memwrite),    // input
    .dout(MemData)          // output
  );

  // ---------- Control Unit ----------
  
  always @(posedge clk) begin
      if(reset)begin
      statereg<=4'b0;
      end
      else begin
      statereg[0] <= N0;
      statereg[1] <= N1;
      statereg[2] <= N2;
      statereg[3] <= N3;
      end
  end
  assign S0 = statereg[0];
  assign S1 = statereg[1];
  assign S2 = statereg[2];
  assign S3 = statereg[3];

   //assign is_halted = (is_ecall && (rs1_dout == 32'b1010)? 1 :0) ? 1 : 0;
  wire is_fhalted;
  assign is_halted = is_fhalted;
  ControlUnit ctrl_unit(
    .Op(IR[6:0]),  // input
    .ALUsrcA(ALUsrcA),        // output
    .IorD(IorD),       // output
    .IRWrite(IRWrite),        // output
    .PCsource(PCsource),      // output 
    .PCWrite(PCWrite),    // output
    .PCWriteNotCond(PCWriteNotCond),     // output
    .ALUSrcB(ALUSrcB),       // output [1:0]
    .RegWrite(RegWrite),     // output
    .MemRead(MemRead),     // output
    .Memwrite(Memwrite),    // output 
    .MemtoReg(MemtoReg),//output
    .ALUOp(ALUOp),       // output 
    .S3(S3), .S2(S2), .S1(S1), .S0(S0), .N3(N3), .N2(N2), .N1(N1), .N0(N0),
    .is_halted(is_ecall),
    .bcond(bcond),
    .is_fhalted(is_fhalted)
  );

  // ---------- Immediate Generator ----------
  
  ImmediateGenerator imm_gen(
    .part_of_inst(IR),  // input
    .imm_gen_out(imm_gen_out)    // output
  );

  // ---------- ALU Control Unit ----------
  wire [3:0] alu_part_of_inst,alu_op;
  assign alu_part_of_inst = {IR[30],IR[14:12]};
  ALUControlUnit alu_ctrl_unit(
    .part_of_inst(alu_part_of_inst),  // input
    .alu_op(alu_op),         // output [3:0]
    .ALUOp(ALUOp)//input [1:0]
  );

  // ---------- ALU ----------
  
  ALU alu(
    .alu_op(alu_op),      // input
    .alu_in_1(mux2out),    // input  
    .alu_in_2(mux4out),    // input
    .alu_result(alu_result),  // output
    .alu_bcond(bcond)     // output
  );

endmodule
