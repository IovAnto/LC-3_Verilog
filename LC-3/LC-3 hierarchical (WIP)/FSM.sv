`include "BR.sv"
`include "Fetch.sv"

module FSM(
  input clock,
  input [15:0] IR, // Instruction register
  input N, // negative register 1 quando il numero è negativo
  input Z, // zero register 1 quando il numero è 0
  input P, // positive register 1 quando il numero è positivo
  input R, // wmfc
  input start, // inizia la FSM
  output reg [28:0] signal,
  output wire fine
);

  wire [2:0] SR1, SR2, DR; //FileREG
  wire ld_mar, ld_mdr, ld_cc, ld_pc, ld_ir, ld_reg; //loader
  wire MuxMDR, MuxMAR, MuxR1, MuxSR2; //1 Bit mux
  wire [1:0] MuxPC, MuxR2, Alu; //2 Bit mux
  wire read, write; //Memoria
  wire [1:0] gate; //Bus

  reg state; // Cambia stato 
  wire [3:0] opcode; // Estrae l'opcode dall'IR
  reg reset;
  reg FetchStart;
  reg fine_reg;
  reg BR_flag;

  assign fine = fine_reg;
  

  always@(*)begin
    signal <= {ld_mar, ld_mdr, ld_cc, ld_pc, ld_ir, ld_reg, MuxMDR, MuxMAR, MuxR1, MuxSR2, MuxPC, MuxR2, Alu, read, write, gate, SR1, SR2, DR };
  end       //  28  -   27   - 26  -  25   - 24   -  23  -   22  -  21   -  20  -  19  -  18:17- 16:15-14:13- 12  - 11  - 10:9- 8:6- 5:3- 2:0  

  Fetch fetch(
    .gate(gate),
    .mdrmux(MuxMDR),
    .marmux(MuxMAR),
    .read(read),
    .ld_ir(ld_ir),
    .ld_pc(ld_pc),
    .ld_mar(ld_mar),
    .ld_mdr(ld_mdr),
    .pcmux(MuxPC),
    .fine(fine),
    .FetchStart(FetchStart),
    .state(state)
  );

 /* BR fsm(
    .N(N),
    .Z(Z),
    .P(P),
    .IR(IR),
    .pcmux(MuxPC),
    .ld_pc(ld_pc),
    .addR1mux(MuxR1),
    .addR2mux(MuxR2),
    .BR_flag(BR_flag),
    .fine(fine)
  ); */


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

  always @(start) reset <= 1;

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
    BR_flag <= 1'b0;
  end

  //FSM---------------------------------------
  always @(posedge fine) begin
    state <= ~state;
    fine_reg <= 0;
    FetchStart <= 1'b0;
    BR_flag <= 1'b0;
    #delay;
  end 

  localparam delay = 10;
  always @(posedge reset or negedge fine_reg) begin
    if (reset == 1) begin
      $display("reset");
      state <= 0;
      reset <= 0;
      FetchStart <= 1'b0;
      #delay;
    end

    $display("-----------------------------");

    case (state)
      1'b0: begin // Fetch
        FetchStart <= 1'b1;
      end

      1'b1: begin
        case (opcode)
          BR: begin 
            $display("ci sta: %b", fine_reg);
          end
          ADD: $display("?");
          LD: $display("?");
          ST: $display("?");
          JSR: $display("?");
          AND: $display("?");
          LDR: $display("?");
          STR: $display("?");
          RTI: $display("?");
          NOT: $display("?");
          LDI: $display("?");
          STI: $display("?");
          RET: $display("?");
          X: $display("?");
          LEA: $display("?");
          TRAP: $display("?");
          default: begin
            $display("non valido");
            state <= 0;
          end
        endcase 
      reset <= 1;
      end
    endcase
  end
endmodule
