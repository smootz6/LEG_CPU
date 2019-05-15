module DataPath(
   input Clk, Rst,
   input [29:0] CtrlWord,
   input [63:0] K,
   output logic [3:0] Flags = 0,
   output logic [3:0] Status,
   output logic [31:0] Instruction,

   input SCLK,
   output CS,
   output MOSI,
   input MISO,

   input [9:0] SW,
   input [2:0] BUTTON,

   output [6:0] HEX0,
   output [6:0] HEX1,
   output [6:0] HEX2,
   output [6:0] HEX3,

   output [15:0] r0, r1, r2, r3, r4, r5, r6, r7
   );

   logic [63:0] SpiReg, SWReg, BUTTONReg;
   logic [11:0] vOut;
   logic [11:0] HexIn = 0;


   logic PCSrc, ALUSrc, ALUCarryIn,
      MemWrite, RegWrite, SetFlags;
   logic [1:0] PCSel, DataSrc;
   logic [4:0] ALUSel, RegAddrIn, 
      RegAddrA, RegAddrB;
   logic [31:0] PCOut, PCPlus4;
   logic [63:0] Data, RegDataA,
      RegDataB, ALUOut, MemData;

   always_comb begin
      {SetFlags, PCSel, PCSrc, 
      DataSrc, ALUSrc, ALUSel, 
      ALUCarryIn, MemWrite, RegWrite, 
      RegAddrIn, RegAddrA, RegAddrB}
      = CtrlWord;
      case (DataSrc)
         0: Data = ALUOut;
         1: Data = RegDataB;
         2: Data = PCPlus4;
         3: begin
            if (ALUOut[11:0] == 4094)
               Data = SpiReg;
            else if (ALUOut[11:0] == 4093)
               Data = SWReg;
            else if (ALUOut[11:0] == 4092)
               Data = BUTTONReg;
            else
               Data = MemData;
         end
      endcase
   end

   RegFile regs (
      .rst(Rst), 
      .clk(Clk), 
      .write(RegWrite), 
      .writeReg(RegAddrIn), 
      .readRegA(RegAddrA), 
      .readRegB(RegAddrB), 
      .writeData(Data), 
      .readDataA(RegDataA),
      .readDataB(RegDataB),
      .r0(r0),
      .r1(r1),
      .r2(r2),
      .r3(r3),
      .r4(r4),
      .r5(r5),
      .r6(r6),
      .r7(r7)
   );

   ALU alu (
      .ALUCtl(ALUSel), 
      .Ain(RegDataA), 
      .Bin(ALUSrc ? K : RegDataB), 
      .carryIn(ALUCarryIn),
      .ALUOut(ALUOut), 
      .status(Status)
   );

   always_ff @(posedge Clk) begin
      if (SetFlags) Flags <= Status;
   end

   RAM ram (
      .clk(Clk),
      .write(MemWrite && ALUOut[11:0] <= 4091),
      .address(ALUOut[11:0]),
      .writeData(Data),
      .readData(MemData)
   );

   PC pc (
      .clk(Clk),
      .rst(Rst),
      .PCSel(PCSel),
      .PCIn(PCSrc ? K[31:0] : RegDataA[31:0]),
      .PCOut(PCOut),
      .PC4(PCPlus4)
   );

   ROM rom (
      .address(PCOut),
      .out(Instruction)
   );

   always_comb begin
      SpiReg = vOut;
      SWReg = SW[9:0];
      BUTTONReg = BUTTON[2:0];
   end
   SPI_Driver spi( 
      .vOut(vOut), 
      .SCLK(SCLK), 
      .CS(CS), 
      .MOSI(MOSI), 
      .MISO(MISO)
   );

   always_ff @(posedge Clk) begin
      if (ALUOut[11:0] == 4095 && MemWrite) begin
         HexIn <= Data[11:0];
      end
   end
   binary_to_hex hex(
      .in(HexIn),
      .HEX3(HEX3),
      .HEX2(HEX2),
      .HEX1(HEX1),
      .HEX0(HEX0)
   );
endmodule
