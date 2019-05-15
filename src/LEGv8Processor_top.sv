module LEGv8Processor_top (
      input CLOCK_50,
      input [2:0] BUTTON,
      input [9:0] SW,
      inout [31:0] GPIO0_D,
                   //GPIO1_D,
      output [6:0] HEX0,
                   HEX1,
                   HEX2,
                   HEX3,
      output HEX3_DP
   );

   logic SCLK;
   logic CS, MOSI, MISO;
   assign GPIO0_D[3:1] = {SCLK, CS, MOSI};
   assign MISO = GPIO0_D[0];
   assign HEX3_DP = 0;

   logic c0, c1;
   logic locked;
   logic Clk;
   //assign Clk = CLOCK_50;
   wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

   PLL pll (
      .inclk0(CLOCK_50),
      .c0(c0),
      .c1(c1),
      .locked(locked)
   );

   always_comb begin
      if (locked) begin
         Clk = c0;
         SCLK = c1;
      end else begin
         Clk = 0;
         SCLK = 0;
      end
   end

   logic [29:0] CtrlWord;
   logic [63:0] K;
   logic [3:0] Flags, Status;
   logic [31:0] Instruction;

   Control ctrl (
      .clk(Clk),
      .rst(0),
      .in(Instruction),
      .flags(Flags),
      .status(Status),
      .CtrlWord(CtrlWord),
      .K(K));

   DataPath path (
      .Clk(Clk),
      .Rst(0),
      .CtrlWord(CtrlWord),
      .K(K),
      .Flags(Flags),
      .Status(Status),
      .Instruction(Instruction),
      .SCLK(SCLK),
      .CS(CS),
      .MOSI(MOSI),
      .MISO(MISO),
      .SW(SW),
      .BUTTON(~BUTTON),
      .HEX0(HEX0),
      .HEX1(HEX1),
      .HEX2(HEX2),
      .HEX3(HEX3),
      .r0(r0),
      .r1(r1),
      .r2(r2),
      .r3(r3),
      .r4(r4),
      .r5(r5),
      .r6(r6),
      .r7(r7)
   );
   /*
   GPIO_Board gpio (
      .clock_50(CLOCK_50),
      .R0(r0), 
      .R1(r1), 
      .R2(r2),
      .R3(r3),
      .R4(r4),
      .R5(r5), 
      .R6(r6), 
      .R7(r7),
      .GPIO_0(GPIO0_D),
      .GPIO_1(GPIO1_D)
   );
   */
endmodule
