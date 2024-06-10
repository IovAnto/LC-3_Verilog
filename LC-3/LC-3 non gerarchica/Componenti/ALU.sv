module ALU(
  input [15:0] data1,
  input [15:0] data2,
  input [1:0] operazione,
  output reg [15:0] risultato
);

always @(*) begin
    case (operazione)
        2'b00: risultato = data1 + data2;
        2'b01: risultato = data1 & data2;
        2'b10: risultato = ~data1 + 1;
    endcase
end

endmodule

 
