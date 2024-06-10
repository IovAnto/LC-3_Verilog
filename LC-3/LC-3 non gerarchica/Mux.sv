module Mux(
  input [15:0] Data1,
  input [15:0] Data2,
  input control,
  output reg [15:0] DataOut
);
  
  always @(*)begin
    if(control == 1'b0)begin
    	DataOut = Data1;
    end else begin
    	DataOut = Data2;
    end
  end
endmodule