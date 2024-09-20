module MuxC2( 
  input [15:0] SEXT6,
  input [15:0] SEXT9,
  input [15:0] SEXT11,
  input [1:0] control,
  output reg [15:0] Out
);
  
  always @(*) begin
    if(control == 2'b00)
      Out = 16'h0000;
    if(control == 2'b01)
      Out = SEXT6;
    if(control == 2'b10)
      Out = SEXT9;
    if(control == 2'b11)
      Out = SEXT11;
  end
endmodule