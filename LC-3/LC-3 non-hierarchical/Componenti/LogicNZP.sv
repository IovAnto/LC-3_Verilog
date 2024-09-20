module Logic(
  input [15:0] data,
  output reg N,
  output reg Z,
  output reg P
);
  
  always @(data) begin
    if(data[15] == 1'b1) begin
      N = 1'b1;
      P = 1'b0;
    end else begin
      N = 1'b0;
      P = 1'b1;
    end
    if(data == 16'b0000000000000000)begin
      Z = 1'b1;
      P = 1'b0;
      end else begin
      Z = 1'b0;
   	  end
  end
endmodule