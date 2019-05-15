module DataPath_tb();
   logic clk;
   
   DataPath dut (.CLOCK_50(clk));
   
   initial begin
   clk <= 0;
	#2000 $stop;
   end
   
   always begin
      #5 clk <= ~clk;
   end
   
   wire [31:0] PC;
   assign PC = dut.PCOut;
   wire [31:0] ROMOut;
   assign ROMOut = dut.ROMOut;
   wire [63:0] regs[0:31];
   assign regs = dut.u1.regs;
   wire [63:0] mem[0:4095];
   assign mem = dut.u3.mem;
	wire [29:0] CtrlWord;
	assign CtrlWord = dut.CtrlWord;
   wire [63:0] K;
   assign K = dut.K;
   wire [3:0] Flags;
   assign Flags = dut.Flags;
   wire [3:0] EXState;
   assign EXState = dut.u6.EXState;
   wire fetch;
   assign fetch = dut.u6.fetch;
  
endmodule
