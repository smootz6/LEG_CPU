module ROM_tb();
   logic clk;
   logic load;
   logic [31:0] address;
   logic [31:0] out;
   ROM dut (.address(address), .out(out));
   initial begin
      clk = 1;
      address = 0;
      #100 $stop;
   end
   always #10 address = address + 4;
   always #5 clk = ~clk;
   wire [31:0] mem[0:4095];
   assign mem = dut.mem;
endmodule
