module RegFile_tb();
   // create registers for holding the simulated input values to the DUT
   reg [4:0]SA, SB, DA;
   reg [63:0]D;
   reg W, reset, clock;
   // create wires for the output of the DUT
   wire [63:0]A, B;
   
   RegFile dut (.readDataA(A), .readDataB(B), .readRegA(SA), .readRegB(SB), .writeData(D), .writeReg(DA), .write(W), .rst(reset), .clk(clock));
   
   // give all inputs initial values
   initial begin
      D <= 0;
      SA <= 0;
      W <= 0;
      SB <= 0;
      DA <= 0;
      clock <= 1;
      reset <= 0;
      #20
      D <= 3;
      W <= 1;
      DA <= 2;
      #20
      D <= 4;
      DA <= 5;
      SB <= 2;
      W <= 0;
      #20
      W <= 1;
      DA <= 1;
      D <= 10;
      SA <= 2;
      SB <= 31;
      #20
      SB <= 1;
      SA <= 5;
      #20
      $stop; 
   end
   
   //simulate clock with period of 10 ticks
   always
      #5 clock <= ~clock;
   wire [63:0] regs[0:31];
   assign regs = dut.regs;
   /*   
   // every 10 ticks generate random data and increment SA, SB, and DA
   always begin
      #5 D <= {$random, $random}; // $random is a system command that generates a 32 random number
      DA <= DA + 5'b1;
      SA <= SA + 5'b1;
      SB <= SB + 5'b1;
      #5 ;
   end*/
   /*
   // create wires for each register in the dut then connect them accordingly so they
   // show up on the wave view in ModelSim automatically
   wire [63:0]R00, R01, R02, R03, R04, R05, R06, R07, R08, R09;
   wire [63:0]R10, R11, R12, R13, R14, R15, R16, R17, R18, R19;
   wire [63:0]R20, R21, R22, R23, R24, R25, R26, R27, R28, R29;
   wire [63:0]R30, R31;
   
   assign R00 = dut.regs[0];
   assign R01 = dut.regs[1];
   assign R02 = dut.regs[2];
   assign R03 = dut.regs[3];
   assign R04 = dut.regs[4];
   assign R05 = dut.regs[5];
   assign R06 = dut.regs[6];
   assign R07 = dut.regs[7];
   assign R08 = dut.regs[8];
   assign R09 = dut.regs[9];
   assign R10 = dut.regs[10];
   assign R11 = dut.regs[11];
   assign R12 = dut.regs[12];
   assign R13 = dut.regs[13];
   assign R14 = dut.regs[14];
   assign R15 = dut.regs[15];
   assign R16 = dut.regs[16];
   assign R17 = dut.regs[17];
   assign R18 = dut.regs[18];
   assign R19 = dut.regs[19];
   assign R20 = dut.regs[20];
   assign R21 = dut.regs[21];
   assign R22 = dut.regs[22];
   assign R23 = dut.regs[23];
   assign R24 = dut.regs[24];
   assign R25 = dut.regs[25];
   assign R26 = dut.regs[26];
   assign R27 = dut.regs[27];
   assign R28 = dut.regs[28];
   assign R29 = dut.regs[29];
   assign R30 = dut.regs[30];
   assign R31 = 0;
   */
endmodule
