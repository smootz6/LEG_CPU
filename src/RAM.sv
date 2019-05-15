module RAM#(
      parameter DATA_WIDTH = 64,
      parameter ADDR_WIDTH = 12,
      parameter RAM_DEPTH = 1 << ADDR_WIDTH
   )(
      input clk, write,
      input [ADDR_WIDTH - 1:0] address,
      input [DATA_WIDTH - 1:0] writeData,
      output logic [DATA_WIDTH - 1:0] readData
   );
   logic [DATA_WIDTH - 1:0] mem[0:RAM_DEPTH - 1] = '{default:0};
   always_ff @(posedge clk) begin
      if (write) mem[address] = writeData;
   end
   always_ff @(posedge clk) begin
      readData <= mem[address];
   end
endmodule
