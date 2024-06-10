module SEXT6(
  input [5:0] data,
  output reg [15:0] datout
);
  
  always @(data) begin
    if(data[5] == 1'b1)begin
      datout = 16'b1111111111111111;
      datout[5:0] = data[5:0];     
    end else begin
      datout[5:0] = data[5:0];
      datout[15:6] = 10'b0;
   	 end
  end
endmodule