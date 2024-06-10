module BR(
  input N,
  input Z,
  input P,
  input [15:0] IR,
  output reg [1:0]pcmux,
  output reg ld_pc,
  output reg [1:0]addR2mux,
  output reg addR1mux,
  input BR_flag,
  output reg fine
  
);

  localparam on = 1'b1, off = 1'b0;
  initial begin
    pcmux <= 2'b00;
    ld_pc <= off;
    addR2mux <= 2'b00;
    addR1mux <= off;
    fine <= 1'b0;
  end

  always@(posedge BR_flag)begin
    if(BR_flag == 0)begin
      $display("BR----------------");
    end else begin
    if(IR[15:12] == 4'b0000)begin
     addR1mux <= off;
     addR2mux <= 2'b10;
    
          //se negativo
  	  if(N == on) begin
          if(IR[11] == N)begin
            	pcmux  <= 2'b01;
            end 
          end
          //se zero
          if(Z == on) begin
            if(IR[10] == Z)begin
            	pcmux  <= 2'b01;
            end 
          end
         //se positivo
          if(P == on) begin
            if(IR[9] == P)begin
            	pcmux  <= 2'b01;
            end 
          end
        #10;
        if(pcmux == 2'b01)begin
        	ld_pc <= on;
          #20;
          ld_pc <= off;
        end
        $display("BR----------------");
        fine <= 1'b1;
      end
    end
  end
      endmodule