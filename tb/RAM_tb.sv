module RAM_tb();
   reg clock, chip_select, write_enable, output_enable;
   wire [63:0] data_out;
   reg [63:0] data_in;
   reg [11:0] address;
      
   wire [63:0] mem0, mem24, mem25, mem257;

   RAM dut (
    .clk(clock)        , // Clock Input
    .addr(address)  , // Address Input
    .data_in(data_in)        , // Data bi-directional
    .data_out(data_out),
    .cs(chip_select)   , // Chip Select
    .we(write_enable)  , // Write Enable/Read Enable
    .oe(output_enable)   // Output Enable
    );
   defparam dut.DATA_WIDTH = 64;
   defparam dut.ADDR_WIDTH = 12;
    
    assign mem0 = dut.mem[0];
    assign mem24 = dut.mem[24];
    assign mem25 = dut.mem[25];
    assign mem257 = dut.mem[257];
    
    initial begin
      clock <= 1'b0;
      chip_select <= 1'b0;
      write_enable <= 1'b0;
      output_enable <= 1'b0;
      address <= 12'h0;
      data_in <= 64'hA5;
   end
   
   always
      #5 clock <= ~clock;
      
   always begin
      #10 write_enable <= 1'b1; // should do nothing
      #10 chip_select <= 1'b1; // M[0] <= A5
      #10 address <= 12'h018; 
      data_in <= 64'h1234; // M[24] <= 1234
      #10 write_enable <= 1'b0; // should do nothing
      #10 address <= 12'h019; // should do nothing
      #10 output_enable <= 1'b1; // should output nothing
      #10 address <= 12'h018; // data <= M[24] (1234)
      #10 address <= 12'h0; // data <= M[0] (A5)
      #10 chip_select <= 1'b0; // should do nothing
      #10 chip_select <= 1'b1;
      write_enable <= 1'b1;
      data_in <= 64'h123456789AB;
      address <= 12'h101; // M[257] <= 123456789AB
      #10 write_enable <= 1'b0;
      output_enable <= 1'b1;
      address <= 12'h0; // data <= M[0]
      #10 address <= 12'h101; // data <= M[257]
      #10 $stop;
   end
   
endmodule
