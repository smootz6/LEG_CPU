module SPI_Driver_tb ();
   reg getV;
   reg SCLK;
   reg MISO;
   reg CLK2;
   wire [9:0] v;
   wire CS, vReady;
   wire MOSI;

   SPI_Driver dut(getV, vReady, v, SCLK, CS, MOSI, MISO);

   initial begin
      getV = 0;
      SCLK = 0;
      CLK2 = 0;
      MISO = 1;
      #5 getV = 1;
   end

   logic [31:0] count = 0;
   always @(posedge SCLK) begin
      count <= count + 1;
      if(count >= 3) begin
         count <= 0;
         CLK2 <= ~CLK2;
      end
   end

   always begin
      #5 SCLK = ~SCLK;
   end
endmodule
