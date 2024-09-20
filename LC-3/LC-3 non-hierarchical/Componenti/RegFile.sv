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
   
  initial begin
    memory[0] = 16'b0000000000000000;
    memory[1] = 16'b0000000000000000;
    memory[2] = 16'b0000000000000000;
    memory[3] = 16'b0000000000000000;
    memory[4] = 16'b0000000000000000;
    memory[5] = 16'b0000000000000000;
    memory[6] = 16'b0000000000000000;
    memory[7] = 16'b0000000000000000;
  end
  
  always @(posedge clock) begin
    R0 <= memory[0]; //Stampa in Output.sv
  end
    
  always @(SR1 or SR2) begin
    SR1out = memory[SR1]; //Uscite reg
    SR2out = memory[SR2];
  end
  
  always @(posedge ld_reg) begin
    #10;
    memory[DR] = data;
    $display("carica? %b %b %b", memory[DR], data, DR); //Debug
    #10;
  end

endmodule
