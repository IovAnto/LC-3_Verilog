module RegFile (
  input clock,
  input [2:0] DR,
  input [2:0] SR1,
  input [2:0] SR2,
  input ld_reg,
  input [15:0] data,
  output reg [15:0] SR1out,
  output reg [15:0] SR2out,
  output reg [15:0] R0
);

  reg [15:0] memory[0:7];
   
  initial begin //inizializzara i registi se si deve
  end
  
  always @(posedge clock) begin
    R0 <= memory[0];
  end
    
  always @(SR1 or SR2) begin
    SR1out = memory[SR1];
    SR2out = memory[SR2];
  end
  
  always @(posedge ld_reg) begin
    #10;
    memory[DR] = data;
    $display("carica? %b %b %b", memory[DR], data, DR);
    #10;
  end

endmodule
