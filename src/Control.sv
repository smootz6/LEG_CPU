module Control(
      input clk, rst,
      input [31:0] in,
      input [3:0] flags,
      input [3:0] status,
      output logic [29:0] CtrlWord,
      output logic [63:0] K
   );

   logic fetch;
   logic [3:0] EXState;
   logic [10:0] op;
   logic PCSrc, ALUSrc, ALUCarryIn,
         RAMWrite, RegWrite,
         SetFlags, V, C, N, Z;
   logic [1:0] PCSel, DataSrc;
   logic [4:0] ALUSel, RegAddrIn,
               RegAddrA, RegAddrB;
   initial begin
      PCSel = 0;
      RegWrite = 0;
      RAMWrite = 0;
      SetFlags = 0;
      fetch = 1;
   end

   always_comb begin
      op = in[31:21];
      CtrlWord = {SetFlags, PCSel, PCSrc,
      DataSrc, ALUSrc, ALUSel, ALUCarryIn, 
      RAMWrite, RegWrite, 
      RegAddrIn, RegAddrA, RegAddrB};
      {V, C, N, Z} = flags;
   end

   always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
         PCSel = 0;
         RegWrite = 0;
         RAMWrite = 0;
         SetFlags = 0;
         fetch <= 1;
      end
      else if (fetch) begin
            PCSel <= 0;
            RegWrite <= 0;
            RAMWrite <= 0;
            SetFlags <= 0;
            ALUCarryIn <= 0;
            EXState <= 0;
            fetch <= 0;
      end
      else begin
         if (op[5]) begin // All Branches
            case (op[10:8])
               3'b000: begin // B
                  PCSel <= 3;
                  PCSrc <= 1;
                  K <= 32'(signed'(in[25:0]));
                  fetch <= 1;
               end
               3'b010: begin // B.cond
                  bit branch;
                  case (in[3:0])
                     0:  branch = Z;
                     1:  branch = ~Z;
                     2:  branch = C;
                     3:  branch = ~C;
                     4:  branch = N;
                     5:  branch = ~N;
                     6:  branch = V;
                     7:  branch = ~V;
                     8:  branch = C & ~Z;
                     9:  branch = ~C | Z;
                     10: branch = ~(N ^ V);
                     11: branch = N ^ V;
                     12: branch = ~Z & ~(N ^ V);
                     13: branch = Z | (N ^ V);
                     14: branch = 1;
                     15: branch = 1;
                  endcase
                  if (branch) begin
                     PCSel <= 3;
                     PCSrc <= 1;
                     K <= 32'(signed'(in[23:5]));
                  end
                  else begin
                     PCSel <= 1;
                  end
                  fetch <= 1;
               end
               3'b100: begin // BL
                  PCSel <= 3;
                  PCSrc <= 1;
                  K <= 32'(signed'(in[25:0]));
                  DataSrc <= 2;
                  RegAddrIn <= 30;
                  RegWrite <= 1;
                  fetch <= 1;
               end
               3'b101: begin // CBZ/CBNZ
                  if (EXState == 0) begin
                     ALUSrc <= 0;
                     ALUSel <= 5'b00100;
                     RegAddrA <= 31;
                     RegAddrB <= in[4:0];
                     EXState <= 1;
                  end
                  else begin
                     if (op[3] & ~status[0] |
                           ~op[3] & status[0]) begin
                        PCSel <= 3;
                        PCSrc <= 1;
                        K <= 32'(signed'(in[23:5]));
                     end
                     else begin
                        PCSel <= 1;
                     end
                     fetch <= 1;
                  end
               end
               3'b110: begin // BR
                  RegAddrA <= in[9:5];
                  PCSrc <= 0;
                  PCSel <= 2;
                  fetch <= 1;
               end
            endcase
         end
         else begin // Everyting Else
            case (op[4:2])
               3'b000: begin // D format
                  if (EXState == 0) begin
                     RegAddrA <= in[9:5];
                     K <= in[20:12];
                     ALUSel <= 5'b01000;
                     ALUSrc <= 1;
                     EXState <= 1;
                     if (op[1]) begin // Load
                        DataSrc <= 3;
                        RegWrite <= 1;
                        RegAddrIn <= in[4:0];
                     end
                     else begin // Store
                        RAMWrite <= 1;
                        DataSrc <= 1;
                        RegAddrB <= in[4:0];
                     end
                  end
                  else begin
                     fetch <= 1;
                     PCSel <= 1;
                  end
               end
               3'b010: begin // I-arithmetic
                  PCSel <= 1;
                  DataSrc <= 0;
                  ALUSrc <= 1;
                  RegWrite <= 1;
                  RegAddrA <= in[9:5];
                  RegAddrIn <= in[4:0];
                  K <= in[21:10];
                  fetch <= 1;
                  if (op[9]) begin // Subtract
                     ALUSel <= 5'b01001;
                     ALUCarryIn <= 1;
                  end
                  else begin // Add
                     ALUSel <= 5'b01000;
                  end
                  SetFlags <= op[8]; // Set Flags
               end
               3'b100: begin // logic
                  RegAddrA <= in[9:5];
                  PCSel <= 1;
                  DataSrc <= 0;
                  RegWrite <= 1;
                  RegAddrIn <= in[4:0];
                  fetch <= 1;
                  case (op[9:8])
                     2'b00, 2'b11: begin // AND/ANDI
                     ALUSel <= 5'b00000;
                     end
                     2'b01: begin // ORR/ORRI
                     ALUSel <= 5'b00100;
                     end
                     2'b10: begin // EOR/EORI
                     ALUSel <= 5'b01100;
                     end
                  endcase
                  SetFlags <= (op[9:8] == 2'b11);
                  if (op[7]) begin // I Format
                     ALUSrc <= 1; 
                     K <= in[21:10];
                  end
                  else begin // R format
                     ALUSrc <= 0;
                     RegAddrB <= in[20:16];
                  end
               end
               3'b101: begin // IW
                  DataSrc <= 0;
                  ALUSrc <= 1;
                  RegWrite <= 1;
                  RegAddrIn <= in[4:0];
                  if (op[8]) begin // MOVK
                     if (EXState == 0) begin
                        PCSel <= 0;
                        ALUSel <= 5'b00001;
                        RegAddrA <= in[9:5];
                        K <= 16'hFFFF << in[22:21] * 16;
                        EXState <= 1;
                     end
                     else begin
                        PCSel <= 1;
                        ALUSel <= 5'b00100;
                        K <= in[20:5] << in[22:21] * 16;
                        fetch <= 1;
                     end
                  end
                  else begin // MOVZ/MOVN
                     PCSel <= 1;
                     RegAddrA <= 31;
                     K <= in[20:5] << in[22:21] * 16;
                     fetch <= 1;
                     if (op[9]) begin // MOVZ
                        ALUSel <= 5'b00100;
                     end
                     else begin // MOVN
                        ALUSel <= 5'b00101;
                     end
                  end
               end
               3'b110: begin // R-Arith/Shift
                  RegAddrA <= in[9:5];
                  PCSel <= 1;
                  DataSrc <= 0;
                  RegWrite <= 1;
                  fetch <= 1;
                  RegAddrIn <= in[4:0];
                  if (op[1]) begin // Shift
                     ALUSrc <= 1;
                     K <= in[15:10];
                     if (!op[9]) begin // ASR
                        ALUSel <= 5'b11000;
                     end
                     else if (op[0]) begin
                        ALUSel <= 5'b10000; // LSL
                     end
                     else begin
                        ALUSel <= 5'b10100; // LSR
                     end
                  end
                  else begin // R-Arithmetic
                     ALUSrc <= 0;
                     RegAddrB <= in[20:16];
                     if (op[9]) begin // Subtract
                        ALUSel <= 5'b01001;
                        ALUCarryIn <= 1;
                     end
                     else begin // Add
                        ALUSel <= 5'b01000;
                     end
                     SetFlags <= op[8]; // Set Flags
                  end
               end
            endcase
         end
      end
   end
endmodule
