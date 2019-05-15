module ALU(
      input [4:0] ALUCtl,
      input [63:0] Ain, Bin,
      input carryIn,
      output logic [63:0] ALUOut,
      output logic [3:0] status
   );
   logic [63:0] A, B;
   logic [64:0] sum;

   always_comb begin
      A = ALUCtl[1] ? ~Ain : Ain;
      B = ALUCtl[0] ? ~Bin : Bin;
      sum = A + B + carryIn;
      case (ALUCtl[4:2])
         0: ALUOut = A & B;
         1: ALUOut = A | B;
         2: ALUOut = sum[63:0];
         3: ALUOut = A ^ B;
         4: ALUOut = Ain << Bin[5:0];
         5: ALUOut = Ain >> Bin[5:0]; 
         6: ALUOut = $signed(Ain) >>> Bin[5:0];
         default: ALUOut = 0;
      endcase
      status = {~(A[63] ^ B[63]) & (ALUOut[63] ^ A[63]),
            sum[64], ALUOut[63], ALUOut == 0};
   end
endmodule
