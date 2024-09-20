module PcMux(
  input [15:0] PC,
  input [15:0] Adder,
  input [15:0] Bus,
  input [1:0] control,
  output reg [15:0] Pcin
);
  
  always @(*) begin  
    if(control == 2'b00)begin 
    	Pcin <= PC + 1'b1;
    end
    if(control == 2'b01)begin 
    	Pcin <= Adder;
    end
    if(control == 2'b10)begin 
    	Pcin <= Bus;
    end
  end
endmodule