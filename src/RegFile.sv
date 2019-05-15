module RegFile#(
      parameter DATA_WIDTH = 64,
      parameter ADDR_WIDTH = 5,
      parameter REG_DEPTH = 1 << ADDR_WIDTH
   )(
      input rst, clk, write,
      input [ADDR_WIDTH - 1:0] writeReg, readRegA, readRegB,
      input [DATA_WIDTH - 1:0] writeData,
      output logic [DATA_WIDTH - 1:0] readDataA, readDataB,
      output logic [15:0] r0, r1, r2, r3, r4, r5, r6, r7
   );
   logic [DATA_WIDTH - 1:0] regs[0:REG_DEPTH - 1] = '{default:0};

   always_ff @(posedge clk or posedge rst) begin
      if (rst)
         regs <= '{default:0};
      else if (write && writeReg != REG_DEPTH - 1)
         regs[writeReg] <= writeData;
   end

   always_comb begin
      readDataA = regs[readRegA];
      readDataB = regs[readRegB];
      r0 = regs[0];
      r1 = regs[1];
      r2 = regs[2];
      r3 = regs[3];
      r4 = regs[4];
      r5 = regs[5];
      r6 = regs[6];
      r7 = regs[7];
   end
endmodule
