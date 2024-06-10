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
    //Carico in memoria l'indirizzo PC per poter scrivere in memoria
    memory[16'h0023] = 16'h023b; //indirizzo TRAP input
    memory[16'h0021] = 16'h021b; //indirizzo TRAP output
    memory[16'h0025] = 16'h3000; //indirizzo TRAP kill, semplificando torno ad una cella iniziale
    //Service Routine input
    memory[16'h023b] = 16'b0010_0000_0000_0001; //per semplificare la Trap ho messo in memoria il dato che avrei dovuto prendere da tastiera, LD in R0 il numero 0
    memory[16'h023c] = 16'b1100_0000_0000_0000; //Return al vecchio PC
    memory[16'h023d] = 16'h0000;
    //Service Routine output
    memory[16'h021b] = 16'b1100_0001_1100_0000; //ret al vecchi PC vedi module output
    
   
    
    //es1
    memory[16'h3000] = 16'b0000_111_000000100; //ld
    memory[16'h3001] = 16'b1111_000000100101; //kill
    memory[16'h3020] = 16'h0001;
    
    //Istruzioni da fare partendo dalla cella di memoria HEX 3000
 /*   memory[15'h0001] = 16'h0020;
    memory[16'h3000] = 16'b0101_010_010_1_00000; //AND
    memory[16'h3001] = 16'b0010_011_000010000;   //LD
    memory[16'h3002] = 16'b1111_0000_00100011;	 //Trap x23
    memory[16'h3003] = 16'b0110_001_011_000000;  //LDR
    memory[16'h3004] = 16'b0001_100_001_111100;  //ADD
    memory[16'h3005] = 16'b0000_010_000001000;   //BR
    memory[16'h3006] = 16'b1001_001_001_111111;  //NOT
    memory[16'h3007] = 16'b0001_001_001_1_00001; //ADD
    memory[16'h3008] = 16'b0001_001_001_000_000; //ADD
    memory[16'h3009] = 16'b0000_101_000000001;   //BR
    memory[16'h300A] = 16'b0001_010_010_1_00001; //ADD
    memory[16'h300B] = 16'b0001_011_011_1_00001; //ADD
    memory[16'h300C] = 16'b0110_001_011_000000;  //LDR
    memory[16'h300D] = 16'b0000_111_111110110;   //BR
    memory[16'h300E] = 16'b0010_000_000000100;   //LD
    memory[16'h300F] = 16'b0001_000_000_000_010; //ADD
    memory[16'h3010] = 16'b1111_0000_00100001;   //Trap x21
    memory[16'h3011] = 16'b1111_0000_0010_0101;  //Trap x25
    memory[16'h3012] = 16'h3013;            	 // Inizio file (puntatore)
    memory[16'h3013] = 16'b0000_0000_0011_0000;  // '0' in ascii (48) */
    
  end
  
  
 always @(posedge clock) begin
   if (MAR == 16'h021b) begin
    print <= 1'b1;
  end else begin
    print <= 1'b0;
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