module FSM(
  input clock,
  input [15:0] IR, // Instruction register
  input N, // negative register 1 quando il numero è negativo
  input Z, // zero register 1 quando il numero è 0
  input P, // positive register 1 quando il numero è positivo
  input R, // wmfc
  output reg [28:0] signal
);

  reg [2:0] SR1, SR2, DR; //FileREG
  reg ld_mar, ld_mdr, ld_cc, ld_pc, ld_ir, ld_reg; //loader
  reg MuxMDR, MuxMAR, MuxR1, MuxSR2; //1 Bit mux
  reg [1:0] MuxPC, MuxR2, Alu; //2 Bit mux
  reg read, write; //Memoria
  reg [1:0] gate; //Bus

  reg state; // Cambia stato 
  wire [3:0] opcode; // Estrae l'opcode dall'IR
  reg reset;

  always @(*) begin
    signal <= {ld_mar, ld_mdr, ld_cc, ld_pc, ld_ir, ld_reg, MuxMDR, MuxMAR, MuxR1, MuxSR2, MuxPC, MuxR2, Alu, read, write, gate, SR1, SR2, DR };
  end

  localparam BR   = 4'b0000, // Branch
             ADD  = 4'b0001, // Add
             LD   = 4'b0010, // Load
             ST   = 4'b0011, // Store
             JSR  = 4'b0100, // JSR/JSSR
             AND  = 4'b0101, // And logico
             LDR  = 4'b0110, // register Load
             STR  = 4'b0111, // register Store
             RTI  = 4'b1000, // Return Interrup
             NOT  = 4'b1001, // Not logico
             LDI  = 4'b1010, // Indirect Load
             STI  = 4'b1011, // Indirect Store
             RET  = 4'b1100, // Return/Jump
             X    = 4'b1101, // non usato
             LEA  = 4'b1110, // Load Effective Address
             TRAP = 4'b1111; // Trap os 

  localparam off = 1'b0,
             on = 1'b1,
             pc = 2'b00,
             alu = 2'b01,
             mdr = 2'b10,
             mar = 2'b11;

  assign opcode = IR[15:12];

  //-------------------------------------------
  task WMFC;
    @(posedge clock) begin
      while (~R) begin
        @(posedge clock);
      end
    end
  endtask
  //--------------------------------------------

  initial begin
    state <= 0; // attiva la FSM quando si accende per la prima volta
  end

  localparam delay = 10;
  always @(posedge reset or posedge clock) begin
    $display("state %b", state);
    if (reset == 1) begin
      $display("reset");
      state <= 0;
      reset <= 0;
      #delay;
    end

    $display("-----------------------------");
    case (state)
      1'b0: begin // Fetch
        #delay gate <= pc; ld_mar <= on;
        #delay ld_mar <= off; MuxMDR <= off;  MuxMAR <= off; MuxPC <= 2'b00;
        #delay ld_mar <= off;
        #delay gate <= mdr;
        #delay read <= on;
        WMFC; //Wait for Memory Function to Complete
        #delay read <= off; ld_pc <= on;
        #delay ld_pc <= off; ld_mdr <= on;
        #delay ld_mdr <= off; ld_ir <= on;
        #delay ld_ir <= off;
      end

      1'b1: begin // Decode/Execute
        case (opcode)
