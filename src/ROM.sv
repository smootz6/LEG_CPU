module ROM(
      input [31:0] address,
      output logic [31:0] out
   );
   // Use this code for a 32 bit wide rom file
   /*
   logic [31:0] mem[0:4095];
   initial $readmemb("C://(ROM file path)", mem);
   always_comb out = mem[address[31:2]];
   */
   
   // Use this code for a 64 bit wide rom file
   logic [63:0] mem64[0:2047];
   initial $readmemb("C://(ROM file path)", mem64);
   always_comb begin
      if (!address[2]) begin
         out = mem64[address[31:3]][31:0];
      end else begin
         out = mem64[address[31:3]][63:32];
      end
   end
endmodule
