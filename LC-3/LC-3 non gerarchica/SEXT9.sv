module SEXT9(
  input [8:0] data,
  output reg [15:0] datout
);
  
  always @(data) begin
    if(data[8] == 1'b1)begin
      datout = 16'b1111111111111111;
      datout[8:0] = data[8:0];     
    end else begin
      datout[8:0] = data[8:0];
      datout[15:9] = 6'b0;
   	 end
  end
endmodule