module SEXT11(
  input [10:0] data,
  output reg [15:0] datout
);
  
  always @(data) begin
    if(data[10] == 1'b1)begin
      datout = 16'b1111111111111111;
      datout[10:0] = data[10:0];     
    end else begin
      datout[10:0] = data[10:0];
      datout[15:11] = 5'b0;
   	 end
  end
endmodule