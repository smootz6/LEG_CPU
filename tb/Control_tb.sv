module Control_tb ();

   logic clk, rst;
   logic [31:0] in;
   logic [3:0] status, flags;
   wire [29:0] CtrlWord;
   wire [63:0] K;

   Control dut (clk, rst, in, status, flags, CtrlWord, K);

   initial begin
      clk = 0;
      rst = 0;
      status = 0;
      flags = 0;
      #5
      in = 32'b11010010100000000000000010100010;
      #20
      in = 32'b10010001000000000000100001000011;
      #30 $stop;
   end

   always begin
      #5 clk = ~clk;
   end

   wire [3:0] state;
   assign state = dut.EXState;
   wire fetch;
   assign fetch = dut.fetch;
endmodule
