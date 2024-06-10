module out(
  input wire [15:0] data,
  input print
);
  
  wire [15:0] data_interna;
  
  assign data_interna = data;
 
  always @(posedge print)begin
    $display("       ___________________________________\n       |                                 |\n       |                                 |\n Video:|             %d               |\n       |                                 |\n       |_________________________________|\n",data_interna);  
              
  end
endmodule