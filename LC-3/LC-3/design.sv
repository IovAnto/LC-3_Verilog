  `include "FSM.sv"
  `include "RegFile.sv"
  `include "Ram.sv"
  `include "LogicNZP.sv"
  `include "ALU.sv"
  `include "Gate.sv"
  `include "Adder.sv"
  `include "ZEXT.sv"
  `include "SEXT5.sv"
  `include "SEXT6.sv"
  `include "SEXT9.sv"
  `include "SEXT11.sv"
  `include "PcMux.sv"
  `include "Mux.sv"
  `include "MuxC2.sv"
  `include "Output.sv"

module LC_3(
  input clock
);

  localparam on = 1'b1,
            off = 1'b0;

  // Ingressi
  reg [15:0] IR, MAR, MDR, PC;
  reg N, Z, P;
  reg start;
  wire [15:0] BUS;
  wire print;

  // Uscite
  wire [15:0] mdr_in, pc_in;
  wire n_in, z_in, p_in;
  wire [15:0] ZEXT_out, SEXT5_out, SEXT6_out, SEXT9_out, SEXT11_out, MDR_out;
  wire [15:0] ALU_out;
  wire [15:0] Adder_out;
  wire [15:0] mar_to_bus;
  wire [15:0] SR1out;
  wire [15:0] SR2out;
  wire [15:0] R1_out;
  wire [15:0] R2_out;
  wire [15:0] SR2toALU;
  wire [15:0] Memory_out;
  wire [15:0] R0;

  wire [28:0] signal;

  initial begin
  	PC = 16'h3000;
    start = 1'b1;
    N = 1'b1;
  end
  
  always @(signal)begin 
    #10;
    if(signal[24] == on)begin
    	IR = BUS;
      $display("IR %b", IR);
    end
    if(signal[28] == on)begin
        MAR = BUS;
      $display("MAR %b", MAR);
    end
    if(signal[27] == on)begin
       MDR = MDR_out;
      $display("MDR %b", MDR);
    end
    if(signal[26] == on)begin
       	N = n_in;
      	Z = z_in;
      	P = p_in;
      $display("N %b, Z %b, P %b", N, Z, P);
    end
    if(signal[25] == on)begin	
        PC = pc_in;
      $display("PC %h", PC);
    end
  end
  
  
    Gate Demux (
    .PC(PC),
    .MARMUX(mar_to_bus),
    .MDR(MDR),
    .ALU(ALU_out),
    .control(signal[10:9]),
    .BUS(BUS)
  );
  // Logica di controllo
  FSM controllore (
    .clock(clock),
    .IR(IR),
    .N(N),
    .Z(Z),
    .P(P),
    .R(R_out),
    .start(start),
    .signal(signal)
  );

  // Multiplexer per selezionare il PC
  PcMux toPC (
    .PC(PC),
    .Adder(Adder_out),
    .Bus(BUS),
    .control(signal[18:17]),
    .Pcin(pc_in)
  );

  // Altri componenti inclusi
  Logic nzp (
    .data(BUS),
    .N(n_in),
    .Z(z_in),
    .P(p_in)
  );

  Mux Marmux (
    .Data1(Adder_out),
    .Data2(ZEXT_out),
    .control(signal[21]),
    .DataOut(mar_to_bus)
  );

  Mux Mdrmux(
    .Data1(Memory_out),
    .Data2(BUS),
    .control(signal[22]),
    .DataOut(MDR_out)
  );
  
  Mux sr2ALU (
    .Data1(SR2out),
    .Data2(SEXT5_out),
    .control(signal[19]),
    .DataOut(SR2toALU)
  );

  Mux R1 (
    .Data1(PC),
    .Data2(SR1out),
    .control(signal[20]),
    .DataOut(R1_out)
  );

  // Componenti inclusi per l'estensione dei segnali
  ZEXT trap (
    .data(IR[5:0]),
    .datout(ZEXT_out)
  );

  SEXT5 u5(
    .data(IR[4:0]),
    .datout(SEXT5_out)
  );
  
  SEXT6 u6 (
    .data(IR[5:0]),
    .datout(SEXT6_out)
  );

  SEXT9 u9 (
    .data(IR[8:0]),
    .datout(SEXT9_out)
  );

  SEXT11 u11 (
    .data(IR[10:0]),
    .datout(SEXT11_out)
  );

  MuxC2 R2 (
    .SEXT6(SEXT6_out),
    .SEXT9(SEXT9_out),
    .SEXT11(SEXT11_out),
    .control(signal[16:15]),
    .Out(R2_out)
  );

  // Altri componenti inclusi
  Adder u (
    .data1(R1_out),
    .data2(R2_out),
    .dataOut(Adder_out)
  );

  ALU AritmeticLocigUnit (
    .data1(SR1out),
    .data2(SR2toALU),
    .operazione(signal[14:13]),
    .risultato(ALU_out)
  );

  RAM memory (
    .clock(clock),
    .read(signal[12]),
    .write(signal[11]),
    .MAR(MAR),
    .MDR_in(MDR),
    .MDR(Memory_out),
    .R(R_out),
    .print(print)
  );

  RegFile Registri (
    .clock(clock),
    .DR(signal[2:0]),
    .SR1(signal[8:6]),
    .SR2(signal[5:3]),
    .ld_reg(signal[23]),
    .data(BUS),
    .SR1out(SR1out),
    .SR2out(SR2out),
    .R0(R0)
  );

  out Print(
    .data(R0),
    .print(print)
  );

endmodule