//-------------------------------------------------------------------------------------        
          BR: begin 
            #delay MuxR1 <= off; MuxR2 <= 2'b10;
            if (N == on)
              if (IR[11] == N)
                MuxPC <= 2'b01;
            if (Z == on)
              if (IR[10] == Z)
                MuxPC <= 2'b01;
            if (P == on)
              if (IR[9] == P)
                MuxPC <= 2'b01;
            #delay;
            if (MuxPC == 2'b01) begin
              ld_pc <= on; #delay;
              #delay ld_pc <= off;
            end
          end
//-------------------------------------------------------------------------------------
          ADD: begin
            if (IR[5] == on) MuxSR2 <= on;
            else MuxSR2 <= off;
            #delay DR <= IR[11:9]; SR1 <= IR[8:6]; SR2 <= IR[2:0]; Alu <= 2'b00;
            #delay gate <= alu; ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------         
          LD: begin
            DR <= IR[11:9]; 
            #delay MuxR1 <= off; MuxR2 <= 2'b10; MuxMAR <= off;
            #delay gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; MuxMDR <= off; read <= on;
            WMFC;
            #delay read <= off; ld_mdr <= on; gate <= mdr;
            #delay ld_mdr <= off; ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------
          ST: begin
            SR1 <= IR[11:9]; SR2 <= IR[11:9];
            #delay MuxR1 <= off; MuxR2 <= 2'b10; MuxMAR <= off;
            #delay gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; MuxSR2 <= 1'b0; Alu <= 2'b01; MuxMDR <= on; 
            #delay gate <= alu;
            #delay ld_mdr <= on; write <= on;
            WMFC;
            #delay ld_mdr <= off; write <= off;
          end
//-------------------------------------------------------------------------------------
          JSR: begin
            DR <= 3'b111; SR1 <= IR[8:6];
            #delay gate <= pc; ld_reg <= on;
            #delay ld_reg <= off;
            if(IR[11]== on) begin
              #delay MuxR1 <= off; MuxR2 <= 2'b11;
            end else begin 
              #delay MuxR1 <= on; MuxR2 <= 2'b00;
            end
            #delay MuxPC <= 2'b01; ld_pc <= on;
            #delay ld_pc <= off;
          end
//-------------------------------------------------------------------------------------
          AND: begin
            DR <= IR[11:9]; SR1 <= IR[8:6]; SR2 <= IR[2:0];
            if (IR[5] == on) MuxSR2 <= on; 
            else MuxSR2 <= off;		  
            #delay Alu <= 2'b01; gate <= alu;
            #delay ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------
          LDR: begin
            DR[2:0] <= IR [11:9]; SR1[2:0] <= IR[8:6];
            #delay MuxR1 <= 1'b1; MuxR2 <= 2'b01; MuxMAR   <= 1'b0; 
            #delay gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; read <= on;
            WMFC;
            #delay read <= off; ld_mdr <= on; gate <= mdr;
            #delay ld_mdr <= off; ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------
          STR: begin
            SR1 <= IR[8:6];
            #delay MuxR1 <= 1'b1; MuxR2 <= 2'b01; MuxMAR <= off; MuxSR2 <= off;
            #delay gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; SR1 <= IR[11:9]; SR2 <= IR[11:9]; Alu <= 2'b01;
            #delay gate <= Alu; MuxMDR <= on; ld_mdr <= on; gate <= mdr;
            #delay ld_mdr <= off; write <= on;
            WMFC;
            #delay write <= off;
          end
//-------------------------------------------------------------------------------------
          RTI: begin
            $display("RTI not implemented");
          end
//-------------------------------------------------------------------------------------
          NOT: begin
            DR <= IR[11:9]; SR1 <= IR[8:6];
            #delay Alu <= 2'b10; gate <= alu;
            #delay ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------
          LDI: begin
            DR <= IR[11:9]; 
            #delay MuxR1 <= off; MuxR2 <= 2'b10; MuxMAR <= off;
            #delay gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; read <= on;
            WMFC;
            #delay read <= off; ld_mdr <= on; gate <= mdr;
            #delay ld_mdr <= off; ld_mar <= on;
            #delay ld_mar <= off; read <= on;
            WMFC;
            #delay ld_mdr <= on; read <= off;
            #delay ld_mdr <= off; ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------
          STI: begin
            SR1 <= IR[11:9]; SR2 <= IR[11:9];
            #delay MuxR1 <= off; MuxR2 <= 2'b10; MuxMAR <= off;
            #delay gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; read <= on;
            WMFC;
            #delay read <= off; ld_mdr <= on; gate <= mdr;
            #delay ld_mdr <= off; ld_mar <= on;
            #delay ld_mar <= off; Alu <= 2'b01; gate <= Alu;
            #delay MuxMDR <= on; ld_mdr <= on; gate <= mdr;
            #delay write <= on; ld_mdr <= off;
            WMFC;
            #delay write <= off;
          end
//-------------------------------------------------------------------------------------
          RET: begin
            if (IR[11] == on) SR1 <= IR[8:6]; 
            else SR1 <= 7;
            #delay MuxR1 <= on; MuxR2 <= 2'b00; MuxPC <= 2'b01; ld_pc <= on;
            #delay ld_pc <= off;
          end
//-------------------------------------------------------------------------------------
          X: begin
            $display("X not implemented");
          end
//-------------------------------------------------------------------------------------
          LEA: begin
            DR <= IR[11:9]; 
            #delay MuxR1 <= off; MuxR2 <= 2'b10; MuxMAR <= off;
            #delay gate <= mar; ld_reg <= on; ld_cc <= on;
            #delay ld_reg <= off; ld_cc <= off;
          end
//-------------------------------------------------------------------------------------
          TRAP: begin
            DR <= 7;
            #delay MuxMAR <= on; gate <= mar; ld_mar <= on;
            #delay ld_mar <= off; gate <= pc; ld_reg <= on;
            #delay ld_reg <= off; read <= on;
            WMFC;
            #delay ld_mdr <= on; read <= off;
            #delay ld_mdr <= off; gate <= mdr; MuxPC <= 2'b10; ld_pc <= on;
            #delay ld_pc <= off;
          end
//-------------------------------------------------------------------------------------
          default: begin
            $display("Comando %b%b%b%b non riconosciuto, controllare RAM", IR[15], IR[14], IR[13], IR[12]);
            $finish;
          end
        endcase
      end
    endcase
    #delay state = ~state;
  end
endmodule
