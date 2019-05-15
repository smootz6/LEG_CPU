module SPI_Driver (
      output logic [11:0] vOut,
      input SCLK,
      output logic CS = 1,
      output logic MOSI = 0,
      input MISO
   );

   logic [9:0] v;
   logic [31:0] inState = 0;
   logic [31:0] outState = 0;

   assign vOut = (v * 3300 / 1023);

   always_ff @(negedge SCLK) begin
      if (outState >= 0 && outState <= 1) begin
         CS <= 0;
         MOSI <= 1;
         outState <= outState + 1;
      end else if (outState >= 2 && outState <= 16) begin
         MOSI <= 0;
         outState <= outState + 1;
      end else if (outState == 17) begin
         CS <= 1;
         outState <= 0;
      end
   end

   always_ff @(posedge SCLK) begin
      if (outState == 8 && inState == 0) begin
         v[9] <= MISO;
         inState <= inState + 1;
      end else if (inState == 1) begin
         v[8] <= MISO;
         inState <= inState + 1;
      end else if (inState == 2) begin
         v[7] <= MISO;
         inState <= inState + 1;
      end else if (inState == 3) begin
         v[6] <= MISO;
         inState <= inState + 1;
      end else if (inState == 4) begin
         v[5] <= MISO;
         inState <= inState + 1;
      end else if (inState == 5) begin
         v[4] <= MISO;
         inState <= inState + 1;
      end else if (inState == 6) begin
         v[3] <= MISO;
         inState <= inState + 1;
      end else if (inState == 7) begin
         v[2] <= MISO;
         inState <= inState + 1;
      end else if (inState == 8) begin
         v[1] <= MISO;
         inState <= inState + 1;
      end else if (inState == 9) begin
         v[0] <= MISO;
         inState <= 0;
      end
   end
endmodule
