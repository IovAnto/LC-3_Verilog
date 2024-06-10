module Gate(
  input [15:0] PC,
  input [15:0] MARMUX,
  input [15:0] MDR,
  input [15:0] ALU,
  input [1:0] control,
  output reg [15:0] BUS
);
  
  
  always @(*) begin
    case (control)
      2'b00: begin
        BUS = PC;
      end
      2'b01: begin
        BUS = ALU;
      end
      2'b10: begin
        BUS = MDR;
      end
      2'b11: begin
        BUS = MARMUX;
      end
    endcase
  end

endmodule
