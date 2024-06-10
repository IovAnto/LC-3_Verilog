module RAM(
  input clock,
  input read,
  input write,
  input [15:0] MAR,
  input [15:0] MDR_in,
  output reg[15:0] MDR,
  output reg R,
  output reg print
  );
  
  reg[15:0] memory[65535:0];

  initial begin
    //Carico in memoria l'indirizzo PC per poter scrivere in memori----------------------------------
    memory[16'h0023] = 16'h023b; //indirizzo TRAP input
    memory[16'h0021] = 16'h021b; //indirizzo TRAP output
    memory[16'h0025] = 16'h3000; //indirizzo TRAP kill, semplificando torno ad una cella iniziale
    //Service Routine input
    memory[16'h023b] = 16'b0010_0000_0000_0001; //per semplificare la Trap ho messo in memoria il dato che avrei dovuto prendere da tastiera, LD in R0 il numero 0
    memory[16'h023c] = 16'b1100_0000_0000_0000; //Return al vecchio PC
    memory[16'h023d] = 16'h0000;
    //Service Routine output
    memory[16'h021b] = 16'b1100_0001_1100_0000; //ret al vecchi PC vedi module output
    //------------------------------------------------------------------------------------------------

   
    //Istruzioni da fare partendo dalla cella di memoria HEX 3000-------------------------------------
    memory[16'h3000] = 16'b0101_001_001_1_00000; //AND R0, R0, #0;
    memory[16'h3001] = 16'b0001_001_001_1_00111; //ADD R0, R0, #5
    memory[16'h3002] = 16'b0011_001_011111111;   //ST R1, NUMBER
    memory[16'h3003] = 16'b0010_000_011111110;    //LD R0, NUMBER;
    memory[16'h3004] = 16'b1111_0000_00100001; //TRAP output
    memory[16'h3005] = 16'b1111_000000100101; //kill
    










    
    //Test1_________________________________________________________________________________________
   /* memory[16'h3000] = 16'b1110_000_011111100; //LEA R0, DATA
    memory[16'h3001] = 16'b0010_001_111111111; //LD R1, Value1
    memory[16'h3002] = 16'b0001_001_1_0000001; //ADD R1, R1, #1
    memory[16'h3003] = 16'b0111_001_000000000; //STR R1, R0
    memory[16'h3004] = 16'b0110_011_000000000; //LDR R3, R0, #0
    memory[16'h3005] = 16'b1111_0000_00100001; //TRAP output
    memory[16'h3006] = 16'b1111_000000100101; //kill
    memory[16'h3020] = 16'h0001;

    memory[16'b1111_1111_1111_1111] = 16'b0000_0000_0000_1010; //Value1 
  */
    
  end
  
  
 always @(posedge clock) begin
   if (MAR == 16'h021b) begin
    print = 1'b1;
  end else begin
    print = 1'b0;
  end
   if(MAR == 16'h0025)begin
   	$finish;
   end
  if (read == 1'b1) begin
    MDR <= memory[MAR];
    #10;
    $display("sto leggendo nella memoria, %b", memory[MAR]);
    R <= 1'b1;
    #50; 
    R = 1'b0;
    
  end
  if (write == 1'b1) begin
    memory[MAR] <= MDR_in;
    #10;
    $display("scrivo in memoria %b indirizzo %h",memory[MAR], MAR);
    R = 1'b1;
    #50;
    R = 1'b0;
  end
    
  if (!read && !write) begin
    R = 1'b0;
  end
 end 
endmodule