module final_Tb;
  
  reg clock;
  
  LC_3 dut (
    .clock(clock)
  );
  

  always #10 clock = ~clock;
  
  initial begin
    clock = 1'b0; //inizializzo il clock a 0
  end
  
  initial begin
    #1000000; //in caso non andasse bene qualcosa 
    $finish;
  end

endmodule