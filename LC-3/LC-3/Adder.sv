module Adder(
  input [15:0] data1,
  input [15:0] data2,
  output reg [15:0] dataOut
);
  
  always @(*) begin
  	dataOut = data1 + data2;
  end
endmodule