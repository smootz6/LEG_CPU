module PC(
      input clk, rst,
      input [1:0] PCSel,
      input [31:0] PCIn,
      output logic [31:0] PCOut = 0,
      output logic [31:0] PC4
   );

   always_ff @(posedge clk or posedge rst) begin
      if (rst) PCOut <= 0;
      else case (PCSel)
         0: PCOut <= PCOut;
         1: PCOut <= PCOut + 4;
         2: PCOut <= PCIn;
         3: PCOut <= PCOut + PCIn * 4 + 4;
      endcase
      
   end
   always_comb PC4 = PCOut + 4;
endmodule
