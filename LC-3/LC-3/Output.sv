module out(
  input wire [15:0] data,
  input print
);
  
  wire [15:0] data_interna;
  
  assign data_interna = data;
 
  always @(posedge print)begin
    $display("---------------------------------video: %h",data_interna);
  end
endmodule