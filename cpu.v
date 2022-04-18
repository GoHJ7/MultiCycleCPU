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
`include "opcodes.v"
`include "Pc.v"
`include "RegisterFile.v"

module CPU(input reset,       // positive reset signal
           input clk,         // clock signal
           output is_halted); // Whehther to finish simulation
  /***** Wire declarations *****/
  wire [31:0] next_pc;
  wire [31:0] current_pc;

  /***** Register declarations *****/
  reg [31:0] IR; // instruction register
  reg [31:0] MDR; // memory data register
  reg [31:0] A; // Read 1 data register
  reg [31:0] B; // Read 2 data register
  reg [31:0] ALUOut; // ALU output register
  // Do not modify and use registers declared above.

  //mux
  wire [31:0] mux1out;
  Mux2 mux1(
    .signal(IorD),
    .sig1(current_pc),
    .sig0(ALUOut),
    .out(mux1out)
  )
  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  PC pc(
    .reset(),       // input (Use reset to initialize PC. Initial value must be 0)
    .clk(),         // input
    .next_pc(),     // input
    .current_pc()   // output
  );

  // ---------- Register File ----------
  RegisterFile reg_file(
    .reset(),        // input
    .clk(),          // input
    .rs1(),          // input
    .rs2(),          // input
    .rd(),           // input
    .rd_din(),       // input
    .write_enable(),    // input
    .rs1_dout(),     // output
    .rs2_dout()      // output
  );

  // ---------- Memory ----------
  Memory memory(
    .reset(),        // input
    .clk(),          // input
    .addr(),         // input
    .din(),          // input
    .mem_read(),     // input
    .mem_write(),    // input
    .dout()          // output
  );

  // ---------- Control Unit ----------
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
  
  ControlUnit ctrl_unit(
    .Op(),  // input
    .ALUsrcA(),        // output
    .IorD(),       // output
    .IRWrite(),        // output
    .PCsource(),      // output
    .PCWrite(),    // output
    .PCWriteNotCond(),     // output
    .ALUSrcB(),       // output [1:0]
    .RegWrite(),     // output
    .MemRead(),     // output
    .Memwrite(),    // output 
    .MemtoReg()       // output 
  );

  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen(
    .part_of_inst(),  // input
    .imm_gen_out()    // output
  );

  // ---------- ALU Control Unit ----------
  ALUControlUnit alu_ctrl_unit(
    .part_of_inst(),  // input
    .alu_op()         // output
  );

  // ---------- ALU ----------
  ALU alu(
    .alu_op(),      // input
    .alu_in_1(),    // input  
    .alu_in_2(),    // input
    .alu_result(),  // output
    .alu_bcond()     // output
  );

endmodule
