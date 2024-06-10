module SEXT5(
  input [4:0] data,
  output reg [15:0] datout
);
  
  always @(data) begin
    if(data[4] == 1'b1)begin
      datout = 16'b1111111111111111;
      datout[4:0] = data[4:0];     
    end else begin
      datout[4:0] = data[4:0];
      datout[15:5] = 10'b0;
   	 end
  end
endmodule