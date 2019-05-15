module binary_to_hex (
      input [11:0] in,
      output [6:0] HEX3, HEX2, HEX1, HEX0
   );
   
   logic [3:0] bcd3, bcd2, bcd1, bcd0;
   bianary_to_bcd u0 (in, bcd3, bcd2, bcd1, bcd0);
   hex_to_seven_seg u1 (bcd3, HEX3);
   hex_to_seven_seg u2 (bcd2, HEX2);
   hex_to_seven_seg u3 (bcd1, HEX1);
   hex_to_seven_seg u4 (bcd0, HEX0);
endmodule

module bianary_to_bcd (in, out3, out2, out1, out0);
   input [11:0] in;
   output reg [3:0] out3, out2, out1, out0;
   
   reg [27:0] shift;
   integer i;
   always_comb begin
       shift[27:12] = 0;
       shift[11:0] = in;
       for (i=0; i<12; i=i+1)
       begin
           if (shift[15:12] >= 5)
               shift[15:12] = shift[15:12] + 3;
           if (shift[19:16] >= 5)
               shift[19:16] = shift[19:16] + 3;
           if (shift[23:20] >= 5)
               shift[23:20] = shift[23:20] + 3;
           if (shift[27:24] >= 5)
               shift[27:24] = shift[27:24] + 3;
           shift = shift << 1;
       end
       out0 = shift[15:12];
       out1 = shift[19:16];
		 out2 = shift[23:20];
		 out3 = shift[27:24];
   end
endmodule

module hex_to_seven_seg(in, sevenSeg);
	input [3:0]in;
	output logic [6:0]sevenSeg;
   logic [6:0] out;
	
	always_comb begin
		case (in)
			// WXYZ            GFEDCBA
			4'b0000: out <= 7'b0111111;
			4'b0001: out <= 7'b0000110;
			4'b0010: out <= 7'b1011011;
			4'b0011: out <= 7'b1001111;
			4'b0100: out <= 7'b1100110;
			4'b0101: out <= 7'b1101101;
			4'b0110: out <= 7'b1111101;
			4'b0111: out <= 7'b0000111;
			4'b1000: out <= 7'b1111111;
			4'b1001: out <= 7'b1100111;
         default: out <= 'x;
		endcase
      sevenSeg = ~out;
	end
endmodule
