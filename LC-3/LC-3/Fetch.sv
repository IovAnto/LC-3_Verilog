    module Fetch(
    output reg [1:0] gate,
    output reg ld_mar,
    output reg mdrmux,
    output reg marmux,
    output reg read,
    output reg ld_ir,
    output reg ld_pc,
    output reg ld_mdr,
    output reg [1:0] pcmux,
    output reg fine,
    input FetchStart,
    input state
    );

  localparam off = 1'b0,
             on = 1'b1,
             pc = 2'b00,
             alu = 2'b01,
             mdr = 2'b10,
             mar = 2'b11,
             delay = 10;

   always@(posedge FetchStart)begin //microistruzioni fetch
    if(state == 0)begin
    #delay gate <= pc; ld_mar <= on;
    #delay ld_mar <= off; mdrmux <= off;  marmux <= off; pcmux <= 2'b00;
    #delay ld_mar <= off;
    #delay gate <= mdr;
    #delay read <= on;
    WMFC; //Wait for Memory Function to Complete
    #delay read <= off; ld_pc = on;
    #delay ld_pc <= off; ld_mdr <= on;
    #delay ld_mdr <= off; ld_ir <= on;
    #delay ld_ir <= off;
    fine <= on;
    $display("Fetch----------------");
   end
   end
   endmodule