module LEGv8Processor_tb();
   logic clk;

   LEGv8Processor_top dut (
      .CLOCK_50(clk)
   );

   initial begin
   clk <= 0;
   #2000 $stop;
   end

   always begin
      #5 clk <= ~clk;
   end

   wire [31:0] PC;
   assign PC = dut.path.PCOut;
   wire [31:0] ROMOut;
   assign ROMOut = dut.Instruction;
   wire [63:0] regs[0:31];
   assign regs = dut.path.regs.regs;
   wire [63:0] mem[0:4095];
   assign mem = dut.path.ram.mem;
   wire [29:0] CtrlWord;
   assign CtrlWord = dut.CtrlWord;
   wire [63:0] K;
   assign K = dut.K;
   wire [3:0] Flags;
   assign Flags = dut.Flags;
   wire [3:0] EXState;
   assign EXState = dut.ctrl.EXState;
   wire fetch;
   assign fetch = dut.ctrl.fetch;  
endmodule
