module ZEXT(
  input [5:0] data,
  output reg [15:0] datout
);
  
  always @(data) begin
      datout[15:6] = 16'b0000000000000000;
      datout[5:0] = data[5:0];
   	 end
endmodule