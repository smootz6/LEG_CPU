module SPI_Test(
      input CLOCK_50,
      inout [3:0] GPIO0_D,
      output [6:0] HEX0, HEX1, HEX2, HEX3,
      output HEX3_DP
   );
   logic SCLK = 0;
   logic CS, MOSI, MISO;
   logic [11:0] voltage = 0;
   logic [9:0] vOut;
   assign GPIO0_D[3:1] = {SCLK, CS, MOSI};
   assign MISO = GPIO0_D[0];
   assign HEX3_DP = 0;

   logic [31:0] count = 0;
   always @(posedge CLOCK_50) begin
      count <= count + 1;
      if(count >= 24) begin
         count <= 0;
         SCLK <= ~SCLK;
      end
   end

   /*always_ff @(posedge CLOCK_50) begin
      if (CS) begin
         voltage = (vOut * 3300 / 1023);
      end
   end*/

   SPI_Driver spi( 
      .vOut(voltage), 
      .SCLK(SCLK), 
      .CS(CS), 
      .MOSI(MOSI), 
      .MISO(MISO)
   );

   binary_to_hex u0 (voltage, HEX3, HEX2, HEX1, HEX0);
endmodule

